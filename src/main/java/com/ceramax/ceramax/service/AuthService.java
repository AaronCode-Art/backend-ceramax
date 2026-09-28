package com.ceramax.ceramax.service;

import com.ceramax.ceramax.dto.auth.AuthResponse;
import com.ceramax.ceramax.dto.auth.LoginRequest;
import com.ceramax.ceramax.dto.auth.RegistroRequest;
import com.ceramax.ceramax.exception.BadRequestException;
import com.ceramax.ceramax.exception.UnauthorizedException;
import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.model.Cliente;
import com.ceramax.ceramax.model.Rol;
import com.ceramax.ceramax.model.RolPermiso;
import com.ceramax.ceramax.repository.ClienteRepository;
import com.ceramax.ceramax.repository.RolPermisoRepository;
import com.ceramax.ceramax.repository.RolRepository;
import com.ceramax.ceramax.repository.UsuarioRepository;
import com.ceramax.ceramax.security.JwtService;
import com.ceramax.ceramax.security.TokenBlacklistService;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;

import java.util.Set;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final ClienteRepository clienteRepository;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;
    private final TokenBlacklistService tokenBlacklistService;
    private final LoginAttemptService loginAttemptService;
    private final RolRepository rolRepository;
    private final RolPermisoRepository rolPermisoRepository;

    public AuthService(UsuarioRepository usuarioRepository, ClienteRepository clienteRepository,
                       JwtService jwtService, PasswordEncoder passwordEncoder,
                       TokenBlacklistService tokenBlacklistService, LoginAttemptService loginAttemptService,
                       RolRepository rolRepository, RolPermisoRepository rolPermisoRepository) {
        this.usuarioRepository = usuarioRepository;
        this.clienteRepository = clienteRepository;
        this.jwtService = jwtService;
        this.passwordEncoder = passwordEncoder;
        this.tokenBlacklistService = tokenBlacklistService;
        this.loginAttemptService = loginAttemptService;
        this.rolRepository = rolRepository;
        this.rolPermisoRepository = rolPermisoRepository;
    }

    @Transactional
    public AuthResponse registroCliente(RegistroRequest req) {
        String email = req.email().trim().toLowerCase();
        if (usuarioRepository.existsByEmail(email)) {
            throw new BadRequestException("El email ya está registrado");
        }

        String passwordHash = passwordEncoder.encode(req.password());
        Cliente cliente = clienteRepository.findByEmailIgnoreCase(email).orElseGet(Cliente::new);
        if (cliente.getPasswordHash() != null) {
            throw new BadRequestException("El email ya tiene una cuenta de tienda registrada");
        }
        cliente.setNombre(req.nombre().trim());
        cliente.setApellido(req.apellido().trim());
        cliente.setEmail(email);
        cliente.setPasswordHash(passwordHash);

        Usuario nuevo = Usuario.builder()
                .nombre(req.nombre().trim())
                .apellido(req.apellido().trim())
                .email(email)
                .passwordHash(passwordHash)
                .rol("CLIENTE")
                .build();

        try {
            clienteRepository.saveAndFlush(cliente);
            Usuario guardado = usuarioRepository.saveAndFlush(nuevo);
            return construirAuthResponse(guardado);
        } catch (DataIntegrityViolationException ex) {
            throw new BadRequestException("El correo ya está registrado en una cuenta de cliente");
        }
    }

    @Transactional
    public AuthResponse loginTienda(String email, String password) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new UnauthorizedException("Correo incorrecto"));

        if (usuario.getEstado() == com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.bloqueado) {
            throw new UnauthorizedException("Cuenta bloqueada contacte con el administrador");
        }
        if (usuario.getEstado() != com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.activo) {
            throw new UnauthorizedException("Cuenta desactivada contacte con el administrador");
        }

        if (!passwordEncoder.matches(password, usuario.getPasswordHash())) {
            throw new UnauthorizedException("Contraseña incorrecta");
        }

        if (!"CLIENTE".equalsIgnoreCase(usuario.getRol())) {
            throw new UnauthorizedException("Esta cuenta pertenece al panel de administración");
        }

        usuario.setIntentosLoginFallidos(0);
        usuarioRepository.save(usuario);
        return construirAuthResponse(usuario);
    }

    private AuthResponse construirAuthResponse(Usuario usuario) {
        String rol = usuario.getRol() != null ? usuario.getRol().toUpperCase() : "CLIENTE";
        Set<String> permisos = obtenerPermisosPorRol(rol);
        String token = jwtService.generateToken(
                usuario.getId(),
                usuario.getEmail(),
                usuario.getNombre(),
                usuario.getApellido(),
                rol,
                permisos
        );
        return new AuthResponse(token, usuario.getId(), usuario.getNombre(), usuario.getApellido(),
                usuario.getEmail(), rol, permisos);
    }

    @Transactional
    public AuthResponse login(String email, String password) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new UnauthorizedException("Correo incorrecto"));

        if (usuario.getEstado() == com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.bloqueado) {
            throw new UnauthorizedException("Cuenta bloqueada contacte con el administrador");
        }
        if (usuario.getEstado() != com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.activo) {
            throw new UnauthorizedException("Cuenta desactivada contacte con el administrador");
        }

        if (!passwordEncoder.matches(password, usuario.getPasswordHash())) {
            registrarIntentoFallido(usuario);
        }

        if ("CLIENTE".equalsIgnoreCase(usuario.getRol())) {
            throw new UnauthorizedException("No estas permitido para el acceso al panel");
        }

        // Con roles simplificados, solo obtenemos el role básico
        String rol = usuario.getRol() != null ? usuario.getRol().toUpperCase() : "CLIENTE";
        usuario.setIntentosLoginFallidos(0);
        usuarioRepository.save(usuario);

        // Generamos el token con el role básico y permisos mínimos
        Set<String> permisos = obtenerPermisosPorRol(rol);

        String token = jwtService.generateToken(
                usuario.getId(),
                usuario.getEmail(),
                usuario.getNombre(),
                usuario.getApellido(),
                rol,
                permisos
        );

        return new AuthResponse(token, usuario.getId(), usuario.getNombre(), usuario.getApellido(),
                usuario.getEmail(), rol, permisos);
    }

    private void registrarIntentoFallido(Usuario usuario) {
        if (!"VENDEDOR".equalsIgnoreCase(usuario.getRol())) {
            throw new UnauthorizedException("Contraseña incorrecta");
        }

        int nuevoTotal = loginAttemptService.registrar(usuario.getId());

        if (nuevoTotal >= 4) {
            throw new UnauthorizedException("Cuenta bloqueada contacte con el administrador");
        }

        int restantes = 4 - nuevoTotal;
        throw new UnauthorizedException(
                "Contraseña incorrecta. Tienes " + restantes
                        + (restantes == 1 ? " intento" : " intentos")
                        + " si no se bloqueará tu cuenta"
        );
    }

    @Transactional
    public void logout(String token) {
        tokenBlacklistService.blacklist(token);
    }

    private Set<String> obtenerPermisosPorRol(String rol) {
        Rol rolRegistrado = rolRepository.findByNombreRolIgnoreCase(rol)
                .filter(rolEncontrado -> rolEncontrado.getActivo()
                        == com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo)
                .orElseThrow(() -> new UnauthorizedException(
                        "El rol de esta cuenta no está configurado. Contacta con el administrador."));
        return rolPermisoRepository.findByRolId(rolRegistrado.getId())
                .stream()
                .filter(rolPermiso -> Boolean.TRUE.equals(rolPermiso.getActivo()))
                .map(RolPermiso::getPermiso)
                .filter(permiso -> permiso.getActivo()
                        == com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo)
                .map(com.ceramax.ceramax.model.Permiso::getNombrePermiso)
                .collect(java.util.stream.Collectors.toUnmodifiableSet());
    }
}
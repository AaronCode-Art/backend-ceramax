package com.ceramax.ceramax.service;

import com.ceramax.ceramax.config.CacheConfig;
import com.ceramax.ceramax.dto.usuario.UsuarioRequest;
import com.ceramax.ceramax.dto.usuario.UsuarioResponse;
import com.ceramax.ceramax.exception.BadRequestException;
import com.ceramax.ceramax.exception.ResourceNotFoundException;
import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.model.Rol;
import com.ceramax.ceramax.model.enums.EstadoGenericoEnum;
import com.ceramax.ceramax.repository.RolRepository;
import com.ceramax.ceramax.repository.UsuarioRepository;
import org.springframework.cache.CacheManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final PasswordEncoder passwordEncoder;
    private final CacheManager cacheManager;

    public UsuarioService(UsuarioRepository usuarioRepository, RolRepository rolRepository,
                          PasswordEncoder passwordEncoder, CacheManager cacheManager) {
        this.usuarioRepository = usuarioRepository;
        this.rolRepository = rolRepository;
        this.passwordEncoder = passwordEncoder;
        this.cacheManager = cacheManager;
    }

    // Invalida el userDetails cacheado (rol/password/estado cambiaron): evita esperar
    // hasta 30s (TTL) para que un cambio de rol o una desactivación surta efecto.
    private void evictUserDetailsCache(String email) {
        if (email == null) return;
        var cache = cacheManager.getCache(CacheConfig.CACHE_USER_DETAILS);
        if (cache != null) cache.evict(email);
    }

    @Transactional(readOnly = true)
    public Page<UsuarioResponse> listar(Pageable pageable) {
        return usuarioRepository.findByFechaEliminacionIsNull(pageable).map(this::toResponse);
    }

    @Transactional(readOnly = true)
    public UsuarioResponse obtenerPorId(Long id) {
        Usuario u = usuarioRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        return toResponse(u);
    }

    @Transactional
    public UsuarioResponse crear(UsuarioRequest req) {
        if (usuarioRepository.existsByEmail(req.email())) {
            throw new BadRequestException("El email ya está registrado");
        }

        if (req.rol() == null || req.rol().isBlank()) {
            throw new BadRequestException("Debes seleccionar un rol para el usuario");
        }
        String rol = validarRolActivo(req.rol());
        if (req.password() == null || req.password().isBlank()) {
            throw new BadRequestException("La contraseña es obligatoria");
        }

        String apellido = req.apellido() != null && !req.apellido().isBlank() ? req.apellido().trim() : "";

        Usuario u = Usuario.builder()
                .nombre(req.nombre())
                .apellido(apellido)
                .tipoDocumento(detectarTipoDocumento(req.dni()))
                .numeroDocumento(normalizar(req.dni()))
                .telefono(normalizar(req.telefono()))
                .email(req.email())
                .passwordHash(passwordEncoder.encode(req.password()))
                .rol(rol)  // Asignar role directo como String
                .build();

        if (req.activo() != null && !req.activo()) {
            u.setEstado(com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.inactivo);
        }

        return toResponse(usuarioRepository.save(u));
    }

    @Transactional
    public UsuarioResponse actualizar(Long id, UsuarioRequest req) {
        Usuario u = usuarioRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        u.setNombre(req.nombre());
        u.setApellido(req.apellido() != null && !req.apellido().isBlank() ? req.apellido().trim() : "");
        if (req.dni() != null && !req.dni().isBlank()) {
            u.setTipoDocumento(detectarTipoDocumento(req.dni()));
            u.setNumeroDocumento(req.dni().trim());
        }
        if (req.telefono() != null) u.setTelefono(req.telefono().isBlank() ? null : req.telefono().trim());
        if (req.password() != null && !req.password().isBlank()) {
            u.setPasswordHash(passwordEncoder.encode(req.password()));
        }
        if (req.rol() == null || req.rol().isBlank()) {
            throw new BadRequestException("Debes seleccionar un rol para el usuario");
        }
        u.setRol(validarRolActivo(req.rol()));
        if (req.activo() != null) {
            u.setEstado(req.activo()
                    ? com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.activo
                    : com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.inactivo);
            if (req.activo()) {
                u.setIntentosLoginFallidos(0);
            }
        }
        Usuario guardado = usuarioRepository.save(u);
        evictUserDetailsCache(guardado.getEmail());
        return toResponse(guardado);
    }

    @Transactional
    public void eliminar(Long id) {
        Usuario u = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        if (u.getFechaEliminacion() != null) {
            throw new BadRequestException("El usuario ya fue eliminado");
        }
        u.setFechaEliminacion(java.time.LocalDateTime.now());
        u.setEstado(com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.inactivo);
        usuarioRepository.save(u);
        evictUserDetailsCache(u.getEmail());
    }

    private String normalizar(String valor) {
        return valor == null || valor.isBlank() ? null : valor.trim();
    }

    private String validarRolActivo(String nombre) {
        String normalizado = nombre.trim().toUpperCase();
        Rol rol = rolRepository.findByNombreRolIgnoreCase(normalizado)
                .orElseThrow(() -> new BadRequestException(
                        "El rol " + normalizado + " no está registrado. Aplica la migración de roles e inténtalo de nuevo."));
        if (rol.getActivo() != EstadoGenericoEnum.activo) {
            throw new BadRequestException("El rol " + normalizado + " está inactivo");
        }
        return normalizado;
    }

    private String detectarTipoDocumento(String dni) {
        if (dni == null || dni.isBlank()) return null;
        return dni.trim().length() == 11 ? "RUC" : "DNI";
    }

    private UsuarioResponse toResponse(Usuario u) {
        String rol = u.getRol() != null ? u.getRol() : "CLIENTE";
        return new UsuarioResponse(
                u.getId(),
                u.getNombre(),
                u.getApellido(),
                u.getNumeroDocumento(),
                u.getTelefono(),
                u.getEmail(),
                rol,
                u.getEstado() != null && u.getEstado().name().equals("activo"),
                u.getFechaRegistro()
        );
    }
}
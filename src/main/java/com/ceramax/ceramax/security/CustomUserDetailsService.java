package com.ceramax.ceramax.security;

import com.ceramax.ceramax.config.CacheConfig;
import com.ceramax.ceramax.model.Permiso;
import com.ceramax.ceramax.model.Rol;
import com.ceramax.ceramax.model.RolPermiso;
import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.model.enums.EstadoGenericoEnum;
import com.ceramax.ceramax.repository.RolPermisoRepository;
import com.ceramax.ceramax.repository.RolRepository;
import com.ceramax.ceramax.repository.UsuarioRepository;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Set;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final RolPermisoRepository rolPermisoRepository;

    public CustomUserDetailsService(UsuarioRepository usuarioRepository, RolRepository rolRepository,
                                    RolPermisoRepository rolPermisoRepository) {
        this.usuarioRepository = usuarioRepository;
        this.rolRepository = rolRepository;
        this.rolPermisoRepository = rolPermisoRepository;
    }

    @Override
    @Cacheable(value = CacheConfig.CACHE_USER_DETAILS, key = "#email")
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + email));
        if (usuario.getRol() == null || usuario.getRol().isBlank()) {
            throw new UsernameNotFoundException("El usuario no tiene un rol configurado");
        }

        Rol rol = rolRepository.findByNombreRolIgnoreCase(usuario.getRol())
                .filter(registeredRole -> registeredRole.getActivo() == EstadoGenericoEnum.activo)
                .orElseThrow(() -> new UsernameNotFoundException(
                        "El rol del usuario no existe o está inactivo"));

        Set<SimpleGrantedAuthority> authorities = new HashSet<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_" + usuario.getRol().toUpperCase()));
        for (RolPermiso rolPermiso : rolPermisoRepository.findByRolId(rol.getId())) {
            if (!Boolean.TRUE.equals(rolPermiso.getActivo())) continue;
            Permiso permiso = rolPermiso.getPermiso();
            if (permiso != null && permiso.getNombrePermiso() != null
                    && permiso.getActivo() == EstadoGenericoEnum.activo) {
                authorities.add(new SimpleGrantedAuthority("PERM_" + permiso.getNombrePermiso()));
            }
        }

        return new CustomUserDetails(
                usuario.getEmail(),
                usuario.getPasswordHash(),
                usuario.getEstado() != null && usuario.getEstado().name().equals("activo"),
                authorities,
                usuario.getId(),
                usuario.getNombre(),
                usuario.getApellido()
        );
    }
}
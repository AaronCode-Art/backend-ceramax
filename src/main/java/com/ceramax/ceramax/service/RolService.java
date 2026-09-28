package com.ceramax.ceramax.service;

import com.ceramax.ceramax.audit.AuditableService;
import com.ceramax.ceramax.config.CacheConfig;
import com.ceramax.ceramax.dto.rol.RolRequest;
import com.ceramax.ceramax.dto.rol.RolResponse;
import com.ceramax.ceramax.exception.BadRequestException;
import com.ceramax.ceramax.exception.ResourceNotFoundException;
import com.ceramax.ceramax.model.Permiso;
import com.ceramax.ceramax.model.Rol;
import com.ceramax.ceramax.model.RolPermiso;
import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.model.enums.EstadoGenericoEnum;
import com.ceramax.ceramax.repository.PermisoRepository;
import com.ceramax.ceramax.repository.RolPermisoRepository;
import com.ceramax.ceramax.repository.RolRepository;
import com.ceramax.ceramax.repository.UsuarioRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
@AuditableService
public class RolService {

    private final RolRepository rolRepository;
    private final PermisoRepository permisoRepository;
    private final RolPermisoRepository rolPermisoRepository;
    private final UsuarioRepository usuarioRepository;

    public RolService(RolRepository rolRepository, PermisoRepository permisoRepository,
                      RolPermisoRepository rolPermisoRepository, UsuarioRepository usuarioRepository) {
        this.rolRepository = rolRepository;
        this.permisoRepository = permisoRepository;
        this.rolPermisoRepository = rolPermisoRepository;
        this.usuarioRepository = usuarioRepository;
    }

    @Cacheable(value = "roles", key = "'all'")
    @Transactional(readOnly = true)
    public List<RolResponse> listar() {
        return rolRepository.findAll().stream().map(this::toResponse).toList();
    }

    @Transactional(readOnly = true)
    public RolResponse obtenerPorId(Integer id) {
        Rol r = rolRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Rol no encontrado"));
        return toResponse(r);
    }

    @CacheEvict(value = "roles", allEntries = true)
    @Transactional
    public RolResponse crear(RolRequest req) {
        String nombreRol = req.nombreRol().trim().toUpperCase();
        if (rolRepository.findByNombreRolIgnoreCase(nombreRol).isPresent()) {
            throw new BadRequestException("Ya existe un rol con ese nombre");
        }

        Rol rol = Rol.builder()
                .nombreRol(nombreRol)
                .descripcion(req.descripcion())
                .activo(EstadoGenericoEnum.activo)
                .build();

        Rol guardado = rolRepository.save(rol);

        if (req.permisosIds() != null) {
            for (Integer permisoId : req.permisosIds()) {
                Permiso p = permisoRepository.findById(permisoId)
                        .orElseThrow(() -> new BadRequestException("Permiso no vÃ¡lido: " + permisoId));
                RolPermiso rp = RolPermiso.builder().rol(guardado).permiso(p).activo(true).build();
                rolPermisoRepository.save(rp);
            }
        }

        return toResponse(guardado);
    }

    @CacheEvict(value = "roles", allEntries = true)
    @Transactional
    public RolResponse actualizar(Integer id, RolRequest req) {
        Rol r = rolRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Rol no encontrado"));
        String nombreRol = req.nombreRol().trim().toUpperCase();

        rolRepository.findByNombreRolIgnoreCase(nombreRol).ifPresent(existente -> {
            if (!existente.getId().equals(id)) {
                throw new BadRequestException("Ya existe otro rol con ese nombre");
            }
        });

        r.setNombreRol(nombreRol);
        r.setDescripcion(req.descripcion());

        if (req.permisosIds() != null) {
            rolPermisoRepository.deleteByRolId(r.getId());
            for (Integer permisoId : req.permisosIds()) {
                Permiso p = permisoRepository.findById(permisoId)
                        .orElseThrow(() -> new BadRequestException("Permiso no vÃ¡lido: " + permisoId));
                RolPermiso rp = RolPermiso.builder().rol(r).permiso(p).activo(true).build();
                rolPermisoRepository.save(rp);
            }
        }

        return toResponse(rolRepository.save(r));
    }

    @CacheEvict(value = {"roles", CacheConfig.CACHE_USER_DETAILS}, allEntries = true)
    @Transactional
    public RolResponse actualizarPermisos(Integer id, Set<Integer> permisosIds) {
        Rol rol = rolRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Rol no encontrado"));
        List<Permiso> permisos = permisoRepository.findAllById(permisosIds);
        if (permisos.size() != permisosIds.size()) {
            throw new BadRequestException("Uno o más permisos seleccionados no existen");
        }
        if (permisos.stream().anyMatch(permiso ->
                permiso.getActivo() != EstadoGenericoEnum.activo)) {
            throw new BadRequestException("No se pueden asignar permisos inactivos");
        }

        rolPermisoRepository.deleteByRolId(rol.getId());
        for (Permiso permiso : permisos) {
            rolPermisoRepository.save(RolPermiso.builder()
                    .rol(rol)
                    .permiso(permiso)
                    .activo(true)
                    .build());
        }
        return toResponse(rol);
    }

    @CacheEvict(value = "roles", allEntries = true)
    @Transactional
    public void eliminar(Integer id) {
        if (!rolRepository.existsById(id)) throw new ResourceNotFoundException("Rol no encontrado");
        rolRepository.deleteById(id);
    }

    @CacheEvict(value = CacheConfig.CACHE_USER_DETAILS, allEntries = true)
    @Transactional
    public void asignarRolAUsuario(Long usuarioId, Integer rolId) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        Rol rol = rolRepository.findById(rolId)
                .orElseThrow(() -> new ResourceNotFoundException("Rol no encontrado"));

        usuario.setRol(rol.getNombreRol().toUpperCase());
        usuarioRepository.save(usuario);
    }

    @CacheEvict(value = CacheConfig.CACHE_USER_DETAILS, allEntries = true)
    @Transactional
    public void removerRolDeUsuario(Long usuarioId, Integer rolId) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        Rol rol = rolRepository.findById(rolId)
                .orElseThrow(() -> new ResourceNotFoundException("Rol no encontrado"));

        if (!usuario.getRol().equalsIgnoreCase(rol.getNombreRol())) {
            throw new BadRequestException("El usuario no tiene este rol");
        }
        usuario.setRol("CLIENTE");
        usuarioRepository.save(usuario);
    }

    @CacheEvict(value = CacheConfig.CACHE_USER_DETAILS, allEntries = true)
    @Transactional
    public void reemplazarRoles(Long usuarioId, List<Integer> rolesIds) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));

        if (rolesIds == null || rolesIds.isEmpty()) {
            usuario.setRol("CLIENTE");
        } else {
            Rol rol = rolRepository.findById(rolesIds.get(0))
                    .orElseThrow(() -> new BadRequestException("Rol no vÃ¡lido: " + rolesIds.get(0)));
            usuario.setRol(rol.getNombreRol().toUpperCase());
        }
        usuarioRepository.save(usuario);
    }

    @Transactional(readOnly = true)
    public Set<RolResponse.PermisoResponse> permisosDeRol(Integer rolId) {
        Rol rol = rolRepository.findById(rolId)
                .orElseThrow(() -> new ResourceNotFoundException("Rol no encontrado"));
        Set<RolResponse.PermisoResponse> permisos = new HashSet<>();
        List<RolPermiso> rolPermisos = rolPermisoRepository.findByRolId(rol.getId());
        for (RolPermiso rp : rolPermisos) {
            if (Boolean.TRUE.equals(rp.getActivo())
                    && rp.getPermiso() != null
                    && rp.getPermiso().getActivo() == EstadoGenericoEnum.activo) {
                Permiso p = rp.getPermiso();
                permisos.add(new RolResponse.PermisoResponse(p.getId(), p.getNombrePermiso(), p.getDescripcion()));
            }
        }
        return permisos;
    }

    private RolResponse toResponse(Rol r) {
        Set<RolResponse.PermisoResponse> permisos = new HashSet<>();
        List<RolPermiso> rolPermisos = rolPermisoRepository.findByRolId(r.getId());
        for (RolPermiso rp : rolPermisos) {
            if (Boolean.TRUE.equals(rp.getActivo())
                    && rp.getPermiso() != null
                    && rp.getPermiso().getActivo() == EstadoGenericoEnum.activo) {
                Permiso p = rp.getPermiso();
                permisos.add(new RolResponse.PermisoResponse(p.getId(), p.getNombrePermiso(), p.getDescripcion()));
            }
        }
        return new RolResponse(r.getId(), r.getNombreRol(), r.getDescripcion(),
                r.getActivo() == EstadoGenericoEnum.activo, permisos);
    }
}

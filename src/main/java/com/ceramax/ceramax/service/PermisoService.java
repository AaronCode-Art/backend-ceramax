package com.ceramax.ceramax.service;

import com.ceramax.ceramax.audit.AuditableService;
import com.ceramax.ceramax.dto.permiso.PermisoRequest;
import com.ceramax.ceramax.dto.permiso.PermisoResponse;
import com.ceramax.ceramax.exception.BadRequestException;
import com.ceramax.ceramax.exception.ResourceNotFoundException;
import com.ceramax.ceramax.model.Permiso;
import com.ceramax.ceramax.repository.PermisoRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@AuditableService
public class PermisoService {

    private final PermisoRepository permisoRepository;

    public PermisoService(PermisoRepository permisoRepository) {
        this.permisoRepository = permisoRepository;
    }

    @Cacheable(value = "permisos", key = "'all'")
    @Transactional(readOnly = true)
    public List<PermisoResponse> listar() {
        return permisoRepository.findAll().stream()
                .filter(permiso -> permiso.getActivo() == com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo)
                .map(this::toResponse)
                .toList();
    }

    @CacheEvict(value = "permisos", allEntries = true)
    @Transactional
    public PermisoResponse crear(PermisoRequest req) {
        permisoRepository.findAll().stream()
                .filter(p -> p.getNombrePermiso().equalsIgnoreCase(req.nombrePermiso()))
                .findFirst()
                .ifPresent(p -> { throw new BadRequestException("Ya existe un permiso con ese nombre"); });

        Permiso permiso = Permiso.builder()
                .nombrePermiso(req.nombrePermiso().trim().toUpperCase())
                .descripcion(req.descripcion())
                .build();
        return toResponse(permisoRepository.save(permiso));
    }

    @CacheEvict(value = "permisos", allEntries = true)
    @Transactional
    public void eliminar(Integer id) {
        if (!permisoRepository.existsById(id)) throw new ResourceNotFoundException("Permiso no encontrado");
        permisoRepository.deleteById(id);
    }

    private PermisoResponse toResponse(Permiso p) {
        return new PermisoResponse(p.getId(), p.getNombrePermiso(), p.getDescripcion());
    }
}

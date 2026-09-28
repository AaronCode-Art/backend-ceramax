package com.ceramax.ceramax.service;

import com.ceramax.ceramax.audit.AuditableService;
import com.ceramax.ceramax.dto.configuracion.ConfiguracionRequest;
import com.ceramax.ceramax.dto.configuracion.ConfiguracionResponse;
import com.ceramax.ceramax.model.ConfiguracionTienda;
import com.ceramax.ceramax.repository.ConfiguracionTiendaRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@AuditableService
public class ConfiguracionService {

    private final ConfiguracionTiendaRepository repo;

    public ConfiguracionService(ConfiguracionTiendaRepository repo) { this.repo = repo; }

    @Cacheable(value = "configuracion", key = "'tienda'")
    @Transactional(readOnly = true)
    public ConfiguracionResponse obtener() {
        ConfiguracionTienda c = repo.findById(1).orElseGet(() -> {
            ConfiguracionTienda nueva = ConfiguracionTienda.builder().id(1).nombreTienda("CeraMax").moneda("PEN").paisOperacion("Peru").build();
            return repo.save(nueva);
        });
        return toResponse(c);
    }

    @CacheEvict(value = "configuracion", allEntries = true)
    @Transactional
    public ConfiguracionResponse actualizar(ConfiguracionRequest req) {
        ConfiguracionTienda c = repo.findById(1).orElseGet(() -> ConfiguracionTienda.builder().id(1).build());
        c.setNombreTienda(req.nombreTienda());
        c.setMoneda(req.moneda() != null ? req.moneda() : "PEN");
        c.setPaisOperacion(req.paisOperacion());
        c.setPorcentajeImpuestoDefault(req.porcentajeImpuestoDefault());
        c.setPermiteVentaPresencial(req.permiteVentaPresencial());
        c.setPermiteRecojoTienda(req.permiteRecojoTienda());
        return toResponse(repo.save(c));
    }

    private ConfiguracionResponse toResponse(ConfiguracionTienda c) {
        return new ConfiguracionResponse(c.getId(), c.getNombreTienda(), c.getMoneda(), c.getPaisOperacion(), c.getPorcentajeImpuestoDefault(), c.getPermiteVentaPresencial(), c.getPermiteRecojoTienda());
    }
}

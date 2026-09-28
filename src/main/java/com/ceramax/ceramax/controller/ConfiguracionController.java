package com.ceramax.ceramax.controller;

import com.ceramax.ceramax.dto.common.ApiResponse;
import com.ceramax.ceramax.dto.configuracion.ConfiguracionRequest;
import com.ceramax.ceramax.dto.configuracion.ConfiguracionResponse;
import com.ceramax.ceramax.service.ConfiguracionService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/configuracion")
public class ConfiguracionController {

    private final ConfiguracionService configuracionService;

    public ConfiguracionController(ConfiguracionService configuracionService) { this.configuracionService = configuracionService; }

    @GetMapping
    public ResponseEntity<ApiResponse<ConfiguracionResponse>> obtener() { return ResponseEntity.ok(ApiResponse.ok(configuracionService.obtener())); }

    @PutMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<ConfiguracionResponse>> actualizar(@Valid @RequestBody ConfiguracionRequest req) { return ResponseEntity.ok(ApiResponse.ok("Configuración actualizada", configuracionService.actualizar(req))); }
}

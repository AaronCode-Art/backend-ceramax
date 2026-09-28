package com.ceramax.ceramax.controller;

import com.ceramax.ceramax.dto.common.ApiResponse;
import com.ceramax.ceramax.dto.permiso.PermisoRequest;
import com.ceramax.ceramax.dto.permiso.PermisoResponse;
import com.ceramax.ceramax.service.PermisoService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/permisos")
@PreAuthorize("hasRole('ADMIN')")
public class PermisoController {

    private final PermisoService permisoService;

    public PermisoController(PermisoService permisoService) {
        this.permisoService = permisoService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<PermisoResponse>>> listar() {
        return ResponseEntity.ok(ApiResponse.ok(permisoService.listar()));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<PermisoResponse>> crear(@Valid @RequestBody PermisoRequest req) {
        return ResponseEntity.ok(ApiResponse.ok("Permiso creado", permisoService.crear(req)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable Integer id) {
        permisoService.eliminar(id);
        return ResponseEntity.ok(ApiResponse.ok("Permiso eliminado", null));
    }
}

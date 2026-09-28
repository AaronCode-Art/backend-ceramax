package com.ceramax.ceramax.controller;

import com.ceramax.ceramax.dto.common.ApiResponse;
import com.ceramax.ceramax.dto.rol.RolPermisosRequest;
import com.ceramax.ceramax.dto.rol.RolResponse;
import com.ceramax.ceramax.service.RolService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/api/roles")
@PreAuthorize("hasRole('ADMIN')")
public class RolController {

    private final RolService rolService;

    public RolController(RolService rolService) {
        this.rolService = rolService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<RolResponse>>> listar() {
        return ResponseEntity.ok(ApiResponse.ok(rolService.listar()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RolResponse>> obtener(@PathVariable Integer id) {
        return ResponseEntity.ok(ApiResponse.ok(rolService.obtenerPorId(id)));
    }

    @GetMapping("/{id}/permisos")
    public ResponseEntity<ApiResponse<Set<RolResponse.PermisoResponse>>> permisosDelRol(@PathVariable Integer id) {
        return ResponseEntity.ok(ApiResponse.ok(rolService.permisosDeRol(id)));
    }

    @PutMapping("/{id}/permisos")
    public ResponseEntity<ApiResponse<RolResponse>> actualizarPermisos(
            @PathVariable Integer id,
            @Valid @RequestBody RolPermisosRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(rolService.actualizarPermisos(id, request.permisosIds())));
    }
}

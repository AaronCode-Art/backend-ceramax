package com.ceramax.ceramax.controller;

import com.ceramax.ceramax.dto.cliente.ClienteRequest;
import com.ceramax.ceramax.dto.cliente.ClienteResponse;
import com.ceramax.ceramax.dto.common.ApiResponse;
import com.ceramax.ceramax.service.ClienteService;
import jakarta.validation.Valid;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/clientes")
public class ClienteController {

    private final ClienteService clienteService;

    public ClienteController(ClienteService clienteService) {
        this.clienteService = clienteService;
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDEDOR')")
    public ResponseEntity<ApiResponse<?>> listar(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        var pageable = PageRequest.of(page, size, Sort.by("id").descending());
        return ResponseEntity.ok(ApiResponse.ok(clienteService.listar(pageable)));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDEDOR')")
    public ResponseEntity<ApiResponse<ClienteResponse>> obtener(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(clienteService.obtenerPorId(id)));
    }

    @GetMapping("/buscar-por-documento")
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDEDOR')")
    public ResponseEntity<ApiResponse<ClienteResponse>> buscarPorDocumento(
            @RequestParam String numeroDocumento) {
        return ResponseEntity.ok(ApiResponse.ok(clienteService.buscarPorDocumento(numeroDocumento)));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDEDOR')")
    public ResponseEntity<ApiResponse<ClienteResponse>> crear(@Valid @RequestBody ClienteRequest req) {
        return ResponseEntity.ok(ApiResponse.ok("Cliente creado", clienteService.crear(req)));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('VENDEDOR')")
    public ResponseEntity<ApiResponse<ClienteResponse>> actualizar(
            @PathVariable Long id, @Valid @RequestBody ClienteRequest req) {
        return ResponseEntity.ok(ApiResponse.ok("Cliente actualizado", clienteService.actualizar(id, req)));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable Long id) {
        clienteService.eliminar(id);
        return ResponseEntity.ok(ApiResponse.ok("Cliente desactivado", null));
    }
}

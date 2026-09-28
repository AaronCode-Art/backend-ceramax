package com.ceramax.ceramax.controller;

import com.ceramax.ceramax.dto.common.ApiResponse;
import com.ceramax.ceramax.exception.ResourceNotFoundException;
import com.ceramax.ceramax.repository.NotificacionRepository;
import com.ceramax.ceramax.security.OwnershipGuard;
import com.ceramax.ceramax.service.NotificacionService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notificaciones")
public class NotificacionController {

    private final NotificacionService notificacionService;
    private final NotificacionRepository notificacionRepository;
    private final OwnershipGuard ownershipGuard;

    public NotificacionController(NotificacionService notificacionService,
            NotificacionRepository notificacionRepository, OwnershipGuard ownershipGuard) {
        this.notificacionService = notificacionService;
        this.notificacionRepository = notificacionRepository;
        this.ownershipGuard = ownershipGuard;
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<?> listar(
            @PathVariable Long usuarioId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            Authentication authentication) {
        ownershipGuard.assertCanAccess(usuarioId, authentication);
        var pageable = PageRequest.of(page, size, Sort.by("id").descending());
        return ResponseEntity.ok(ApiResponse.ok(notificacionService.listarPorUsuario(usuarioId, pageable)));
    }

    @GetMapping("/usuario/{usuarioId}/no-leidas")
    public ResponseEntity<?> noLeidas(
            @PathVariable Long usuarioId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            Authentication authentication) {
        ownershipGuard.assertCanAccess(usuarioId, authentication);
        var pageable = PageRequest.of(page, size, Sort.by("id").descending());
        return ResponseEntity.ok(ApiResponse.ok(notificacionService.listarNoLeidas(usuarioId, pageable)));
    }

    @GetMapping("/usuario/{usuarioId}/contar-no-leidas")
    public ResponseEntity<ApiResponse<Long>> contarNoLeidas(
            @PathVariable Long usuarioId, Authentication authentication) {
        ownershipGuard.assertCanAccess(usuarioId, authentication);
        return ResponseEntity.ok(ApiResponse.ok(notificacionService.contarNoLeidas(usuarioId)));
    }

    @PatchMapping("/{id}/leida")
    public ResponseEntity<ApiResponse<Void>> marcarLeida(@PathVariable Long id, Authentication authentication) {
        var notificacion = notificacionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Notificación no encontrada"));
        ownershipGuard.assertCanAccess(
                notificacion.getUsuarioDestino() == null ? null : notificacion.getUsuarioDestino().getId(),
                authentication);
        notificacionService.marcarLeida(id);
        return ResponseEntity.ok(ApiResponse.ok("Marcada como leída", null));
    }

    @PatchMapping("/usuario/{usuarioId}/marcar-todas-leidas")
    public ResponseEntity<ApiResponse<Void>> marcarTodasLeidas(
            @PathVariable Long usuarioId, Authentication authentication) {
        ownershipGuard.assertCanAccess(usuarioId, authentication);
        notificacionService.marcarTodasLeidas(usuarioId);
        return ResponseEntity.ok(ApiResponse.ok("Todas marcadas como leídas", null));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable Long id, Authentication authentication) {
        var notificacion = notificacionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Notificación no encontrada"));
        ownershipGuard.assertCanAccess(
                notificacion.getUsuarioDestino() == null ? null : notificacion.getUsuarioDestino().getId(),
                authentication);
        notificacionService.eliminar(id);
        return ResponseEntity.ok(ApiResponse.ok("Notificación eliminada", null));
    }
}

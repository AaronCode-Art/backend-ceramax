package com.ceramax.ceramax.controller;

import com.ceramax.ceramax.dto.common.ApiResponse;
import com.ceramax.ceramax.model.Direccion;
import com.ceramax.ceramax.model.enums.TipoDireccionEnum;
import com.ceramax.ceramax.repository.DireccionRepository;
import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.security.OwnershipGuard;
import com.ceramax.ceramax.exception.ResourceNotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/direcciones")
public class DireccionController {

    private final DireccionRepository direccionRepository;
    private final OwnershipGuard ownershipGuard;

    public DireccionController(DireccionRepository direccionRepository, OwnershipGuard ownershipGuard) {
        this.direccionRepository = direccionRepository;
        this.ownershipGuard = ownershipGuard;
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> listarPorUsuario(
            @PathVariable Long usuarioId, Authentication authentication) {
        ownershipGuard.assertCanAccess(usuarioId, authentication);
        List<Map<String, Object>> result = direccionRepository.findByUsuarioId(usuarioId)
                .stream().map(this::toMap).toList();
        return ResponseEntity.ok(ApiResponse.ok(result));
    }

    @PostMapping("/usuario/{usuarioId}")
    public ResponseEntity<ApiResponse<Map<String, Object>>> crear(
            @PathVariable Long usuarioId, @RequestBody Map<String, Object> req, Authentication authentication) {
        ownershipGuard.assertCanAccess(usuarioId, authentication);
        Direccion d = Direccion.builder()
                .usuario(Usuario.builder().id(usuarioId).build())
                .tipo(TipoDireccionEnum.valueOf((String) req.get("tipo")))
                .calle((String) req.get("calle"))
                .numeroExt((String) req.get("numero_ext"))
                .coloniaSector((String) req.get("colonia_sector"))
                .ciudad((String) req.get("ciudad"))
                .estadoProvincia((String) req.get("estado_provincia"))
                .codigoPostal((String) req.get("codigo_postal"))
                .pais((String) req.get("pais"))
                .telefonoContacto((String) req.get("telefono_contacto"))
                .esPredeterminada(Boolean.TRUE.equals(req.get("es_predeterminada")))
                .build();
        return ResponseEntity.ok(ApiResponse.ok("Direccion creada", toMap(direccionRepository.save(d))));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> eliminar(@PathVariable Long id, Authentication authentication) {
        Direccion direccion = direccionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Dirección no encontrada"));
        ownershipGuard.assertCanAccess(direccion.getUsuario().getId(), authentication);
        direccionRepository.delete(direccion);
        return ResponseEntity.ok(ApiResponse.ok("Direccion eliminada", null));
    }

    private Map<String, Object> toMap(Direccion d) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", d.getId());
        map.put("usuarioId", d.getUsuario() != null ? d.getUsuario().getId() : null);
        map.put("tipo", d.getTipo() != null ? d.getTipo().name() : null);
        map.put("calle", d.getCalle());
        map.put("numero_ext", d.getNumeroExt());
        map.put("colonia_sector", d.getColoniaSector());
        map.put("ciudad", d.getCiudad());
        map.put("estado_provincia", d.getEstadoProvincia());
        map.put("codigo_postal", d.getCodigoPostal());
        map.put("pais", d.getPais());
        map.put("telefono_contacto", d.getTelefonoContacto());
        map.put("es_predeterminada", d.getEsPredeterminada());
        return map;
    }
}

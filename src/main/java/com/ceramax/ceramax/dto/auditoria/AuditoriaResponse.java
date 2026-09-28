package com.ceramax.ceramax.dto.auditoria;

import java.time.LocalDateTime;

public record AuditoriaResponse(
        Long id,
        Long usuarioId,
        String usuarioNombre,
        String accion,
        String entidad,
        Long entidadId,
        String valoresAnteriores,
        String valoresNuevos,
        String descripcion,
        String ipAddress,
        LocalDateTime fechaAuditoria
) {}

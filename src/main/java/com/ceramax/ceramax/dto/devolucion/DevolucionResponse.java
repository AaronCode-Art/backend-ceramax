package com.ceramax.ceramax.dto.devolucion;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record DevolucionResponse(
        Long id,
        Long pedidoId,
        Long detallePedidoId,
        Integer cantidad,
        String motivo,
        String estado,
        BigDecimal montoReembolso,
        LocalDateTime fechaSolicitud,
        LocalDateTime fechaResolucion
) {}

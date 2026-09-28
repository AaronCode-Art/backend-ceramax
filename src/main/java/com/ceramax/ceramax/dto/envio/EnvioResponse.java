package com.ceramax.ceramax.dto.envio;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public record EnvioResponse(
        Long id,
        Long pedidoId,
        String codigoPedido,
        Long transportistaId,
        String transportistaNombre,
        String numeroSeguimiento,
        BigDecimal costoEnvio,
        String estadoPedido,
        String tipoEntrega,
        LocalDateTime fechaEnvio,
        LocalDate fechaEntregaEstimada,
        LocalDateTime fechaEntregaReal
) {}

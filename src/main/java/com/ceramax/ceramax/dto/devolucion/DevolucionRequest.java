package com.ceramax.ceramax.dto.devolucion;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record DevolucionRequest(
        @NotNull Long pedidoId,
        @NotNull Long detallePedidoId,
        @NotNull Integer cantidad,
        @NotNull String motivo,
        BigDecimal montoReembolso
) {}

package com.ceramax.ceramax.dto.checkout;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record CheckoutRequest(
        @NotNull Long carritoId,
        @NotBlank String tipoEntrega,
        Long direccionEnvioId,
        Long sucursalRecojoId,
        @NotNull Long metodoPagoId,
        String notas
) {}

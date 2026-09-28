package com.ceramax.ceramax.dto.pago;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record PagoRequest(
        @NotNull Long pedidoId,
        @NotNull Long metodoPagoId,
        @NotNull BigDecimal monto,
        String referenciaTransaccion,
        String pasarelaPago
) {}

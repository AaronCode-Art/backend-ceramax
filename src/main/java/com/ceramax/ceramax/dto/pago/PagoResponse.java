package com.ceramax.ceramax.dto.pago;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record PagoResponse(
        Long id,
        Long pedidoId,
        Long metodoPagoId,
        String metodoPagoNombre,
        BigDecimal monto,
        String estadoPago,
        String referenciaTransaccion,
        String pasarelaPago,
        LocalDateTime fechaPago
) {}

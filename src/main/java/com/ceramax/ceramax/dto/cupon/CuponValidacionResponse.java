package com.ceramax.ceramax.dto.cupon;

import java.math.BigDecimal;

public record CuponValidacionResponse(
        boolean valido,
        String codigo,
        String tipoDescuento,
        BigDecimal valor,
        BigDecimal descuento,
        BigDecimal montoMinimoCompra,
        String mensaje
) {}

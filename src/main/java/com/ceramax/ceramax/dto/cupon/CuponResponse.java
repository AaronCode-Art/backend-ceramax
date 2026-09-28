package com.ceramax.ceramax.dto.cupon;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record CuponResponse(
        Integer id,
        String codigo,
        String tipoDescuento,
        BigDecimal valor,
        BigDecimal montoMinimoCompra,
        LocalDateTime fechaInicio,
        LocalDateTime fechaFin,
        Integer usoMaximo,
        Integer usoActual,
        String estado
) {}

package com.ceramax.ceramax.dto.cupon;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public record CuponRequest(
        @NotBlank String codigo,
        @NotBlank String tipoDescuento,
        @NotNull BigDecimal valor,
        BigDecimal montoMinimoCompra,
        @NotNull LocalDateTime fechaInicio,
        @NotNull LocalDateTime fechaFin,
        Integer usoMaximo
) {}

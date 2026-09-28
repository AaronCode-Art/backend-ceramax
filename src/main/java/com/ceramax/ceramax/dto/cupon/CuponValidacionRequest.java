package com.ceramax.ceramax.dto.cupon;

import jakarta.validation.constraints.NotBlank;
import java.math.BigDecimal;

public record CuponValidacionRequest(
        @NotBlank String codigo,
        BigDecimal monto
) {}

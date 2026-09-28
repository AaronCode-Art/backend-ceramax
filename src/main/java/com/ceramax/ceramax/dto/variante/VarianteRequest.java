package com.ceramax.ceramax.dto.variante;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record VarianteRequest(
        @NotNull Long productoId,
        @NotBlank String skuVariante,
        String codigoBarras,
        BigDecimal precioAdicional
) {
    @Override
    public BigDecimal precioAdicional() { return precioAdicional == null ? BigDecimal.ZERO : precioAdicional; }
}

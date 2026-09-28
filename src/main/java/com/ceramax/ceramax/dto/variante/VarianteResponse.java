package com.ceramax.ceramax.dto.variante;

import com.ceramax.ceramax.dto.atributo.VarianteAtributoResponse;

import java.math.BigDecimal;
import java.util.List;

public record VarianteResponse(
        Long id,
        Long productoId,
        String productoNombre,
        String skuVariante,
        String codigoBarras,
        BigDecimal precioAdicional,
        String estado,
        List<VarianteAtributoResponse> atributos
) {}

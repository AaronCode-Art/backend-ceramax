package com.ceramax.ceramax.dto.producto;

import java.math.BigDecimal;

public record ProductoCatalogoResponse(
        Long id,
        String sku,
        String nombre,
        Long categoriaId,
        String categoria,
        BigDecimal precio,
        Integer stock,
        String imagen
) {}

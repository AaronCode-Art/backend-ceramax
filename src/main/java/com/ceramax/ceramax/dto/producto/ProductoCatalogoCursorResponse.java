package com.ceramax.ceramax.dto.producto;

import java.util.List;

public record ProductoCatalogoCursorResponse(
        List<ProductoCatalogoResponse> items,
        Long nextCursor,
        boolean hasMore
) {}

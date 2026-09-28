package com.ceramax.ceramax.dto.categoria;

public record CategoriaResponse(
        Long id,
        String nombre,
        String descripcion,
        String imagen,
        String imagenPublicId,
        Long cantidadProductos,
        String estado
) {}

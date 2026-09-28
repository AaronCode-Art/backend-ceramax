package com.ceramax.ceramax.dto.marca;

public record MarcaResponse(
        Integer id,
        String nombre,
        String descripcion,
        String logoUrl,
        String sitioWeb,
        String estado
) {}

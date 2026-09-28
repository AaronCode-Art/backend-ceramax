package com.ceramax.ceramax.dto.categoria;

import jakarta.validation.constraints.NotBlank;

public record CategoriaRequest(
        @NotBlank String nombre,
        String descripcion,
        String imagen,
        String imagenPublicId
) {}

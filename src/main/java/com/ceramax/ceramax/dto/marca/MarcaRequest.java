package com.ceramax.ceramax.dto.marca;

import jakarta.validation.constraints.NotBlank;

public record MarcaRequest(
        @NotBlank String nombre,
        String descripcion,
        String logoUrl,
        String sitioWeb
) {}

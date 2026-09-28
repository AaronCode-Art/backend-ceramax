package com.ceramax.ceramax.dto.transportista;

import jakarta.validation.constraints.NotBlank;

public record TransportistaRequest(
        @NotBlank String nombre,
        String sitioRastreoUrl
) {}

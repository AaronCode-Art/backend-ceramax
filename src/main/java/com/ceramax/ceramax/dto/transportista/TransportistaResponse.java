package com.ceramax.ceramax.dto.transportista;

public record TransportistaResponse(
        Integer id,
        String nombre,
        String sitioRastreoUrl,
        String estado
) {}

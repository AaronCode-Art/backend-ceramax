package com.ceramax.ceramax.dto.imagen;

public record ImagenResponse(
        Long id,
        Long productoId,
        Long varianteId,
        String urlImagen,
        String imagenPublicId,
        Boolean esPrincipal,
        Integer orden
) {}

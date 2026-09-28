package com.ceramax.ceramax.dto.imagen;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record ImagenRequest(
        @NotNull Long productoId,
        Long varianteId,
        @NotBlank String urlImagen,
        String imagenPublicId,
        Boolean esPrincipal,
        Integer orden) {
    @Override
    public Boolean esPrincipal() {
        return esPrincipal == null ? false : esPrincipal;
    }

    @Override
    public Integer orden() {
        return orden == null ? 0 : orden;
    }
}

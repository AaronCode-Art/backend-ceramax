package com.ceramax.ceramax.dto.atributo;

import jakarta.validation.constraints.NotNull;

public record CategoriaAtributoRequest(
        @NotNull Integer categoriaId,
        @NotNull Integer atributoId,
        Boolean esObligatorio
) {
    public boolean obligatorio() {
        return Boolean.TRUE.equals(esObligatorio);
    }
}

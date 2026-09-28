package com.ceramax.ceramax.dto.atributo;

public record CategoriaAtributoResponse(
        Integer categoriaId,
        Integer atributoId,
        String atributoNombre,
        Boolean esObligatorio
) {
}

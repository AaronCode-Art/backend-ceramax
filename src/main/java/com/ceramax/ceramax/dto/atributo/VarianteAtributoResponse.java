package com.ceramax.ceramax.dto.atributo;

public record VarianteAtributoResponse(
        Long varianteId,
        Integer valorId,
        Integer atributoId,
        String atributoNombre,
        String valor
) {
}

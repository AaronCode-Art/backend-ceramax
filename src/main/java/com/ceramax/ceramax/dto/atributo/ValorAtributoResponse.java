package com.ceramax.ceramax.dto.atributo;

public record ValorAtributoResponse(
        Integer id,
        Integer atributoId,
        String atributoNombre,
        String valor
) {
}

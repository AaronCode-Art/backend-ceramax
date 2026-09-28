package com.ceramax.ceramax.dto.atributo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record ValorAtributoRequest(
        @NotNull Integer atributoId,
        @NotBlank String valor
) {
}

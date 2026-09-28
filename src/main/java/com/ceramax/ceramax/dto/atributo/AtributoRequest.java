package com.ceramax.ceramax.dto.atributo;

import jakarta.validation.constraints.NotBlank;

public record AtributoRequest(@NotBlank String nombre) {
}

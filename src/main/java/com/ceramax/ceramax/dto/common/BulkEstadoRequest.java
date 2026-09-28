package com.ceramax.ceramax.dto.common;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;

import java.util.List;

public record BulkEstadoRequest(
        @NotEmpty(message = "Selecciona al menos un producto") List<Long> ids,
        @NotBlank(message = "El estado es obligatorio") String estado
) {
}
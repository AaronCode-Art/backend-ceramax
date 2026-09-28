package com.ceramax.ceramax.dto.common;

import jakarta.validation.constraints.NotEmpty;

import java.util.List;

public record BulkIdsRequest(
        @NotEmpty(message = "Selecciona al menos un producto") List<Long> ids
) {
}
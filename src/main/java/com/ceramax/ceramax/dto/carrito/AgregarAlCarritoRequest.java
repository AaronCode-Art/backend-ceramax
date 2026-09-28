package com.ceramax.ceramax.dto.carrito;

import jakarta.validation.constraints.NotNull;

public record AgregarAlCarritoRequest(
        @NotNull Long varianteId,
        @NotNull Integer cantidad
) {}

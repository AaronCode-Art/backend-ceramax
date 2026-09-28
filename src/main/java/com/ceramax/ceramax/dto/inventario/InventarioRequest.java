package com.ceramax.ceramax.dto.inventario;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record InventarioRequest(
        @NotNull Long varianteId,
        @NotNull Integer almacenId,
        @PositiveOrZero Integer cantidadDisponible,
        Integer stockMinimo,
        Integer stockMaximo,
        Integer puntoReorden,
        Boolean permiteReposicion
) {}

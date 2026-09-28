package com.ceramax.ceramax.dto.listaDeseos;

import jakarta.validation.constraints.NotNull;

public record ListaDeseosRequest(
        @NotNull Long usuarioId,
        @NotNull Long varianteId
) {}

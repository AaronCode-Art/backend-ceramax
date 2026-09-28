package com.ceramax.ceramax.dto.metodopago;

import jakarta.validation.constraints.NotBlank;

public record MetodoPagoRequest(
        @NotBlank String nombre
) {}

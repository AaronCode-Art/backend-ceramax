package com.ceramax.ceramax.dto.movimientoinventario;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;

public record MovimientoInventarioRequest(
        @NotNull Long inventarioId,
        @NotBlank String tipoMovimiento,
        @NotNull @Positive Integer cantidad,
        String motivo,
        String referenciaDocumento,
        Long usuarioResponsableId
) {}

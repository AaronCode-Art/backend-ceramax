package com.ceramax.ceramax.dto.envio;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public record EnvioRequest(
        @NotNull Long pedidoId,
        Long transportistaId,
        String numeroSeguimiento,
        LocalDate fechaEntregaEstimada
) {}

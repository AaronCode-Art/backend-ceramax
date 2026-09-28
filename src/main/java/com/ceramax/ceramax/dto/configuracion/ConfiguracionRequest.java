package com.ceramax.ceramax.dto.configuracion;

import jakarta.validation.constraints.NotBlank;
import java.math.BigDecimal;

public record ConfiguracionRequest(
                @NotBlank String nombreTienda,
                String moneda,
                String paisOperacion,
                BigDecimal porcentajeImpuestoDefault,
                Boolean permiteVentaPresencial,
                Boolean permiteRecojoTienda) {
}

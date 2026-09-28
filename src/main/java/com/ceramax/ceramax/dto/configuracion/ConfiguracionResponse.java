package com.ceramax.ceramax.dto.configuracion;

import java.math.BigDecimal;

public record ConfiguracionResponse(
                Integer id,
                String nombreTienda,
                String moneda,
                String paisOperacion,
                BigDecimal porcentajeImpuestoDefault,
                Boolean permiteVentaPresencial,
                Boolean permiteRecojoTienda) {
}

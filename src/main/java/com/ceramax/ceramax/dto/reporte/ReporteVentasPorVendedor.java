package com.ceramax.ceramax.dto.reporte;

import java.math.BigDecimal;
import java.util.List;

public record ReporteVentasPorVendedor(
        Long usuarioId,
        String nombreVendedor,
        Long totalVentas,
        BigDecimal ingresosTotales
) {}

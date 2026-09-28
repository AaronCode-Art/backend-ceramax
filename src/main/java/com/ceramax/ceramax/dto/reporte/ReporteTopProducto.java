package com.ceramax.ceramax.dto.reporte;

import java.math.BigDecimal;

public record ReporteTopProducto(
        Long productoId,
        String productoNombre,
        Long totalVendidos,
        BigDecimal ingresosTotales
) {}

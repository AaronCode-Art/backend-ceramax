package com.ceramax.ceramax.dto.reporte;

import java.math.BigDecimal;

public record ReporteVentaDiaria(
        String fecha,
        Long cantidadPedidos,
        BigDecimal ingresos
) {}

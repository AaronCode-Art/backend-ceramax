package com.ceramax.ceramax.dto.reporte;

import java.math.BigDecimal;

public record ResumenDashboardResponse(
        Long numeroVentas,
        Long pendientes,
        Long despachadas,
        BigDecimal ingresos,
        BigDecimal igvTotal,
        BigDecimal ticketPromedio,
        Long stockBajo
) {}

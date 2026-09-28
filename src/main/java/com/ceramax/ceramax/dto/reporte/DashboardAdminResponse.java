package com.ceramax.ceramax.dto.reporte;

import java.math.BigDecimal;
import java.util.List;

public record DashboardAdminResponse(
        // Resumen general
        Long totalVentas,
        Long pendientes,
        Long despachadas,
        BigDecimal ingresos,
        BigDecimal igvTotal,
        BigDecimal ticketPromedio,
        Long stockBajo,
        // Nuevos
        Long totalProductos,
        Long totalUsuarios,
        Long totalClientes,
        Long totalVendedores,
        Long pedidosHoy,
        BigDecimal ingresosHoy,
        Long notificacionesSinLeer,
        // Listas para gráficos
        List<ReportePedidoPorEstado> pedidosPorEstado,
        List<ReporteVentaDiaria> ventasDiarias,
        List<ReporteVentasPorVendedor> ventasPorVendedor,
        List<ReporteTopProducto> topProductos,
        List<ReporteTopCliente> topClientes
) {}

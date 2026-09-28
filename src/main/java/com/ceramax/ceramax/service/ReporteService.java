package com.ceramax.ceramax.service;

import com.ceramax.ceramax.dto.reporte.*;
import com.ceramax.ceramax.repository.*;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class ReporteService {

    private static final DateTimeFormatter DIA_MM_DD = DateTimeFormatter.ofPattern("dd/MM");

    private final PedidoRepository pedidoRepository;
    private final InventarioRepository inventarioRepository;
    private final ProductoRepository productoRepository;
    private final UsuarioRepository usuarioRepository;
    private final DetallePedidoRepository detallePedidoRepository;

    public ReporteService(PedidoRepository pedidoRepository, InventarioRepository inventarioRepository,
                          ProductoRepository productoRepository, UsuarioRepository usuarioRepository,
                          DetallePedidoRepository detallePedidoRepository) {
        this.pedidoRepository = pedidoRepository;
        this.inventarioRepository = inventarioRepository;
        this.productoRepository = productoRepository;
        this.usuarioRepository = usuarioRepository;
        this.detallePedidoRepository = detallePedidoRepository;
    }

    @Cacheable(value = "reportes", key = "'resumen_' + #desde.toLocalDate() + '_' + #hasta.toLocalDate()")
    @Transactional(readOnly = true)
    public ResumenDashboardResponse resumen(LocalDateTime desde, LocalDateTime hasta) {
        var agg = pedidoRepository.resumenEntre(desde, hasta);
        long numeroVentas = nz(agg != null ? agg.getTotal() : null);
        long pendientes = nz(agg != null ? agg.getPendientes() : null);
        long despachadas = nz(agg != null ? agg.getDespachadas() : null);
        BigDecimal ingresos = bd(agg != null ? agg.getIngresos() : null);
        BigDecimal igvTotal = bd(agg != null ? agg.getIgv() : null);
        BigDecimal ticketPromedio = ticket(numeroVentas, ingresos);
        long stockBajo = inventarioRepository.countStockBajo();
        return new ResumenDashboardResponse(numeroVentas, pendientes, despachadas, ingresos, igvTotal, ticketPromedio, stockBajo);
    }

    @Cacheable(value = "reportes", key = "'dashboard_' + #desde.toLocalDate() + '_' + #hasta.toLocalDate()")
    @Transactional(readOnly = true)
    public DashboardAdminResponse dashboardCompleto(LocalDateTime desde, LocalDateTime hasta) {
        var agg = pedidoRepository.resumenEntre(desde, hasta);
        long totalVentas = nz(agg != null ? agg.getTotal() : null);
        long pendientes = nz(agg != null ? agg.getPendientes() : null);
        long despachadas = nz(agg != null ? agg.getDespachadas() : null);
        BigDecimal ingresos = bd(agg != null ? agg.getIngresos() : null);
        BigDecimal igvTotal = bd(agg != null ? agg.getIgv() : null);
        BigDecimal ticketPromedio = ticket(totalVentas, ingresos);
        long stockBajo = inventarioRepository.countStockBajo();

        long totalProductos = productoRepository.count();
        long totalUsuarios = usuarioRepository.count();

        LocalDateTime inicioHoy = LocalDateTime.now().with(LocalTime.MIN);
        LocalDateTime finHoy = LocalDateTime.now().with(LocalTime.MAX);
        var aggHoy = pedidoRepository.resumenEntre(inicioHoy, finHoy);
        long pedidosHoy = nz(aggHoy != null ? aggHoy.getTotal() : null);
        BigDecimal ingresosHoy = bd(aggHoy != null ? aggHoy.getIngresos() : null);

        List<ReportePedidoPorEstado> pedidosPorEstado = pedidoRepository.contarPorEstado(desde, hasta).stream()
                .map(a -> new ReportePedidoPorEstado(a.getEstado(), a.getCantidad()))
                .toList();

        List<ReporteVentaDiaria> ventasDiarias = pedidoRepository.ventasDiarias(desde, hasta).stream()
                .map(a -> new ReporteVentaDiaria(
                        a.getDia() != null ? a.getDia().format(DIA_MM_DD) : "N/A",
                        a.getCantidad(), bd(a.getIngresos())))
                .toList();

        List<ReporteVentasPorVendedor> ventasPorVendedor = pedidoRepository.ventasPorVendedor(desde, hasta).stream()
                .map(a -> new ReporteVentasPorVendedor(a.getUsuarioId(), a.getNombre(), a.getTotal(), bd(a.getIngresos())))
                .toList();

        List<ReporteTopProducto> topProductos = detallePedidoRepository.topProductos(desde, hasta).stream()
                .map(a -> new ReporteTopProducto(a.getProductoId(), a.getNombre(), a.getVendidos(), bd(a.getIngresos())))
                .toList();

        List<ReporteTopCliente> topClientes = pedidoRepository.topClientes(desde, hasta).stream()
                .map(a -> new ReporteTopCliente(a.getUsuarioId(), a.getNombre(), a.getTotal(), bd(a.getMonto())))
                .toList();

        return new DashboardAdminResponse(
                totalVentas, pendientes, despachadas, ingresos, igvTotal, ticketPromedio, stockBajo,
                totalProductos, totalUsuarios, 0L, 0L, pedidosHoy, ingresosHoy, 0L,
                pedidosPorEstado, ventasDiarias, ventasPorVendedor, topProductos, topClientes
        );
    }

    @Cacheable(value = "reportes", key = "'vendedores_' + #desde.toLocalDate() + '_' + #hasta.toLocalDate()")
    @Transactional(readOnly = true)
    public List<ReporteVentasPorVendedor> ventasPorVendedor(LocalDateTime desde, LocalDateTime hasta) {
        return pedidoRepository.ventasPorVendedor(desde, hasta).stream()
                .map(a -> new ReporteVentasPorVendedor(a.getUsuarioId(), a.getNombre(), a.getTotal(), bd(a.getIngresos())))
                .toList();
    }

    private static long nz(Long v) {
        return v != null ? v : 0L;
    }

    private static BigDecimal bd(BigDecimal v) {
        return v != null ? v : BigDecimal.ZERO;
    }

    private static BigDecimal ticket(long numeroVentas, BigDecimal ingresos) {
        return numeroVentas > 0
                ? ingresos.divide(BigDecimal.valueOf(numeroVentas), 2, RoundingMode.HALF_UP)
                : BigDecimal.ZERO;
    }
}

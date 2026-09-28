package com.ceramax.ceramax.controller;

import com.ceramax.ceramax.dto.common.ApiResponse;
import com.ceramax.ceramax.dto.reporte.*;
import com.ceramax.ceramax.service.ReporteService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/reportes")
@PreAuthorize("hasAnyRole('ADMIN') or hasAuthority('PERM_REPORTES_VER')")
public class ReporteController {

    private final ReporteService reporteService;

    public ReporteController(ReporteService reporteService) {
        this.reporteService = reporteService;
    }

    @GetMapping("/resumen")
    public ResponseEntity<ApiResponse<ResumenDashboardResponse>> resumen(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime desde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime hasta) {
        LocalDateTime[] rango = rangoPorDefecto(desde, hasta);
        return ResponseEntity.ok(ApiResponse.ok(reporteService.resumen(rango[0], rango[1])));
    }

    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<DashboardAdminResponse>> dashboard(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime desde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime hasta) {
        LocalDateTime[] rango = rangoPorDefecto(desde, hasta);
        return ResponseEntity.ok(ApiResponse.ok(reporteService.dashboardCompleto(rango[0], rango[1])));
    }

    @GetMapping("/ventas-por-vendedor")
    public ResponseEntity<ApiResponse<List<ReporteVentasPorVendedor>>> ventasPorVendedor(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime desde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime hasta) {
        LocalDateTime[] rango = rangoPorDefecto(desde, hasta);
        return ResponseEntity.ok(ApiResponse.ok(reporteService.ventasPorVendedor(rango[0], rango[1])));
    }

    /**
     * Si el frontend no envía fechas (ej. al cargar el dashboard por primera vez),
     * se usa un rango por defecto de los últimos 30 días en vez de fallar.
     */
    private LocalDateTime[] rangoPorDefecto(LocalDateTime desde, LocalDateTime hasta) {
        LocalDateTime finalHasta = hasta != null ? hasta : LocalDateTime.now();
        LocalDateTime finalDesde = desde != null ? desde : finalHasta.minusDays(30);
        return new LocalDateTime[] { finalDesde, finalHasta };
    }
}

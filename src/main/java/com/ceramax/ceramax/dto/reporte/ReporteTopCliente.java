package com.ceramax.ceramax.dto.reporte;

import java.math.BigDecimal;

public record ReporteTopCliente(
        Long usuarioId,
        String nombreCliente,
        Long totalCompras,
        BigDecimal montoTotal
) {}

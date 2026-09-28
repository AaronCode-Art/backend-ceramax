package com.ceramax.ceramax.dto.producto;

import com.ceramax.ceramax.dto.common.ApiResponse;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public record ProductoResponse(
        Long id,
        String sku,
        String nombre,
        String detalle,
        String descripcionCorta,
        String descripcion,
        Long categoriaId,
        String categoria,
        BigDecimal precio,
        BigDecimal precioConDescuento,
        BigDecimal descuentoPorcentaje,
        BigDecimal costo,
        java.time.LocalDate fechaCaducidad,
        Boolean requiereEnvioFisico,
        String metaTitulo,
        String metaDescripcion,
        Long marcaId,
        String marca,
        Long proveedorId,
        String proveedor,
        Integer stock,
        Boolean destacado,
        String imagen,
        String imagenPublicId,
        Boolean tieneDescuento,
        LocalDateTime creadoEl,
        Map<String, String> especificaciones,
        String estado
) {}

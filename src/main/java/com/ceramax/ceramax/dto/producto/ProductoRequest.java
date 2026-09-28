package com.ceramax.ceramax.dto.producto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.util.Map;

public record ProductoRequest(
        @NotBlank String sku,
        @NotBlank String nombre,
        String detalle,
        String descripcionCorta,
        String descripcion,
        @NotNull Long categoriaId,
        @NotNull @DecimalMin("0.01") @Digits(integer = 10, fraction = 2) BigDecimal precio,
        Integer stock,
        Boolean destacado,
        String imagen,
        String imagenPublicId,
        Boolean tieneDescuento,
        @DecimalMin("0") BigDecimal descuentoPorcentaje,
        Map<String, String> especificaciones,
        BigDecimal costo,
        java.time.LocalDate fechaCaducidad,
        Boolean requiereEnvioFisico,
        @Size(max = 200) String metaTitulo,
        @Size(max = 300) String metaDescripcion,
        Long marcaId,
        Long proveedorId
) {}

package com.ceramax.ceramax.dto.inventario;

import java.time.LocalDateTime;

public record InventarioResponse(
        Long id,
        Long varianteId,
        String skuVariante,
        Long productoId,
        String nombreProducto,
        Long categoriaId,
        Integer almacenId,
        String nombreAlmacen,
        Integer cantidadDisponible,
        Integer cantidadReservada,
        Integer stockMinimo,
        Integer stockMaximo,
        LocalDateTime ultimaActualizacion
) {}

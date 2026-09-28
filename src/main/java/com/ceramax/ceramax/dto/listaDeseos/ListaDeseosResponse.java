package com.ceramax.ceramax.dto.listaDeseos;

import java.time.LocalDateTime;

public record ListaDeseosResponse(
        Long id,
        Long usuarioId,
        Long varianteId,
        Long productoId,
        String skuVariante,
        String nombreProducto,
        LocalDateTime fechaAgregado
) {}

package com.ceramax.ceramax.dto.detallepedido;

import java.math.BigDecimal;

public record DetallePedidoResponse(
        Long id,
        Long pedidoId,
        Long varianteId,
        String skuSnapshot,
        String nombreProductoSnapshot,
        Integer cantidad,
        BigDecimal precioUnitario,
        BigDecimal subtotal,
        Integer almacenId
) {}

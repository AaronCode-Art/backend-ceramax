package com.ceramax.ceramax.dto.checkout;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record CheckoutResponse(
        Long pedidoId,
        String numeroPedido,
        String estado,
        BigDecimal subtotal,
        BigDecimal impuestos,
        BigDecimal costoEnvio,
        BigDecimal total,
        String metodoPago,
        String estadoPago,
        String tipoEntrega,
        LocalDateTime fechaPedido,
        List<ItemCheckoutResponse> items
) {
    public record ItemCheckoutResponse(
            Long varianteId,
            String sku,
            String nombreProducto,
            Integer cantidad,
            BigDecimal precioUnitario,
            BigDecimal subtotal
    ) {}
}

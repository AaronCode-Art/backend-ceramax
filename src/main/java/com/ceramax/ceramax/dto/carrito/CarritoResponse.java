package com.ceramax.ceramax.dto.carrito;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record CarritoResponse(
        Long id,
        Long usuarioId,
        String sessionId,
        String estado,
        LocalDateTime fechaCreacion,
        List<DetalleCarritoResponse> items
) {
    public record DetalleCarritoResponse(
            Long id,
            Long varianteId,
            String skuVariante,
            String nombreProducto,
            Integer cantidad,
            BigDecimal precioUnitarioMomento,
            BigDecimal subtotal
    ) {}
}

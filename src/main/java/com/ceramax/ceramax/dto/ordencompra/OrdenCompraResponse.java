package com.ceramax.ceramax.dto.ordencompra;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public record OrdenCompraResponse(
        Long id,
        Integer proveedorId,
        String proveedorNombre,
        Integer almacenDestinoId,
        String almacenNombre,
        LocalDateTime fechaOrden,
        LocalDate fechaRecepcionEstimada,
        String estado,
        BigDecimal total,
        Long usuarioCreadorId,
        List<DetalleOCResponse> items
) {
    public record DetalleOCResponse(
            Long id,
            Long varianteId,
            String skuVariante,
            Integer cantidadSolicitada,
            Integer cantidadRecibida,
            BigDecimal costoUnitario,
            BigDecimal subtotal
    ) {}
}

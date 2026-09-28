package com.ceramax.ceramax.dto.ordencompra;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record OrdenCompraRequest(
        @NotNull Integer proveedorId,
        @NotNull Integer almacenDestinoId,
        LocalDate fechaRecepcionEstimada,
        List<DetalleOCRequest> items
) {
    public record DetalleOCRequest(
            @NotNull Long varianteId,
            @NotNull Integer cantidadSolicitada,
            @NotNull BigDecimal costoUnitario
    ) {}
}

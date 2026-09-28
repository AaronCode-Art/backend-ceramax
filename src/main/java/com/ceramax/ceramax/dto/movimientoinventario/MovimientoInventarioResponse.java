package com.ceramax.ceramax.dto.movimientoinventario;

import java.time.LocalDateTime;

public record MovimientoInventarioResponse(
        Long id,
        Long inventarioId,
        String tipoMovimiento,
        Integer cantidad,
        Integer cantidadAntes,
        Integer cantidadDespues,
        String motivo,
        String referenciaDocumento,
        Long usuarioResponsableId,
        LocalDateTime fechaMovimiento
) {}

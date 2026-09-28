package com.ceramax.ceramax.dto.resena;

import java.time.LocalDateTime;

public record ResenaResponse(
        Long id,
        Long productoId,
        String productoNombre,
        Long usuarioId,
        String usuarioNombre,
        Long pedidoId,
        Short calificacion,
        String titulo,
        String comentario,
        String estado,
        LocalDateTime fechaResena
) {}

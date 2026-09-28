package com.ceramax.ceramax.dto.usuario;

import java.time.LocalDateTime;

public record UsuarioResponse(
        Long id,
        String nombre,
        String apellido,
        String dni,
        String telefono,
        String email,
        String rol,
        Boolean activo,
        LocalDateTime creadoEl
) {}

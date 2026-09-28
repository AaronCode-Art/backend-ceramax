package com.ceramax.ceramax.dto.cliente;

import java.time.LocalDateTime;

public record ClienteResponse(
        Long id,
        String nombre,
        String apellido,
        String tipoDocumento,
        String numeroDocumento,
        String departamento,
        String provincia,
        String distrito,
        String direccion,
        String referencia,
        String codigoPostal,
        String email,
        String telefono,
        String ruc,
        String razonSocial,
        String estado,
        LocalDateTime creadoEl
) {}

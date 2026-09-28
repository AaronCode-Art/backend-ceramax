package com.ceramax.ceramax.dto.cliente;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ClienteRequest(
        @NotBlank @Size(max = 100) String nombre,
        @NotBlank @Size(max = 100) String apellido,
        @NotBlank @Size(max = 20) String tipoDocumento,
        @NotBlank @Size(max = 20) String numeroDocumento,
        @NotBlank @Size(max = 100) String departamento,
        @NotBlank @Size(max = 100) String provincia,
        @NotBlank @Size(max = 100) String distrito,
        @NotBlank @Size(max = 250) String direccion,
        @Size(max = 250) String referencia,
        @Size(max = 20) String codigoPostal,
        @NotBlank @Email @Size(max = 150) String email,
        @Size(max = 30) String telefono,
        @Size(max = 20) String ruc,
        @Size(max = 200) String razonSocial
) {}

package com.ceramax.ceramax.dto.usuario;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UsuarioRequest(
        @NotBlank String nombre,
        String apellido,
        String dni,
        String telefono,
        @NotBlank @Email String email,
        @Size(min = 8) String password,
        @NotBlank String rol,
        Boolean activo
) {}

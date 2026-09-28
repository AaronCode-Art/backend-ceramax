package com.ceramax.ceramax.dto.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RegistroRequest(
        @NotBlank(message = "El nombre es obligatorio") @Size(max = 100) String nombre,
        @NotBlank(message = "El apellido es obligatorio") @Size(max = 100) String apellido,
        @NotBlank @Email(message = "Correo inválido") @Size(max = 150) String email,
        @NotBlank(message = "La contraseña es obligatoria") @Size(min = 6, message = "La contraseña debe tener al menos 6 caracteres") String password
) {}
package com.ceramax.ceramax.dto.proveedor;

import jakarta.validation.constraints.NotBlank;

public record ProveedorRequest(
        @NotBlank String nombreEmpresa,
        String contactoNombre,
        String email,
        String telefono,
        String direccion,
        String condicionesPago
) {}

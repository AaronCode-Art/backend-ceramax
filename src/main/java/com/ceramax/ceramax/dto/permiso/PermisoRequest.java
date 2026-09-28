package com.ceramax.ceramax.dto.permiso;

import jakarta.validation.constraints.NotBlank;

public record PermisoRequest(
        @NotBlank String nombrePermiso,
        String descripcion
) {}

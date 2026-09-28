package com.ceramax.ceramax.dto.rol;

import jakarta.validation.constraints.NotBlank;
import java.util.Set;

public record RolRequest(
        @NotBlank String nombreRol,
        String descripcion,
        Set<Integer> permisosIds
) {}

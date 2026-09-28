package com.ceramax.ceramax.dto.rol;

import jakarta.validation.constraints.NotNull;

import java.util.Set;

public record RolPermisosRequest(@NotNull Set<Integer> permisosIds) {
}

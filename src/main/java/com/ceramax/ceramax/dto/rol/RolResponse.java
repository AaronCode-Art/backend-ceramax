package com.ceramax.ceramax.dto.rol;

import java.util.Set;

public record RolResponse(
        Integer id,
        String nombreRol,
        String descripcion,
        boolean activo,
        Set<PermisoResponse> permisos
) {
    public record PermisoResponse(Integer id, String nombrePermiso, String descripcion) {}
}

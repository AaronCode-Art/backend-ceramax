package com.ceramax.ceramax.dto.auth;

import java.util.Set;

public record AuthResponse(
        String token,
        String tipo,
        Long usuarioId,
        String nombre,
        String apellido,
        String email,
        String rol,
        Set<String> permisos
) {
    public AuthResponse(String token, Long usuarioId, String nombre, String apellido,
                        String email, String rol, Set<String> permisos) {
        this(token, "Bearer", usuarioId, nombre, apellido, email, rol, permisos);
    }

    public AuthResponse(String token, Long usuarioId, String nombre, String apellido, String email, String rol) {
        this(token, "Bearer", usuarioId, nombre, apellido, email, rol, Set.of());
    }
}

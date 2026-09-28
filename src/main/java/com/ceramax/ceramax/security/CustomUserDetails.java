package com.ceramax.ceramax.security;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

public class CustomUserDetails extends User {

    private final Long usuarioId;
    private final String nombre;
    private final String apellido;

    public CustomUserDetails(String username, String password, boolean enabled,
                             Collection<? extends GrantedAuthority> authorities,
                             Long usuarioId, String nombre, String apellido) {
        super(username, password, enabled, true, true, true, authorities);
        this.usuarioId = usuarioId;
        this.nombre = nombre;
        this.apellido = apellido;
    }

    public Long getUsuarioId() {
        return usuarioId;
    }

    public String getNombre() {
        return nombre;
    }

    public String getApellido() {
        return apellido;
    }
}

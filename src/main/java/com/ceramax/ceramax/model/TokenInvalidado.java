package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/**
 * Guarda el hash de cada token invalidado (logout) hasta que expire por sí
 * solo. Antes esto vivía solo en memoria (un Set en TokenBlacklistService),
 * así que un reinicio del servidor "revivía" tokens ya cerrados por el
 * usuario. Se guarda el hash SHA-256, no el JWT completo, por seguridad.
 */
@Entity
@Table(name = "tokens_invalidados")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class TokenInvalidado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_token_invalidado")
    private Long id;

    @Column(name = "token_hash", length = 64, nullable = false, unique = true)
    private String tokenHash;

    @Column(name = "fecha_expiracion", nullable = false)
    private LocalDateTime fechaExpiracion;

    @Column(name = "fecha_invalidacion")
    private LocalDateTime fechaInvalidacion;

    @PrePersist
    void prePersist() {
        if (fechaInvalidacion == null) fechaInvalidacion = LocalDateTime.now();
    }
}

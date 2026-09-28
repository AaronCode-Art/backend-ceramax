package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "auditorias")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Auditoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_auditoria")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    @Column(nullable = false, length = 50)
    private String accion;

    @Column(nullable = false, length = 100)
    private String entidad;

    @Column(name = "entidad_id")
    private Long entidadId;

    @Column(columnDefinition = "TEXT")
    private String valoresAnteriores;

    @Column(columnDefinition = "TEXT")
    private String valoresNuevos;

    @Column(length = 255)
    private String descripcion;

    @Column(name = "ip_address", length = 50)
    private String ipAddress;

    @Column(name = "user_agent", length = 500)
    private String userAgent;

    @Column(name = "fecha_auditoria", nullable = false)
    private LocalDateTime fechaAuditoria;

    @PrePersist
    void prePersist() {
        if (fechaAuditoria == null) fechaAuditoria = LocalDateTime.now();
    }
}

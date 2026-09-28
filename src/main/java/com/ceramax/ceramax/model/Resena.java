package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "resenas", uniqueConstraints = @UniqueConstraint(columnNames = {"id_usuario", "id_producto", "id_pedido"}))
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Resena {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_resena")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_producto", nullable = false)
    private Producto producto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_pedido")
    private Pedido pedido;

    @Column(nullable = false)
    private Short calificacion;

    @Column(length = 150)
    private String titulo;

    @Column(columnDefinition = "TEXT")
    private String comentario;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoResenaEnum estado;

    @Column(name = "fecha_resena")
    private LocalDateTime fechaResena;

    @PrePersist
    void prePersist() {
        if (fechaResena == null) fechaResena = LocalDateTime.now();
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoResenaEnum.pendiente;
    }
}

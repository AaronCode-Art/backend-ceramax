package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "lista_deseos", uniqueConstraints = @UniqueConstraint(columnNames = {"id_usuario", "id_variante"}))
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ListaDeseos {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_lista_deseos")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_variante", nullable = false)
    private VarianteProducto variante;

    @Column(name = "fecha_agregado")
    private LocalDateTime fechaAgregado;

    @PrePersist
    void prePersist() {
        if (fechaAgregado == null) fechaAgregado = LocalDateTime.now();
    }
}

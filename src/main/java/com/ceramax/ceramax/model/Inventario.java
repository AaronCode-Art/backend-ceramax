package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "inventario", uniqueConstraints = @UniqueConstraint(columnNames = {"id_variante", "id_almacen"}))
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Inventario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_inventario")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_variante", nullable = false)
    private VarianteProducto variante;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_almacen", nullable = false)
    private Almacen almacen;

    @Column(name = "cantidad_disponible", nullable = false)
    @Builder.Default
    private Integer cantidadDisponible = 0;

    @Column(name = "cantidad_reservada", nullable = false)
    @Builder.Default
    private Integer cantidadReservada = 0;

    @Column(name = "stock_minimo")
    @Builder.Default
    private Integer stockMinimo = 0;

    @Column(name = "stock_maximo")
    private Integer stockMaximo;

    @Column(name = "punto_reorden")
    @Builder.Default
    private Integer puntoReorden = 0;

    @Column(name = "permite_reposicion")
    @Builder.Default
    private Boolean permiteReposicion = true;

    @Column(name = "ultima_actualizacion")
    private LocalDateTime ultimaActualizacion;

    @PrePersist
    void prePersist() {
        ultimaActualizacion = LocalDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        ultimaActualizacion = LocalDateTime.now();
    }
}

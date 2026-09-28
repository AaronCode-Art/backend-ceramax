package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "detalle_carrito", uniqueConstraints = @UniqueConstraint(columnNames = {"id_carrito", "id_variante"}))
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class DetalleCarrito {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_detalle_carrito")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_carrito", nullable = false)
    private Carrito carrito;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_variante", nullable = false)
    private VarianteProducto variante;

    @Column(nullable = false)
    @Builder.Default
    private Integer cantidad = 1;

    @Column(name = "precio_unitario_momento", nullable = false, precision = 12, scale = 2)
    private BigDecimal precioUnitarioMomento;

    @Column(name = "fecha_agregado")
    private LocalDateTime fechaAgregado;

    @PrePersist
    void prePersist() {
        if (fechaAgregado == null) fechaAgregado = LocalDateTime.now();
    }
}

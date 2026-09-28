package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "detalle_orden_compra")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class DetalleOrdenCompra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_detalle")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_orden_compra", nullable = false)
    private OrdenCompra ordenCompra;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_variante")
    private VarianteProducto variante;

    @Column(name = "cantidad_solicitada", nullable = false)
    private Integer cantidadSolicitada;

    @Column(name = "cantidad_recibida")
    @Builder.Default
    private Integer cantidadRecibida = 0;

    @Column(name = "costo_unitario", nullable = false, precision = 12, scale = 2)
    private BigDecimal costoUnitario;

    @Column(columnDefinition = "GENERATED ALWAYS AS (cantidad_solicitada * costo_unitario) STORED",
            insertable = false, updatable = false)
    private BigDecimal subtotal;
}

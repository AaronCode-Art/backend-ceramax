package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "ordenes_compra")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class OrdenCompra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_orden_compra")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_proveedor", nullable = false)
    private Proveedor proveedor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_almacen_destino", nullable = false)
    private Almacen almacenDestino;

    @Column(name = "fecha_orden")
    private LocalDateTime fechaOrden;

    @Column(name = "fecha_recepcion_estimada")
    private LocalDate fechaRecepcionEstimada;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoOrdenCompraEnum estado;

    @Column(precision = 14, scale = 2)
    @Builder.Default
    private BigDecimal total = BigDecimal.ZERO;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario_creador")
    private Usuario usuarioCreador;

    @OneToMany(mappedBy = "ordenCompra", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<DetalleOrdenCompra> items = new ArrayList<>();

    @PrePersist
    void prePersist() {
        if (fechaOrden == null) fechaOrden = LocalDateTime.now();
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoOrdenCompraEnum.pendiente;
    }
}

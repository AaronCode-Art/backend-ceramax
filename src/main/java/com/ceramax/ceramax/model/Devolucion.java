package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "devoluciones")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Devolucion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_devolucion")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_pedido", nullable = false)
    private Pedido pedido;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_detalle_pedido", nullable = false)
    private DetallePedido detallePedido;

    @Column(nullable = false)
    private Integer cantidad;

    @Column(nullable = false, length = 255)
    private String motivo;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoDevolucionEnum estado;

    @Column(name = "monto_reembolso", precision = 12, scale = 2)
    @Builder.Default
    private BigDecimal montoReembolso = BigDecimal.ZERO;

    @Column(name = "fecha_solicitud")
    private LocalDateTime fechaSolicitud;

    @Column(name = "fecha_resolucion")
    private LocalDateTime fechaResolucion;

    @PrePersist
    void prePersist() {
        if (fechaSolicitud == null) fechaSolicitud = LocalDateTime.now();
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoDevolucionEnum.solicitada;
    }
}

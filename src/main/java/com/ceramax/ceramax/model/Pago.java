package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "pagos")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Pago {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_pago")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_pedido", nullable = false)
    private Pedido pedido;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_metodo_pago", nullable = false)
    private MetodoPago metodoPago;

    @Column(nullable = false, precision = 14, scale = 2)
    private BigDecimal monto;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "estado_pago", length = 20)
    private com.ceramax.ceramax.model.enums.EstadoPagoEnum estadoPago;

    @Column(name = "referencia_transaccion", length = 150)
    private String referenciaTransaccion;

    @Column(name = "pasarela_pago", length = 60)
    private String pasarelaPago;

    @Column(name = "fecha_pago")
    private LocalDateTime fechaPago;

    @PrePersist
    void prePersist() {
        if (fechaPago == null) fechaPago = LocalDateTime.now();
        if (estadoPago == null) estadoPago = com.ceramax.ceramax.model.enums.EstadoPagoEnum.pendiente;
    }
}

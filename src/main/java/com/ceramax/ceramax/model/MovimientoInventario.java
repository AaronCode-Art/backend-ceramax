package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "movimientos_inventario")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class MovimientoInventario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_movimiento")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_inventario", nullable = false)
    private Inventario inventario;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "tipo_movimiento", nullable = false, length = 20)
    private com.ceramax.ceramax.model.enums.TipoMovimientoEnum tipoMovimiento;

    @Column(nullable = false)
    private Integer cantidad;

    @Column(name = "cantidad_antes", nullable = false)
    private Integer cantidadAntes;

    @Column(name = "cantidad_despues", nullable = false)
    private Integer cantidadDespues;

    @Column(length = 255)
    private String motivo;

    @Column(name = "referencia_documento", length = 100)
    private String referenciaDocumento;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario_responsable")
    private Usuario usuarioResponsable;

    @Column(name = "fecha_movimiento")
    private LocalDateTime fechaMovimiento;

    @PrePersist
    void prePersist() {
        if (fechaMovimiento == null) fechaMovimiento = LocalDateTime.now();
    }
}

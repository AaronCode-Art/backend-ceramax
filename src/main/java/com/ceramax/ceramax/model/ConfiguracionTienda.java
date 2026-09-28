package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "configuracion_tienda")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ConfiguracionTienda {

    @Id
    @Column(name = "id_configuracion")
    @Builder.Default
    private Integer id = 1;

    @Column(name = "nombre_tienda", nullable = false, length = 150)
    private String nombreTienda;

    @Column(nullable = false, length = 10)
    @Builder.Default
    private String moneda = "PEN";

    @Column(name = "pais_operacion", length = 100)
    private String paisOperacion;

    @Column(name = "porcentaje_impuesto_default", precision = 5, scale = 2)
    @Builder.Default
    private BigDecimal porcentajeImpuestoDefault = BigDecimal.ZERO;

    @Column(name = "permite_venta_presencial")
    @Builder.Default
    private Boolean permiteVentaPresencial = true;

    @Column(name = "permite_recojo_tienda")
    @Builder.Default
    private Boolean permiteRecojoTienda = true;

    @PrePersist
    void prePersist() {
        if (id == null) id = 1;
    }
}

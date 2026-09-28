package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

@Entity
@Table(name = "sucursales")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Sucursal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_sucursal")
    private Integer id;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(length = 255)
    private String direccion;

    @Column(length = 100)
    private String distrito;

    @Column(length = 100)
    private String departamento;

    @Column(length = 255)
    private String referencia;

    @Column(name = "codigo_postal", length = 20)
    private String codigoPostal;

    @Column(length = 30)
    private String telefono;

    @Column(length = 150)
    private String email;

    @Column(name = "horario_atencion", length = 200)
    private String horarioAtencion;

    @Column(name = "latitud", precision = 10, scale = 7)
    private java.math.BigDecimal latitud;

    @Column(name = "longitud", precision = 10, scale = 7)
    private java.math.BigDecimal longitud;

    @Column(name = "permite_recojo")
    @Builder.Default
    private Boolean permiteRecojo = true;

    @Column(name = "permite_delivery")
    @Builder.Default
    private Boolean permiteDelivery = true;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado;

    @PrePersist
    void prePersist() {
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;
    }
}

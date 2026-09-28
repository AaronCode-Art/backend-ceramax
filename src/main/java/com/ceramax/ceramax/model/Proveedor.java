package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

@Entity
@Table(name = "proveedores")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Proveedor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_proveedor")
    private Integer id;

    @Column(name = "nombre_empresa", nullable = false, length = 150)
    private String nombreEmpresa;

    @Column(name = "contacto_nombre", length = 100)
    private String contactoNombre;

    @Column(length = 150)
    private String email;

    @Column(length = 30)
    private String telefono;

    @Column(length = 255)
    private String direccion;

    @Column(name = "condiciones_pago", length = 100)
    private String condicionesPago;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado;

    @PrePersist
    void prePersist() {
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;
    }
}

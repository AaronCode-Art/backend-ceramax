package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;

@Entity
@Table(name = "clientes", uniqueConstraints = {
        @UniqueConstraint(name = "uq_clientes_documento", columnNames = {"tipo_documento", "numero_documento"}),
        @UniqueConstraint(name = "uq_clientes_email", columnNames = {"email"}),
        @UniqueConstraint(name = "uq_clientes_telefono", columnNames = {"telefono"}),
        @UniqueConstraint(name = "uq_clientes_ruc", columnNames = {"ruc"})
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cliente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_cliente")
    private Long id;

    @Column(name = "tipo_documento", length = 20)
    private String tipoDocumento;

    @Column(name = "numero_documento", length = 20)
    private String numeroDocumento;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 100)
    private String apellido;

    @Column(name = "departamento", length = 100)
    private String departamento;

    @Column(length = 100)
    private String provincia;

    @Column(length = 100)
    private String distrito;

    @Column(length = 250)
    private String direccion;

    @Column(length = 250)
    private String referencia;

    @Column(name = "codigo_postal", length = 20)
    private String codigoPostal;

    @Column(length = 150)
    private String email;

    @Column(length = 30)
    private String telefono;

    @Column(length = 20)
    private String ruc;

    @Column(name = "razon_social", length = 200)
    private String razonSocial;

    @Column(name = "password_hash", length = 255)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado =
            com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;

    @Column(name = "fecha_registro", nullable = false)
    private LocalDateTime fechaRegistro;

    @Column(name = "fecha_actualizacion", nullable = false)
    private LocalDateTime fechaActualizacion;

    @PrePersist
    void prePersist() {
        fechaRegistro = LocalDateTime.now();
        fechaActualizacion = LocalDateTime.now();
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;
    }

    @PreUpdate
    void preUpdate() {
        fechaActualizacion = LocalDateTime.now();
    }
}

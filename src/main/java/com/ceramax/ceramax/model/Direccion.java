package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

@Entity
@Table(name = "direcciones")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Direccion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_direccion")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(nullable = false, length = 20)
    private com.ceramax.ceramax.model.enums.TipoDireccionEnum tipo;

    @Column(nullable = false, length = 200)
    private String calle;

    @Column(name = "numero_ext", length = 20)
    private String numeroExt;

    @Column(name = "colonia_sector", length = 100)
    private String coloniaSector;

    @Column(nullable = false, length = 100)
    private String ciudad;

    @Column(name = "estado_provincia", nullable = false, length = 100)
    private String estadoProvincia;

    @Column(name = "codigo_postal", nullable = false, length = 20)
    private String codigoPostal;

    @Column(nullable = false, length = 100)
    private String pais;

    @Column(name = "telefono_contacto", length = 30)
    private String telefonoContacto;

    @Column(name = "es_predeterminada")
    @Builder.Default
    private Boolean esPredeterminada = false;
}

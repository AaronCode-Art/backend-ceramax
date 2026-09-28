package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

@Entity
@Table(name = "marcas")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Marca {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_marca")
    private Integer id;

    @Column(nullable = false, unique = true, length = 100)
    private String nombre;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "logo_url", length = 500)
    private String logoUrl;

    @Column(name = "sitio_web", length = 255)
    private String sitioWeb;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado;

    @PrePersist
    void prePersist() {
        if (estado == null)
            estado = com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;
    }
}

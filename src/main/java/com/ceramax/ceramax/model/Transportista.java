package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

@Entity
@Table(name = "transportistas")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Transportista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_transportista")
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(name = "sitio_rastreo_url", length = 255)
    private String sitioRastreoUrl;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado;

    @PrePersist
    void prePersist() {
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;
    }
}

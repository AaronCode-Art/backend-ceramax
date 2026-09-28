package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

@Entity
@Table(name = "atributos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Atributo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_atributo")
    private Integer id;

    @Column(nullable = false, unique = true, length = 60)
    private String nombre;

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

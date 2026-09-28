package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

@Entity
@Table(name = "permisos")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Permiso {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_permiso")
    private Integer id;

    @Column(name = "nombre_permiso", nullable = false, unique = true, length = 80)
    private String nombrePermiso;

    @Column(length = 255)
    private String descripcion;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    @Builder.Default
    private com.ceramax.ceramax.model.enums.EstadoGenericoEnum activo = com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;
}

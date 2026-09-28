package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "categoria_atributos")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@IdClass(CategoriaAtributo.CategoriaAtributoId.class)
public class CategoriaAtributo {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categoria", nullable = false)
    private Categoria categoria;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_atributo", nullable = false)
    private Atributo atributo;

    @Column(name = "es_obligatorio")
    @Builder.Default
    private Boolean esObligatorio = false;

    @lombok.AllArgsConstructor
    @lombok.NoArgsConstructor
    @lombok.EqualsAndHashCode
    public static class CategoriaAtributoId implements Serializable {
        private Integer categoria;
        private Integer atributo;
    }
}

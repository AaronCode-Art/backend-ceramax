package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "variante_atributo_valor")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@IdClass(VarianteAtributoValor.VarianteAtributoValorId.class)
public class VarianteAtributoValor {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_variante", nullable = false)
    private VarianteProducto variante;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_valor", nullable = false)
    private ValorAtributo valorAtributo;

    @lombok.AllArgsConstructor
    @lombok.NoArgsConstructor
    @lombok.EqualsAndHashCode
    public static class VarianteAtributoValorId implements Serializable {
        private Long variante;
        private Integer valorAtributo;
    }
}

package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "valores_atributo", uniqueConstraints = @UniqueConstraint(columnNames = {"id_atributo", "valor"}))
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ValorAtributo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_valor")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_atributo", nullable = false)
    private Atributo atributo;

    @Column(nullable = false, length = 100)
    private String valor;
}

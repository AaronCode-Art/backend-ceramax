package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "categorias")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Categoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_categoria")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categoria_padre")
    private Categoria categoriaPadre;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, unique = true, length = 120)
    private String slug;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "imagen_url", length = 500)
    private String imagenUrl;

    @Column(name = "imagen_public_id", length = 250)
    private String imagenPublicId;

    @Builder.Default
    private Integer orden = 0;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado;

    @OneToMany(mappedBy = "categoriaPadre")
    @Builder.Default
    private List<Categoria> subcategorias = new ArrayList<>();

    @OneToMany(mappedBy = "categoria", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ImagenCategoria> imagenes = new ArrayList<>();

    @PrePersist
    void prePersist() {
        if (estado == null)
            estado = com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;
    }
}

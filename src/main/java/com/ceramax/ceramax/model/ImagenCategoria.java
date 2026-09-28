package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "imagenes_categoria")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ImagenCategoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_imagen_categoria")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_categoria", nullable = false)
    private Categoria categoria;

    @Column(name = "url_imagen", nullable = false, length = 500)
    private String urlImagen;

    @Column(name = "imagen_public_id", length = 250)
    private String imagenPublicId;

    @Column(name = "es_principal")
    @Builder.Default
    private Boolean esPrincipal = false;

    @Builder.Default
    private Integer orden = 0;
}

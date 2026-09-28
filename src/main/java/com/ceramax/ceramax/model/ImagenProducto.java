package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "imagenes_producto")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ImagenProducto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_imagen")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_producto", nullable = false)
    private Producto producto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_variante")
    private VarianteProducto variante;

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

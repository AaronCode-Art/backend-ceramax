package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "variantes_producto")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class VarianteProducto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_variante")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_producto", nullable = false)
    private Producto producto;

    @Column(name = "sku_variante", nullable = false, unique = true, length = 60)
    private String skuVariante;

    @Column(name = "codigo_barras", length = 60)
    private String codigoBarras;

    @Column(name = "precio_adicional", precision = 12, scale = 2)
    @Builder.Default
    private java.math.BigDecimal precioAdicional = java.math.BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado;

    @OneToMany(mappedBy = "variante")
    @Builder.Default
    private List<Inventario> inventarios = new ArrayList<>();

    @PrePersist
    void prePersist() {
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoGenericoEnum.activo;
    }
}

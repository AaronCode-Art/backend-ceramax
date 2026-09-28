package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "pedidos")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Pedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_pedido")
    private Long id;

    @Column(name = "numero_pedido", nullable = false, unique = true, length = 30)
    private String numeroPedido;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_cliente")
    private Cliente cliente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_vendedor")
    private Usuario vendedor;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "canal_venta", nullable = false, length = 20)
    private com.ceramax.ceramax.model.enums.CanalVentaEnum canalVenta;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "tipo_entrega", nullable = false, length = 20)
    private com.ceramax.ceramax.model.enums.TipoEntregaEnum tipoEntrega;

    @Column(name = "nombre_cliente_invitado", length = 200)
    private String nombreClienteInvitado;

    @Column(name = "telefono_cliente_invitado", length = 30)
    private String telefonoClienteInvitado;

    @Column(name = "documento_cliente_invitado", length = 30)
    private String documentoClienteInvitado;

    @Column(name = "tipo_documento_cliente_snapshot", length = 20)
    private String tipoDocumentoClienteSnapshot;

    @Column(name = "direccion_cliente_snapshot", length = 500)
    private String direccionClienteSnapshot;

    @Column(name = "departamento_cliente_snapshot", length = 100)
    private String departamentoClienteSnapshot;

    @Column(name = "provincia_cliente_snapshot", length = 100)
    private String provinciaClienteSnapshot;

    @Column(name = "distrito_cliente_snapshot", length = 100)
    private String distritoClienteSnapshot;

    @Column(name = "referencia_cliente_snapshot", length = 250)
    private String referenciaClienteSnapshot;

    @Column(name = "codigo_postal_cliente_snapshot", length = 20)
    private String codigoPostalClienteSnapshot;

    @Column(name = "ciudad_cliente_snapshot", length = 100)
    private String ciudadClienteSnapshot;

    @Column(name = "pais_cliente_snapshot", length = 100)
    private String paisClienteSnapshot;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_sucursal_recojo")
    private Sucursal sucursalRecojo;

    @Column(name = "tipo_comprobante", nullable = false, length = 20)
    @Builder.Default
    private String tipoComprobante = "BOLETA";

    @Column(name = "ruc_cliente", length = 20)
    private String rucCliente;

    @Column(name = "razon_social_cliente", length = 200)
    private String razonSocialCliente;

    @Column(name = "email_cliente_invitado", length = 150)
    private String emailClienteInvitado;

    @Column(name = "nombre_receptor", length = 200)
    private String nombreReceptor;

    @Column(name = "documento_receptor", length = 30)
    private String documentoReceptor;

    @Column(name = "direccion_envio_texto", length = 500)
    private String direccionEnvioTexto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_cupon")
    private Cupon cupon;

    @Column(nullable = false, precision = 14, scale = 2)
    private BigDecimal subtotal;

    @Column(precision = 14, scale = 2)
    @Builder.Default
    private BigDecimal descuento = BigDecimal.ZERO;

    @Column(name = "costo_envio", precision = 12, scale = 2)
    @Builder.Default
    private BigDecimal costoEnvio = BigDecimal.ZERO;

    @Column(precision = 12, scale = 2)
    @Builder.Default
    private BigDecimal impuestos = BigDecimal.ZERO;

    @Column(nullable = false, precision = 14, scale = 2)
    private BigDecimal total;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "estado", length = 30)
    private com.ceramax.ceramax.model.enums.EstadoPedidoEnum estado;

    @Column(columnDefinition = "TEXT")
    private String notas;

    @Column(name = "fecha_pedido")
    private LocalDateTime fechaPedido;

    @Column(name = "fecha_actualizacion")
    private LocalDateTime fechaActualizacion;

    @OneToMany(mappedBy = "pedido", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<DetallePedido> items = new ArrayList<>();

    @PrePersist
    void prePersist() {
        if (fechaPedido == null) fechaPedido = LocalDateTime.now();
        fechaActualizacion = LocalDateTime.now();
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoPedidoEnum.pendiente;
    }

    @PreUpdate
    void preUpdate() {
        fechaActualizacion = LocalDateTime.now();
    }
}

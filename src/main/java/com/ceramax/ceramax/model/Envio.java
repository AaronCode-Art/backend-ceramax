package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "envios")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Envio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_envio")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_pedido", nullable = false)
    private Pedido pedido;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_transportista")
    private Transportista transportista;

    @Column(name = "numero_seguimiento", length = 100)
    private String numeroSeguimiento;

    @Column(name = "costo_envio", precision = 12, scale = 2)
    @Builder.Default
    private BigDecimal costoEnvio = BigDecimal.ZERO;

    @Column(name = "fecha_envio")
    private LocalDateTime fechaEnvio;

    @Column(name = "fecha_entrega_estimada")
    private LocalDate fechaEntregaEstimada;

    @Column(name = "fecha_entrega_real")
    private LocalDateTime fechaEntregaReal;
}

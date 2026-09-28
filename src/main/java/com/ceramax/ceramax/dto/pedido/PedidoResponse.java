package com.ceramax.ceramax.dto.pedido;

import com.ceramax.ceramax.dto.atributo.VarianteAtributoResponse;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record PedidoResponse(
        Long id,
        String codigo,
        String tipoComprobante,
        Long clienteId,
        String clienteNombre,
        String dniCliente,
        String contacto,
        String emailCliente,
        String tipoDocumentoCliente,
        String rucCliente,
        String razonSocialCliente,
        String entrega,
        String direccionEnvio,
        String direccionCliente,
        String departamentoCliente,
        String provinciaCliente,
        String distritoCliente,
        String referenciaCliente,
        String codigoPostalCliente,
        String ciudadCliente,
        String paisCliente,
        Long sucursalId,
        String sucursalNombre,
        String receptor,
        String dniReceptor,
        BigDecimal costoDelivery,
        String codigoCupon,
        String tipoDescuentoCupon,
        BigDecimal descuento,
        BigDecimal subtotal,
        BigDecimal baseImponible,
        BigDecimal igv,
        BigDecimal total,
        String metodoPago,
        String origen,
        String estado,
        Long clienteUsuarioId,
        Long usuarioId,
        String nombreUsuario,
        LocalDateTime creadoEl,
        List<ItemResponse> items
) {
    public record ItemResponse(
            Long id,
            Long productoId,
            String nombre,
            String descripcionCorta,
            String skuVariante,
            BigDecimal precioBase,
            BigDecimal precioAdicional,
            BigDecimal precio,
            Integer cantidad,
            BigDecimal subtotal,
            List<VarianteAtributoResponse> atributosVariante
    ) {}
}

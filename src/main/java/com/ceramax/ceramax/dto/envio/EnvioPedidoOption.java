package com.ceramax.ceramax.dto.envio;

public record EnvioPedidoOption(
        Long pedidoId,
        String codigoPedido,
        String dniCliente,
        String clienteNombre,
        String estadoPedido,
        String tipoEntrega,
        String direccionEntrega
) {}

package com.ceramax.ceramax.dto.pedido;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.List;

public record PedidoRequest(
        String tipoComprobante,
        Long clienteId,
        String clienteNombre,
        String apellidoCliente,
        @Size(max = 20) String tipoDocumentoCliente,
        @Size(max = 20) String dniCliente,
        @Size(max = 30) String contacto,
        @Email @Size(max = 150) String emailCliente,
        @Size(max = 100) String departamento,
        @Size(max = 100) String provincia,
        @Size(max = 100) String distrito,
        @Size(max = 250) String direccionCliente,
        @Size(max = 250) String referenciaCliente,
        @Size(max = 20) String codigoPostalCliente,
        @Size(max = 20) String rucCliente,
        @Size(max = 200) String razonSocialCliente,
        String entrega,
        String direccionEnvio,
        Long sucursalId,
        String receptor,
        String dniReceptor,
        BigDecimal costoDelivery,
        @Size(max = 50) String codigoCupon,
        String metodoPago,
        String origen,
        List<ItemRequest> items
) {
    public record ItemRequest(
            @NotNull Long productoId,
            Long varianteId,
            @NotNull Integer cantidad
    ) {}
}

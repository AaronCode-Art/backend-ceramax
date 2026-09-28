package com.ceramax.ceramax.dto.almacen;

public record AlmacenResponse(
        Integer id,
        String nombre,
        String tipo,
        String direccion,
        String ciudad,
        String pais,
        Boolean permiteRecojoCliente,
        String estado
) {}

package com.ceramax.ceramax.dto.almacen;

import jakarta.validation.constraints.NotBlank;

public record AlmacenRequest(
        @NotBlank String nombre,
        String tipo,
        String direccion,
        String ciudad,
        String pais,
        Boolean permiteRecojoCliente
) {}

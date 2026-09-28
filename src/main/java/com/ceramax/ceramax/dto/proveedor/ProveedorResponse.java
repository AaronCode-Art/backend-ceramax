package com.ceramax.ceramax.dto.proveedor;

public record ProveedorResponse(
        Integer id,
        String nombreEmpresa,
        String contactoNombre,
        String email,
        String telefono,
        String direccion,
        String condicionesPago,
        String estado
) {}

package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "usuarios")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    private Long id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 100)
    private String apellido;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "tipo_documento", length = 20)
    private String tipoDocumento;

    @Column(name = "numero_documento", unique = true, length = 20)
    private String numeroDocumento;

    @Column(length = 30)
    private String telefono;

    @Column(name = "fecha_nacimiento")
    private java.time.LocalDate fechaNacimiento;

    @Column(name = "fecha_registro", nullable = false, updatable = false)
    private java.time.LocalDateTime fechaRegistro;

    @Column(name = "fecha_actualizacion", nullable = false)
    private java.time.LocalDateTime fechaActualizacion;

    @Column(name = "fecha_eliminacion")
    private java.time.LocalDateTime fechaEliminacion;

    @Column(nullable = false, length = 20)
    private String rol;  // 'CLIENTE', 'VENDEDOR', 'ADMIN'

    @Column(length = 20)
    private String imagenUrl;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private com.ceramax.ceramax.model.enums.EstadoUsuarioEnum estado;  // ← REGRESAMO ESTO

    @Column(name = "intentos_login_fallidos", nullable = false)
    @Builder.Default
    private Integer intentosLoginFallidos = 0;

    @PrePersist
    void prePersist() {
        fechaRegistro = java.time.LocalDateTime.now();
        fechaActualizacion = java.time.LocalDateTime.now();
        if (rol == null || rol.isBlank()) rol = "CLIENTE";
        if (estado == null) estado = com.ceramax.ceramax.model.enums.EstadoUsuarioEnum.activo;
    }

    @PreUpdate
    void preUpdate() {
        fechaActualizacion = java.time.LocalDateTime.now();
    }
}
package com.ceramax.ceramax.model;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "rol_permisos")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@IdClass(RolPermiso.RolPermisoId.class)
public class RolPermiso {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_rol", nullable = false)
    private Rol rol;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_permiso", nullable = false)
    private Permiso permiso;

    @Column(name = "activo")
    @Builder.Default
    private Boolean activo = true;

    @lombok.AllArgsConstructor
    @lombok.NoArgsConstructor
    @lombok.EqualsAndHashCode
    public static class RolPermisoId implements Serializable {
        private Integer rol;
        private Integer permiso;
    }
}

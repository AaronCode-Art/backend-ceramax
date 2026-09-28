package com.ceramax.ceramax.repository;

import com.ceramax.ceramax.model.RolPermiso;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RolPermisoRepository extends JpaRepository<RolPermiso, RolPermiso.RolPermisoId> {

    // Queries nativas: Spring Data/Hibernate 7 fallan al generar queries derivadas
    // sobre @IdClass compuesto con @ManyToOne en el id (NPE "TableGroup.getModelPart() is null").
    @Query(value = "SELECT * FROM rol_permisos WHERE id_rol = :idRol", nativeQuery = true)
    List<RolPermiso> findByRolId(@Param("idRol") Integer idRol);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query(value = "DELETE FROM rol_permisos WHERE id_rol = :idRol", nativeQuery = true)
    int deleteByRolId(@Param("idRol") Integer idRol);
}
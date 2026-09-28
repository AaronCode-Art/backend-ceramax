package com.ceramax.ceramax.repository;

import com.ceramax.ceramax.model.Direccion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DireccionRepository extends JpaRepository<Direccion, Long> {
    List<Direccion> findByUsuarioId(Long idUsuario);
    List<Direccion> findByUsuarioIdAndEsPredeterminadaTrue(Long idUsuario);
}

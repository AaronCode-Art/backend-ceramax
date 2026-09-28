package com.ceramax.ceramax.repository;

import com.ceramax.ceramax.model.Notificacion;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificacionRepository extends JpaRepository<Notificacion, Long> {
    Page<Notificacion> findByUsuarioDestinoIdOrderByFechaCreacionDesc(Long idUsuario, Pageable pageable);
    long countByUsuarioDestinoIdAndLeidaFalse(Long idUsuario);

    @Query("SELECT n FROM Notificacion n WHERE n.usuarioDestino.id = :usuarioId AND n.leida = false ORDER BY n.fechaCreacion DESC")
    List<Notificacion> findNoLeidasList(@Param("usuarioId") Long usuarioId);

    @Query("SELECT n FROM Notificacion n WHERE n.usuarioDestino.id = :usuarioId AND n.leida = false ORDER BY n.fechaCreacion DESC")
    Page<Notificacion> findNoLeidas(@Param("usuarioId") Long usuarioId, Pageable pageable);
}

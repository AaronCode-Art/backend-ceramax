package com.ceramax.ceramax.repository;

import com.ceramax.ceramax.model.Auditoria;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AuditoriaRepository extends JpaRepository<Auditoria, Long> {
    List<Auditoria> findByFechaAuditoriaBetweenOrderByFechaAuditoriaDesc(LocalDateTime desde, LocalDateTime hasta);

    Page<Auditoria> findByUsuarioIdOrderByFechaAuditoriaDesc(Long idUsuario, Pageable pageable);

    Page<Auditoria> findByEntidadOrderByFechaAuditoriaDesc(String entidad, Pageable pageable);

    List<Auditoria> findByAccionOrderByFechaAuditoriaDesc(String accion);

    @Query("SELECT a FROM Auditoria a LEFT JOIN FETCH a.usuario WHERE a.fechaAuditoria BETWEEN :desde AND :hasta ORDER BY a.fechaAuditoria DESC")
    Page<Auditoria> findBetweenFechas(@Param("desde") LocalDateTime desde, @Param("hasta") LocalDateTime hasta,
            Pageable pageable);

    @Query("SELECT a.entidad, COUNT(a) FROM Auditoria a "
            + "WHERE (:desde IS NULL OR a.fechaAuditoria >= :desde) "
            + "AND (:hasta IS NULL OR a.fechaAuditoria <= :hasta) "
            + "GROUP BY a.entidad ORDER BY COUNT(a) DESC")
    List<Object[]> countByEntidadBetweenFechas(@Param("desde") LocalDateTime desde,
            @Param("hasta") LocalDateTime hasta);
}

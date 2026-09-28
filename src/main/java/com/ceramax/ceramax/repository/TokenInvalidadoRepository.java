package com.ceramax.ceramax.repository;

import com.ceramax.ceramax.model.TokenInvalidado;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface TokenInvalidadoRepository extends JpaRepository<TokenInvalidado, Long> {

    boolean existsByTokenHash(String tokenHash);

    @Modifying
    @Query("DELETE FROM TokenInvalidado t WHERE t.fechaExpiracion < :ahora")
    int deleteExpirados(LocalDateTime ahora);
}

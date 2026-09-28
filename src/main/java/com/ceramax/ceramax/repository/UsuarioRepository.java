package com.ceramax.ceramax.repository;

import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.model.enums.EstadoUsuarioEnum;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByEmail(String email);
    boolean existsByEmail(String email);
    Page<Usuario> findByFechaEliminacionIsNull(Pageable pageable);
    List<Usuario> findByRolAndEstado(String rol, EstadoUsuarioEnum estado);
}

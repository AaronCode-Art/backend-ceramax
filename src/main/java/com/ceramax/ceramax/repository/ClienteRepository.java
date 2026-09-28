package com.ceramax.ceramax.repository;

import com.ceramax.ceramax.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface ClienteRepository extends JpaRepository<Cliente, Long> {
    Page<Cliente> findByEstado(
            com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado,
            Pageable pageable);

    Optional<Cliente> findByNumeroDocumentoAndEstado(String numeroDocumento,
            com.ceramax.ceramax.model.enums.EstadoGenericoEnum estado);

    Optional<Cliente> findByEmailIgnoreCase(String email);

    Optional<Cliente> findByTipoDocumentoAndNumeroDocumento(String tipoDocumento, String numeroDocumento);

    Optional<Cliente> findByTelefono(String telefono);

    Optional<Cliente> findByRuc(String ruc);

    Optional<Cliente> findByRazonSocialIgnoreCase(String razonSocial);
}

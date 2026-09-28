package com.ceramax.ceramax.service;

import com.ceramax.ceramax.dto.cliente.ClienteRequest;
import com.ceramax.ceramax.dto.cliente.ClienteResponse;
import com.ceramax.ceramax.exception.BadRequestException;
import com.ceramax.ceramax.exception.ResourceNotFoundException;
import com.ceramax.ceramax.model.Cliente;
import com.ceramax.ceramax.model.enums.EstadoGenericoEnum;
import com.ceramax.ceramax.repository.ClienteRepository;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ClienteService {

    private final ClienteRepository clienteRepository;

    public ClienteService(ClienteRepository clienteRepository) {
        this.clienteRepository = clienteRepository;
    }

    @Transactional(readOnly = true)
    public Page<ClienteResponse> listar(Pageable pageable) {
        return clienteRepository.findByEstado(EstadoGenericoEnum.activo, pageable).map(this::toResponse);
    }

    @Transactional(readOnly = true)
    public ClienteResponse obtenerPorId(Long id) {
        return toResponse(clienteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente no encontrado")));
    }

    @Transactional(readOnly = true)
    public ClienteResponse buscarPorDocumento(String documento) {
        String valor = documento == null ? "" : documento.trim();
        if (valor.isBlank()) {
            throw new BadRequestException("El documento es obligatorio");
        }
        return clienteRepository.findByNumeroDocumentoAndEstado(valor, EstadoGenericoEnum.activo)
                .map(this::toResponse)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente no encontrado"));
    }

    @Transactional
    public ClienteResponse crear(ClienteRequest req) {
        validarUnicidad(req.tipoDocumento(), req.numeroDocumento(), req.email(), req.telefono(),
                req.ruc(), req.razonSocial(), null);

        Cliente cliente = new Cliente();
        aplicarCambios(cliente, req);
        cliente.setEstado(EstadoGenericoEnum.activo);
        return toResponse(guardarCliente(cliente));
    }

    @Transactional
    public ClienteResponse actualizar(Long id, ClienteRequest req) {
        Cliente cliente = clienteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente no encontrado"));
        validarUnicidad(req.tipoDocumento(), req.numeroDocumento(), req.email(), req.telefono(),
                req.ruc(), req.razonSocial(), id);
        aplicarCambios(cliente, req);
        return toResponse(guardarCliente(cliente));
    }

    @Transactional
    public Cliente obtenerOCrearParaVenta(
            Long clienteId,
            String nombre,
            String apellido,
            String tipoDocumento,
            String numeroDocumento
    ) {
        Cliente cliente = clienteId == null
                ? null
                : clienteRepository.findById(clienteId)
                        .orElseThrow(() -> new BadRequestException("Cliente no válido"));

        String tipoDocumentoNormalizado = normalizar(tipoDocumento) == null
                ? "DNI" : tipoDocumento.trim().toUpperCase();
        String documento = normalizar(numeroDocumento);
        if (documento == null) {
            throw new BadRequestException("El documento del cliente es obligatorio para el pedido");
        }
        if (cliente == null && documento != null) {
            cliente = clienteRepository.findByTipoDocumentoAndNumeroDocumento(tipoDocumentoNormalizado, documento)
                    .orElse(null);
        }

        if (cliente == null) {
            if (normalizar(nombre) == null || normalizar(apellido) == null) {
                throw new BadRequestException("Para registrar una venta se requiere nombre y apellido del cliente");
            }
            if (tipoDocumentoNormalizado.equals("DNI") && !documento.matches("\\d{8}")) {
                throw new BadRequestException("El DNI del cliente debe tener 8 dígitos");
            }
        }

        if (cliente != null
                && (!tipoDocumentoNormalizado.equalsIgnoreCase(cliente.getTipoDocumento())
                || !documento.equals(cliente.getNumeroDocumento()))) {
            throw new BadRequestException("El documento no coincide con el cliente seleccionado");
        }

        if (cliente == null) {
            cliente = new Cliente();
            cliente.setTipoDocumento(tipoDocumentoNormalizado);
            cliente.setNumeroDocumento(documento);
            cliente.setNombre(nombre.trim());
            cliente.setApellido(apellido.trim());
            cliente.setEstado(EstadoGenericoEnum.activo);
            return guardarCliente(cliente);
        }

        return cliente;
    }

    @Transactional
    public void eliminar(Long id) {
        Cliente cliente = clienteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente no encontrado"));
        cliente.setEstado(EstadoGenericoEnum.inactivo);
        clienteRepository.save(cliente);
    }

    private void validarUnicidad(String tipoDocumento, String numeroDocumento, String email,
                                 String telefono, String ruc, String razonSocial, Long idActual) {
        String emailNormalizado = normalizar(email);
        if (emailNormalizado != null) {
            verificarUnico(clienteRepository.findByEmailIgnoreCase(emailNormalizado.toLowerCase()).orElse(null),
                    idActual, "El correo ya está registrado en otro cliente");
        }

        String tipoNormalizado = normalizar(tipoDocumento);
        String documentoNormalizado = normalizar(numeroDocumento);
        if (tipoNormalizado != null && documentoNormalizado != null) {
            verificarUnico(clienteRepository.findByTipoDocumentoAndNumeroDocumento(
                            tipoNormalizado.toUpperCase(), documentoNormalizado).orElse(null),
                    idActual, "Ya existe un cliente con ese tipo y número de documento");
        }

        String telefonoNormalizado = normalizar(telefono);
        if (telefonoNormalizado != null) {
            verificarUnico(clienteRepository.findByTelefono(telefonoNormalizado).orElse(null),
                    idActual, "El teléfono ya está registrado en otro cliente");
        }

        String rucNormalizado = normalizar(ruc);
        if (rucNormalizado != null) {
            if (!rucNormalizado.matches("\\d{11}")) {
                throw new BadRequestException("El RUC debe tener 11 dígitos");
            }
            verificarUnico(clienteRepository.findByRuc(rucNormalizado).orElse(null),
                    idActual, "El RUC ya está registrado en otro cliente");
        }

        String razonSocialNormalizada = normalizar(razonSocial);
        if (razonSocialNormalizada != null) {
            verificarUnico(clienteRepository.findByRazonSocialIgnoreCase(razonSocialNormalizada).orElse(null),
                    idActual, "La razón social ya está registrada en otro cliente");
        }
    }

    private void verificarUnico(Cliente existente, Long idActual, String mensaje) {
        if (existente != null && !existente.getId().equals(idActual)) {
            throw new BadRequestException(mensaje);
        }
    }

    private Cliente guardarCliente(Cliente cliente) {
        try {
            return clienteRepository.saveAndFlush(cliente);
        } catch (DataIntegrityViolationException ex) {
            throw new BadRequestException("El DNI, correo, teléfono, RUC o razón social ya pertenece a otro cliente");
        }
    }

    private void aplicarCambios(Cliente cliente, ClienteRequest req) {
        cliente.setNombre(req.nombre().trim());
        cliente.setApellido(req.apellido().trim());
        cliente.setTipoDocumento(req.tipoDocumento().trim().toUpperCase());
        cliente.setNumeroDocumento(req.numeroDocumento().trim());
        cliente.setDepartamento(req.departamento().trim());
        cliente.setProvincia(req.provincia().trim());
        cliente.setDistrito(req.distrito().trim());
        cliente.setDireccion(req.direccion().trim());
        cliente.setReferencia(normalizar(req.referencia()));
        cliente.setCodigoPostal(normalizar(req.codigoPostal()));
        cliente.setEmail(req.email().trim().toLowerCase());
        cliente.setTelefono(normalizar(req.telefono()));
        cliente.setRuc(normalizar(req.ruc()));
        cliente.setRazonSocial(normalizar(req.razonSocial()));
    }

    private String normalizar(String valor) {
        return valor == null || valor.isBlank() ? null : valor.trim();
    }

    private ClienteResponse toResponse(Cliente cliente) {
        return new ClienteResponse(
                cliente.getId(),
                cliente.getNombre(),
                cliente.getApellido(),
                cliente.getTipoDocumento(),
                cliente.getNumeroDocumento(),
                cliente.getDepartamento(),
                cliente.getProvincia(),
                cliente.getDistrito(),
                cliente.getDireccion(),
                cliente.getReferencia(),
                cliente.getCodigoPostal(),
                cliente.getEmail(),
                cliente.getTelefono(),
                cliente.getRuc(),
                cliente.getRazonSocial(),
                cliente.getEstado() != null ? cliente.getEstado().name() : null,
                cliente.getFechaRegistro()
        );
    }
}

package com.ceramax.ceramax.service;

import com.ceramax.ceramax.dto.auditoria.AuditoriaResponse;
import com.ceramax.ceramax.model.Auditoria;
import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.repository.AuditoriaRepository;
import com.ceramax.ceramax.repository.UsuarioRepository;
import com.ceramax.ceramax.security.CustomUserDetails;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class AuditoriaService {

    private final AuditoriaRepository auditoriaRepository;
    private final UsuarioRepository usuarioRepository;
    private final ObjectMapper objectMapper;
    private final EntityManager entityManager;

    public AuditoriaService(AuditoriaRepository auditoriaRepository, UsuarioRepository usuarioRepository,
            ObjectMapper objectMapper, EntityManager entityManager) {
        this.auditoriaRepository = auditoriaRepository;
        this.usuarioRepository = usuarioRepository;
        this.objectMapper = objectMapper;
        this.entityManager = entityManager;
    }

    /**
     * Punto de entrada usado por AuditAspect. Se ejecuta en un hilo aparte
     * (auditExecutor): el request HTTP no espera la serialización JSON de
     * argumentos/resultado ni el INSERT en auditorias. El usuario se referencia con
     * getReference (proxy sin SELECT) en vez de volver a consultarlo por id.
     */
    @Async("auditExecutor")
    @Transactional
    public void registrarAsync(String accion, String entidad, Long entidadId, Long usuarioId,
                                Object argumentos, Object resultado, String descripcion,
                                String ipAddress, String userAgent) {
        // El filtrado "no auditar si el usuario actual es CLIENTE" ya ocurrió en el
        // hilo de la petición (AuditAspect), antes de encolar esta tarea async.
        Usuario usuarioRef = usuarioId != null ? entityManager.getReference(Usuario.class, usuarioId) : null;
        Auditoria a = Auditoria.builder()
                .usuario(usuarioRef)
                .accion(accion)
                .entidad(entidad)
                .entidadId(entidadId)
                .valoresAnteriores(argumentos != null ? toJson(argumentos) : null)
                .valoresNuevos(resultado != null ? toJson(resultado) : null)
                .descripcion(descripcion)
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .build();
        auditoriaRepository.save(a);
    }

    @Transactional(readOnly = true)
    public Page<AuditoriaResponse> listar(LocalDateTime desde, LocalDateTime hasta, Pageable pageable) {
        LocalDateTime desdeEfectivo = desde != null
                ? desde : LocalDateTime.of(1900, 1, 1, 0, 0, 0);
        LocalDateTime hastaEfectivo = hasta != null
                ? hasta : LocalDateTime.of(9999, 12, 31, 23, 59, 59);
        return auditoriaRepository.findBetweenFechas(desdeEfectivo, hastaEfectivo, pageable).map(this::toResponse);
    }

    @Transactional(readOnly = true)
    public Page<AuditoriaResponse> listarPorUsuario(Long usuarioId, Pageable pageable) {
        return auditoriaRepository.findByUsuarioIdOrderByFechaAuditoriaDesc(usuarioId, pageable).map(this::toResponse);
    }

    @Transactional(readOnly = true)
    public Page<AuditoriaResponse> listarPorEntidad(String entidad, Pageable pageable) {
        return auditoriaRepository.findByEntidadOrderByFechaAuditoriaDesc(entidad, pageable).map(this::toResponse);
    }

    @Transactional
    public void registrar(Usuario usuario, String accion, String entidad, Long entidadId,
                          Object valoresAnteriores, Object valoresNuevos, String descripcion,
                          HttpServletRequest request) {
        if (usuarioActualEsCliente()) {
            return;
        }
        Usuario usuarioAuditoria = usuario != null ? usuario : obtenerUsuarioAutenticado();
        Auditoria a = Auditoria.builder()
                .usuario(usuarioAuditoria)
                .accion(accion)
                .entidad(entidad)
                .entidadId(entidadId)
                .valoresAnteriores(valoresAnteriores != null ? toJson(valoresAnteriores) : null)
                .valoresNuevos(valoresNuevos != null ? toJson(valoresNuevos) : null)
                .descripcion(descripcion)
                .ipAddress(request != null ? request.getRemoteAddr() : null)
                .userAgent(request != null ? request.getHeader("User-Agent") : null)
                .build();
        auditoriaRepository.save(a);
    }

    @Transactional
    public void registrar(String accion, String entidad, Long entidadId, String descripcion) {
        if (usuarioActualEsCliente()) {
            return;
        }
        Auditoria a = Auditoria.builder()
                .usuario(obtenerUsuarioAutenticado())
                .accion(accion)
                .entidad(entidad)
                .entidadId(entidadId)
                .descripcion(descripcion)
                .build();
        auditoriaRepository.save(a);
    }

    public void registrar(String accion, String entidad, Long entidadId, Object argumentos,
                          Object resultado, String descripcion, HttpServletRequest request) {
        registrar(null, accion, entidad, entidadId, argumentos, resultado, descripcion, request);
    }

    private boolean usuarioActualEsCliente() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || auth.getPrincipal() == null) {
            return false;
        }
        return auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equalsIgnoreCase("ROLE_CLIENTE"));
    }

    /**
     * Igual que usuarioActualEsCliente() pero pensado para llamarse desde AuditAspect
     * en el hilo de la petición (antes de encolar el registro async). Sin acceso a BD:
     * lee directo del JWT ya autenticado (SecurityContext).
     */
    public boolean esClienteActual() {
        return usuarioActualEsCliente();
    }

    /** Id del usuario autenticado tomado del token (sin ir a BD). */
    public Long usuarioIdActual() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated()
                && auth.getPrincipal() instanceof com.ceramax.ceramax.security.CustomUserDetails userDetails) {
            return userDetails.getUsuarioId();
        }
        return null;
    }

    private Usuario obtenerUsuarioAutenticado() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()
                || !(auth.getPrincipal() instanceof CustomUserDetails userDetails)) {
            return null;
        }
        return usuarioRepository.findById(userDetails.getUsuarioId()).orElse(null);
    }

    private String toJson(Object obj) {
        try {
            return objectMapper.writeValueAsString(obj);
        } catch (Exception e) {
            return obj.toString();
        }
    }

    private AuditoriaResponse toResponse(Auditoria a) {
        return new AuditoriaResponse(
                a.getId(),
                a.getUsuario() != null ? a.getUsuario().getId() : null,
                a.getUsuario() != null ? a.getUsuario().getNombre() + " " + a.getUsuario().getApellido() : "Sistema",
                a.getAccion(),
                a.getEntidad(),
                a.getEntidadId(),
                a.getValoresAnteriores(),
                a.getValoresNuevos(),
                a.getDescripcion(),
                a.getIpAddress(),
                a.getFechaAuditoria()
        );
    }
}
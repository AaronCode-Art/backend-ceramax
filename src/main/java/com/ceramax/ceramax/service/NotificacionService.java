package com.ceramax.ceramax.service;

import com.ceramax.ceramax.audit.AuditableService;
import com.ceramax.ceramax.exception.ResourceNotFoundException;
import com.ceramax.ceramax.model.Notificacion;
import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.repository.NotificacionRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@AuditableService
public class NotificacionService {

    private final NotificacionRepository notificacionRepository;

    public NotificacionService(NotificacionRepository notificacionRepository) {
        this.notificacionRepository = notificacionRepository;
    }

    @Transactional(readOnly = true)
    public Page<Map<String, Object>> listarPorUsuario(Long usuarioId, Pageable pageable) {
        return notificacionRepository.findByUsuarioDestinoIdOrderByFechaCreacionDesc(usuarioId, pageable)
                .map(this::toMap);
    }

    @Transactional(readOnly = true)
    public Page<Map<String, Object>> listarNoLeidas(Long usuarioId, Pageable pageable) {
        return notificacionRepository.findNoLeidas(usuarioId, pageable)
                .map(this::toMap);
    }

    @Transactional(readOnly = true)
    public long contarNoLeidas(Long usuarioId) {
        return notificacionRepository.countByUsuarioDestinoIdAndLeidaFalse(usuarioId);
    }

    @Transactional
    public void crear(Usuario usuarioDestino, String titulo, String mensaje, String tipo,
                      String entidadReferencia, Long entidadId) {
        Notificacion n = Notificacion.builder()
                .usuarioDestino(usuarioDestino)
                .titulo(titulo)
                .mensaje(mensaje)
                .tipo(tipo)
                .entidadReferencia(entidadReferencia)
                .entidadId(entidadId)
                .leida(false)
                .build();
        notificacionRepository.save(n);
    }

    @Transactional
    public void marcarLeida(Long id) {
        Notificacion n = notificacionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Notificación no encontrada"));
        n.setLeida(true);
        notificacionRepository.save(n);
    }

    @Transactional
    public void marcarTodasLeidas(Long usuarioId) {
        List<Notificacion> noLeidas = notificacionRepository.findNoLeidasList(usuarioId);
        for (Notificacion n : noLeidas) {
            n.setLeida(true);
        }
        notificacionRepository.saveAll(noLeidas);
    }

    @Transactional
    public void eliminar(Long id) {
        if (!notificacionRepository.existsById(id)) throw new ResourceNotFoundException("Notificación no encontrada");
        notificacionRepository.deleteById(id);
    }

    private Map<String, Object> toMap(Notificacion n) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", n.getId());
        map.put("titulo", n.getTitulo());
        map.put("mensaje", n.getMensaje());
        map.put("tipo", n.getTipo());
        map.put("entidadReferencia", n.getEntidadReferencia());
        map.put("entidadId", n.getEntidadId());
        map.put("leida", n.getLeida());
        map.put("fechaCreacion", n.getFechaCreacion());
        return map;
    }
}

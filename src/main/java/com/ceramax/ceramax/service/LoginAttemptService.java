package com.ceramax.ceramax.service;

import com.ceramax.ceramax.exception.ResourceNotFoundException;
import com.ceramax.ceramax.model.Usuario;
import com.ceramax.ceramax.model.enums.EstadoUsuarioEnum;
import com.ceramax.ceramax.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LoginAttemptService {

    private final UsuarioRepository usuarioRepository;

    public LoginAttemptService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public int registrar(Long usuarioId) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        int nuevoTotal = (usuario.getIntentosLoginFallidos() == null
                ? 0
                : usuario.getIntentosLoginFallidos()) + 1;
        usuario.setIntentosLoginFallidos(nuevoTotal);
        if (nuevoTotal >= 4) {
            usuario.setEstado(EstadoUsuarioEnum.bloqueado);
        }
        usuarioRepository.saveAndFlush(usuario);
        return nuevoTotal;
    }
}

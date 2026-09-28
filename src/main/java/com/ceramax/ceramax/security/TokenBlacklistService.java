package com.ceramax.ceramax.security;

import com.ceramax.ceramax.config.CacheConfig;
import com.ceramax.ceramax.model.TokenInvalidado;
import com.ceramax.ceramax.repository.TokenInvalidadoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 * Antes esto era un Set en memoria: al reiniciar el servidor, todos los
 * tokens "cerrados" con logout volvían a ser válidos hasta su expiración
 * natural. Ahora se persiste en la tabla tokens_invalidados (Postgres),
 * así que un reinicio del servidor ya no revive sesiones cerradas.
 * Se guarda el hash SHA-256 del token, no el token completo, por seguridad.
 */
@Service
public class TokenBlacklistService {

    private static final Logger log = LoggerFactory.getLogger(TokenBlacklistService.class);

    private final TokenInvalidadoRepository tokenInvalidadoRepository;
    private final JwtService jwtService;
    private final CacheManager cacheManager;

    public TokenBlacklistService(TokenInvalidadoRepository tokenInvalidadoRepository, JwtService jwtService,
                                  CacheManager cacheManager) {
        this.tokenInvalidadoRepository = tokenInvalidadoRepository;
        this.jwtService = jwtService;
        this.cacheManager = cacheManager;
    }

    private Cache blacklistCache() {
        return cacheManager.getCache(CacheConfig.CACHE_TOKEN_BLACKLIST);
    }

    @Transactional
    public void blacklist(String token) {
        String hash = hash(token);
        try {
            if (!tokenInvalidadoRepository.existsByTokenHash(hash)) {
                Date expiracion = jwtService.extractExpiration(token);
                LocalDateTime fechaExpiracion = expiracion.toInstant()
                        .atZone(ZoneId.systemDefault())
                        .toLocalDateTime();

                tokenInvalidadoRepository.save(
                        TokenInvalidado.builder()
                                .tokenHash(hash)
                                .fechaExpiracion(fechaExpiracion)
                                .build()
                );
            }
        } catch (Exception e) {
            log.error("No se pudo persistir el token invalidado (¿falta correr la migración de tokens_invalidados?): {}", e.getMessage());
        } finally {
            // Se marca en caché SIEMPRE, incluso si la escritura en BD falló: en esta
            // instancia el token queda bloqueado de inmediato (isBlacklisted ya no
            // depende de la BD para confirmarlo).
            Cache cache = blacklistCache();
            if (cache != null) cache.put(hash, Boolean.TRUE);
        }
    }

    // JwtFilter llama esto en CADA request con Bearer token. Cachear evita un
    // segundo roundtrip a la BD remota por petición (además del de userDetails).
    // Los positivos (token sí invalidado) se cachean indefinidamente vía blacklist();
    // aquí solo cacheamos negativos con TTL corto (ver CacheConfig), que es la
    // consulta que se repite miles de veces para el mismo token durante su vida útil.
    public boolean isBlacklisted(String token) {
        String hash = hash(token);
        Cache cache = blacklistCache();
        if (cache != null) {
            Cache.ValueWrapper cached = cache.get(hash);
            if (cached != null) {
                return Boolean.TRUE.equals(cached.get());
            }
        }
        try {
            boolean blacklisted = tokenInvalidadoRepository.existsByTokenHash(hash);
            if (cache != null) cache.put(hash, blacklisted);
            return blacklisted;
        } catch (Exception e) {
            log.error("No se pudo consultar tokens_invalidados (¿falta correr la migración?): {}. Se deja pasar la petición.", e.getMessage());
            return false;
        }
    }

    /**
     * Purga cada hora los tokens ya invalidados que además ya expiraron por
     * su cuenta (después de eso, un token rechazado por expiración no
     * necesita seguir ocupando espacio en la tabla).
     */
    @Scheduled(fixedRate = 3_600_000)
    @Transactional
    public void limpiarTokensExpirados() {
        try {
            int eliminados = tokenInvalidadoRepository.deleteExpirados(LocalDateTime.now());
            if (eliminados > 0) {
                log.info("Limpieza de tokens_invalidados: {} registros eliminados", eliminados);
            }
        } catch (Exception e) {
            log.warn("No se pudo limpiar tokens_invalidados (¿falta correr la migración?): {}", e.getMessage());
        }
    }

    private String hash(String token) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] bytes = digest.digest(token.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 no disponible en esta JVM", e);
        }
    }
}

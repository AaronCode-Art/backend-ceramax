package com.ceramax.ceramax.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
@EnableCaching
public class CacheConfig {

    /** Nombres de las cachés "calientes" de autenticación (se recorren en cada request). */
    public static final String CACHE_USER_DETAILS = "userDetails";
    public static final String CACHE_TOKEN_BLACKLIST = "tokenBlacklist";

    @Bean
    public CacheManager cacheManager() {
        // Caché por defecto: datos de referencia (categorías, marcas, roles, etc.)
        // que cambian poco y ya se manejaban con @Cacheable/@CacheEvict.
        CaffeineCacheManager manager = new CaffeineCacheManager();
        manager.setCaffeine(Caffeine.newBuilder()
                .maximumSize(500)
                .expireAfterWrite(10, TimeUnit.MINUTES)
                .recordStats());

        // Cachés dedicadas al hot-path de autenticación (JwtFilter): se consultan en
        // TODAS las peticiones autenticadas, así que evitan un roundtrip a la BD (Neon,
        // remota) por request. TTL corto para no perder consistencia con cambios de
        // rol/estado/logout más de unos segundos.
        manager.registerCustomCache(CACHE_USER_DETAILS,
                Caffeine.newBuilder()
                        .maximumSize(5_000)
                        .expireAfterWrite(30, TimeUnit.SECONDS)
                        .recordStats()
                        .build());
        manager.registerCustomCache(CACHE_TOKEN_BLACKLIST,
                Caffeine.newBuilder()
                        .maximumSize(20_000)
                        .expireAfterWrite(60, TimeUnit.SECONDS)
                        .recordStats()
                        .build());
        return manager;
    }
}

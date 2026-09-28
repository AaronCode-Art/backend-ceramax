package com.ceramax.ceramax.config;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

@Component
public class RateLimitFilter implements Filter {

    // Antes era un ConcurrentHashMap sin límite ni expiración: cada IP (y con
    // upload:/global: cada IP dos veces) quedaba para siempre en memoria, así que el
    // mapa solo crecía y nunca se liberaba, degradando el rendimiento con el tiempo
    // (más basura para el GC). Caffeine expira y acota automáticamente las entradas.
    private final Cache<String, RequestCounter> counters = Caffeine.newBuilder()
            .maximumSize(50_000)
            .expireAfterWrite(2, TimeUnit.MINUTES)
            .build();

    private static class RequestCounter {
        private final AtomicInteger count = new AtomicInteger(0);
        private volatile long windowStart = System.currentTimeMillis();

        boolean tryConsume(int maxRequests, long windowMs) {
            long now = System.currentTimeMillis();
            if (now - windowStart > windowMs) {
                windowStart = now;
                count.set(0);
            }
            return count.incrementAndGet() <= maxRequests;
        }
    }

    private RequestCounter resolve(String key) {
        return counters.get(key, k -> new RequestCounter());
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpRes = (HttpServletResponse) response;
        String ip = httpReq.getRemoteAddr();
        String path = httpReq.getRequestURI();

        if (path.startsWith("/api/uploads")) {
            RequestCounter bucket = resolve("upload:" + ip);
            if (!bucket.tryConsume(10, 60_000)) {
                httpRes.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
                httpRes.setContentType("application/json");
                httpRes.getWriter().write("{\"success\":false,\"message\":\"Demasiadas peticiones de subida. Intenta más tarde.\"}");
                return;
            }
        }

        RequestCounter global = resolve("global:" + ip);
        if (!global.tryConsume(100, 60_000)) {
            httpRes.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
            httpRes.setContentType("application/json");
            httpRes.getWriter().write("{\"success\":false,\"message\":\"Límite de peticiones excedido.\"}");
            return;
        }

        chain.doFilter(request, response);
    }
}

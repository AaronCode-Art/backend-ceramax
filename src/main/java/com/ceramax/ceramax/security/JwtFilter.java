package com.ceramax.ceramax.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(JwtFilter.class);

    private final JwtService jwtService;
    private final CustomUserDetailsService userDetailsService;
    private final TokenBlacklistService tokenBlacklistService;

    public JwtFilter(JwtService jwtService, CustomUserDetailsService userDetailsService,
            TokenBlacklistService tokenBlacklistService) {
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
        this.tokenBlacklistService = tokenBlacklistService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String header = request.getHeader("Authorization");
        String uri = request.getRequestURI();

        if (StringUtils.hasText(header) && header.startsWith("Bearer ")) {
            String token = header.substring(7);

            if (tokenBlacklistService.isBlacklisted(token)) {
                log.debug("JWT RECHAZADO (blacklist) para {}", uri);
            } else if (!jwtService.isValidToken(token)) {
                log.debug("JWT RECHAZADO (inválido) para {}", uri);
            } else {
                String email = jwtService.extractEmail(token);

                if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    try {
                        UserDetails userDetails = userDetailsService.loadUserByUsername(email);
                        UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                                userDetails, null, userDetails.getAuthorities());
                        authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        SecurityContextHolder.getContext().setAuthentication(authToken);
                        log.debug("JWT OK: {} autenticado para {}", email, uri);
                    } catch (Exception e) {
                        log.warn("JWT FAIL: No se pudo autenticar {} para {} - Error: {}", email, uri, e.getMessage());
                    }
                } else if (email != null) {
                    log.debug("JWT SKIP: auth ya existe para {} en {}", email, uri);
                } else {
                    log.debug("JWT RECHAZADO (email null) para {}", uri);
                }
            }
        } else if (StringUtils.hasText(header)) {
            log.debug("JWT RECHAZADO (header sin Bearer) para {}", uri);
        }

        filterChain.doFilter(request, response);
    }
}

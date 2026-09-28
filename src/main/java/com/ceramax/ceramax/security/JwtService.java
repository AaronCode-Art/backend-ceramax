package com.ceramax.ceramax.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Set;

@Service
public class JwtService {

    @Value("${app.jwt.secret}")
    private String jwtSecret;

    @Value("${app.jwt.expiration-ms}")
    private long jwtExpirationMs;

    // La clave y el parser son inmutables una vez arrancada la app: antes se
    // reconstruían (Keys.hmacShaKeyFor + Jwts.parser().build()) en cada validación
    // de token, es decir en cada request autenticado. Se calculan una sola vez.
    private SecretKey signingKey;
    private JwtParser parser;

    @PostConstruct
    private void init() {
        this.signingKey = Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));
        this.parser = Jwts.parser().verifyWith(signingKey).build();
    }

    private SecretKey getSigningKey() {
        return signingKey;
    }

    public String generateToken(Long usuarioId, String email, String nombre, String apellido, String rol, Set<String> permisos) {
        return Jwts.builder()
                .subject(email)
                .claim("usuarioId", usuarioId)
                .claim("nombre", nombre)
                .claim("apellido", apellido)
                .claim("role", rol)
                .claim("permissions", permisos)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + jwtExpirationMs))
                .signWith(getSigningKey())
                .compact();
    }

    public String extractEmail(String token) {
        return getClaims(token).getSubject();
    }

    public String extractRole(String token) {
        return getClaims(token).get("role", String.class);
    }

    public Date extractExpiration(String token) {
        return getClaims(token).getExpiration();
    }

    public boolean isValidToken(String token) {
        try {
            Claims claims = getClaims(token);
            return !claims.getExpiration().before(new Date());
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    private Claims getClaims(String token) {
        return parser.parseSignedClaims(token).getPayload();
    }
}

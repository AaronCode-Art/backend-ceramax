package com.ceramax.ceramax.security;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.util.Objects;

@Component
public class OwnershipGuard {

    public void assertCanAccess(Long ownerId, Authentication authentication) {
        if (hasAuthority(authentication, "ROLE_ADMIN")) return;

        if (authentication == null
                || !(authentication.getPrincipal() instanceof CustomUserDetails user)
                || !Objects.equals(user.getUsuarioId(), ownerId)) {
            throw new AccessDeniedException("No tienes acceso a los datos de otro usuario");
        }
    }

    public void assertCanAccessOrAuthority(Long ownerId, Authentication authentication, String authority) {
        if (hasAuthority(authentication, "ROLE_ADMIN") || hasAuthority(authentication, authority)) return;
        assertCanAccess(ownerId, authentication);
    }

    private boolean hasAuthority(Authentication authentication, String authority) {
        return authentication != null && authentication.getAuthorities().stream()
                .anyMatch(grantedAuthority -> authority.equals(grantedAuthority.getAuthority()));
    }
}

package com.ceramax.ceramax.controller;

import com.ceramax.ceramax.dto.auth.AuthResponse;
import com.ceramax.ceramax.dto.auth.LoginRequest;
import com.ceramax.ceramax.dto.auth.RegistroRequest;
import com.ceramax.ceramax.dto.common.ApiResponse;
import com.ceramax.ceramax.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest req) {
        AuthResponse auth = authService.login(req.email(), req.password());
        return ResponseEntity.ok(ApiResponse.ok("Login exitoso", auth));
    }

    @PostMapping("/login-tienda")
    public ResponseEntity<ApiResponse<AuthResponse>> loginTienda(@Valid @RequestBody LoginRequest req) {
        AuthResponse auth = authService.loginTienda(req.email(), req.password());
        return ResponseEntity.ok(ApiResponse.ok("Login exitoso", auth));
    }

    @PostMapping("/registro")
    public ResponseEntity<ApiResponse<AuthResponse>> registro(@Valid @RequestBody RegistroRequest req) {
        AuthResponse auth = authService.registroCliente(req);
        return ResponseEntity.ok(ApiResponse.ok("Registro exitoso", auth));
    }

    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(@RequestHeader("Authorization") String header) {
        String token = header.replace("Bearer ", "");
        authService.logout(token);
        return ResponseEntity.ok(ApiResponse.ok("Logout exitoso", null));
    }
}

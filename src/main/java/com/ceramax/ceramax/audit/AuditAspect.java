package com.ceramax.ceramax.audit;

import com.ceramax.ceramax.service.AuditoriaService;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Arrays;

@Aspect
@Component
public class AuditAspect {

    private final AuditoriaService auditoriaService;

    public AuditAspect(AuditoriaService auditoriaService) {
        this.auditoriaService = auditoriaService;
    }

    @Around("@within(com.ceramax.ceramax.audit.AuditableService) "
            + "&& execution(public * *(..))")
    public Object audit(ProceedingJoinPoint joinPoint) throws Throwable {
        Method method = ((MethodSignature) joinPoint.getSignature()).getMethod();
        String accion = accionPara(method.getName());
        if (accion == null) {
            return joinPoint.proceed();
        }

        Object[] argumentos = joinPoint.getArgs();
        Object resultado = joinPoint.proceed();

        // A partir de aquí ya se tiene la respuesta: todo el trabajo de auditoría
        // (serializar a JSON, resolver el id de entidad, escribir en BD) se encola
        // en auditExecutor y NO retrasa la respuesta HTTP.
        if (!auditoriaService.esClienteActual()) {
            Long entidadId = obtenerId(resultado, argumentos);
            String entidad = entidadPara(joinPoint.getTarget().getClass());
            HttpServletRequest request = obtenerRequest();
            String ip = request != null ? request.getRemoteAddr() : null;
            String userAgent = request != null ? request.getHeader("User-Agent") : null;
            Long usuarioId = auditoriaService.usuarioIdActual();

            auditoriaService.registrarAsync(accion, entidad, entidadId, usuarioId,
                    argumentos, resultado, method.getName() + " ejecutado", ip, userAgent);
        }
        return resultado;
    }

    private String accionPara(String nombreMetodo) {
        String nombre = nombreMetodo.toLowerCase();
        if (nombre.startsWith("crear") || nombre.startsWith("registrar")
                || nombre.startsWith("agregar") || nombre.startsWith("asignar")) {
            return "CREAR";
        }
        if (nombre.startsWith("actualizar") || nombre.startsWith("editar")
                || nombre.startsWith("cambiar") || nombre.startsWith("procesar")) {
            return "ACTUALIZAR";
        }
        if (nombre.startsWith("eliminar") || nombre.startsWith("borrar")
                || nombre.startsWith("remover") || nombre.startsWith("cancelar")) {
            return "ELIMINAR";
        }
        return null;
    }

    private String entidadPara(Class<?> serviceClass) {
        String nombre = serviceClass.getSimpleName();
        if (nombre.contains("$$")) {
            nombre = nombre.substring(0, nombre.indexOf("$$"));
        }
        return nombre.endsWith("Service") ? nombre.substring(0, nombre.length() - 7) : nombre;
    }

    private Long obtenerId(Object resultado, Object[] argumentos) {
        Long idResultado = obtenerIdDesdeObjeto(resultado);
        if (idResultado != null) {
            return idResultado;
        }
        return Arrays.stream(argumentos)
                .filter(Number.class::isInstance)
                .map(Number.class::cast)
                .map(Number::longValue)
                .findFirst()
                .orElse(null);
    }

    private Long obtenerIdDesdeObjeto(Object objeto) {
        if (objeto == null || objeto instanceof Iterable<?>) {
            return null;
        }
        try {
            Method idMethod;
            try {
                idMethod = objeto.getClass().getMethod("getId");
            } catch (NoSuchMethodException exception) {
                idMethod = objeto.getClass().getMethod("id");
            }
            Object id = idMethod.invoke(objeto);
            return id instanceof Number number ? number.longValue() : null;
        } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException ignored) {
            return null;
        }
    }

    private HttpServletRequest obtenerRequest() {
        if (RequestContextHolder.getRequestAttributes() instanceof ServletRequestAttributes attributes) {
            return attributes.getRequest();
        }
        return null;
    }
}

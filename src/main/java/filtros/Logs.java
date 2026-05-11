package filtros;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import java.io.*;
import java.time.LocalDateTime;

public class Logs implements Filter {

    private String rutaLogs;

    @Override
    public void init(FilterConfig config) throws ServletException {
        // Lee la ruta del archivo desde web.xml (context-param)
        rutaLogs = config.getServletContext().getInitParameter("ruta-logs");
        
        if (rutaLogs == null || rutaLogs.isEmpty()) {
            throw new ServletException("Falta el parámetro 'ruta-logs' en web.xml");
        }
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;

        // Datos del acceso
        String timestamp = LocalDateTime.now().toString();
        String usuario    = req.getRemoteUser();        // null si no autenticado
        String ip         = req.getRemoteAddr();
        String uri        = req.getRequestURI();
        String metodo     = req.getMethod();

        // Nombre del servlet/recurso: solo el último segmento de la URI
        String recurso = uri.substring(uri.lastIndexOf('/') + 1);
        if (recurso.isEmpty()) recurso = "index";

        // Formato: 2020-06-09T19:38:14.278 prof1 158.11.11.11 Acceso GET
        String linea = String.format("%s %s %s %s %s%n",
                timestamp,
                (usuario != null ? usuario : "anonimo"),
                ip,
                recurso,
                metodo);

        // Escritura en el archivo (append = true para mantener orden cronológico)
        synchronized (this) {
            try (FileWriter fw = new FileWriter(rutaLogs, true);
                 BufferedWriter bw = new BufferedWriter(fw)) {
                bw.write(linea);
            }
        }

        // Continúa con la cadena de filtros / servlet destino
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // nada que limpiar
    }
}
package filtros;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;

public class Logs implements Filter {
    private String rutaArchivo; 

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        
        this.rutaArchivo = filterConfig.getServletContext().getInitParameter("rutaLog");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;

        
        String fechaHora = LocalDateTime.now().toString();
        String usuario = httpRequest.getRemoteUser();
        if (usuario == null) usuario = "Desconocido"; 
        
        String ipCliente = httpRequest.getRemoteAddr();
        String recurso = httpRequest.getRequestURI();
        String metodo = httpRequest.getMethod();

        
        String entradaLog = String.format("%s %s %s %s %s", 
                            fechaHora, usuario, ipCliente, recurso, metodo);

        
        if (rutaArchivo != null) {
            
            try (FileWriter fw = new FileWriter(rutaArchivo, true);
                 PrintWriter pw = new PrintWriter(fw)) {
                pw.println(entradaLog);
            } catch (IOException e) {
                e.printStackTrace(); 
            }
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
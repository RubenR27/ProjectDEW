package es.upv.dew.filtros;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class FiltroSeguridad implements Filter {

    // Diccionario para traducir: Usuario Tomcat -> {DNI, Password}
    private Map<String, String[]> usuariosLocal;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        usuariosLocal = new HashMap<>();
        // Estos son los datos para simular el login en la base de datos de la uni
        usuariosLocal.put("pepe", new String[]{"12345678W", "123456"}); 
        usuariosLocal.put("ramon", new String[]{"23456733H", "123456"});
        usuariosLocal.put("carlos", new String[]{"11223344A", "123456"});
        usuariosLocal.put("ana", new String[]{"22334455B", "123456"});
        usuariosLocal.put("luis", new String[]{"33445566C", "123456"});
        usuariosLocal.put("sofia", new String[]{"44556677D", "123456"});
        usuariosLocal.put("andres", new String[]{"55667788E", "123456"});
        usuariosLocal.put("elena", new String[]{"66778899F", "123456"});
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession sesion = req.getSession(false);

        if (sesion != null) {
            String key = (String) sesion.getAttribute("key");

            // Si no tenemos la 'key', la buscamos usando el login de Tomcat
            if (key == null) {
                String login = req.getRemoteUser(); 

                if (login != null && usuariosLocal.containsKey(login)) {
                    String[] datos = usuariosLocal.get(login);
                    String dni = datos[0];
                    String pass = datos[1];

                    // --- PARTE A COMPLETAR CON EL MIEMBRO 5 ---
                    // Aquí irá la llamada HTTP POST al puerto 9090 para sacar la key real
                    String claveObtenida = "CLAVE_SIMULADA_POR_AHORA"; 
                    
                    // Guardamos la key en la sesión para que el resto de la web la use
                    sesion.setAttribute("key", claveObtenida);
                    sesion.setAttribute("dni", dni);
                    System.out.println("DEBUG: Key generada para " + login);
                }
            }
        }

        // Seguir adelante con la petición
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
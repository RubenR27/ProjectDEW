package filtros;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession sesion = request.getSession(false);

        // Tomcat ya nos garantiza que el usuario está logueado en este punto
        // Solo verificamos que la conexión a CentroEducativo siga viva
        String key = (sesion != null) ? (String) sesion.getAttribute("key") : null;

        if (key == null) {
            // Si por algún motivo se perdió la key, deslogueamos y mandamos al login
            request.logout();
            if (sesion != null) {
                sesion.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/loginPrueba.html");
            return;
        }

        chain.doFilter(req, res);
    }
}
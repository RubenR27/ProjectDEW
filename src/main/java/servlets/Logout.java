package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class Logout extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        if (sesion != null) {
            sesion.invalidate();        // Borra key, dni, pass de sesión
        }
        request.logout();              // Cierra la sesión de seguridad de Tomcat
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
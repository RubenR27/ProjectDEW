package es.upv.dew.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Recuperamos la sesión actual (sin crear una nueva)
        HttpSession sesion = request.getSession(false);
        
        if (sesion != null) {
            // Esto destruye la sesión y borra la famosa 'key' de la memoria
            sesion.invalidate();
        }
        
        // 2. Le decimos a Tomcat que cierre la sesión de seguridad (borra a "pepe" o "ramon")
        request.logout();
        
        // 3. Redirigimos al usuario a la pantalla de bienvenida pública
        // getContextPath() añade automáticamente el "/ProjectDEW-master" para que no falle la ruta
        response.sendRedirect(request.getContextPath() + "/bienvenida.html");
    }
}
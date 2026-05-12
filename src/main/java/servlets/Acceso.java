package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class Acceso extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("j_username");
        String pass    = request.getParameter("j_password");

        // Guardamos la pass en sesión ANTES de que Tomcat procese el login
        HttpSession sesion = request.getSession(true);
        sesion.setAttribute("pass", pass);
        sesion.setAttribute("dniLogin", usuario);

        // Redirigir a j_security_check para que Tomcat complete la autenticación
        response.sendRedirect(request.getContextPath() + "/j_security_check?j_username="
                + usuario + "&j_password=" + pass);
    }
}
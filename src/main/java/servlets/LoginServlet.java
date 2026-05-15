package servlets;

import datos.CentroEducativoClient;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni = request.getParameter("j_username");
        String pass = request.getParameter("j_password");

        if (dni == null || pass == null || dni.isBlank() || pass.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/login_error.jsp");
            return;
        }

        // ── TRUCO: Creamos la sesión ANTES del login ──────────────────
        HttpSession sesion = request.getSession(true);

        if (request.getUserPrincipal() != null) {
            try { request.logout(); } catch (Exception e) {}
        }

        // ── 1. Autenticar contra tomcat-users.xml ─────────────────────
        try {
            request.login(dni, pass);
        } catch (ServletException e) {
            response.sendRedirect(request.getContextPath() + "/login_error.jsp");
            return;
        }

        // ── 2. Autenticar contra CentroEducativo ──────────────────────
        CentroEducativoClient cliente = new CentroEducativoClient();
        String key;
        try {
            key = cliente.login(dni, pass);
        } catch (Exception e) {
            try { request.logout(); } catch (Exception ex) {}
            throw new ServletException("No se pudo conectar con CentroEducativo", e);
        }

        if (key == null) {
            try { request.logout(); } catch (Exception ex) {}
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Usuario válido en Tomcat pero rechazado por CentroEducativo.");
            return;
        }

        // ── 3. Guardar en sesión (Usamos la variable de arriba) ───────
        sesion.setAttribute("key", key);
        sesion.setAttribute("clienteCE", cliente);
        sesion.setAttribute("dni", dni);

        // ── 4. Redirigir según rol ────────────────────────────────────
        if (request.isUserInRole("rolalu")) {
            response.sendRedirect(request.getContextPath() + "/alumno/asignaturas");
        } else if (request.isUserInRole("rolpro")) {
            response.sendRedirect(request.getContextPath() + "/profesor/asignaturas");
        } else {
            try { request.logout(); } catch (Exception ex) {}
            response.sendRedirect(request.getContextPath() + "/login_error.jsp");
        }
    }
}
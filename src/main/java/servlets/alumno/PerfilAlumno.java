package servlets.alumno;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import datos.CentroEducativoClient;
import com.google.gson.*;
import java.io.IOException;

public class PerfilAlumno extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni = request.getRemoteUser();

        HttpSession sesion = request.getSession(false);
        if (sesion == null) {
            response.sendRedirect(request.getContextPath() + "/loginPrueba.html");
            return;
        }

        String key = (String) sesion.getAttribute("key");
        CentroEducativoClient cliente = (CentroEducativoClient) sesion.getAttribute("clienteCE");

        if (cliente == null || key == null) {
            response.sendRedirect(request.getContextPath() + "/loginPrueba.html");
            return;
        }

        // ── 1. Obtener nombre del alumno ──
        if (sesion.getAttribute("nombre") == null) {
            String jsonAlumno = cliente.get("/alumnos/" + dni, key);
            if (jsonAlumno != null) {
                JsonObject alumnoObj = JsonParser.parseString(jsonAlumno).getAsJsonObject();
                String nombreCompleto = alumnoObj.get("nombre").getAsString() + " " + 
                                        alumnoObj.get("apellidos").getAsString();
                sesion.setAttribute("nombre", nombreCompleto);
            } else {
                sesion.setAttribute("nombre", "Usuario");
            }
        }

        // ── 2. Obtener y enriquecer las asignaturas ──
        String jsonNotas = cliente.get("/alumnos/" + dni + "/asignaturas", key);
        JsonArray asigsEnriquecidas = new JsonArray();

        if (jsonNotas != null && !jsonNotas.trim().equals("[]") && !jsonNotas.trim().isEmpty()) {
            JsonArray notasArray = JsonParser.parseString(jsonNotas).getAsJsonArray();
            for (JsonElement elem : notasArray) {
                JsonObject notaObj = elem.getAsJsonObject();
                if (notaObj.has("asignatura")) {
                    String acronimo = notaObj.get("asignatura").getAsString();
                    String jsonDetalle = cliente.get("/asignaturas/" + acronimo, key);
                    
                    if (jsonDetalle != null && !jsonDetalle.isEmpty()) {
                        JsonObject detalleObj = JsonParser.parseString(jsonDetalle).getAsJsonObject();
                        if (notaObj.has("nota")) {
                            detalleObj.add("nota", notaObj.get("nota"));
                        }
                        asigsEnriquecidas.add(detalleObj);
                    }
                }
            }
        }

        // ── 3. ENVIAR LOS DATOS AL JSP DEL PERFIL ──
        request.setAttribute("asignaturas", asigsEnriquecidas.toString());
        request.getRequestDispatcher("/alu_perfil.jsp").forward(request, response);
    }
}
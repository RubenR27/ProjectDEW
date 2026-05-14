package servlets.alumno;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import datos.CentroEducativoClient;
import com.google.gson.*;
import java.io.IOException;

public class DetalleAsignatura extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni = request.getRemoteUser();
        // Leemos 'acr' porque así lo envía el botón en bienvenida.jsp
        String acr = request.getParameter("acr");

        if (acr == null || acr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/alumno/asignaturas");
            return;
        }

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

        // 1. Obtener nombre del alumno
        if (sesion.getAttribute("nombre") == null) {
            String jsonAlumno = cliente.get("/alumnos/" + dni, key);
            if (jsonAlumno != null) {
                JsonObject alumnoObj = JsonParser.parseString(jsonAlumno).getAsJsonObject();
                String nombreCompleto = alumnoObj.get("nombre").getAsString() + " " + 
                                        alumnoObj.get("apellidos").getAsString();
                sesion.setAttribute("nombre", nombreCompleto);
            }
        }

        // 2. Obtener datos de la asignatura
        String jsonAsig = cliente.get("/asignaturas/" + acr, key);
        JsonObject detalleObj = new JsonObject();
        
        if (jsonAsig != null && !jsonAsig.isEmpty()) {
            detalleObj = JsonParser.parseString(jsonAsig).getAsJsonObject();
        } else {
            // Si la asignatura no existe, volvemos a la lista
            response.sendRedirect(request.getContextPath() + "/alumno/asignaturas");
            return;
        }

        // 3. Obtener la nota del alumno en esta asignatura
        String jsonNotas = cliente.get("/alumnos/" + dni + "/asignaturas", key);
        if (jsonNotas != null && !jsonNotas.isEmpty()) {
            JsonArray notasArray = JsonParser.parseString(jsonNotas).getAsJsonArray();
            for (JsonElement elem : notasArray) {
                JsonObject notaObj = elem.getAsJsonObject();
                if (notaObj.has("asignatura") && notaObj.get("asignatura").getAsString().equals(acr)) {
                    if (notaObj.has("nota")) {
                        detalleObj.add("nota", notaObj.get("nota"));
                    }
                    break;
                }
            }
        }

        // 4. Obtener el profesor de la asignatura (Opcional pero queda muy bien en el diseño)
        String jsonProfes = cliente.get("/asignaturas/" + acr + "/profesores", key);
        String profesStr = "Sin asignar";
        if (jsonProfes != null && !jsonProfes.trim().equals("[]")) {
            JsonArray profesArray = JsonParser.parseString(jsonProfes).getAsJsonArray();
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < profesArray.size(); i++) {
                JsonObject p = profesArray.get(i).getAsJsonObject();
                if (i > 0) sb.append(", ");
                sb.append(p.get("nombre").getAsString()).append(" ").append(p.get("apellidos").getAsString());
            }
            profesStr = sb.toString();
        }
        detalleObj.addProperty("profesor", profesStr);

        // 5. Mandar los datos al nuevo JSP
        request.setAttribute("detalle", detalleObj.toString());
        request.getRequestDispatcher("/alu_detalle.jsp").forward(request, response);
    }
}
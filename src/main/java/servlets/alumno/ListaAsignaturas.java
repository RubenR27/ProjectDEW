package servlets.alumno;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import datos.CentroEducativoClient;
import com.google.gson.*;
import java.io.IOException;
import java.io.PrintWriter;

public class ListaAsignaturas extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni = request.getRemoteUser();

        // Para el prototipo Hito 1: todos los usuarios de prueba tienen pass "123456"
        String pass = "123456";

        CentroEducativoClient cliente = new CentroEducativoClient();
        String json = cliente.loginYGet("/alumnos/" + dni + "/asignaturas", dni, pass);
        System.out.println("JSON recibido: " + json);
        

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html><html lang='es'><head><meta charset='UTF-8'>");
        out.println("<title>NOL - Mis Asignaturas</title>");
        out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>");
        out.println("</head><body class='bg-light'>");

        out.println("<nav class='navbar navbar-dark bg-primary px-3 d-flex justify-content-between'>");
        out.println("  <span class='navbar-brand mb-0'>Notas OnLine</span>");
        out.println("  <span class='text-white'>Alumno: " + dni + "</span>");
        out.println("  <a href='" + request.getContextPath() + "/logout' class='btn btn-outline-light btn-sm'>Cerrar sesión</a>");
        out.println("</nav>");

        out.println("<div class='container mt-4'>");
        out.println("<h3>Mis asignaturas matriculadas</h3>");

        if (json != null) {
            JsonArray asignaturas = JsonParser.parseString(json).getAsJsonArray();

            if (asignaturas.size() == 0) {
                out.println("<div class='alert alert-info'>No estás matriculado en ninguna asignatura.</div>");
            } else {
                out.println("<div class='list-group mt-3' style='max-width:600px'>");
                for (JsonElement elem : asignaturas) {
                    JsonObject asig = elem.getAsJsonObject();
                    // El endpoint /alumnos/{dni}/asignaturas devuelve {"asignatura":"DEW","nota":""}
                    String acronimo = asig.get("asignatura").getAsString();
                    String nota     = asig.get("nota").getAsString();
                    String notaTexto = (nota == null || nota.isEmpty()) ? "Sin calificar" : nota;

                    out.println("<a href='" + request.getContextPath()
                        + "/alumno/detalle?asig=" + acronimo
                        + "' class='list-group-item list-group-item-action d-flex justify-content-between align-items-center'>"
                        + "<strong>" + acronimo + "</strong>"
                        + "<span class='badge bg-primary rounded-pill'>" + notaTexto + "</span>"
                        + "</a>");
                }
                out.println("</div>");
            }
        } else {
            out.println("<div class='alert alert-danger'>Error al conectar con CentroEducativo.</div>");
        }

        out.println("</div></body></html>");
    }
}
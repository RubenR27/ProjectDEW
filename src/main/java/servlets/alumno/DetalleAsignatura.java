package servlets.alumno;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import datos.CentroEducativoClient;
import com.google.gson.*;
import java.io.IOException;
import java.io.PrintWriter;

public class DetalleAsignatura extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni  = request.getRemoteUser();
        String asig = request.getParameter("asig");

        if (asig == null || asig.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/alumno/asignaturas");
            return;
        }

        // key garantizada por IniciarSesionDatos
        HttpSession sesion = request.getSession(false);
        String key = (String) sesion.getAttribute("key");

        CentroEducativoClient cliente = (CentroEducativoClient) sesion.getAttribute("clienteCE");
        if (cliente == null) {
            response.sendRedirect(request.getContextPath() + "/loginPrueba.html");
            return;
        }
        String jsonNota = cliente.get("/alumnos/" + dni + "/asignaturas/" + asig, key);
        String jsonAsig = cliente.get("/asignaturas/" + asig, key);

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html><html lang='es'><head><meta charset='UTF-8'>");
        out.println("<title>NOL - Detalle Asignatura</title>");
        out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>");
        out.println("</head><body class='bg-light'>");
        out.println("<nav class='navbar navbar-dark bg-primary px-3 d-flex justify-content-between'>");
        out.println("  <span class='navbar-brand mb-0'>Notas OnLine</span>");
        out.println("  <a href='" + request.getContextPath() + "/alumno/asignaturas' class='btn btn-outline-light btn-sm'>← Mis asignaturas</a>");
        out.println("</nav>");
        out.println("<div class='container mt-4'>");

        if (jsonAsig != null) {
            JsonObject a = JsonParser.parseString(jsonAsig).getAsJsonObject();
            out.println("<h3>" + a.get("nombre").getAsString() + " (" + asig + ")</h3>");
            out.println("<p class='text-muted'>Curso " + a.get("curso").getAsString()
                + " &bull; Cuatrimestre " + a.get("cuatrimestre").getAsString()
                + " &bull; " + a.get("creditos").getAsString() + " créditos</p>");
        } else {
            out.println("<h3>Asignatura: " + asig + "</h3>");
        }

        out.println("<div class='card mt-3' style='max-width:400px'><div class='card-body text-center'>");
        out.println("<h5 class='card-title'>Tu calificación</h5>");

        if (jsonNota != null) {
            JsonObject obj = JsonParser.parseString(jsonNota).getAsJsonObject();
            String nota = obj.has("nota") && !obj.get("nota").isJsonNull()
                ? obj.get("nota").getAsString() : "Sin calificar";
            out.println("<p class='display-4'>" + nota + "</p>");
        } else {
            out.println("<p class='display-4 text-muted'>—</p>");
            out.println("<p class='text-muted'>Sin calificación registrada</p>");
        }
        out.println("</div></div></div></body></html>");
    }
}
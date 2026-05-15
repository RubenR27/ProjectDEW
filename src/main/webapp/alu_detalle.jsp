<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.google.gson.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NOL — Detalle de Asignatura</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/estils2.css">
</head>
<body>

    <%
        // Datos del alumno
        String nombre   = (String) session.getAttribute("nombre");
        String dni      = request.getRemoteUser();
        String[] partes = nombre != null ? nombre.split(" ") : new String[]{"?"};
        String iniciales = (partes[0].charAt(0) + "" + (partes.length > 1 ? partes[1].charAt(0) : "")).toUpperCase();
        
        // Datos de la asignatura
        String detalleJson = (String) request.getAttribute("detalle");
        JsonObject asig = new JsonObject();
        if (detalleJson != null) {
            asig = JsonParser.parseString(detalleJson).getAsJsonObject();
        }

        String acr      = asig.has("acronimo") ? asig.get("acronimo").getAsString() : "";
        String nomAsig  = asig.has("nombre") ? asig.get("nombre").getAsString() : "";
        int curso       = asig.has("curso") ? asig.get("curso").getAsInt() : 0;
        String cuatri   = asig.has("cuatrimestre") ? asig.get("cuatrimestre").getAsString() : "";
        double creditos = asig.has("creditos") ? asig.get("creditos").getAsDouble() : 0;
        String profesor = asig.has("profesor") ? asig.get("profesor").getAsString() : "Desconocido";

        // Nota
        double nota = -1.0;
        if (asig.has("nota") && !asig.get("nota").isJsonNull()) {
            try { nota = asig.get("nota").getAsDouble(); } catch (Exception e) {}
        }
        String notaStr = nota >= 0 ? String.format("%.1f", nota) : "—";

        String claseNota;
        if      (nota >= 7) claseNota = "nota-alta";
        else if (nota >= 5) claseNota = "nota-media";
        else if (nota >= 0) claseNota = "nota-baja";
        else                claseNota = "nota-media";

        String lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.";
    %>

    <nav class="navbar">
        <div class="navbar-marca">
            NOL <span>·</span> Notas Online
        </div>
        <div class="navbar-acciones">
            <a href="<%= request.getContextPath() %>/alumno/asignaturas" class="btn-nav" id="btn-asig">
                Mis asignaturas
            </a>
            <a href="<%= request.getContextPath() %>/alumno/certificado" class="btn-nav" id="btn-cert">
                Certificado
            </a>
            <div class="navbar-usuario">
                <span class="chip-rol">Alumno</span>
                <div class="perfil-wrapper">
                    <div class="perfil-avatar" onclick="togglePerfil()">
                        <%= iniciales %>
                    </div>
                    <div class="perfil-dropdown" id="perfilDropdown">
                        <div class="perfil-header">
                            <div class="perfil-avatar-grande"><<%= iniciales %></div>
                            <div>
                                <div class="perfil-nombre"><%= nombre %></div>
                                <div class="perfil-dni">DNI: <%= dni %></div>
                                <span class="chip-rol" style="margin-top: 6px; display: inline-block;">
                                    Alumno
                                </span>
                            </div>
                        </div>
                        <a href="<%= request.getContextPath() %>/logout"
                           class="btn-salir"
                           style="width: 100%; margin-top: 12px; display: block; text-align: center; text-decoration: none;">
                            Cerrar sesión
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="contenedor-principal">

        <a href="<%= request.getContextPath() %>/alumno/asignaturas" class="btn-volver" style="text-decoration: none; display: inline-block;">
            &larr; Volver a mis asignaturas
        </a>

        <div class="seccion-titulo"><%= nomAsig %></div>
        <div class="seccion-subtitulo">Detalle de asignatura</div>

        <div class="detalle-grid">

            <div>
                <div class="detalle-avatar"><%= acr %></div>
                <div class="detalle-nota-grande">
                    <span class="nota-numero badge-nota <%= claseNota %>"><%= notaStr %></span>
                    <span class="nota-label">Calificación</span>
                </div>
            </div>

            <div class="detalle-ficha">

                <div class="ficha-fila">
                    <span class="ficha-label">Asignatura</span>
                    <span class="ficha-valor"><%= nomAsig %></span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Acrónimo</span>
                    <span class="ficha-valor"><%= acr %></span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Profesor</span>
                    <span class="ficha-valor"><%= profesor %></span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Créditos</span>
                    <span class="ficha-valor"><%= creditos %> ECTS</span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Curso</span>
                    <span class="ficha-valor"><%= curso %>º · Cuatrimestre <%= cuatri %></span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Alumno</span>
                    <span class="ficha-valor"><%= nombre %></span>
                </div>

            </div>

        </div>

    </div>

    <script>
        function togglePerfil() {
            document.getElementById('perfilDropdown').classList.toggle('visible');
        }

        document.addEventListener('click', function(e) {
            const wrapper = document.querySelector('.perfil-wrapper');
            if (wrapper && !wrapper.contains(e.target)) {
                document.getElementById('perfilDropdown').classList.remove('visible');
            }
        });
    </script>

</body>
</html>
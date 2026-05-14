<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.google.gson.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NOL — Notas Online</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/estils2.css">
</head>
<body>

    <%
        String nombre = (String) session.getAttribute("nombre");
        String dni    = request.getRemoteUser();
        String[] partes = nombre != null ? nombre.split(" ") : new String[]{"?"};
        String iniciales = (partes[0].charAt(0) + "" + (partes.length > 1 ? partes[1].charAt(0) : "")).toUpperCase();
        
        String asigJson = (String) request.getAttribute("asignaturas");
        JsonArray asigs = new JsonArray();
        if (asigJson != null && !asigJson.equals("[]")) {
            asigs = JsonParser.parseString(asigJson).getAsJsonArray();
        }
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
                            <div class="perfil-avatar-grande"><%= iniciales %></div>
                            <div>
                                <div class="perfil-nombre"><%= nombre %></div>
                                <div class="perfil-dni">DNI: <%= dni %></div>
                                <span class="chip-rol" style="margin-top: 6px; display: inline-block;">
                                    Alumno
                                </span>
                            </div>
                        </div>
                        <div class="perfil-info">
                            <div class="perfil-fila">
                                <span class="perfil-key">Asignaturas</span>
                                <span class="perfil-val"><%= asigs.size() %> matriculadas</span>
                            </div>
                            <div class="perfil-fila">
                                <span class="perfil-key">Curso</span>
                                <span class="perfil-val">2025/2026</span>
                            </div>
                            <div class="perfil-fila">
                                <span class="perfil-key">Centro</span>
                                <span class="perfil-val">ETSINF · UPV</span>
                            </div>
                        </div>
                        
                        <a href="<%= request.getContextPath() %>/alumno/perfil"
                           class="btn-primario"
                           style="width: 100%; margin-top: 15px; display: block; text-align: center; text-decoration: none; padding: 8px; font-size: 14px;">
                            Ver mi perfil completo
                        </a>

                        <a href="<%= request.getContextPath() %>/logout"
                           class="btn-salir"
                           style="width: 100%; margin-top: 8px; display: block; text-align: center; text-decoration: none;">
                            Cerrar sesión
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="contenedor-principal">

        <div class="seccion-titulo">Mis asignaturas</div>
        <div class="seccion-subtitulo"><%= nombre %> &nbsp;·&nbsp; <%= dni %></div>

        <%
            for (int i = 0; i < asigs.size(); i++) {

                JsonObject a    = asigs.get(i).getAsJsonObject();
                String acr      = a.has("acronimo") ? a.get("acronimo").getAsString() : "";
                String nomAsig  = a.has("nombre") ? a.get("nombre").getAsString() : "";
                int curso       = a.has("curso") ? a.get("curso").getAsInt() : 0;
                String cuatri   = a.has("cuatrimestre") ? a.get("cuatrimestre").getAsString() : "";
                double creditos = a.has("creditos") ? a.get("creditos").getAsDouble() : 0;
                
                double nota     = -1.0;
                if (a.has("nota") && !a.get("nota").isJsonNull()) {
                    try {
                        nota = a.get("nota").getAsDouble();
                    } catch (Exception e) {} // Evita cuelgues si la nota viene vacía
                }
                String notaStr  = nota >= 0 ? String.format("%.1f", nota) : "—";

                String claseNota;
                if      (nota >= 7) claseNota = "nota-alta";
                else if (nota >= 5) claseNota = "nota-media";
                else if (nota >= 0) claseNota = "nota-baja";
                else                claseNota = "nota-media";
        %>

            <div class="asig-card">

                <div>
                    <div class="asig-nombre"><%= nomAsig %></div>
                    <div class="asig-meta">
                        <%= acr %> &nbsp;·&nbsp;
                        Curso <%= curso %> &nbsp;·&nbsp;
                        Cuatrimestre <%= cuatri %> &nbsp;·&nbsp;
                        <%= creditos %> ECTS
                    </div>
                </div>

                <div class="asig-derecha">
                    <span class="badge-nota <%= claseNota %>"><%= notaStr %></span>
                    <a href="<%= request.getContextPath() %>/alumno/detalle?acr=<%= acr %>"
                       class="btn-detalle">
                        Ver detalles
                    </a>
                </div>

            </div>

        <% } %>

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

        // Marcar botón activo según la URL
        const url = window.location.href;
        if (url.includes('/certificado')) {
            document.getElementById('btn-cert').classList.add('activo');
        } else {
            document.getElementById('btn-asig').classList.add('activo');
        }
    </script>

</body>
</html>
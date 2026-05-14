<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.json.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NOL — Certificado</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/estils.css">
</head>
<body>

    <%
        String nombre   = (String) session.getAttribute("nombre");
        String dni      = request.getRemoteUser();
        String[] partes = nombre != null ? nombre.split(" ") : new String[]{"?"};
        String iniciales = (partes[0].charAt(0) + "" + (partes.length > 1 ? partes[1].charAt(0) : "")).toUpperCase();
        String asigJson  = (String) request.getAttribute("asignaturas");
        JSONArray asigs  = asigJson != null ? new JSONArray(asigJson) : new JSONArray();

        double suma = 0;
        int    con  = 0;
        for (int i = 0; i < asigs.length(); i++) {
            double n = asigs.getJSONObject(i).optDouble("nota", -1);
            if (n >= 0) { suma += n; con++; }
        }
        String media = con > 0 ? String.format("%.2f", suma / con) : "—";
    %>

    <nav class="navbar">

        <div class="navbar-marca">
            NOL <span>·</span> Notas Online
        </div>

        <div class="navbar-acciones">

            <a href="<%= request.getContextPath() %>/alumno/asignaturas" class="btn-nav" id="btn-asig">
                Mis asignaturas
            </a>

            <a href="<%= request.getContextPath() %>/alumno/certificado" class="btn-nav activo" id="btn-cert">
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
                                <span class="perfil-val"><%= asigs.length() %> matriculadas</span>
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

        <div class="cert-cabecera">
            <div>
                <div class="seccion-titulo">Certificado académico</div>
                <div class="cert-alumno-info">
                    <%= nombre %> &nbsp;·&nbsp; DNI: <%= dni %>
                </div>
            </div>
            <button onclick="window.print()" class="btn-imprimir">
                Imprimir
            </button>
        </div>

        <table class="cert-tabla">

            <thead>
                <tr>
                    <th>Asignatura</th>
                    <th>Acrónimo</th>
                    <th>Créditos</th>
                    <th>Nota</th>
                </tr>
            </thead>

            <tbody>

                <% for (int i = 0; i < asigs.length(); i++) {
                    JSONObject a    = asigs.getJSONObject(i);
                    double nota     = a.optDouble("nota", -1);
                    String notaStr  = nota >= 0 ? String.format("%.1f", nota) : "—";
                    String claseNota;
                    if      (nota >= 7) claseNota = "nota-alta";
                    else if (nota >= 5) claseNota = "nota-media";
                    else if (nota >= 0) claseNota = "nota-baja";
                    else                claseNota = "nota-media";
                %>

                    <tr>
                        <td><%= a.optString("nombre", "") %></td>
                        <td><%= a.optString("acronimo", "") %></td>
                        <td><%= a.optDouble("creditos", 0) %> ECTS</td>
                        <td>
                            <span class="badge-nota <%= claseNota %>">
                                <%= notaStr %>
                            </span>
                        </td>
                    </tr>

                <% } %>

            </tbody>

        </table>

        <div class="cert-media-box">
            <span class="cert-media-label">Nota media del expediente</span>
            <span class="cert-media-valor"><%= media %></span>
        </div>

    </div>

    <div class="pie-pagina">
       
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
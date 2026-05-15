<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.google.gson.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NOL — Mi Perfil</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/estilos.css">
</head>
<body>

    <%
        // Extraemos los datos que nos envía el Servlet
        String nombre = (String) session.getAttribute("nombre");
        String dni    = request.getRemoteUser();
        String asigJson = (String) request.getAttribute("asignaturas");
        JsonArray asigs = new JsonArray();
        if (asigJson != null && !asigJson.equals("[]")) {
            asigs = JsonParser.parseString(asigJson).getAsJsonArray();
        }

        // Calculamos la nota media global
        double sumaNotas = 0;
        int asignaturasCalificadas = 0;
        for (int i = 0; i < asigs.size(); i++) {
            JsonObject asig = asigs.get(i).getAsJsonObject();
            if (asig.has("nota") && !asig.get("nota").isJsonNull()) {
                try {
                    double nota = asig.get("nota").getAsDouble();
                    if (nota >= 0) {
                        sumaNotas += nota;
                        asignaturasCalificadas++;
                    }
                } catch (Exception e) {}
            }
        }
        String mediaGlobal = asignaturasCalificadas > 0 ? String.format("%.2f", sumaNotas / asignaturasCalificadas) : "—";
    %>

    <nav class="navbar">
        <div class="navbar-marca">
            NOL <span>·</span> Notas Online
        </div>
        <div class="navbar-acciones">
            <span class="chip-rol">Estudiante Identificado</span>
            <a href="<%= request.getContextPath() %>/logout" style="color: white; margin-left: 15px; text-decoration: none; font-size: 14px; font-weight: 600;">Cerrar sesión</a>
        </div>
    </nav>

    <div class="contenedor-principal fade-in">
        
        <a href="<%= request.getContextPath() %>/alumno/asignaturas" class="btn-back" style="text-decoration: none; display: inline-flex;">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
            Volver a mis asignaturas
        </a>
        <header class="perfil-header">
            <div class="perfil-foto-container">
                <img src="https://ui-avatars.com/api/?name=<%= nombre.replace(" ", "+") %>&background=0f3460&color=fff&size=200" alt="Foto de perfil" class="perfil-foto">
                <span class="status-badge">Activo</span>
            </div>
            
            <div class="perfil-info">
			    <h1><%= nombre %></h1>
			    <div class="chip-rol" style="display: inline-block; margin-bottom: 10px; background: #e9f9f4; color: #19a17a; border-color: #20c997;">
			        <strong>DNI:</strong> <%= (dni != null) ? dni : "No identificado" %>
			    </div>
			    <p class="perfil-bio">
			        Estudiante matriculado en el curso académico 2025/2026. 
			        Acceso al sistema de gestión de calificaciones y expediente.
			    </p>
			</div>
	        </header>

        <div class="stats-grid">
            <div class="stat-card">
                <span class="stat-val"><%= mediaGlobal %></span>
                <span class="stat-label">Media Global</span>
            </div>
            <div class="stat-card">
                <span class="stat-val"><%= asigs.size() %></span>
                <span class="stat-label">Asignaturas en curso</span>
            </div>
        </div>

        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 20px;">
            <div>
                <h2 class="seccion-titulo" style="font-size: 22px;">Mis Asignaturas</h2>
                <p class="seccion-subtitulo" style="margin-bottom: 0;">Haz clic en Ver Detalles o Certificado arriba</p>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/alumno/certificado" class="btn-primario" style="text-decoration:none; display: inline-block;padding: 10px 20px; font-size: 14px;"> Ver Certificado</a>
            </div>
        </div>
        
        <div class="asignaturas-grid">
            <%
                for (int i = 0; i < asigs.size(); i++) {
                    JsonObject a = asigs.get(i).getAsJsonObject();
                    String nomAsig = a.has("nombre") ? a.get("nombre").getAsString() : "Desconocida";
                    String acr = a.has("acronimo") ? a.get("acronimo").getAsString() : "";
                    double creditos = a.has("creditos") ? a.get("creditos").getAsDouble() : 0;
                    
                    // Comprobar si está calificada para pintar el puntito gris o azul
                    boolean tieneNota = a.has("nota") && !a.get("nota").isJsonNull();
                    String dotStyle = tieneNota ? "" : "background: var(--text-muted);";
            %>
            <a href="<%= request.getContextPath() %>/alumno/detalle?acr=<%= acr %>" style="text-decoration: none; color: inherit; display: block;">
                <div class="asignatura-item">
                    <div class="dot" style="<%= dotStyle %>"></div>
                    <div>
                        <div style="font-weight: 700; font-size: 14px;"><%= nomAsig %></div>
                        <div style="color: var(--text-muted); font-size: 11px;"><%= acr %> · <%= creditos %> ECTS</div>
                    </div>
                </div>
            </a>
            <% } %>
        </div>
    </div>

</body>
</html>
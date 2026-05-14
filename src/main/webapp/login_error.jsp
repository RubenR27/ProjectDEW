<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Error de acceso</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/estilos.css">
</head>
<body>
    <div class="contenedor-principal fade-in" style="max-width: 500px; text-align: center; min-height: auto;">
        <h2 class="seccion-titulo" style="color: var(--error);">Error de acceso</h2>
        <p class="seccion-subtitulo" style="margin-bottom: 20px;">Credenciales incorrectas o usuario no autorizado.</p>
        <a href="<%= request.getContextPath() %>/index.jsp" class="btn-primario" style="text-decoration: none; display: inline-block;">Volver a intentarlo</a>
    </div>
</body>
</html>
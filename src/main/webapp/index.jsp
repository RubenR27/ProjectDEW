<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NOL — Acceso</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/estilos.css">
</head>
<body>

    <nav class="navbar">
        <div class="navbar-marca">
            NOL <span>·</span> Notas Online
        </div>
        <div class="navbar-acciones">
            <span class="chip-rol">Portal Académico 2026</span>
        </div>
    </nav>

    <div class="contenedor-principal fade-in">
        
        <div class="layout-perfil">
            
            <div>
                <div id="seleccion-rol" style="text-align: center;">
                    <div class="seccion-titulo">Bienvenido al Portal</div>
                    <div class="seccion-subtitulo">Selecciona tu perfil para ingresar</div>

                    <div class="grid-roles" style="margin-top: 20px;">
                        <div class="rol-card" onclick="mostrarLogin('alumno')">
                            <div class="rol-icon-container alumno-bg">
                                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10l-10-5-10 5 10 5 10-5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
                            </div>
                            <div class="asig-nombre">Estudiante</div>
                            <div class="asig-meta">Acceso a notas y progreso</div>
                            <div class="rol-arrow">➔</div>
                        </div>

                        <div class="rol-card" onclick="mostrarLogin('profesor')">
                            <div class="rol-icon-container profesor-bg">
                                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                            </div>
                            <div class="asig-nombre">Docente</div>
                            <div class="asig-meta">Gestión de actas y alumnos</div>
                            <div class="rol-arrow">➔</div>
                        </div>
                    </div>
                </div>

                <div id="seccion-login" style="display: none;">
                    <button class="btn-back" onclick="volverSeleccion()">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                        Regresar
                    </button>

                    <div class="login-box-aesthetic fade-in" style="text-align: center;">
                        <div id="login-header-icon"></div>
                        <h2 id="login-titulo" class="seccion-titulo" style="font-size: 24px;"></h2>
                        <p id="login-subtitulo" class="seccion-subtitulo" style="margin-bottom: 30px;"></p>

                        <form method="post" action="login">
                            <div class="form-group">
                                <label>Documento de Identidad (DNI)</label>
                                <input type="text" name="j_username" class="form-input" placeholder="Ej: 12345678W" required>
                            </div>
                            <div class="form-group">
                                <label>Contraseña</label>
                                <input type="password" name="j_password" class="form-input" placeholder="••••••••" required>
                            </div>
                            <button type="submit" class="btn-primario">Ingresar al portal</button>
                        </form>
                    </div>
                </div>
            </div>

            <aside class="perfil-sidebar">
                <div class="equipo-card">
                    <h3 class="equipo-titulo">Grupo 3</h3>
                    <p class="equipo-subtitulo">Integrantes del Grupo</p>
                    
                    <ul class="lista-integrantes">
                        <li><span class="numero">01</span> Rico Martínez, Rubén</li>
                        <li><span class="numero">02</span> Paredes Ramos, Carmen</li>
                        <li><span class="numero">03</span> Ariza Galán, Ivan</li>
                        <li><span class="numero">04</span> Romero Ferandis, Remei</li>
                        <li><span class="numero">05</span> Miralles Avilés, David</li>
                        <li><span class="numero">06</span> Jornet Botella, Diego</li>
                    </ul>
                </div>
            </aside>

        </div>

    </div>

    <div class="pie-pagina">
        NOL — Sistema de Gestión Académica &copy; 2026
    </div>

    <script src="<%= request.getContextPath() %>/app.js"></script>

</body>
</html>
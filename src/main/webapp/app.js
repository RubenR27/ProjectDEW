function mostrarLogin(rol) {
    const seleccionRol = document.getElementById('seleccion-rol');
    const seccionLogin = document.getElementById('seccion-login');
    const titulo = document.getElementById('login-titulo');
    const subtitulo = document.getElementById('login-subtitulo');
    const headerIcon = document.getElementById('login-header-icon');

    if (rol === 'alumno') {
        titulo.innerText = "Acceso Estudiante";
        subtitulo.innerText = "Consulta tu historial académico y notas.";
        headerIcon.className = "icon-header-small alumno-bg";
        headerIcon.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10l-10-5-10 5 10 5 10-5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>`;
    } else {
        titulo.innerText = "Acceso Docente";
        subtitulo.innerText = "Gestiona tus asignaturas y calificaciones.";
        headerIcon.className = "icon-header-small profesor-bg";
        headerIcon.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>`;
    }

    seleccionRol.style.display = 'none';
    seccionLogin.style.display = 'block';
}

function volverSeleccion() {
    document.getElementById('seleccion-rol').style.display = 'block';
    document.getElementById('seccion-login').style.display = 'none';
}
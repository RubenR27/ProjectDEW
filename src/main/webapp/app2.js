const alumno = {
    nombre: "Pepe García Sánchez",
    dni: "12345678W"
};

const asignaturas = [

    {
        id: 1,
        nombre: "Desarrollo Web",
        acronimo: "DEW",
        nota: 8.4,
        profesor: "Ramón García",
        creditos: 4.5,
        curso: 3,
        cuatrimestre: "B"
    },

    {
        id: 2,
        nombre: "Desarrollo Centrado en el Usuario",
        acronimo: "DCU",
        nota: 5.9,
        profesor: "Pedro Valderas",
        creditos: 4.5,
        curso: 4,
        cuatrimestre: "A"
    },

    {
        id: 3,
        nombre: "Integración de Aplicaciones",
        acronimo: "IAP",
        nota: 6.5,
        profesor: "Manoli Albert",
        creditos: 4.5,
        curso: 4,
        cuatrimestre: "A"
    }
];


function colorNota(nota) {

    if (nota >= 7) return "nota-alta";
    if (nota >= 5) return "nota-media";
    return "nota-baja";
}


function setNavActivo(id) {

    document.querySelectorAll('.btn-nav').forEach(b => b.classList.remove('activo'));

    const btn = document.getElementById(id);
    if (btn) btn.classList.add('activo');
}


function togglePerfil() {

    const dropdown = document.getElementById('perfilDropdown');
    dropdown.classList.toggle('visible');
}


document.addEventListener('click', function(e) {

    const wrapper = document.querySelector('.perfil-wrapper');

    if (wrapper && !wrapper.contains(e.target)) {
        document.getElementById('perfilDropdown').classList.remove('visible');
    }
});


function mostrarAsignaturas() {

    setNavActivo('btn-asig');

    let html = `
        <div class="seccion-titulo">Mis asignaturas</div>
        <div class="seccion-subtitulo">${alumno.nombre} &nbsp;·&nbsp; ${alumno.dni}</div>
    `;

    asignaturas.forEach(asig => {

        html += `

            <div class="asig-card">

                <div>
                    <div class="asig-nombre">${asig.nombre}</div>
                    <div class="asig-meta">
                        ${asig.acronimo} &nbsp;·&nbsp; Curso ${asig.curso} &nbsp;·&nbsp; Cuatrimestre ${asig.cuatrimestre} &nbsp;·&nbsp; ${asig.creditos} ECTS
                    </div>
                </div>

                <div class="asig-derecha">
                    <span class="badge-nota ${colorNota(asig.nota)}">${asig.nota}</span>
                    <button onclick="mostrarDetalles(${asig.id})" class="btn-detalle">
                        Ver detalles
                    </button>
                </div>

            </div>
        `;
    });

    document.getElementById("contenido").innerHTML = html;
}


function mostrarDetalles(id) {

    const asig = asignaturas.find(a => a.id === id);

    if (!asig) return;

    const lorem = `Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.`;

    let html = `

        <button onclick="mostrarAsignaturas()" class="btn-volver">
            ← Volver a mis asignaturas
        </button>

        <div class="seccion-titulo">${asig.nombre}</div>
        <div class="seccion-subtitulo">Detalle de asignatura</div>

        <div class="detalle-grid">

            <div>
                <div class="detalle-avatar">${asig.acronimo}</div>
                <div class="detalle-nota-grande">
                    <span class="nota-numero badge-nota ${colorNota(asig.nota)}">${asig.nota}</span>
                    <span class="nota-label">Calificación</span>
                </div>
            </div>

            <div class="detalle-ficha">

                <div class="ficha-fila">
                    <span class="ficha-label">Asignatura</span>
                    <span class="ficha-valor">${asig.nombre}</span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Acrónimo</span>
                    <span class="ficha-valor">${asig.acronimo}</span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Profesor</span>
                    <span class="ficha-valor">${asig.profesor}</span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Créditos</span>
                    <span class="ficha-valor">${asig.creditos} ECTS</span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Curso</span>
                    <span class="ficha-valor">${asig.curso}º · Cuatrimestre ${asig.cuatrimestre}</span>
                </div>

                <div class="ficha-fila">
                    <span class="ficha-label">Alumno</span>
                    <span class="ficha-valor">${alumno.nombre}</span>
                </div>

                <p class="lorem-text">${lorem}</p>

            </div>

        </div>
    `;

    document.getElementById("contenido").innerHTML = html;
}


function mostrarCertificado() {

    setNavActivo('btn-cert');

    const suma = asignaturas.reduce((total, a) => total + a.nota, 0);
    const media = (suma / asignaturas.length).toFixed(2);

    let filas = "";

    asignaturas.forEach(a => {

        filas += `
            <tr>
                <td>${a.nombre}</td>
                <td>${a.acronimo}</td>
                <td>${a.creditos} ECTS</td>
                <td>
                    <span class="badge-nota ${colorNota(a.nota)}">${a.nota}</span>
                </td>
            </tr>
        `;
    });

    let html = `

        <div class="cert-cabecera">
            <div>
                <div class="seccion-titulo">Certificado académico</div>
                <div class="cert-alumno-info">
                    ${alumno.nombre} &nbsp;·&nbsp; DNI: ${alumno.dni}
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
                ${filas}
            </tbody>

        </table>

        <div class="cert-media-box">
            <span class="cert-media-label">Nota media del expediente</span>
            <span class="cert-media-valor">${media}</span>
        </div>
    `;

    document.getElementById("contenido").innerHTML = html;
}


mostrarAsignaturas();
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


function mostrarAsignaturas() {

    let html = `
        <h2 class="mb-4">Mis asignaturas</h2>
        <p class="text-muted mb-4">
            ${alumno.nombre} — ${alumno.dni}
        </p>
    `;

    asignaturas.forEach(asig => {

        html += `

            <div class="card shadow-sm mb-3">

                <div class="card-body d-flex justify-content-between align-items-center">

                    <div>

                        <h5 class="card-title mb-1">
                            ${asig.nombre}
                            <span class="text-muted" style="font-size:14px;">
                                (${asig.acronimo})
                            </span>
                        </h5>

                        <p class="mb-0 text-muted" style="font-size:14px;">
                            Curso ${asig.curso} · Cuatrimestre ${asig.cuatrimestre} · ${asig.creditos} créditos
                        </p>

                    </div>

                    <div class="d-flex align-items-center gap-3">

                        <span class="${colorNota(asig.nota)}" style="font-weight:bold;">
                            ${asig.nota}
                        </span>

                        <button
                        onclick="mostrarDetalles(${asig.id})"
                        class="btn btn-outline-success btn-sm">

                            Ver detalles

                        </button>

                    </div>

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
    Nulla facilisi. Sed euismod, nisl vel ultricies lacinia,
    nisl nisl aliquam nisl, nec aliquam nisl nisl sit amet nisl.`;

    let html = `

        <button
        onclick="mostrarAsignaturas()"
        class="btn btn-outline-secondary btn-sm mb-4">
            ← Volver
        </button>

        <h2 class="mb-1">${asig.nombre}</h2>
        <p class="text-muted mb-4">${asig.acronimo} · Curso ${asig.curso}</p>

        <div class="row">

            <div class="col-md-4 text-center mb-4">

                <div style="
                    width: 120px;
                    height: 120px;
                    border-radius: 50%;
                    background-color: #d3f9f0;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 40px;
                    margin: 0 auto 15px auto;
                ">
                    📚
                </div>

                <span class="${colorNota(asig.nota)}" style="font-size:28px; font-weight:bold;">
                    ${asig.nota}
                </span>

            </div>

            <div class="col-md-8">

                <div class="card shadow-sm">

                    <div class="card-body">

                        <p><strong>Profesor:</strong> ${asig.profesor}</p>
                        <p><strong>Créditos:</strong> ${asig.creditos} ECTS</p>
                        <p><strong>Cuatrimestre:</strong> ${asig.cuatrimestre}</p>
                        <p><strong>Matriculado en:</strong> ${alumno.nombre}</p>

                        <hr>

                        <p class="text-muted" style="font-size:14px;">
                            ${lorem}
                        </p>

                    </div>

                </div>

            </div>

        </div>
    `;

    document.getElementById("contenido").innerHTML = html;
}


function mostrarCertificado() {

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
                    <span class="${colorNota(a.nota)}">
                        ${a.nota}
                    </span>
                </td>
            </tr>
        `;
    });

    let html = `

        <div class="d-flex justify-content-between align-items-center mb-4">

            <h2 class="mb-0">Certificado académico</h2>

            <button
            onclick="window.print()"
            class="btn btn-outline-success btn-sm">
                🖨 Imprimir
            </button>

        </div>

        <p class="text-muted">
            Alumno: <strong>${alumno.nombre}</strong> — DNI: ${alumno.dni}
        </p>

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

        <div class="cert-media">
            <strong>Nota media:</strong> ${media}
        </div>
    `;

    document.getElementById("contenido").innerHTML = html;
}


mostrarAsignaturas();

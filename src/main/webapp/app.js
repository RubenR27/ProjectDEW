const asignaturas = [

    {
        id: 1,
        nombre: "Desarrollo Web",
        nota: 8.4,
        profesor: "Ramón García",
        creditos: 4.5
    },

    {
        id: 2,
        nombre: "DCU",
        nota: 5.9,
        profesor: "Pedro Valderas",
        creditos: 4.5
    },

    {
        id: 3,
        nombre: "IAP",
        nota: 6.5,
        profesor: "Manoli Albert",
        creditos: 4.5
    }
];




function mostrarAsignaturas(){

    let html = `
        <h2 class="mb-4">
            Mis asignaturas
        </h2>
    `;

    asignaturas.forEach(asig => {

        html += `

            <div class="card shadow-sm mb-3">

                <div class="card-body">

                    <h4 class="card-title">
                        ${asig.nombre}
                    </h4>

                    <p class="card-text">
                        Nota: ${asig.nota}
                    </p>

                    <button
                    onclick="mostrarDetalles(${asig.id})"
                    class="btn btn-primary">

                        Ver detalles

                    </button>

                </div>

            </div>
        `;
    });

    document.getElementById("contenido").innerHTML = html;
}




function mostrarDetalles(id){

    const asignatura =
    asignaturas.find(a => a.id === id);

    let html = `

        <h2>
            ${asignatura.nombre}
        </h2>

        <div class="card mt-4">

            <div class="card-body">

                <p>
                    <strong>Nota:</strong>
                    ${asignatura.nota}
                </p>

                <p>
                    <strong>Profesor:</strong>
                    ${asignatura.profesor}
                </p>

                <p>
                    <strong>Créditos:</strong>
                    ${asignatura.creditos}
                </p>

                <button
                onclick="mostrarAsignaturas()"
                class="btn btn-secondary">

                    Volver

                </button>

            </div>

        </div>
    `;

    document.getElementById("contenido").innerHTML = html;
}




//function mostrarCertificado(){

    //`document.getElementById("contenido").innerHTML = 

        //<h2>
           // Certificado académico
           // <button onclick="imprimir()">Imprimir</button>
        //</h2>
        

        //<p>
            //Tus notas son:
            //<ul>
                //${asignaturas.map(a => `<li>${a.nombre}: ${a.nota}</li>`).join("")}
           // </ul>
        //</p>`
function notaClass(n) {
    return n >= 7 ? "nota-alta" : n >= 5 ? "nota-media" : "nota-baja";
}

function mostrarCertificado() {
    const media = (asignaturas.reduce((s, a) => s + a.nota, 0) / asignaturas.length).toFixed(2);

    let filas = asignaturas.map(a => `
        <tr>
            <td>${a.nombre}</td>
            <td>${a.creditos} ECTS</td>
            <td><strong>${a.nota}</strong></td>
        </tr>
    `).join("");

    document.getElementById("contenido").innerHTML = `
        <h2>Certificado académico
        <button onclick="imprimir()" class="btn btn-success mb-3">Imprimir</button></h2>
        

        <table class="table table-bordered table-striped">
            <thead class="table-success">
                <tr>
                    <th>Asignatura</th>
                    <th>Créditos</th>
                    <th>Nota</th>
                </tr>
            </thead>
            <tbody>${filas}</tbody>
        </table>

        <div class="alert alert-success mt-3">
            <strong>Media:</strong> ${media}
        </div>
    `;
}
function imprimir(){
    window.print();
}


mostrarAsignaturas();

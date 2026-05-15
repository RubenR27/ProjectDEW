#!/bin/bash
BASE="http://localhost:9090/CentroEducativo"
CUCU=cucu

echo "============================================"
echo " Poblando CentroEducativo - nuevos datos"
echo "============================================"


# ── 0. LOGIN como administrador ──────────────────────────────
echo ""
echo "[0] Autenticando como administrador..."
KEY=$(curl -s \
  --data '{"dni":"111111111","password":"654321"}' \
  -X POST \
  -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  "$BASE/login")

if [ -z "$KEY" ]; then
  echo "ERROR: No se pudo obtener la key. ¿Está CentroEducativo arrancado?"
  exit 1
fi
echo "  Key obtenida: $KEY"

if ! grep -q "JSESSIONID" $CUCU; then
  echo "ERROR: No se guardó la cookie de sesión."
  exit 1
fi
echo "  Cookie de sesión guardada correctamente."

# ── 1. AÑADIR PROFESORES ─────────────────────────────────────
echo ""
echo "[1] Añadiendo profesores..."

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"dni":"11223344A","nombre":"Carlos","apellidos":"Martinez Lopez","password":"123456"}' \
  "$BASE/profesores?key=$KEY"
echo -e "\n  → Carlos Martinez Lopez (11223344A)"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"dni":"22334455B","nombre":"Ana","apellidos":"Romero Vidal","password":"123456"}' \
  "$BASE/profesores?key=$KEY"
echo -e "\n  → Ana Romero Vidal (22334455B)"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"dni":"33445566C","nombre":"Luis","apellidos":"Torres Navarro","password":"123456"}' \
  "$BASE/profesores?key=$KEY"
echo -e "\n  → Luis Torres Navarro (33445566C)"

# ── 2. AÑADIR ASIGNATURAS ────────────────────────────────────
echo ""
echo "[2] Añadiendo asignaturas..."

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"acronimo":"ISW","nombre":"Ingenieria del Software","curso":3,"cuatrimestre":"A","creditos":6.0}' \
  "$BASE/asignaturas?key=$KEY"
echo -e "\n  → Ingenieria del Software (ISW)"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"acronimo":"SBD","nombre":"Sistemas de Bases de Datos","curso":2,"cuatrimestre":"B","creditos":4.5}' \
  "$BASE/asignaturas?key=$KEY"
echo -e "\n  → Sistemas de Bases de Datos (SBD)"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"acronimo":"REC","nombre":"Redes de Computadores","curso":3,"cuatrimestre":"A","creditos":4.5}' \
  "$BASE/asignaturas?key=$KEY"
echo -e "\n  → Redes de Computadores (REC)"

# ── 3. AÑADIR ALUMNOS ────────────────────────────────────────
echo ""
echo "[3] Añadiendo alumnos..."

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"dni":"44556677D","nombre":"Sofia","apellidos":"Navarro Gil","password":"123456"}' \
  "$BASE/alumnos?key=$KEY"
echo -e "\n  → Sofia Navarro Gil (44556677D)"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"dni":"55667788E","nombre":"Andres","apellidos":"Castillo Mora","password":"123456"}' \
  "$BASE/alumnos?key=$KEY"
echo -e "\n  → Andres Castillo Mora (55667788E)"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '{"dni":"66778899F","nombre":"Elena","apellidos":"Prieto Santos","password":"123456"}' \
  "$BASE/alumnos?key=$KEY"
echo -e "\n  → Elena Prieto Santos (66778899F)"

# ── 4. ASIGNAR ASIGNATURAS A PROFESORES ──────────────────────
echo ""
echo "[4] Asignando asignaturas a profesores..."

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "ISW" \
  "$BASE/profesores/11223344A/asignaturas?key=$KEY"
echo -e "\n  → Carlos Martinez → ISW"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "SBD" \
  "$BASE/profesores/22334455B/asignaturas?key=$KEY"
echo -e "\n  → Ana Romero → SBD"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "REC" \
  "$BASE/profesores/33445566C/asignaturas?key=$KEY"
echo -e "\n  → Luis Torres → REC"

# ── 5. MATRICULAR ALUMNOS EN ASIGNATURAS ─────────────────────
echo ""
echo "[5] Matriculando alumnos..."

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "44556677D" \
  "$BASE/asignaturas/ISW/alumnos?key=$KEY"
curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "44556677D" \
  "$BASE/asignaturas/SBD/alumnos?key=$KEY"
echo "  → Sofia: ISW, SBD"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "55667788E" \
  "$BASE/asignaturas/ISW/alumnos?key=$KEY"
curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "55667788E" \
  "$BASE/asignaturas/REC/alumnos?key=$KEY"
echo "  → Andres: ISW, REC"

curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "66778899F" \
  "$BASE/asignaturas/SBD/alumnos?key=$KEY"
curl -s -X POST -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data "66778899F" \
  "$BASE/asignaturas/REC/alumnos?key=$KEY"
echo "  → Elena: SBD, REC"

echo ""
echo "============================================"
echo " Hecho. Verifica con:"
echo " curl -s -c $CUCU -b $CUCU \"$BASE/alumnos?key=$KEY\" | python3 -m json.tool"

# ── 6. PONER NOTAS A LOS ALUMNOS ─────────────────────────────
echo ""
echo "[6] Asignando notas a los alumnos..."

# -- Carlos Martinez (11223344A) pone notas en ISW --
echo "  Login como Carlos Martinez (ISW)..."
KEY=$(curl -s \
  --data '{"dni":"11223344A","password":"123456"}' \
  -X POST \
  -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  "$BASE/login")
echo "  Key: $KEY"

curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '8.5' \
  "$BASE/alumnos/44556677D/asignaturas/ISW?key=$KEY"
echo -e "\n  → Sofia en ISW: 8.5"

curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '6.0' \
  "$BASE/alumnos/55667788E/asignaturas/ISW?key=$KEY"
echo -e "\n  → Andres en ISW: 6.0"

# -- Ana Romero (22334455B) pone notas en SBD --
echo "  Login como Ana Romero (SBD)..."
KEY=$(curl -s \
  --data '{"dni":"22334455B","password":"123456"}' \
  -X POST \
  -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  "$BASE/login")
echo "  Key: $KEY"

curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '7.0' \
  "$BASE/alumnos/44556677D/asignaturas/SBD?key=$KEY"
echo -e "\n  → Sofia en SBD: 7.0"

curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '5.5' \
  "$BASE/alumnos/66778899F/asignaturas/SBD?key=$KEY"
echo -e "\n  → Elena en SBD: 5.5"

# -- Luis Torres (33445566C) pone notas en REC --
echo "  Login como Luis Torres (REC)..."
KEY=$(curl -s \
  --data '{"dni":"33445566C","password":"123456"}' \
  -X POST \
  -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  "$BASE/login")
echo "  Key: $KEY"

curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '9.0' \
  "$BASE/alumnos/55667788E/asignaturas/REC?key=$KEY"
echo -e "\n  → Andres en REC: 9.0"

curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '7.5' \
  "$BASE/alumnos/66778899F/asignaturas/REC?key=$KEY"
echo -e "\n  → Elena en REC: 7.5"

echo "============================================"





# -- Ramon Garcia (23456733H) pone notas en DEW --
echo ""
echo "  Login como Ramon Garcia (DEW)..."
KEY=$(curl -s \
  --data '{"dni":"23456733H","password":"123456"}' \
  -X POST \
  -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  "$BASE/login")
echo "  Key: $KEY"
 
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '7.5' \
  "$BASE/alumnos/12345678W/asignaturas/DEW?key=$KEY"
echo -e "\n  → Pepe en DEW: 7.5"
 
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '8.0' \
  "$BASE/alumnos/23456387R/asignaturas/DEW?key=$KEY"
echo -e "\n  → Maria en DEW: 8.0"
 
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '6.5' \
  "$BASE/alumnos/93847525G/asignaturas/DEW?key=$KEY"
echo -e "\n  → Laura en DEW: 6.5"
 
# -- Pedro Valderas (10293756L) pone notas en IAP (Pepe y Miguel) --
echo ""
echo "  Login como Pedro Valderas (IAP y DCU)..."
KEY=$(curl -s \
  --data '{"dni":"10293756L","password":"123456"}' \
  -X POST \
  -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  "$BASE/login")
echo "  Key: $KEY"
 
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '9.0' \
  "$BASE/alumnos/12345678W/asignaturas/IAP?key=$KEY"
echo -e "\n  → Pepe en IAP: 9.0"
 
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '5.5' \
  "$BASE/alumnos/34567891F/asignaturas/IAP?key=$KEY"
echo -e "\n  → Miguel en IAP: 5.5"
 
# -- Pedro Valderas (10293756L) pone notas en DCU (Pepe y Miguel) --
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '8.0' \
  "$BASE/alumnos/12345678W/asignaturas/DCU?key=$KEY"
echo -e "\n  → Pepe en DCU: 8.0"
 
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '6.0' \
  "$BASE/alumnos/34567891F/asignaturas/DCU?key=$KEY"
echo -e "\n  → Miguel en DCU: 6.0"
 
# -- Joan Fons (65748923M) pone nota en IAP (Laura) --
echo ""
echo "  Login como Joan Fons (IAP)..."
KEY=$(curl -s \
  --data '{"dni":"65748923M","password":"123456"}' \
  -X POST \
  -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  "$BASE/login")
echo "  Key: $KEY"
 
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '7.0' \
  "$BASE/alumnos/93847525G/asignaturas/IAP?key=$KEY"
echo -e "\n  → Laura en IAP: 7.0"
 
# -- Manoli Albert (06374291A) pone nota en DCU (Maria) --
echo ""
echo "  Login como Manoli Albert (DCU)..."
KEY=$(curl -s \
  --data '{"dni":"06374291A","password":"123456"}' \
  -X POST \
  -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  "$BASE/login")
echo "  Key: $KEY"
 
curl -s -X PUT -H "content-type: application/json" \
  -c $CUCU -b $CUCU \
  --data '9.5' \
  "$BASE/alumnos/23456387R/asignaturas/DCU?key=$KEY"
echo -e "\n  → Maria en DCU: 9.5"
 
echo ""
echo "============================================"
echo " Notas asignadas correctamente."
echo "============================================"

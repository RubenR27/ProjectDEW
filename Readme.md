# NOL — Sistema de Gestión Académica 🎓

**NOL (Notas Online)** es una aplicación web desarrollada en Java para la gestión de calificaciones y expedientes académicos. Permite a los estudiantes consultar sus notas y a los docentes gestionar las actas de sus asignaturas de forma eficiente y segura.

# GRUPO 3

---

### Integrantes:
* **Ariza Galán, Ivan**
* **Jornet Botella, Diego**
* **Miralles Avilés, David**
* **Paredes Ramos, Carmen**
* **Rico Martínez, Rubén**
* **Romero Ferandis, Remei**
---

## 🚀 Requisitos Previos

Antes de ejecutar la aplicación, asegúrate de tener instalado:

* **Java JDK** (Versión 17 o superior).
* **Apache Tomcat** (Versión 10.1 recomendada).
* **Eclipse IDE** for Enterprise Java and Web Developers.
* **Servidor de Datos:** Tener acceso al script `lanza-centroeducativo.sh` (API REST externa).

---

## 🛠️ Instalación y Configuración

(cambiar)
### 1. Importar el zip del proyecto en eclipse 
Importarlo usando **Existing projects into workspace** y seleccionando el zip

### 2. Configuración de Librerías (JARs)
Asegúrate de que los siguientes archivos estén en `src/main/webapp/WEB-INF/lib` y añadidos al **Java Build Path**:
* `gson-2.10.1.jar`
* `okhttp-4.12.0.jar`
* `okio-jvm-3.6.0.jar`
* `kotlin-stdlib-1.9.10.jar`

### 3. Configuración de Usuarios (Tomcat)
Edita el archivo `tomcat-users.xml` de tu servidor para incluir los roles y usuarios de prueba usando el archivo tomcat-users adjuntado en la tarea:
```xml
<role rolename="rolalu"/>
<role rolename="rolpro"/>
<user username="12345678W" password="[PASSWORD]" roles="rolalu"/>
<user username="[DNI_PROFE]" password="[PASSWORD]" roles="rolpro"/>
```
### 4. Ejecutar el servidor de datos y poblarlo
Lanza el script `lanza-centroeducativo.sh` y una vez este iniciado, que suele tarda 10 segundos como máximo, ahora puedes poblar la base de datos usando el script que se encuentra en nuestro proyecto: [scriptPoblacion.sh](./NOL/scriptPoblacion.sh).

### 5. Logs
Asegurarse de cambiar la ruta de los logs en el web.xml, en esta parte:
```xml
 <context-param>
    <param-name>ruta-logs</param-name>
    <param-value>/home/dew/proyecto/logs/acceso.log</param-value>
  </context-param>
  ```

### 6. Ejecutar el proyecto en el servidor que hemos modificado tomcat-users.xml
Ahora puedes lanzar nuestro proyecto en el servidor deseado, donde hemos modificado el tomcat-users.xml, cuando el servidor este en funcionando, puedes abrir el navegador deseado y entrar a nuestra aplicación en local usando el siguiente enlace: http://localhost:8080/ProjectDEW/ .
Ese enlace funcionaría si tu servidor usa el puerto 8080 al lanzarse, si no lo hace debes de cambiar el 8080 por el puerto en el que lanza la aplicación tu servidor.

### SI DA PROBLEMAS (algunos que he encontrado probando el zip):
Asegurarse de tener en web.xml en la cabecera `metadata-complete="true"`

Si ahora da error 404 al abrir la web, el problema puede ser no tener el servidor correctamente "bounded" en el proyecto.
La solución:
1. Añadir Tomcat al Build Path
Clic derecho sobre el proyecto → Properties → Java Build Path → pestaña Libraries
Verás algo como esto entre las librerías — busca si hay alguna con Unbound o si directamente falta la de Tomcat:
Si no está o aparece con error → Add Library... → Server Runtime → selecciona Apache Tomcat 10.1 → Finish → Apply and Close.

---

## Resumen de interfaces e interraciones
### Inicio de sesión
![alt text](/Readme-img/image.png)
### Asignaturas
![alt text](/Readme-img/image-1.png)
### Detalles asignaturas
![alt text](/Readme-img/image-3.png)
### Certificados
![alt text](/Readme-img/image-2.png)
### Desplegable
![alt text](/Readme-img/image-4.png)
### Perfil alumno
![alt text](/Readme-img/image-5.png)
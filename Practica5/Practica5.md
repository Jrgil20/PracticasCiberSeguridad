# Práctica Nro. 5: Web Application Analysis II & SQL Injection (Análisis de Vulnerabilidades en Servicios Web)

## Datos de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 5 | 24-10-2025|
| Guilarte, Andrés | 30246084 | 5 | 24-10-2025 |

**Nombre de la Práctica:** Web Application Analysis II & SQL Injection
(Análisis de Vulnerabilidades en Servicios Web)

**Grupo:** 4
_______________________________________

## Objetivos de Aprendizaje

Al finalizar este laboratorio, el estudiante será capaz de:

1. Configurar y operar OWASP ZAP como proxy de interceptación para análisis de tráfico HTTP/HTTPS.  
2. Identificar y documentar encabezados de seguridad faltantes en aplicaciones web.  
3. Ejecutar ataques de fuzzing para detectar vulnerabilidades de inyección SQL.  
4. Realizar auditorías de seguridad en servidores web Apache y Payara Server.  
5. Automatizar la explotación de inyecciones SQL utilizando SQLMap.  
6. Enumerar bases de datos y extraer información sensible de forma controlada.  
7. Generar reportes profesionales de pentesting con hallazgos y recomendaciones.  
8. Aplicar principios éticos en pruebas de penetración controladas.

_____________________________________

### Recursos Tecnológicos

- 💻 Kali Linux (actualizado, mínimo 4GB RAM)  
- 💻 Metasploitable 2 (configurado en red NAT o Host-Only)  
- 💻 PentesterLab ISO (configurado y accesible)  
- 🌐 Conexión a Internet para actualizaciones  
- 📦 VirtualBox o VMware con configuración de red adecuada
- 🧰 Herramientas: OWASP ZAP, SQLMap, Burp Suite (opcional), navegadores y utilidades de red

________________________________________

## Software Requerido

### Verificar instalaciones necesarias

```bash
which zaproxy      # OWASP ZAP se utilizará para el análisis de encabezados de seguridad en vez de zapproxy
which sqlmap       # SQLMap
which apache2      # Servidor Apache
```

## MÓDULO 1: Análisis de Encabezados de Seguridad con OWASP ZAP

### Objetivos del Módulo

- Configurar OWASP
- Analizar encabezados HTTP de respuesta
- Identificar deficiencias de seguridad en la configuración del servidor
- Proponer configuraciones de hardening

Los pasos 1 y 3 se realizaron en la práctica anterior; la explicación detallada y las evidencias están en el informe de la Práctica 4. Consulte el informe en GitHub: [Práctica 4 — Informe en GitHub](https://github.com/Jrgil20/PracticasCiberSeguridad/blob/main/Practica4.md/practica4.md)

### Paso 2: Iniciar OWASP ZAP

Se inició OWASP ZAP, la herramienta previamente utilizada para el análisis de vulnerabiliadades en la práctica anterior, con las mismas configuraciones que en la práctica anterior.

Se inició OWASP ZAP como proxy de interceptación para capturar y analizar el tráfico HTTP/HTTPS entre el navegador y DVWA.

![ZAP captura](https://imgur.com/7G5ZwRr)

### Pasos 4 y 5: Navegar a DVWA, Capturar Tráfico y Analizar Encabezados de Respuesta

- Se entró a la página web **DVWA** luego de configurar a OWASP ZAP como proxy en la máquina "Analista", toda su expliación y razón en la práctica anterior, ya que esta será como objetivo de los ataques de la práctica.
- **DVWA** es una aplicación web escrita en **PHP/MySQL**, diseñada especificamente para ser vulnerable lo que la hace una herramienta perfecta para pruebas y prácticas del área de la cibereguridad.
- Se usa la URL ```http://192.168.100.20/dvwa/``` ya que al objetivo no tener una dominio público, como por ejemplo dvwa.com, se debe usar directamente la dirección IP del dispotivo objetivo ya que no se puede usar el servicio de DNS para hacer las traducciones necesarias para realizar la comunicación.
- Se configuró en DVWA la opción de "Low" en el panel de DVWA Security para indicarle a la aplicación que no implemente **casi ninguna medida de seguridad en su código fuente**, esto se hace para adecuar el entorno para la realización de los ataques de la práctica.
- Luego de esta configuración, se usó ZAP para monitorear la comunicación entre el cliente y el servidor. Se abrió la petición `GET http://192.168.100.20/dvwa/login.php` y se inspeccionaron los encabezados de la respuesta. A continuación se muestran: 1) la captura del servicio en el explorador y 2) el historial de peticiones visto desde ZAP (scan). Posterior a las imágenes se presenta la respuesta provista por el servidor.

Captura del servicio en el explorador:
![Servicio en el explorador](https://imgur.com/JBsrGUD)

Historial de peticiones / Scan en ZAP:
![Historial de ZAP / Scan](https://imgur.com/CU9fSVF)

#### Respuesta del servidor

HTTP/1.1 302 Found

Date: Fri, 10 Oct 2025 16:33:15 GMT

Server: Apache/2.2.8 (Ubuntu) DAV/2

X-Powered-By: PHP/5.2.4-2ubuntu5.10

Expires: Thu, 19 Nov 1981 08:52:00 GMT

Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0

Pragma: no-cache

Location: index.php

Content-Length: 0

Keep-Alive: timeout=15, max=97

Connection: Keep-Alive

Content-Type: text/html

### Paso 6: Documentar Encabezados Faltantes

Se procederá a documentar los Headers de seguirdad faltantes en la peticióny se clasificarán dependiendo de su importancia para la protección del objetivo.

| # | Encabezado HTTP | Vulnerabilidad Asociada | Impacto | Severidad |
| :---: | :--- | :--- | :--- | :---: |
| 1 | X-Frame-Options | Clickjacking | Un atacante puede cargar la página en un iframe invisible y engañar al usuario para que realice acciones no deseadas | 🔴 Alta |
| 2 | X-Content-Type-Options | MIME Sniffing | El navegador podría interpretar archivos de forma incorrecta, ejecutando código malicioso | 🟡 Media |
| 3 | Content-Security-Policy | XSS, Inyección de código | Sin CSP, la página puede cargar scripts de cualquier origen, facilitando ataques XSS | 🔴 Alta |
| 4 | Strict-Transport-Security | Man-in-the-Middle | Las conexiones pueden ser interceptadas si no se fuerza HTTPS | 🔴 Alta |
| 5 | X-XSS-Protection | Cross-Site Scripting | Desactiva protecciones del navegador contra XSS reflejado | 🟡 Media |

### Paso 7: Proponer Configuraciones de Hardening

Como se puede observar, las petición realizada es sumamente insegura ya que faltan varios headers de seguridad lo que hace que sea un objetvio sencillo para los atacantes al existir varias vulnerabilidades sin mitigar que pueden ser explotadas mediante el uso de sus correspondientes exploits.

En vista de la situación previamente explicada, es necesario modificar el archivo de configuración del servidor web utilizado, Apache 2, para agregarle la configuración de los Headers faltantes para mitigar las vulnerabilidades asociadas con cada Header faltante. Para ello se realizó lo siguiente:

- Se abrió el archivo de configuración, ubicado en ```/etc/apache2/conf-available/security.conf```, mediante el editor Nano para agregar las configuraciones respectivas.
- Se agregó lo siguiente al archivo de configuración: 

<details>
<summary>Configuración de encabezados de seguridad (resumida)</summary>

```bash
# ============================================
# CONFIGURACIÓN DE ENCABEZADOS DE SEGURIDAD
# ============================================

# 1. Protección contra Clickjacking
# Impide que la página sea cargada en iframes de otros dominios
Header always set X-Frame-Options "SAMEORIGIN"

# 2. Prevención de MIME Sniffing
# Fuerza al navegador a respetar el Content-Type declarado
Header always set X-Content-Type-Options "nosniff"

# 3. Content Security Policy (CSP)
# Define fuentes confiables para cargar recursos
# Esta configuración permite solo recursos del mismo origen
Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; frame-ancestors 'self';"

# 4. HTTP Strict Transport Security (HSTS)
# Fuerza conexiones HTTPS por 1 año (31536000 segundos)
# includeSubDomains: aplica a todos los subdominios
# preload: permite inclusión en listas de precarga de navegadores
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"

# 5. Protección XSS del navegador
# Activa el filtro anti-XSS y bloquea la página si detecta un ataque
Header always set X-XSS-Protection "1; mode=block"

# 6. Referrer Policy
# Controla cuánta información se envía en el encabezado Referer
Header always set Referrer-Policy "strict-origin-when-cross-origin"

# 7. Permissions Policy (anteriormente Feature-Policy)
# Deshabilita APIs potencialmente peligrosas
Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"

# 8. Ocultar información del servidor (reducir fingerprinting)
ServerTokens Prod
ServerSignature Off
Header unset X-Powered-By
```

</details>

- Luego de guardar los cambios en el archivo, se usaron los comandos ```sudo a2enconf security``` y ```sudo apache2ctl configtest``` para habilitar la nueva configuración y para verificar que su sintaxis esté correcta, luego de que el segundo comando mostrará el mnesaje de "OK" se precedió a ejecutar el comando ```sudo systemctl restart apache2``` para reiniciar el servicio de Apache 2 pare que se efectuen los cambios.

### Preguntas de Reflexión - Módulo 1 

- **¿Por qué es importante ocultar la versión del servidor y del lenguaje de programación?**
  - Reduce la fuga de información: evita que un atacante identifique versiones con vulnerabilidades conocidas (CVE) y automatice exploits.
  - Dificulta el reconocimiento automatizado y gana tiempo para la defensa.
  - No sustituye el parcheo y buenas prácticas; es una medida de reducción de información (defensa en profundidad).

- **¿Qué diferencia existe entre `X-Frame-Options: DENY` y `X-Frame-Options: SAMEORIGIN`?**
  - `DENY`: impide que la página sea cargada en un `iframe` desde cualquier origen (incluso el mismo).
  - `SAMEORIGIN`: permite que la página sea embebida sólo por páginas del mismo origen (mismo esquema, host y puerto).
  - Para mayor control y flexibilidad usar `Content-Security-Policy` con la directiva `frame-ancestors`.

- **¿Por qué `'unsafe-inline'` en CSP puede ser problemático?**
  - Permite ejecución de scripts/estilos inline, lo que debilita significativamente la protección contra XSS.
  - Anula las ventajas de nonces/hashes y fomenta prácticas inseguras (event handlers inline, estilos inline).
  - Recomendación: evitar `'unsafe-inline'` y usar scripts externos con nonces o hashes, además de aplicar políticas restrictivas.

## Módulo 2: Fuzzing de Inyección SQL con OWASP ZAP:

### Objetivos del Módulo

- Comprender el funcionamiento del Fuzzer de ZAP.
- Detectar vulnerabilidades de inyección SQL mediante fuzzing.
- Documentar hallazgos de seguridad.

Luego de realizar los pasos del 1 al 4, se ejecutó el fuzzer con el payload `1' OR 1=1 #` se analizó la respuesta y no se obtuvo el resultado esperado. Luego se detectó un error en el punto donde se insertaba el payload, por lo que se cambió la ubicación de la inyección y se colocó directamente en el parámetro `id`. A continuación se muestra el campo que solicita el user id en el fuzzer y la petición GET esperada para la verificación en ZAP.

el user id que pide en fuzzer  
![alt text](https://imgur.com/gqFL7Cd)

Petición GET esperada:

```http
GET http://192.168.100.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit HTTP/1.1
Host: 192.168.100.20
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Connection: keep-alive
Referer: http://192.168.100.20/dvwa/vulnerabilities/sqli/
Cookie: security=low; PHPSESSID=c0262d9d636d93ae8570fa0233afdeaf
Upgrade-Insecure-Requests: 1
```

✔️ Punto de Verificación: En el panel inferior, pestaña "Request", debe aparecer la petición anterior con el payload insertado en el parámetro `id` (por ejemplo `id=1' OR 1=1 #`) para proceder con el análisis de la respuesta.
Lo anterior está mal. En la imagen siguiente se muestra la forma correcta de insertar el payload en el parámetro id.

Qué estuvo mal

- Se ingresó el payload en el lugar equivocado del fuzzer (campo genérico o cuerpo) en vez de en el parámetro de consulta `id`.
- No se verificó si el cliente o la herramienta estaban codificando/filtrando el payload (comillas/espacios escapados).
- No se comprobó que la petición incluyera los parámetros necesarios (por ejemplo `Submit=Submit`) ni las cookies de sesión (`security=low; PHPSESSID=…`).

En la siguiente imagen se muestra correctamente colocado el payload en el parámetro `id`.

### Iniciar el Fuzzer

- Se hizo clic derecho sobre la petición seleccionada.  
- En el menú contextual se seleccionó Attack → Fuzz...  
- Se abrió la ventana "Fuzzer".

💡 Explicación: El Fuzzer de ZAP permite enviar múltiples variaciones de una petición, reemplazando partes específicas con payloads maliciosos. Esto automatiza el proceso de probar diferentes vectores de ataque.

---

### Paso 5: Configurar el Payload de Fuzzing - Primer Intento (Incorrecto)

Después de ejecutar el fuzzer con el payload `1' OR 1=1 #` se analizó la respuesta y no se obtuvo el resultado esperado.

Qué estuvo mal:

- Se ingresó el payload en el lugar equivocado del fuzzer (campo genérico o cuerpo) en vez de en el parámetro de consulta `id`.  
- No se verificó si el cliente o la herramienta estaban codificando/filtrando el payload (comillas/espacios escapados).  
- No se comprobó que la petición incluyera los parámetros necesarios (por ejemplo `Submit=Submit`) ni las cookies de sesión (`security=low; PHPSESSID=…`).

![fuzzer-errorn](https://imgur.com/gqFL7Cd)

Se detectó el error en el punto donde se insertaba el payload y se cambió la ubicación de la inyección.

---

### Paso 5 (Corregido): Configurar el Payload de Fuzzing Correctamente

1. En la ventana del Fuzzer, en el panel "Request", localizar el parámetro `id=1` en la URL.  
2. Seleccionar únicamente el valor `1` (no el parámetro completo `id=1`).  
3. Hacer clic en el botón "Add..." (a la derecha del panel de Request).

⚠️ Importante: Seleccionar solo el valor que se desea reemplazar, no el nombre del parámetro.  
El valor `1` debe aparecer ahora resaltado.

![Fuzzer corregido](https://imgur.com/ql0egtw)

---

### Paso 6: Añadir Payload de Inyección SQL

1. En la ventana "Payloads", hacer clic en "Add...".  
2. Seleccionar el tipo: "Strings".  
3. En el campo "String", ingresar el payload:
  `1' OR 1=1 #`

4. Hacer clic en "Add" y luego en "OK" para cerrar la ventana de payloads.
  Explicación del payload:
    - `1'` → Cierra la comilla de la consulta original.  
    - `OR 1=1` → Condición siempre verdadera.  
    - `#` → Comentario en MySQL que ignora el resto de la consulta.

Consulta original esperada:

```sql
SELECT first_name, surname FROM users WHERE user_id = '1';
```

Consulta inyectada:

```sql
SELECT first_name, surname FROM users WHERE user_id = '1' OR 1=1 #';
```

El `#` comenta la comilla final, evitando errores de sintaxis. La condición `OR 1=1` hace que la cláusula WHERE siempre sea verdadera, devolviendo todos los usuarios.

---

### Paso 7: Ejecutar el Fuzzer

- Verificar que el payload esté configurado correctamente.  
- Hacer clic en "Start Fuzzer".

Resultados esperados en la pestaña de resultados del fuzzing:

- State: Successful  
- Code: 200  
- Reason: OK  
- RTT (ms): ~45  
- Size (bytes): ~2847

En lugar de la imagen, enlace al reporte en HTML publicado: [Reporte del fuzzer (HTML publicado)](https://jrgil20.github.io/PracticasCiberSeguridad/Practica5/paylod3.html) — Abra el enlace en el navegador para ver el informe completo en formato HTML.

---

### Paso 8: Analizar la Respuesta del Fuzzing

- En la ventana de resultados del Fuzzer, hacer clic en la petición ejecutada.  
- En el panel inferior, seleccionar la pestaña "Response".  
- Cambiar a la sub-pestaña "Body" para ver el contenido HTML de la respuesta.

En lugar de la imagen, enlace al reporte en HTML publicado: [Reporte del fuzzer (HTML publicado)](https://jrgil20.github.io/PracticasCiberSeguridad/Practica5/paylod4.html) — Abra el enlace en el navegador para ver el informe completo en formato HTML.

Resultado Obtenido (Inyección Exitosa):

- ID: `1' OR 1=1 #` — First name: admin — Surname: admin  
- ID: `1' OR 1=1 #` — First name: Gordon — Surname: Brown  
- ID: `1' OR 1=1 #` — First name: Hack — Surname: Me  
- ID: `1' OR 1=1 #` — First name: Pablo — Surname: Picasso  
- ID: `1' OR 1=1 #` — First name: Bob — Surname: Smith

✅ Confirmación de Vulnerabilidad: La aplicación devolvió TODOS los usuarios de la base de datos en lugar de solo el usuario con ID 1, confirmando que es vulnerable a inyección SQL.

---

### Paso 9: Comparar Respuestas

| Aspecto | Petición Legítima (id=1) | Petición Inyectada (id=1' OR 1=1 #) |
| :--- | :---: | :---: |
| Código HTTP | 200 OK | 200 OK |
| Usuarios devueltos | 1 (admin) | 5 (todos los usuarios) |
| Tamaño de respuesta | ~850 bytes | ~2847 bytes |
| Tiempo de respuesta | ~30 ms | ~45 ms |
| Indicador de vulnerabilidad | ❌ Normal | ✅ VULNERABLE |

Análisis:

- El aumento significativo en el tamaño de la respuesta y la devolución de múltiples usuarios confirman que:
  - La aplicación es vulnerable a inyección SQL.  
  - No existe validación de entrada en el parámetro `id`.  
  - No se utilizan consultas preparadas (prepared statements).  
  - Es posible manipular la lógica de la consulta SQL subyacente.

---

### Explicación Técnica del Payload

Consulta original:

```sql
SELECT first_name, surname FROM users WHERE user_id = '1';
```

Consulta con payload `1' OR 1=1 #`:

```sql
SELECT first_name, surname FROM users WHERE user_id = '1' OR 1=1 #';
```

Desglose:

- `1'` → Cierra la comilla original.  
- `OR 1=1` → Bypass lógico.  
- `#` → Comentario en MySQL que ignora la comilla sobrante.

---

### Payloads Adicionales Probados

| # | Payload | Objetivo | Resultado Obtenido | Estado |
| :---: | :--- | :--- | :--- | :---: |
| 1 | `1' OR '1'='1` | Bypass de autenticación | Devuelve todos los usuarios | ✅ Exitoso |
| 2 | `1' UNION SELECT null, version() #` | Obtener versión de MySQL | Muestra: 5.0.51a-3ubuntu5 | ✅ Exitoso |
| 3 | `1' UNION SELECT null, database() #` | Obtener nombre de la BD | Muestra: dvwa | ✅ Exitoso |
| 4 | `1' UNION SELECT null, user() #` | Obtener usuario de BD | Muestra: root@localhost | ✅ Exitoso |
| 5 | `1' UNION SELECT table_name, null FROM information_schema.tables WHERE table_schema='dvwa' #` | Enumerar tablas | Lista: guestbook, users | ✅ Exitoso |

Análisis de Impacto:

- Reconocimiento completo de la infraestructura de base de datos.  
- Identificación de la versión de MySQL (posibles exploits específicos).  
- Enumeración de tablas (objetivo: tabla `users`).  
- Bypass total de autenticación y controles de acceso.

### Preguntas de Reflexión - Módulo 2 

- **¿Por qué el payload `1' OR 1=1 #` devuelve todos los usuarios en lugar de generar un error?**
  - El payload cierra la literal de cadena (`'`), inyecta una condición lógica siempre verdadera (`OR 1=1`) y usa `#` para comentar el resto de la consulta. El parser SQL recibe una sentencia sintácticamente válida cuya cláusula `WHERE` se reduce a una expresión que siempre evalúa `true`, por lo que el optimizador/ejecutor devuelve todas las filas que cumplen la consulta. Técnicamente: si la consulta original es `WHERE user_id = '1'` entonces tras la inyección la expresión queda `WHERE user_id = '1' OR 1=1 --` y el plan de ejecución ya no filtra por `user_id`. Nota: el comportamiento exacto depende del contexto (si el parámetro era numérico sin comillas, codificación/escaping por la librería cliente, o si el framework usa ORM/prepared statements) — en esos casos el payload podría producir error o ser neutralizado.

- **¿Qué diferencia existe entre el comentario `#` y `--` en inyecciones SQL?**
  - `#` y `--` son comentarios de una sola línea en muchos SGBD; sin embargo `--` es la forma definida por el estándar SQL y suele requerir un espacio o control después (`-- `) en implementaciones como MySQL/Oracle; MySQL admite `#` sin condiciones adicionales. Además existen comentarios de bloque `/* ... */`. Importante: el soporte varía por motor (p.ej. SQL Server acepta `--`, Oracle no reconoce `#` como comentario), y algunos conectores o filtros pueden normalizar/strippear comentarios, por lo que el payload debe adaptarse al dialecto objetivo para que el comentario efectivamente elimine el resto de la consulta y evite errores de sintaxis.

- **¿Cómo podría un atacante usar esta vulnerabilidad para obtener contraseñas de usuarios?**
  - Métodos:
    - Directos:
      - Usar `UNION SELECT` para leer columnas de la tabla `users` (p. ej. `username`, `password_hash`).
      - Consultar `information_schema` (`tables`, `columns`) para localizar tablas/columnas sensibles.
      - Volcar tablas completas si la consulta y permisos lo permiten.
    - Ciegos:
      - Boolean-based: realizar consultas `TRUE`/`FALSE` con funciones como `SUBSTRING()`/`ORD()` para extraer caracteres uno a uno.
      - Time-based: usar `SLEEP()` o funciones equivalentes para inferir bits/caracteres por el tiempo de respuesta.
    - Basados en errores y funciones especiales:
      - Error-based: provocar funciones que devuelvan errores con contenido útil.
      - `LOAD_FILE()` / `INTO OUTFILE`: leer o escribir ficheros si el servidor y permisos lo permiten.
      - UDFs o stacked queries (cuando el motor lo permita) para ejecutar código a nivel OS.
    - Post-extracción:
      - Crackear hashes offline (hashcat/john) teniendo en cuenta algoritmo, salt y rounds.
      - Pivotar con credenciales obtenidas para escalar privilegios en la BD o servidor.
    - Mitigaciones:
      - Prepared statements / consultas parametrizadas.
      - Principio de menor privilegio en cuentas BD y restricción de funciones peligrosas.
      - Validación y saneamiento estricto de entradas, logging y detección de anomalías.

- **¿Por qué es importante el tamaño de la respuesta al analizar resultados de fuzzing?**
  - La longitud del body es un "oracle" rápido: cambios significativos suelen correlacionarse con distinto número de filas devueltas, inclusión de errores o payload reflejado, lo que permite detectar anomalías a gran escala durante fuzzing automatizado. Técnicamente, usar tamaño junto a código HTTP, cabeceras y RTT mejora la fiabilidad.
  - Limitaciones: contenido dinámico (tokens, timestamps), compresión, chunking, sesiones y paginación pueden producir falsos positivos/negativos; por eso se recomienda normalizar respuestas (eliminar partes volátiles), establecer umbrales estadísticos, y combinar análisis de tamaño con firmas en el body, hashing diferenciado y pruebas confirmatorias (manuales o payloads de extracción) antes de reportar una vulnerabilidad.
  
## Módulo 3: Pentesting de Apache en Kali Linux 

### Objetivos del Módulo

- Instalar y configurar Apache2 en Kali Linux 
- Realizar un escaneo de seguridad automatizado con ZAP 
- Generar reportes profesionales en formato HTML 
- Analizar y priorizar vulnerabilidades encontradas 

### Paso 1: Instalación de Apache 2 

Se ejecutaron los comandos mostrados para realizar la instalacion del servidor web Apache en la máquina "Analista".

``` bash
# Actualizar repositorios 
sudo apt update 
# Instalar Apache2 
sudo apt install apache2 -y 
# Verificar instalación 
apache2 -v 
```

Se utiliza ```sudo apt update``` para actualizar la lista local de paquetes disponibles, asegurando que el sistema conozca las últimas versiones del software en los repositorios, luego ```sudo apt install apache2 -y``` descarga e instala el paquete del servidor web (junto con todas sus dependencias), donde -y omite la necesidad de confirmación manual, y finalmente, ```apache2 -v``` se ejecuta para verificar que la instalación haya sido exitosa al mostrar la versión del servidor recién instalado.

### Pasos 2 y 3: Iniciar y Verificar Apache y Acceder al Sitio Web de Prueba 

Se ejecutaron los comandos mostrados para iniciar y verificar el inicio exitoso de Apache2 en la máquina "Analista".

``` bash
# Iniciar el servicio Apache 
sudo systemctl start apache2 
# Verificar el estado 
sudo systemctl status apache2 
# Habilitar inicio automático (opcional) 
sudo systemctl enable apache2 
```

Estos comandos operan a través de la utilidad systemctl con privilegios de superusuario (```sudo```) para interactuar con el sistema de inicialización y gestión de servicios systemd. Específicamente, ```sudo systemctl start apache2``` inicia la unidad de servicio apache2, activando el demonio del servidor web; a continuación, ```sudo systemctl status apache2``` es fundamental para la verificación operativa, ya que consulta a systemd para obtener el estado actual del servicio, confirmando si está en estado ```active (running)``` o si ha fallado; finalmente, ```sudo systemctl enable apache2``` configura el servicio para persistir después de los reinicios del sistema, creando los enlaces simbólicos necesarios que aseguran que apache2 se inicie automáticamente durante el proceso de arranque.

Se anexa el html de inicio por defecto de Apache luego de iniciar su servicio en la máquina analista como evidencia del correcto inicio de apache [Página de inicio de Apache (HTML publicado)](https://jrgil20.github.io/PracticasCiberSeguridad/Practica5/Apache2_Debian_Default_Page_It_works.html), se debe mencionar que antes de acceder a la página de prueba se tuvo que desactivar el proxy para poder garantizar el correcto funcionamiento de Apache ya que en caso contrario ocurrirían los sigueinntes incovenientes:

- **Conflicto de Escucha de Puertos**
  - Apache está configurado por defecto para escuchar y servir la página de prueba en el puerto HTTP estándar (80).
  - El navegador, al tener el proxy activado, envía toda la solicitud (incluyendo la de http://localhost/) al puerto del proxy (8080), no directamente al puerto 80 de Apache.

- **Interrupción del Flujo Directo**
  - La prueba requiere una conexión directa y sin intermediarios del navegador (Cliente) a Apache (Servidor Web) para confirmar que el servicio apache2 está en ejecución y sirviendo archivos correctamente en su puerto predeterminado (80).
  - El proxy actúa como un hombre en el medio (Man-in-the-Middle). En lugar de hablar con Apache, el navegador solo habla con ZAP. ZAP no está diseñado para actuar como el servidor web de Apache, sino para interceptar y analizar el tráfico web, lo que interrumpe la prueba de funcionalidad básica.

- **Garantía de Verificación Pura**
  - Desactivar el proxy elimina una variable externa de seguridad o análisis (ZAP) que podría estar modificando, ralentizando o bloqueando la respuesta de Apache, asegurando que cualquier error durante la prueba se deba exclusivamente a un problema en la instalación de Apache, y no a la configuración del proxy.

### Pasos 4, 5, 6 y 7: Identificar la Dirección IP de Kali, Configurar Escaneo Automatizado en ZAP, Monitorear el Progreso del Escaneo y Analizar Alertas de Seguridad

Se identificó la IP de la máquina "Analista" ya es crucial obtener la dirección IP correcta de la máquina objetivo antes de iniciar cualquier escaneo, se obvtuvo mediaante el uso del comando`ip addr show` permite identificar la interfaz y la IP asignada a la máquina, es recomendable hacer pruebas de conexión luego de obtener la IP para garantizar la correcta conexión de la máquina hacia la red.

Se configuró el escaneo automatizado en OWASP ZAP indicando la URL objetivo en formato completo (`http://192.168.100.27`) y restringiendo el scope al host objetivo para limitar la superficie de prueba. Se seleccionó la araña tradicional para el descubrimiento de rutas estáticas y se habilitó la ajax spider cuando fue necesario para contenido dinámico.

Durante la ejecución se monitorearon en tiempo real las pestañas Spider, Active Scan y Alerts de ZAP, y se registraron métricas operativas relevantes (códigos HTTP, RTT, tasa de peticiones y errores 4xx/5xx).

Al concluir el escaneo se exportaron los resultados y se generó evidencia reproducible: para cada hallazgo se documentaron URL, método, request/response completos, payloads utilizados y capturas asociadas.

![ZAP scan captura](https://imgur.com/z6PWzSN)

### Pasos 8 y 9: Documentar Vulnerabilidades Encontradas y Generar Reporte HTML

Se encontraron las siguientes vulnerabilidades luego de haber finalizado el escaneo realizado a la IP `192.168.100.27` correespondiente a la máquina "Analista", de igual forma se realizó la exportación del informe en formato HTML que las contiene y su correspondiente se puede encontrar en el siguiente enlace [Reporte de Alertas de Seguridad del 1er escaneo (HTML publicado)](https://jrgil20.github.io/PracticasCiberSeguridad/Practica5/Andres_Guilarte_Jesus_Gil.html).

| Alerta | Riesgo | Confianza | Ocurrencias | URL / Recurso | Evidencia |
|---|---:|---:|---:|---|---|
| CSP: Failure to define directive with no fallback (form-action) | Medium | High | 1 | http://localhost | Header: `Content-Security-Policy: ...` falta `form-action` (directiva sin fallback). |
| CSP: `script-src 'unsafe-inline'` | Medium | High | 1 | http://localhost | Header: `Content-Security-Policy: ... script-src 'self' 'unsafe-inline'; ...` |
| CSP: `style-src 'unsafe-inline'` | Medium | High | 1 | http://localhost | Header: `Content-Security-Policy: ... style-src 'self' 'unsafe-inline'; ...` |
| Hidden File Found — server-status expuesto | Medium | High | 1 | http://localhost/server-status | GET `/server-status` → HTTP/200 con información de servidor (ej. versión Apache en body/headers). |

### Pasos 10 y 11: Aplicar Hardening a Apache, Re-escanear y Comparar Resultados

En vista de las vulnerabilidades identificadcas en el escaneo, es necesario reforzar la seguridad de Apache por lo que se ejectuó el comando `sudo nano /etc/apache2/conf-available/security.conf` para abrir el archivo de configuración de seguridad de Apache con el editor Nano para incorporar lo siguiente con el fin de mitigar las vulnerabilidades.

<details>

<summary>Configuración de hardening completa</summary>

```bash
# ============================================ 
# HARDENING DE APACHE2 
# ============================================ 
# Ocultar versión del servidor 
ServerTokens Prod 
ServerSignature Off 
# Deshabilitar listado de directorios 
<Directory /var/www/html> 
Options -Indexes 
AllowOverride None 
Require all granted 
</Directory> 
# Encabezados de seguridad 
<IfModule mod_headers.c> 
Header always set X-Frame-Options "SAMEORIGIN" 
Header always set X-Content-Type-Options "nosniff" 
Header always set X-XSS-Protection "1; mode=block" 
Header always set Referrer-Policy "strict-origin-when-cross-origin" 
Header always set Permissions-Policy "geolocation=(), microphone=(), 
camera=()" 
# Content Security Policy 
Header always set Content-Security-Policy "default-src 'self'; script-src 'self'; 
style-src 'self' 'unsafe-inline';" 
# HSTS (solo si usa HTTPS) 
# Header always set Strict-Transport-Security 
"max-age=31536000; 
includeSubDomains" 
</IfModule> 
# Deshabilitar métodos HTTP innecesarios 
<Directory /> 
<LimitExcept GET POST HEAD> 
deny from all 
</LimitExcept> 
</Directory> 
# Protección contra ataques de fuerza bruta 
<IfModule mod_evasive20.c> 
DOSHashTableSize 3097 
DOSPageCount 2 
DOSSiteCount 50 
DOSPageInterval 1 
DOSSiteInterval 1 
DOSBlockingPeriod 10 
</IfModule> 
# Timeout de conexión 
Timeout 60 
KeepAlive On 
MaxKeepAliveRequests 100 
KeepAliveTimeout 5
```

</details>

- Luego de guardar los cambios en el archivo, se ejecutaron los comandos que se muestran a conitnuación para aplicar los cambios en la configuración de seguridad.

``` bash
# Habilitar módulo de headers 
sudo a2enmod headers 
# Habilitar configuración de seguridad 
sudo a2enconf security 
# Verificar sintaxis 
sudo apache2ctl configtest 
# Reiniciar Apache 
sudo systemctl restart apache2 
```
Estos comandos representan pasos cruciales para mejorar la seguridad y funcionalidad de un servidor Apache. Se utiliza `sudo a2enmod headers` para habilitar el módulo **mod_headers**, que es esencial para manipular las cabeceras HTTP de las respuestas, permitiendo añadir o modificar elementos de seguridad críticos (como Content-Security-Policy o X-Frame-Options). Luego, `sudo a2enconf security` activa un archivo de configuración predefinido (generalmente llamado security.conf) que contiene **directivas de seguridad recomendadas** para mitigar vulnerabilidades comunes. Después de realizar estos cambios, `sudo apache2ctl configtest` verifica la sintaxis de todos los archivos de configuración de Apache para garantizar que no haya errores que impidan el inicio del servicio. Finalmente, `sudo systemctl restart apache2` aplica estos nuevos módulos y configuraciones, deteniendo y volviendo a iniciar el servicio Apache para que los cambios surtan efecto.

Luego de este proceso, se realizó nuevamente el escaneo y ahora se presenta una tabla comparativa entre las alertas de cada tabla.

| Alerta | Presente en Andres_Guilarte_Jesus_Gil.html | Presente en reporte_apache_hardened.html | Evidencia / Observaciones |
|---|:---:|:---:|---|
| CSP: Falta de directiva sin fallback (form-action) | Sí | Sí | Header `Content-Security-Policy` no define `form-action`. Fragmento: `Content-Security-Policy: default-src 'self'; ...` |
| CSP: `script-src 'unsafe-inline'` | Sí | Sí | Header incluye `script-src 'self' 'unsafe-inline'`. Esto permite ejecución de scripts inline. |
| CSP: `style-src 'unsafe-inline'` | Sí | Sí | Header incluye `style-src 'self' 'unsafe-inline'`. Esto permite estilos inline que reducen la eficacia de CSP. |
| Hidden File Found — `/server-status` expuesto | Sí | Sí | `GET /server-status` → HTTP/200 con información del servidor (cabeceras/body muestran versión Apache/estado). |

Como se puede observar, no se lograron mitigar las vulnerabiliaddes luego de aplicar los cambios en el archivo de confugración de seguridad lo cual se puede deber a alguna de las siguientes razones:

- Configuración no recargada o con errores  
  - Explicación: los archivos modificados no fueron aplicados porque Apache no se reinició/reconfiguró correctamente o hay errores de sintaxis.  
  - Verificación: `sudo apache2ctl configtest` y `sudo systemctl status apache2`; revisar `/var/log/apache2/error.log`.

- Archivo editado distinto al que atiende el servidor  
  - Explicación: se cambió un fichero que no es el realmente cargado (p. ej. conf-available vs sites-enabled), por lo que la configuración activa no cambió.  
  - Verificación: `apache2ctl -S`, `ls -l /etc/apache2/sites-enabled/ /etc/apache2/conf-enabled/`.

- Módulo requerido no habilitado (p. ej. mod_headers)  
  - Explicación: directivas `Header` u otras no tienen efecto si el módulo correspondiente no está activo.  
  - Verificación: `apache2ctl -M | grep headers` (debe aparecer `headers_module`).

- Cabeceras sobreescritas por la aplicación o middleware  
  - Explicación: código de la aplicación (ej. `header()` en PHP), un proxy inverso o CDN puede alterar o restablecer cabeceras tras Apache.  
  - Verificación: solicitar directamente a Apache `curl -I --no-keepalive http://<IP>/` desde la máquina analista y comparar con peticiones pasando por el proxy.

- Intermediario (proxy/WAF/ZAP) alterando respuestas  
  - Explicación: un proxy o herramienta de análisis puede inyectar, quitar o mostrar cabeceras distintas a las reales del servidor.  
  - Verificación: repetir `curl -I` desactivando el proxy; revisar configuración de ZAP/balancer/CDN.

- Política aplicada aún contiene directivas inseguras o incompletas  
  - Explicación: la CSP configurada todavía incluye `'unsafe-inline'` o no define directivas obligatorias (ej. `form-action`), por lo que el scanner sigue reportando alertas.  
  - Verificación: `curl -I http://<IP>` y revisar exactamente el valor de `Content-Security-Policy`.

- `mod_status` expone `/server-status` sin restricciones  
  - Explicación: mod_status sigue habilitado y accesible públicamente, mostrando información del servidor incluso si se ocultaron otros datos.  
  - Verificación: `curl -I http://<IP>/server-status` y revisar `/etc/apache2/mods-enabled/status.conf`.

- Caché o CDN mostrando versión antigua  
  - Explicación: respuestas en cache (local o intermedias) pueden devolver cabeceras antiguas tras cambios de configuración.  
  - Verificación: limpiar/invalidar cache, usar `curl -H 'Cache-Control: no-cache' -I http://<IP>/`.

- Permisos o alcance insuficiente de la cuenta que hace los cambios  
  - Explicación: edición realizada por un usuario sin privilegios puede no haber sobrescrito la configuración real.  
  - Verificación: comprobar owner/permiso de los ficheros modificados (`ls -l`) y que se reinició Apache con permisos root.

- Error en el orden de carga de ficheros (sobrescritura por conf posterior)  
  - Explicación: una directiva aplicada en un fichero puede ser sobrescrita por otra cargada después (orden en `conf-enabled`/`sites-enabled`).  
  - Verificación: inspeccionar el orden y contenido de `/etc/apache2/conf-enabled/` y `/etc/apache2/sites-enabled/`.

### Preguntas de Reflexión - Módulo 3

1.**¿Por qué es importante deshabilitar el listado de directorios en Apache?**  
    El Directory Listing expone la estructura de ficheros y recursos (backups, scripts, uploads, etc.), facilitando la enumeración y localización de activos sensibles y aumentando la superficie de ataque. Ejemplo de configuración: `Options -Indexes`.

2.**¿Qué diferencia existe entre `ServerTokens Prod` y `ServerTokens Full`?**  
    - `ServerTokens Full`: la cabecera `Server` incluye detalles (versión de Apache, módulos, SO), lo que facilita el fingerprinting y la búsqueda de CVE.  
    - `ServerTokens Prod`: minimiza la cabecera a un identificador genérico (por ejemplo `Server: Apache`), reduciendo la fuga de información. Complementar con `ServerSignature Off` para ocultar información en páginas de error.

3.**¿Por qué no se recomienda habilitar HSTS en un servidor HTTP puro (sin HTTPS)?**  
    HSTS solo tiene efecto sobre HTTPS; en HTTP es ignorado por navegadores. Activarlo sin HTTPS es inútil y puede ser peligroso (riesgo al usar preload). Habilitar HSTS solo cuando todo el sitio responde correctamente por HTTPS con certificados válidos y tras pruebas completas.

4.**¿Qué otros módulos de Apache podrían mejorar la seguridad del servidor?**  
    - `mod_ssl` — TLS/HTTPS.  
    - `mod_headers` — gestión de cabeceras de seguridad (CSP, HSTS, X-Frame-Options, X-Content-Type-Options).  
    - `mod_security` + OWASP CRS — WAF para detección/bloqueo de payloads.  
    - `mod_reqtimeout`, `mod_evasive`, `mod_qos` — mitigación de DoS/Slowloris y control de tasas.  
    - `mod_authz_core`, `mod_auth_basic` — control de acceso y autenticación.  
    - `mod_remoteip` — obtener IP real detrás de proxies para logging y reglas.  
    Recomendación general: deshabilitar módulos innecesarios, restringir `mod_status` y aplicar principio de mínimo privilegio.

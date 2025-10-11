# Práctica Nro. 3: Análisis de Vulnerabilidades

## Análisis y Detección de Vulnerabilidades en Sistemas Web y Servicios de Red

---

## OBJETIVOS

- Identificar y clasificar al menos 10 vulnerabilidades diferentes utilizando herramientas automatizadas de escaneo.
- Diferenciar entre escáneres de capa de red y capa de aplicación, justificando cuándo usar cada uno.
- Correlacionar vulnerabilidades detectadas con entradas CVE y evaluar su criticidad usando CVSS.
- Analizar resultados de escaneo y proponer contramedidas específicas basadas en mejores prácticas.
- Documentar hallazgos de seguridad en formato profesional siguiendo estándares de la industria.

---

## Datos de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 3 | 10-10-2025|
| Guilarte, Andrés | 30246084 | 3 | 10-10-2025 |

**Nombre de la Práctica:** Análisis de Vulnerabilidades  
**Grupo:** 4

---

## Configuración del Laboratorio

| Elemento | Valor |
| :--- | :--- |
| Direccionamiento IP / Máscara (ejemplo) | 192.168.56.0/24 |
| Equipo origen / fuente | Kali Linux |
| Equipo objetivo / destino | Metasploitable 2 |
| Otros equipos involucrados | Host de gestión, repositorio de evidencias |

<!-- 
🔴 COMENTARIO 1: FALTA AGREGAR AQUÍ LA IP ESPECÍFICA DE KALI Y METASPLOITABLE
Según el documento original, aquí debes incluir:
- IP específica de Kali Linux (equipo origen/fuente)
- IP específica de Metasploitable 2 (equipo objetivo/destino)
Ejemplo: 
- Kali Linux: 192.168.56.101
- Metasploitable 2: 192.168.56.102
-->

Antes de empezar con la realización de las actividades de la práctica se modificarán las configuraciones del adaptor de red usado por las dos máquinas virtuales para conectarlas a una red interna denomindada "lab_vulnerabilidades" para simlar el entorno empresarial especificado más adelante en el apartado de escenario y contexto del presente reporte. 

<!-- 
🔴 COMENTARIO 2: AGREGAR JUSTIFICACIÓN TÉCNICA DE "RED INTERNA"
El documento original explica el "¿Por qué Red Interna?":
- Aísla completamente el tráfico de tu red física
- Previene escaneos accidentales a sistemas reales
- Simula un entorno corporativo controlado

Agrega este texto después del párrafo anterior.
-->

Como se puede observar en las capturas correspondientes a la configutación de los respectivos adptadroes de red se está activando el modo promiscuo con la opción de permitir todo, el modo promiscuo es una configuración especial que permite que el adaptador capture y pase a la capa superior (como el sistema operativo o un programa analizador) todo el tráfico que circula por la red compartida a la que está conectado, sin importar si los paquetes están dirigidos a su propia dirección MAC o no.

<img width="679" height="527" alt="image" src="https://gist.github.com/user-attachments/assets/38d59ac5-2d6e-45b0-ac79-4224475f947b" />
<img width="684" height="524" alt="image" src="https://gist.github.com/user-attachments/assets/d1fe7996-29d8-4e24-a540-ddaa8f6cbbeb" />

**Verificación de Conectividad**

Luego de configurar los adaptadores de red en ambas VMs se procede a ejecutar los comandos ip addr show en la máquina Kali("Analista") y el comanndo ifconfig en la máquina Metasploitable 2("Obejeitvo") para poder saber cuales son las IP asignadas a los adpatores de red que serán utilizadas mas adeleante en los comandos necesarios para realizar la práctica

En Kali Linux:
> Obtén tu dirección IP
ip addr show
<img width="633" height="620" alt="image" src="https://gist.github.com/user-attachments/assets/53422336-6ef6-4b69-85bc-92736fb2477d" />

<!-- 
🔴 COMENTARIO 3: ESPECIFICAR LA IP OBTENIDA
Después de la imagen, agrega un texto que diga:
"Como se observa en la captura, la dirección IP asignada a Kali Linux es: **[IP_OBTENIDA]**"
-->

En Metasploitable 2:

<img width="723" height="470" alt="image" src="https://gist.github.com/user-attachments/assets/6c6c6538-d482-4032-9251-4dbe4c2e9b59" />

<!-- 
🔴 COMENTARIO 4: ESPECIFICAR LA IP OBTENIDA
Después de la imagen, agrega:
"La dirección IP asignada a Metasploitable 2 es: **[IP_OBTENIDA]**"
-->

Luego de obtener las direcciones IPs se realiza un ping desde la máquina analista para comprobar la conexión entre ellas en la red interna "lab_vulnerabilidades", teniendo como resultado la confirmación de la conexión evidenciada en los resultados del ping ya que se enviaron 4 paquetes y se tuvo respuesta de los 4.

> ping
<img width="631" height="516" alt="image" src="https://gist.github.com/user-attachments/assets/23afa9ae-a280-4333-ba77-2f3468d32d54" />

<!-- 
🔴 COMENTARIO 5: AGREGAR INTERPRETACIÓN DE RESULTADOS DEL PING
Después de la imagen, incluye:
"Los resultados muestran:
- 4 paquetes transmitidos, 4 recibidos (0% pérdida)
- Tiempo promedio de respuesta: [X] ms
- Esto confirma conectividad completa entre ambos equipos"
-->

El último paso de la preparación para la realización de los comandos es verificar las versiones de las herramientas principales a utilizar en la realización de la práctica, en este caso siendo nikto y nmap, posteriormente se actualizó la versión de nmap mediante la ejecución de comando nmap --script-updatedb.

<img width="632" height="346" alt="image" src="https://gist.github.com/user-attachments/assets/b41e1167-c512-4537-9be0-7dfb4b466f58" />

<!-- 
🔴 COMENTARIO 6: ESPECIFICAR VERSIONES DETECTADAS
Después de la imagen, agrega:
"Versiones detectadas:
- Nikto: [versión]
- Nmap: [versión]
- Scripts NSE actualizados: [fecha/número]"
-->

---

## Requisitos

- Kali Linux (plataforma de pentesting).
- Metasploitable 2 (objetivo vulnerable controlado).
- Nikto (escáner de vulnerabilidades web).
- Nmap con NSE scripts (detección de servicios y correlación con CVEs).
- Acceso a bases de datos CVE / NVD para verificación de vulnerabilidades.

---

## Escenario y Contexto

<!-- 
🔴 COMENTARIO 7: EL DOCUMENTO ORIGINAL INCLUYE UN MARCO NARRATIVO COMPLETO
Falta agregar aquí el texto completo del escenario:
"Título del caso: 'El Incidente de SecureTech Solutions'"

Y la cita textual del CISO:
"Hola, necesitamos que evalúes la postura de seguridad de nuestros servidores de desarrollo antes de que lancemos nuestra nueva plataforma. Tenemos un servidor legacy (similar a Metasploitable 2) que aún corre en producción y varios servicios web externos. El board está presionando para el lanzamiento, pero yo necesito datos concretos sobre nuestras vulnerabilidades. Tienes 3 horas para entregar un informe completo."

Esto da contexto profesional al informe.
-->

Título del caso: "El Incidente de SecureTech Solutions"

Breve descripción:
Eres analista senior de ciberseguridad y debes evaluar la postura de seguridad de los servidores de desarrollo de SecureTech Solutions. El objetivo es obtener evidencia sobre vulnerabilidades en un servidor legacy (similar a Metasploitable 2) que aún opera en producción, y revisar servicios web externos autorizados. El tiempo límite para entregar el informe completo es de 3 horas.

Fases de la misión:

1. Reconocimiento Interno: Evaluar el servidor legacy de desarrollo.
2. Evaluación Externa: Analizar la exposición de servicios públicos autorizados (ej. certifiedhacker.com).
3. Análisis Profundo: Auditoría exhaustiva del servidor web principal (puerto 80).

<!-- 
🔴 COMENTARIO 8: AGREGAR ADVERTENCIA ÉTICA
El documento original incluye una sección importante de "ADVERTENCIA ÉTICA Y LEGAL":
⚖️ CÓDIGO DE CONDUCTA DEL PENTESTER PROFESIONAL
✓ SOLO escanea sistemas que POSEES o tienes AUTORIZACIÓN EXPLÍCITA
✓ Metasploitable 2: Diseñado para ser vulnerable
✗ NUNCA escanees sistemas de terceros sin permiso

Esto es MUY importante incluirlo antes de comenzar las fases.
-->

---

# FASE 1: RECONOCIMIENTO Y EVALUACIÓN INTERNA

Objetivo: Realizar un análisis completo del servidor legacy interno (Metasploitable 2).

## Actividad 1.1 — Escaneo con Nikto (capa de aplicación)

<!-- 
🔴 COMENTARIO 9: AGREGAR CONTEXTO TÉCNICO DE NIKTO
El documento original incluye explicación de qué hace Nikto:
"Nikto es un escáner especializado en servidores web que realiza más de 6,700 pruebas específicas para detectar:
- Archivos y scripts peligrosos
- Versiones desactualizadas de software
- Problemas de configuración del servidor
- Vulnerabilidades conocidas en aplicaciones web"

Agrégalo antes del comando.
-->

Se realizó un escaneo al servidor web legacy mediante utilizndo la nikto, especializada en este tipos de escaenos para obtener 

<!-- 
🔴 COMENTARIO 10: TEXTO INCOMPLETO - COMPLETAR LA ORACIÓN
"...para obtener [COMPLETAR: información sobre vulnerabilidades en la capa de aplicación web]"
-->

Parámetros:
- -h [IP] : host objetivo.
- -Tuning x : ajuste de pruebas (según necesidad).
- -output / -Format html : reporte en HTML para documentación.

<!-- 
🔴 COMENTARIO 11: AGREGAR EXPLICACIÓN DETALLADA DE PARÁMETROS
El documento original incluye una tabla explicativa más completa:
| Parámetro | Función | ¿Por qué es importante? |
Incluye esta tabla para mejor comprensión.
-->

<!-- 
🔴 COMENTARIO 12: FALTA EL COMANDO EJECUTADO COMPLETO
Agrega aquí:
```bash
nikto -h [IP_METASPLOITABLE_REAL] -Tuning x -output nikto_internal.html -Format html
```
Con la IP real usada.
-->

<img width="636" height="655" alt="image" src="https://gist.github.com/user-attachments/assets/c98fbb7a-10bd-49ee-a3e8-14fad4810975" />

<!-- 
🔴 COMENTARIO 13: AGREGAR INTERPRETACIÓN DE LA CAPTURA
Después de la imagen, incluye:
"En la captura se observa:
- [Describir qué se ve en la imagen]
- Tiempo de escaneo: [X minutos]
- Número de pruebas realizadas: [X]
- Hallazgos preliminares: [X vulnerabilidades detectadas]"
-->

Notas:
- Ejecutar únicamente en entornos autorizados y controlados.
- Guardar reportes con timestamps para trazabilidad.

<!-- 
🔴 COMENTARIO 14: AGREGAR PREGUNTAS DE REFLEXIÓN
El documento original incluye preguntas importantes:
"Mientras el escaneo corre, reflexiona:
- ¿Qué diferencia hay entre un escaneo de red y un escaneo de aplicación web?
- ¿Por qué Nikto es más efectivo que Nmap para detectar vulnerabilidades web?"

Agrégalas para demostrar comprensión conceptual.
-->

## Actividad 1.2 — Escaneo con Nmap + scripts "vuln"

<!-- 
🔴 COMENTARIO 15: AGREGAR CONTEXTO TÉCNICO DE NMAP
El documento original explica:
"Nmap con NSE (Nmap Scripting Engine) puede ejecutar scripts especializados que correlacionan servicios detectados con vulnerabilidades conocidas en bases de datos públicas."
-->

Descripción:
Nmap con NSE ejecuta scripts que correlacionan servicios detectados con vulnerabilidades conocidas.

Comando ejemplo:
```bash
nmap -sV --script vuln [IP_METASPLOITABLE] -oN nmap_vuln_internal.txt
```

<!-- 
🔴 COMENTARIO 16: FALTA EL COMANDO REAL EJECUTADO Y SU SALIDA
Aquí debes:
1. Poner el comando exacto que ejecutaste con la IP real
2. Agregar captura de pantalla de la ejecución
3. Incluir fragmento relevante de la salida del archivo .txt generado
-->

Parámetros:
- -sV : detección de versiones (banner grabbing).
- --script vuln : ejecutar scripts de la categoría "vuln".
- -oN : salida en formato legible.

<!-- 
🔴 COMENTARIO 17: EXPANDIR TABLA DE PARÁMETROS
El documento original tiene una tabla más detallada:
| Parámetro | Función | Detalles Técnicos |
| -sV | Detección de versiones | Realiza banner grabbing y fingerprinting |
| --script vuln | Ejecuta categoría "vuln" de NSE | ~100 scripts que buscan CVEs conocidos |
| -oN | Output en formato normal | Legible para humanos y parseable |
-->

## Actividad 1.3 — Escaneo con Nmap + script "vulners"

<!-- 
🔴 COMENTARIO 18: AGREGAR CONTEXTO TÉCNICO DEL SCRIPT VULNERS
El documento original explica:
"El script 'vulners' consulta la base de datos Vulners.com, que agrega información de múltiples fuentes (CVE, ExploitDB, Metasploit, etc.) y proporciona scores CVSS actualizados."
-->

Descripción:
El script "vulners" consulta bases como Vulners.com y devuelve referencias a CVE y puntajes CVSS cuando están disponibles.

Comando ejemplo:
```bash
nmap --script vulners -sV [IP_METASPLOITABLE] -oN nmap_vulners_internal.txt
```

<!-- 
🔴 COMENTARIO 19: FALTA COMANDO REAL, CAPTURA Y SALIDA
Igual que en actividad 1.2:
1. Comando con IP real
2. Captura de ejecución
3. Fragmento de salida relevante
-->

<!-- 
🔴 COMENTARIO 20: AGREGAR DIFERENCIA CLAVE
El documento original destaca:
"💡 Diferencia clave con --script vuln:
- vuln: Ejecuta pruebas activas para confirmar vulnerabilidades
- vulners: Correlaciona versiones detectadas con bases de datos (más rápido, menos intrusivo)"
-->

Salida esperada:
- Lista de servicios y referencias a CVE/NVD/Vulners con puntajes CVSS.

---

# FASE 2: EVALUACIÓN EXTERNA

Objetivo: Analizar exposición de un sistema público autorizado (por ejemplo, certifiedhacker.com).

<!-- 
🔴 COMENTARIO 21: AGREGAR NOTA IMPORTANTE SOBRE AUTORIZACIÓN
El documento original incluye:
"⚠️ Nota Importante: certifiedhacker.com es un dominio que autoriza escaneos con fines educativos. Sin embargo, siempre verifica las políticas actuales antes de escanear."
-->

## Actividad 2.1 — Escaneo externo con Nikto

**Comando ejecutado:**

```bash
nikto -h 192.168.56.102 -Tuning x -output nikto_external.html -Format html
```

**Parámetros utilizados:**

- `-h 192.168.56.102`: Dirección IP objetivo (red interna en lugar de certifiedhacker.com)
- `-Tuning x`: Deshabilitar todas las verificaciones de tuning
- `-output nikto_external.html`: Guardar resultados en archivo HTML
- `-Format html`: Formato de salida HTML

**Resultados obtenidos:**
El comando se ejecutó contra la dirección IP `192.168.56.102`, pero la ejecución no se completó correctamente. El archivo de salida `nikto_external.html` contiene únicamente el mensaje "no se termino de ejecutar xd", lo que indica que el proceso fue interrumpido o falló.

**Análisis:**

- **Estado**: Ejecución incompleta
- **Causa probable**: Interrupción manual del proceso o error en la conexión
- **Recomendación**: Re-ejecutar el comando con un timeout apropiado o verificar conectividad con el objetivo

## Actividad 2.2 — Escaneo externo con Nmap (vuln)

Comando ejemplo:
```bash
nmap -sV --script vuln certifiedhacker.com -oN nmap_vuln_external.txt
```

<!-- 
🔴 COMENTARIO 23: FALTA EVIDENCIA
Misma situación que 2.1
-->

## Actividad 2.3 — Escaneo externo con Nmap (vulners)

Comando ejemplo:
```bash
nmap --script vulners -sV certifiedhacker.com -oN nmap_vulners_external.txt
```

<!-- 
🔴 COMENTARIO 24: AGREGAR PREGUNTA DE REFLEXIÓN
El documento original pregunta:
"¿Notaste diferencias en los tiempos de respuesta entre escanear Metasploitable (local) y certifiedhacker.com (remoto)? ¿Qué factores influyen en esto?"

Esta reflexión es importante para demostrar comprensión.
-->

---

# FASE 3: ANÁLISIS PROFUNDO DEL SERVIDOR WEB (Puerto 80)

Objetivo: Análisis exhaustivo del servidor web que corre en puerto 80 — búsqueda de archivos peligrosos, configuraciones incorrectas y componentes desactualizados.

<!-- 
🔴 COMENTARIO 25: AGREGAR LA "MISIÓN FINAL" DEL CISO
El documento original incluye otra cita del CISO:
"Hola de nuevo, nuestro servidor web principal corre en el puerto 80 de Metasploitable. Necesito un análisis EXHAUSTIVO de ese servicio específicamente. Usa la herramienta más apropiada para detectar archivos dañinos, configuraciones incorrectas y componentes desactualizados. Justifica tu elección."

Esto da continuidad narrativa al informe.
-->

## Elección de herramienta (recomendación)

- Herramienta principal: Nikto para pruebas específicas de aplicaciones web.
- Complemento: Nmap --script vulners para correlacionar versiones con CVE/CVSS.

Justificación:
- Nikto profundiza en endpoints, archivos y configuraciones HTTP.
- Nmap vulners aporta referencias a CVE y puntajes para priorizar hallazgos.

<!-- 
🔴 COMENTARIO 26: COMPLETAR EL ANÁLISIS COMPARATIVO
El documento original pide completar una tabla exhaustiva:

ANÁLISIS COMPARATIVO DE HERRAMIENTAS

NIKTO:
Ventajas para este escenario:
- [Completa aquí]
- [Completa aquí]
Desventajas:
- [Completa aquí]

NMAP (--script vuln):
Ventajas: ...
Desventajas: ...

NMAP (--script vulners):
Ventajas: ...
Desventajas: ...

Necesitas llenar cada sección con análisis específico.
-->

## Actividad 3.1 — Ejecución del escaneo específico

Opción A — Nikto:
```bash
nikto -h [IP_METASPLOITABLE] -port 80 -Tuning x -output nikto_puerto80.html -Format html
```

Opción B — Nmap:
```bash
nmap -p 80 -sV --script vuln [IP_METASPLOITABLE] -oN nmap_puerto80.txt
```

<!-- 
🔴 COMENTARIO 27: FALTA INDICAR QUÉ OPCIÓN ELIGIERON Y POR QUÉ
Deben:
1. Indicar claramente: "Se eligió la opción [A/B]"
2. Justificar basándose en el análisis comparativo
3. Mostrar el comando ejecutado CON LA IP REAL
4. Captura de ejecución
5. Análisis de resultados obtenidos
-->

---

# ANÁLISIS Y DOCUMENTACIÓN DE RESULTADOS

<!-- 
🔴 COMENTARIO 28: ESTA ES LA SECCIÓN MÁS IMPORTANTE Y ESTÁ INCOMPLETA
El documento original pide documentar vulnerabilidades con este formato ESPECÍFICO:

### VULNERABILIDAD NIKTO #1
**Nombre/Descripción:**
[Copia exacta del hallazgo de Nikto]

**CVE Asociado (si aplica):**
[Busca en https://cve.mitre.org/]

**Severidad (CVSS Score):**
[Consulta NVD: https://nvd.nist.gov/]
- Score: X.X (Bajo/Medio/Alto/Crítico)

**Análisis Técnico:**
¿Qué significa esta vulnerabilidad?
[Explica en tus propias palabras qué permite hacer al atacante]

**Vector de Ataque:**
¿Cómo podría ser explotada?
[Describe el escenario de ataque]

**Impacto Potencial:**
- Confidencialidad: [Alto/Medio/Bajo]
- Integridad: [Alto/Medio/Bajo]
- Disponibilidad: [Alto/Medio/Bajo]

**Contramedidas Específicas:**
1. [Acción inmediata]
2. [Configuración recomendada]
3. [Mejora a largo plazo]

**Referencias:**
- [URL de CVE]
- [URL de advisory del vendor]
- [Artículo técnico relevante]

DEBES REPETIR ESTE FORMATO PARA AL MENOS:
- 2 vulnerabilidades de Nikto
- 2 vulnerabilidades de Nmap vulners
(El objetivo dice "al menos 10 vulnerabilidades" pero puedes empezar con las más críticas)
-->

Instrucción general:
Repetir el formato de análisis para cada vulnerabilidad: extraer texto exacto del hallazgo, buscar el CVE (si aplica) en MITRE/NVD, anotar el CVSSv3 real, describir vector de ataque, impacto (confidencialidad, integridad, disponibilidad) y proponer contramedidas.

## Plantilla por hallazgo

- Nombre / Descripción (texto exacto del reporte)
- Fuente (Nikto / Nmap --script vulners / otra)
- CVE asociado (si aplica)
- Severidad (CVSSv3 score y clasificación)
- Análisis técnico (qué permite al atacante)
- Vector de ataque (cómo podría explotarse)
- Impacto potencial:
  - Confidencialidad: [Alto/Medio/Bajo]
  - Integridad: [Alto/Medio/Bajo]
  - Disponibilidad: [Alto/Medio/Bajo]
- Contramedidas:
  1. Acción inmediata
  2. Configuración recomendada
  3. Mejora a largo plazo
- Referencias (NVD, CVE, avisos del proveedor, KBs)

<!-- 
🔴 COMENTARIO 29: AQUÍ DEBEN IR LAS VULNERABILIDADES REALES ENCONTRADAS
Esta plantilla es solo el formato. Necesitan:
1. Revisar los archivos de salida (nikto_internal.html, nmap_vuln_internal.txt, etc.)
2. Seleccionar las vulnerabilidades más críticas
3. Documentar CADA UNA con este formato completo
4. Buscar información real en CVE y NVD

Ejemplo de cómo debería verse:

### VULNERABILIDAD #1 (NIKTO)
**Nombre/Descripción:**
"+ The anti-clickjacking X-Frame-Options header is not present."

**CVE Asociado:**
N/A (es una configuración de seguridad)

**Severidad:**
Informacional / Bajo (no tiene CVE pero facilita ataques)

**Análisis Técnico:**
La ausencia del header X-Frame-Options permite que la página sea embebida en un iframe de un sitio malicioso, facilitando ataques de clickjacking donde el usuario cree estar interactuando con un sitio legítimo pero está siendo engañado.

[Y CONTINUAR CON TODOS LOS CAMPOS...]
-->

---

# HALLAZGOS REPRESENTATIVOS (ejemplos típicos)

Los siguientes son hallazgos representativos basados en objetivos tipo Metasploitable 2 y escaneos con Nikto / Nmap. Verificar siempre en los outputs reales y en NVD.

<!-- 
🔴 COMENTARIO 30: ESTA SECCIÓN ES UN "PLACEHOLDER"
Los hallazgos listados aquí (vsftpd, ProFTPD, Tomcat, etc.) son EJEMPLOS GENÉRICOS de lo que típicamente se encuentra en Metasploitable 2.

DEBEN:
1. Verificar cuáles de estos hallazgos aparecieron REALMENTE en sus escaneos
2. Eliminar los que NO encontraron
3. Agregar los que SÍ encontraron y no están en la lista
4. Para cada hallazgo que mantengan, documentarlo con el formato completo del COMENTARIO 29
5. Incluir capturas de pantalla de los reportes mostrando cada hallazgo
-->

1) vsftpd 2.3.4 — backdoor en versión distribuida
- Fuente: nmap (banner), vulners
- Impacto: RCE remoto — alto
- Contramedidas: actualizar/desinstalar, restringir acceso FTP, usar SFTP/FTPS

2) ProFTPD — módulo mod_copy mal configurado
- Fuente: nmap, verificación manual
- Impacto: exposición de archivos / posible RCE
- Contramedidas: deshabilitar módulo, parchear, restringir permisos

<!-- [Continúan del 3 al 10...] -->

<!-- 
🔴 COMENTARIO 31: EXPANDIR CADA HALLAZGO
Cada uno de estos 10 hallazgos debe tener el formato COMPLETO con:
- CVE específico (ejemplo: vsftpd 2.3.4 = CVE-2011-2523)
- CVSS score exacto consultado en NVD
- Análisis técnico detallado
- Vector de ataque paso a paso
- Impacto en CIA
- 3 contramedidas específicas
- Referencias con URLs reales
-->

---

# ANÁLISIS COMPARATIVO: Nikto vs Nmap --script vulners

| Criterio | Nikto | Nmap --script vulners |
| :--- | :--- | :--- |
| Capa OSI objetivo | Aplicación (HTTP/HTTPS) | Red / Transporte + Aplicación (puertos y versiones) |
| Tipo de pruebas | Activas, enfocadas en endpoints web | Activas, detección de servicios y correlación con CVE |
| Profundidad en apps web | Alta | Media (foco en versiones y CVE) |
| Cobertura de servicios | Específica (HTTP/HTTPS) | Amplia (todos los servicios detectables) |
| Velocidad | Media | Rápido para inventario; variable con scripts |
| Intrusividad | Alta | Variable (depende de los scripts) |
| Falsos positivos | Moderados | Moderados / depende de banners |
| Mejor caso de uso | Auditoría de aplicaciones web | Reconocimiento y priorización por CVE |

<!-- 
🔴 COMENTARIO 32: AGREGAR PREGUNTA DE REFLEXIÓN ESTRATÉGICA
El documento original pide:
"En un escenario real de auditoría, ¿en qué orden ejecutarías estas herramientas y por qué?

Mi estrategia sería:
1. [Primera herramienta] porque...
2. [Segunda herramienta] porque...
3. [Tercera herramienta] porque...

Justificación de la secuencia:
[Explica tu razonamiento considerando factores como sigilo, eficiencia, y progresión lógica del pentesting]"

Esta sección demuestra pensamiento estratégico.
-->

---

# ESTRATEGIA RECOMENDADA DE EJECUCIÓN

Orden sugerido en una auditoría:

1. Nmap (descubrimiento de puertos y versiones) — para mapear superficie.
2. Nmap --script vulners / vuln — para correlacionar versiones con CVEs y priorizar.
3. Escáneres de aplicación (Nikto, OWASP ZAP, Burp) en los hosts web prioritarios — para hallar problemas lógicos de la app.

Justificación:
- Empezar con reconocimiento pasará a pruebas más profundas solo donde aporte valor; así se minimiza tiempo y ruido, y se mejora priorización.

<!-- 
🔴 COMENTARIO 33: PERSONALIZAR ESTA SECCIÓN
Esta es la estrategia genérica, pero deberían:
1. Explicar si siguieron este orden en la práctica
2. Si no, por qué eligieron otro orden
3. Qué aprendieron sobre la eficiencia de cada enfoque
4. Qué harían diferente en un escenario real
-->

---

# CONCLUSIONES

<!-- 
🔴 COMENTARIO 34: SECCIÓN CRÍTICA - EXPANDIR SIGNIFICATIVAMENTE
El documento original pide:
"Conclusiones de la actividad desarrollada
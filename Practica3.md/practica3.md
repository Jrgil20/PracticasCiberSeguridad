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
| Equipo origen / fuente | Kali Linux (192.168.56.101) |
| Equipo objetivo / destino | Metasploitable 2 (192.168.56.102) |
| Otros equipos involucrados | Host de gestión, repositorio de evidencias |

Antes de empezar con la realización de las actividades de la práctica se modificarán las configuraciones del adaptor de red usado por las dos máquinas virtuales para conectarlas a una red interna denomindada "lab_vulnerabilidades" para simlar el entorno empresarial especificado más adelante en el apartado de escenario y contexto del presente reporte. 

> **¿Por qué se utilizó una Red Interna?**  
Configurar las máquinas virtuales en una red interna aporta varias ventajas importantes para la práctica:  
- **Aislamiento total del tráfico respecto a la red física:** Esto protege tanto la infraestructura real como otros equipos conectados en la red local, evitando cualquier posible interferencia o riesgo relacionado con los escaneos.
- **Prevención de escaneos accidentales a sistemas reales:** Al utilizar una red cerrada y simulada, eliminamos el peligro de impactar por error servidores reales externos durante las actividades de análisis.
- **Simulación de un entorno corporativo controlado:** Reproduce las condiciones de una red empresarial, donde los analistas de seguridad operan en un entorno controlado y segmentado, facilitando pruebas seguras y realistas sin consecuencias no deseadas.

Esta configuración es fundamental para realizar pruebas de vulnerabilidades de forma responsable y enfocada únicamente en los sistemas objetivo definidos en el laboratorio.

Como se puede observar en las capturas correspondientes a la configutación de los respectivos adptadroes de red se está activando el modo promiscuo con la opción de permitir todo, el modo promiscuo es una configuración especial que permite que el adaptador capture y pase a la capa superior (como el sistema operativo o un programa analizador) todo el tráfico que circula por la red compartida a la que está conectado, sin importar si los paquetes están dirigidos a su propia dirección MAC o no.

<img width="679" height="527" alt="image" src="https://gist.github.com/user-attachments/assets/38d59ac5-2d6e-45b0-ac79-4224475f947b" />
<img width="684" height="524" alt="image" src="https://gist.github.com/user-attachments/assets/d1fe7996-29d8-4e24-a540-ddaa8f6cbbeb" />

**Verificación de Conectividad**

Luego de configurar los adaptadores de red en ambas VMs se procede a ejecutar los comandos ip addr show en la máquina Kali("Analista") y el comanndo ifconfig en la máquina Metasploitable 2("Obejeitvo") para poder saber cuales son las IP asignadas a los adpatores de red que serán utilizadas mas adeleante en los comandos necesarios para realizar la práctica

En Kali Linux:
> Obtén tu dirección IP
ip addr show
<img width="633" height="620" alt="image" src="https://gist.github.com/user-attachments/assets/53422336-6ef6-4b69-85bc-92736fb2477d" />

Como se observa en la captura, la dirección IP asignada a Kali Linux es: **192.168.56.101**

En Metasploitable 2:

<img width="723" height="470" alt="image" src="https://gist.github.com/user-attachments/assets/6c6c6538-d482-4032-9251-4dbe4c2e9b59" />

La dirección IP asignada a Metasploitable 2 es: **192.168.56.102**

Luego de obtener las direcciones IPs se realiza un ping desde la máquina analista para comprobar la conexión entre ellas en la red interna "lab_vulnerabilidades", teniendo como resultado la confirmación de la conexión evidenciada en los resultados del ping ya que se enviaron 4 paquetes y se tuvo respuesta de los 4.

> ping
<img width="631" height="516" alt="image" src="https://gist.github.com/user-attachments/assets/23afa9ae-a280-4333-ba77-2f3468d32d54" />

Los resultados muestran:
- 4 paquetes transmitidos, 4 recibidos (0% de pérdida)
- Tiempo promedio de respuesta: aproximadamente 0.593 ms
- Esto confirma la conectividad completa entre ambos equipos en la red interna “lab_vulnerabilidades”.

El último paso de la preparación para la realización de los comandos es verificar las versiones de las herramientas principales a utilizar en la realización de la práctica, en este caso siendo nikto y nmap, posteriormente se actualizó la versión de nmap mediante la ejecución de comando nmap --script-updatedb.

<img width="632" height="346" alt="image" src="https://gist.github.com/user-attachments/assets/b41e1167-c512-4537-9be0-7dfb4b466f58" />

Versiones detectadas:

- Nmap: 7.94

---

## Requisitos

- Kali Linux (plataforma de pentesting).
- Metasploitable 2 (objetivo vulnerable controlado).
- Nikto (escáner de vulnerabilidades web).
- Nmap con NSE scripts (detección de servicios y correlación con CVEs).
- Acceso a bases de datos CVE / NVD para verificación de vulnerabilidades.

---

## Escenario y Contexto

Título del caso: "El Incidente de SecureTech Solutions"

> Cita del CISO:
> "Hola, necesitamos que evalúes la postura de seguridad de nuestros servidores de desarrollo antes de que lancemos nuestra nueva plataforma. Tenemos un servidor legacy (similar a Metasploitable 2) que aún corre en producción y varios servicios web externos. El board está presionando para el lanzamiento, pero yo necesito datos concretos sobre nuestras vulnerabilidades. Tienes 3 horas para entregar un informe completo."

Este escenario establece el contexto profesional del informe, simulando una auditoría real con presión temporal y requerimientos de alto nivel.

Breve descripción:
Eres analista senior de ciberseguridad y debes evaluar la postura de seguridad de los servidores de desarrollo de SecureTech Solutions. El objetivo es obtener evidencia sobre vulnerabilidades en un servidor legacy (similar a Metasploitable 2) que aún opera en producción, y revisar servicios web externos autorizados. El tiempo límite para entregar el informe completo es de 3 horas.

Fases de la misión:

1. Reconocimiento Interno: Evaluar el servidor legacy de desarrollo.
2. Evaluación Externa: Analizar la exposición de servicios públicos autorizados (ej. certifiedhacker.com).
3. Análisis Profundo: Auditoría exhaustiva del servidor web principal (puerto 80).

> ⚠️ **ADVERTENCIA ÉTICA Y LEGAL**

**CÓDIGO DE CONDUCTA DEL PENTESTER PROFESIONAL**
- ✅ **SOLO** realiza escaneos y pruebas sobre sistemas que POSEES o para los cuales tienes AUTORIZACIÓN EXPLÍCITA.
- ✅ **Metasploitable 2** ha sido diseñado específicamente para fines educativos y pruebas controladas, por lo que está permitido realizar auditorías sobre él en entornos de laboratorio.
- ❌ **NUNCA** realices escaneos, ataques o pruebas de intrusión sobre sistemas de terceros, públicos o privados, sin el consentimiento formal y documentado del propietario.

> _Respetar la ley y el código ético es una responsabilidad primordial antes de comenzar cualquier práctica de ciberseguridad._

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

**Resultados del escaneo:**

<details>
<summary>📄 Ver resultados completos del escaneo Nmap (vuln) - certifiedhacker.com</summary>

```txt
# Nmap 7.94SVN scan initiated Fri Oct 10 10:36:32 2025 as: nmap -sV --script vuln -oN nmap_vuln_external.txt certifiedhacker.com
Nmap scan report for certifiedhacker.com (162.241.216.11)
Host is up (0.16s latency).
rDNS record for 162.241.216.11: box5331.bluehost.com
Not shown: 996 filtered tcp ports (no-response)
PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 8.7 (protocol 2.0)
| vulners: 
|   cpe:/a:openbsd:openssh:8.7: 
|     	PACKETSTORM:179290	10.0	https://vulners.com/packetstorm/PACKETSTORM:179290	*EXPLOIT*
|     	1EEC8894-D2F7-547C-827C-915BE866875C	10.0	https://vulners.com/githubexploit/1EEC8894-D2F7-547C-827C-915BE866875C	*EXPLOIT*
|     	PACKETSTORM:173661	9.8	https://vulners.com/packetstorm/PACKETSTORM:173661	*EXPLOIT*
|     	F0979183-AE88-53B4-86CF-3AF0523F3807	9.8	https://vulners.com/githubexploit/F0979183-AE88-53B4-86CF-3AF0523F3807	*EXPLOIT*
|     	CVE-2023-38408	9.8	https://vulners.com/cve/CVE-2023-38408
|     	B8190CDB-3EB9-5631-9828-8064A1575B23	9.8	https://vulners.com/githubexploit/B8190CDB-3EB9-5631-9828-8064A1575B23	*EXPLOIT*
|     	8FC9C5AB-3968-5F3C-825E-E8DB5379A623	9.8	https://vulners.com/githubexploit/8FC9C5AB-3968-5F3C-825E-E8DB5379A623	*EXPLOIT*
|     	8AD01159-548E-546E-AA87-2DE89F3927EC	9.8	https://vulners.com/githubexploit/8AD01159-548E-546E-AA87-2DE89F3927EC	*EXPLOIT*
|     	33D623F7-98E0-5F75-80FA-81AA666D1340	9.8	https://vulners.com/githubexploit/33D623F7-98E0-5F75-80FA-81AA666D1340	*EXPLOIT*
|     	2227729D-6700-5C8F-8930-1EEAFD4B9FF0	9.8	https://vulners.com/githubexploit/2227729D-6700-5C8F-8930-1EEAFD4B9FF0	*EXPLOIT*
|     	0221525F-07F5-5790-912D-F4B9E2D1B587	9.8	https://vulners.com/githubexploit/0221525F-07F5-5790-912D-F4B9E2D1B587	*EXPLOIT*
|     	F8981437-1287-5B69-93F1-657DFB1DCE59	9.3	https://vulners.com/githubexploit/F8981437-1287-5B69-93F1-657DFB1DCE59	*EXPLOIT*
|     	CB2926E1-2355-5C82-A42A-D4F72F114F9B	9.3	https://vulners.com/githubexploit/CB2926E1-2355-5C82-A42A-D4F72F114F9B	*EXPLOIT*
|     	8DEE261C-33D4-5057-BA46-E4293B705BAE	9.3	https://vulners.com/githubexploit/8DEE261C-33D4-5057-BA46-E4293B705BAE	*EXPLOIT*
|     	6FD8F914-B663-533D-8866-23313FD37804	9.3	https://vulners.com/githubexploit/6FD8F914-B663-533D-8866-23313FD37804	*EXPLOIT*
|     	PACKETSTORM:190587	8.1	https://vulners.com/packetstorm/PACKETSTORM:190587	*EXPLOIT*
|     	FB2E9ED1-43D7-585C-A197-0D6628B20134	8.1	https://vulners.com/githubexploit/FB2E9ED1-43D7-585C-A197-0D6628B20134	*EXPLOIT*
|     	FA3992CE-9C4C-5350-8134-177126E0BD3F	8.1	https://vulners.com/githubexploit/FA3992CE-9C4C-5350-8134-177126E0BD3F	*EXPLOIT*
|     	EFD615F0-8F17-5471-AA83-0F491FD497AF	8.1	https://vulners.com/githubexploit/EFD615F0-8F17-5471-AA83-0F491FD497AF	*EXPLOIT*
|     	EC20B9C2-6857-5848-848A-A9F430D13EEB	8.1	https://vulners.com/githubexploit/EC20B9C2-6857-5848-848A-A9F430D13EEB	*EXPLOIT*
|     	EB13CBD6-BC93-5F14-A210-AC0B5A1D8572	8.1	https://vulners.com/githubexploit/EB13CBD6-BC93-5F14-A210-AC0B5A1D8572	*EXPLOIT*
|     	E543E274-C20A-582A-8F8E-F8E3F381C345	8.1	https://vulners.com/githubexploit/E543E274-C20A-582A-8F8E-F8E3F381C345	*EXPLOIT*
|     	E34FCCEC-226E-5A46-9B1C-BCD6EF7D3257	8.1	https://vulners.com/githubexploit/E34FCCEC-226E-5A46-9B1C-BCD6EF7D3257	*EXPLOIT*
|     	E24EEC0A-40F7-5BBC-9E4D-7B13522FF915	8.1	https://vulners.com/githubexploit/E24EEC0A-40F7-5BBC-9E4D-7B13522FF915	*EXPLOIT*
|     	DC1BB99A-8B57-5EE5-9AC4-3D9D59BFC346	8.1	https://vulners.com/githubexploit/DC1BB99A-8B57-5EE5-9AC4-3D9D59BFC346	*EXPLOIT*
|     	DA18D761-BB81-54B6-85CB-CFD73CE33621	8.1	https://vulners.com/githubexploit/DA18D761-BB81-54B6-85CB-CFD73CE33621	*EXPLOIT*
|     	D8974199-6B08-5895-9610-919F71468F23	8.1	https://vulners.com/githubexploit/D8974199-6B08-5895-9610-919F71468F23	*EXPLOIT*
|     	D52370EF-02EE-507D-9212-2D8EA86CBA94	8.1	https://vulners.com/githubexploit/D52370EF-02EE-507D-9212-2D8EA86CBA94	*EXPLOIT*
|     	CVE-2024-6387	8.1	https://vulners.com/cve/CVE-2024-6387
|     	CFEBF7AF-651A-5302-80B8-F8146D5B33A6	8.1	https://vulners.com/githubexploit/CFEBF7AF-651A-5302-80B8-F8146D5B33A6	*EXPLOIT*
|     	C6FB6D50-F71D-5870-B671-D6A09A95627F	8.1	https://vulners.com/githubexploit/C6FB6D50-F71D-5870-B671-D6A09A95627F	*EXPLOIT*
|     	C623D558-C162-5D17-88A5-4799A2BEC001	8.1	https://vulners.com/githubexploit/C623D558-C162-5D17-88A5-4799A2BEC001	*EXPLOIT*
|     	C5B2D4A1-8C3B-5FF7-B620-EDE207B027A0	8.1	https://vulners.com/githubexploit/C5B2D4A1-8C3B-5FF7-B620-EDE207B027A0	*EXPLOIT*
|     	C185263E-3E67-5550-B9C0-AB9C15351960	8.1	https://vulners.com/githubexploit/C185263E-3E67-5550-B9C0-AB9C15351960	*EXPLOIT*
|     	BDA609DA-6936-50DC-A325-19FE2CC68562	8.1	https://vulners.com/githubexploit/BDA609DA-6936-50DC-A325-19FE2CC68562	*EXPLOIT*
|     	BA3887BD-F579-53B1-A4A4-FF49E953E1C0	8.1	https://vulners.com/githubexploit/BA3887BD-F579-53B1-A4A4-FF49E953E1C0	*EXPLOIT*
|     	B1F444E0-F217-5FC0-B266-EBD48589940F	8.1	https://vulners.com/githubexploit/B1F444E0-F217-5FC0-B266-EBD48589940F	*EXPLOIT*
|     	92254168-3B26-54C9-B9BE-B4B7563586B5	8.1	https://vulners.com/githubexploit/92254168-3B26-54C9-B9BE-B4B7563586B5	*EXPLOIT*
|     	91752937-D1C1-5913-A96F-72F8B8AB4280	8.1	https://vulners.com/githubexploit/91752937-D1C1-5913-A96F-72F8B8AB4280	*EXPLOIT*
|     	89F96BAB-1624-51B5-B09E-E771D918D1E6	8.1	https://vulners.com/githubexploit/89F96BAB-1624-51B5-B09E-E771D918D1E6	*EXPLOIT*
|     	81F0C05A-8650-5DE8-97E9-0D89F1807E5D	8.1	https://vulners.com/githubexploit/81F0C05A-8650-5DE8-97E9-0D89F1807E5D	*EXPLOIT*
|     	7C7167AF-E780-5506-BEFA-02E5362E8E48	8.1	https://vulners.com/githubexploit/7C7167AF-E780-5506-BEFA-02E5362E8E48	*EXPLOIT*
|     	79FE1ED7-EB3D-5978-A12E-AAB1FFECCCAC	8.1	https://vulners.com/githubexploit/79FE1ED7-EB3D-5978-A12E-AAB1FFECCCAC	*EXPLOIT*
|     	795762E3-BAB4-54C6-B677-83B0ACC2B163	8.1	https://vulners.com/githubexploit/795762E3-BAB4-54C6-B677-83B0ACC2B163	*EXPLOIT*
|     	774022BB-71DA-57C4-9B8F-E21D667DE4BC	8.1	https://vulners.com/githubexploit/774022BB-71DA-57C4-9B8F-E21D667DE4BC	*EXPLOIT*
|     	743E5025-3BB8-5EC4-AC44-2AA679730661	8.1	https://vulners.com/githubexploit/743E5025-3BB8-5EC4-AC44-2AA679730661	*EXPLOIT*
|     	73A19EF9-346D-5B2B-9792-05D9FE3414E2	8.1	https://vulners.com/githubexploit/73A19EF9-346D-5B2B-9792-05D9FE3414E2	*EXPLOIT*
|     	6E81EAE5-2156-5ACB-9046-D792C7FAF698	8.1	https://vulners.com/githubexploit/6E81EAE5-2156-5ACB-9046-D792C7FAF698	*EXPLOIT*
|     	6B78D204-22B0-5D11-8A0C-6313958B473F	8.1	https://vulners.com/githubexploit/6B78D204-22B0-5D11-8A0C-6313958B473F	*EXPLOIT*
|     	65650BAD-813A-565D-953D-2E7932B26094	8.1	https://vulners.com/githubexploit/65650BAD-813A-565D-953D-2E7932B26094	*EXPLOIT*
|     	649197A2-0224-5B5C-9C4E-B5791D42A9FB	8.1	https://vulners.com/githubexploit/649197A2-0224-5B5C-9C4E-B5791D42A9FB	*EXPLOIT*
|     	61DDEEE4-2146-5E84-9804-B780AA73E33C	8.1	https://vulners.com/githubexploit/61DDEEE4-2146-5E84-9804-B780AA73E33C	*EXPLOIT*
|     	608FA50C-AEA1-5A83-8297-A15FC7D32A7C	8.1	https://vulners.com/githubexploit/608FA50C-AEA1-5A83-8297-A15FC7D32A7C	*EXPLOIT*
|     	5D2CB1F8-DC04-5545-8BC7-29EE3DA8890E	8.1	https://vulners.com/githubexploit/5D2CB1F8-DC04-5545-8BC7-29EE3DA8890E	*EXPLOIT*
|     	5C81C5C1-22D4-55B3-B843-5A9A60AAB6FD	8.1	https://vulners.com/githubexploit/5C81C5C1-22D4-55B3-B843-5A9A60AAB6FD	*EXPLOIT*
|     	53BCD84F-BD22-5C9D-95B6-4B83627AB37F	8.1	https://vulners.com/githubexploit/53BCD84F-BD22-5C9D-95B6-4B83627AB37F	*EXPLOIT*
|     	4FB01B00-F993-5CAF-BD57-D7E290D10C1F	8.1	https://vulners.com/githubexploit/4FB01B00-F993-5CAF-BD57-D7E290D10C1F	*EXPLOIT*
|     	48603E8F-B170-57EE-85B9-67A7D9504891	8.1	https://vulners.com/githubexploit/48603E8F-B170-57EE-85B9-67A7D9504891	*EXPLOIT*
|     	4748B283-C2F6-5924-8241-342F98EEC2EE	8.1	https://vulners.com/githubexploit/4748B283-C2F6-5924-8241-342F98EEC2EE	*EXPLOIT*
|     	452ADB71-199C-561E-B949-FCDE6288B925	8.1	https://vulners.com/githubexploit/452ADB71-199C-561E-B949-FCDE6288B925	*EXPLOIT*
|     	331B2B7F-FB25-55DB-B7A4-602E42448DB7	8.1	https://vulners.com/githubexploit/331B2B7F-FB25-55DB-B7A4-602E42448DB7	*EXPLOIT*
|     	1FFDA397-F480-5C74-90F3-060E1FE11B2E	8.1	https://vulners.com/githubexploit/1FFDA397-F480-5C74-90F3-060E1FE11B2E	*EXPLOIT*
|     	1FA2B3DD-FC8F-5602-A1C9-2CF3F9536563	8.1	https://vulners.com/githubexploit/1FA2B3DD-FC8F-5602-A1C9-2CF3F9536563	*EXPLOIT*
|     	1F7A6000-9E6D-511C-B0F6-7CADB7200761	8.1	https://vulners.com/githubexploit/1F7A6000-9E6D-511C-B0F6-7CADB7200761	*EXPLOIT*
|     	1CF00BB8-B891-5347-A2DC-2C6A6BFF7C99	8.1	https://vulners.com/githubexploit/1CF00BB8-B891-5347-A2DC-2C6A6BFF7C99	*EXPLOIT*
|     	1AB9F1F4-9798-59A0-9213-1D907E81E7F6	8.1	https://vulners.com/githubexploit/1AB9F1F4-9798-59A0-9213-1D907E81E7F6	*EXPLOIT*
|     	179F72B6-5619-52B5-A040-72F1ECE6CDD8	8.1	https://vulners.com/githubexploit/179F72B6-5619-52B5-A040-72F1ECE6CDD8	*EXPLOIT*
|     	15C36683-070A-5CC1-B21F-5F0BF974D9D3	8.1	https://vulners.com/githubexploit/15C36683-070A-5CC1-B21F-5F0BF974D9D3	*EXPLOIT*
|     	1337DAY-ID-39674	8.1	https://vulners.com/zdt/1337DAY-ID-39674	*EXPLOIT*
|     	11F020AC-F907-5606-8805-0516E06160EE	8.1	https://vulners.com/githubexploit/11F020AC-F907-5606-8805-0516E06160EE	*EXPLOIT*
|     	0FC4BE81-312B-51F4-9D9B-66D8B5C093CD	8.1	https://vulners.com/githubexploit/0FC4BE81-312B-51F4-9D9B-66D8B5C093CD	*EXPLOIT*
|     	0B165049-2374-5E2A-A27C-008BEA3D13F7	8.1	https://vulners.com/githubexploit/0B165049-2374-5E2A-A27C-008BEA3D13F7	*EXPLOIT*
|     	08144020-2B5F-5EB9-9286-1ABD5477278E	8.1	https://vulners.com/githubexploit/08144020-2B5F-5EB9-9286-1ABD5477278E	*EXPLOIT*
|     	SSV:92579	7.5	https://vulners.com/seebug/SSV:92579	*EXPLOIT*
|     	1337DAY-ID-26576	7.5	https://vulners.com/zdt/1337DAY-ID-26576	*EXPLOIT*
|     	CVE-2021-41617	7.0	https://vulners.com/cve/CVE-2021-41617
|     	284B94FC-FD5D-5C47-90EA-47900DAD1D1E	7.0	https://vulners.com/githubexploit/284B94FC-FD5D-5C47-90EA-47900DAD1D1E	*EXPLOIT*
|     	PACKETSTORM:189283	6.8	https://vulners.com/packetstorm/PACKETSTORM:189283	*EXPLOIT*
|     	CVE-2025-26465	6.8	https://vulners.com/cve/CVE-2025-26465
|     	9D8432B9-49EC-5F45-BB96-329B1F2B2254	6.8	https://vulners.com/githubexploit/9D8432B9-49EC-5F45-BB96-329B1F2B2254	*EXPLOIT*
|     	85FCDCC6-9A03-597E-AB4F-FA4DAC04F8D0	6.8	https://vulners.com/githubexploit/85FCDCC6-9A03-597E-AB4F-FA4DAC04F8D0	*EXPLOIT*
|     	1337DAY-ID-39918	6.8	https://vulners.com/zdt/1337DAY-ID-39918	*EXPLOIT*
|     	D104D2BF-ED22-588B-A9B2-3CCC562FE8C0	6.5	https://vulners.com/githubexploit/D104D2BF-ED22-588B-A9B2-3CCC562FE8C0	*EXPLOIT*
|     	CVE-2023-51385	6.5	https://vulners.com/cve/CVE-2023-51385
|     	C07ADB46-24B8-57B7-B375-9C761F4750A2	6.5	https://vulners.com/githubexploit/C07ADB46-24B8-57B7-B375-9C761F4750A2	*EXPLOIT*
|     	A88CDD3E-67CC-51CC-97FB-AB0CACB6B08C	6.5	https://vulners.com/githubexploit/A88CDD3E-67CC-51CC-97FB-AB0CACB6B08C	*EXPLOIT*
|     	65B15AA1-2A8D-53C1-9499-69EBA3619F1C	6.5	https://vulners.com/githubexploit/65B15AA1-2A8D-53C1-9499-69EBA3619F1C	*EXPLOIT*
|     	5325A9D6-132B-590C-BDEF-0CB105252732	6.5	https://vulners.com/gitee/5325A9D6-132B-590C-BDEF-0CB105252732	*EXPLOIT*
|     	530326CF-6AB3-5643-AA16-73DC8CB44742	6.5	https://vulners.com/githubexploit/530326CF-6AB3-5643-AA16-73DC8CB44742	*EXPLOIT*
|     	CVE-2023-48795	5.9	https://vulners.com/cve/CVE-2023-48795
|     	CVE-2016-20012	5.3	https://vulners.com/cve/CVE-2016-20012
|     	CVE-2025-32728	4.3	https://vulners.com/cve/CVE-2025-32728
|     	CVE-2021-36368	3.7	https://vulners.com/cve/CVE-2021-36368
|     	CVE-2025-61985	3.6	https://vulners.com/cve/CVE-2025-61985
|     	CVE-2025-61984	3.6	https://vulners.com/cve/CVE-2025-61984
|     	B7EACB4F-A5CF-5C5A-809F-E03CCE2AB150	3.6	https://vulners.com/githubexploit/B7EACB4F-A5CF-5C5A-809F-E03CCE2AB150	*EXPLOIT*
|_    	PACKETSTORM:140261	0.0	https://vulners.com/packetstorm/PACKETSTORM:140261	*EXPLOIT*
53/tcp  open  domain   (unknown banner: 9.16.23-RH)
| fingerprint-strings: 
|   DNSVersionBindReqTCP: 
|     version
|     bind
|_    9.16.23-RH
80/tcp  open  http     Apache httpd
|_http-server-header: Apache
|_http-csrf: Couldn't find any CSRF vulnerabilities.
| http-enum: 
|_  /blog/: Blog
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-dombased-xss: Couldn't find any DOM based XSS.
443/tcp open  ssl/http Apache httpd
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-server-header: Apache
|_http-csrf: Couldn't find any CSRF vulnerabilities.
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port53-TCP:V=7.94SVN%I=7%D=10/10%Time=68E91A65%P=x86_64-pc-linux-gnu%r(
SF:DNSVersionBindReqTCP,37,"\x005\0\x06\x85\0\0\x01\0\x01\0\0\0\0\x07versi
SF:on\x04bind\0\0\x10\0\x03\xc0\x0c\0\x10\0\x03\0\0\0\0\0\x0b\n9\.16\.23-R
SF:H");

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Oct 10 10:39:42 2025 -- 1 IP address (1 host up) scanned in 189.14 seconds
```

</details>

**📊 Resumen de hallazgos:**

- **Host:** certifiedhacker.com (162.241.216.11)
- **Puertos abiertos:** 22 (SSH), 53 (DNS), 80 (HTTP), 443 (HTTPS)
- **Vulnerabilidades críticas detectadas:** Múltiples CVEs en OpenSSH 8.7
- **Servicios identificados:** Apache httpd, BIND DNS server



## Actividad 2.3 — Escaneo externo con Nmap (vulners)

Comando ejemplo:
```bash
nmap --script vulners -sV certifiedhacker.com -oN nmap_vulners_external.txt
```

**Resultados del escaneo:**

<details>
<summary>📄 Ver resultados completos del escaneo Nmap (vulners) - certifiedhacker.com</summary>

```txt
# Nmap 7.94SVN scan initiated Fri Oct 10 10:36:55 2025 as: nmap --script vulners -sV -oN nmap_vulners_external.txt certifiedhacker.com
# Nmap done at Fri Oct 10 10:36:58 2025 -- 1 IP address (0 hosts up) scanned in 3.21 seconds
```

</details>

**📊 Resumen de hallazgos:**
- **Host:** certifiedhacker.com
- **Estado:** Host no disponible durante el escaneo
- **Tiempo de escaneo:** 3.21 segundos
- **Resultado:** 0 hosts activos detectados

**🤔 Reflexión sobre diferencias de rendimiento:**

¿Notaste diferencias en los tiempos de respuesta entre escanear Metasploitable (local) y certifiedhacker.com (remoto)? ¿Qué factores influyen en esto?

**Factores que influyen en los tiempos de respuesta:**

1. **Latencia de red:** El escaneo remoto depende de la latencia entre el atacante y el objetivo
2. **Filtros de red:** Firewalls, IPS/IDS pueden bloquear o limitar el tráfico de escaneo
3. **Estado del host objetivo:** El host puede estar caído, sobrecargado o con filtros estrictos
4. **Configuración de servicios:** Los servicios pueden estar configurados para no responder a ciertos tipos de escaneos
5. **Ancho de banda:** Limitaciones en la conexión pueden afectar la velocidad del escaneo

---

## FASE 3: ANÁLISIS PROFUNDO DEL SERVIDOR WEB (Puerto 80)

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
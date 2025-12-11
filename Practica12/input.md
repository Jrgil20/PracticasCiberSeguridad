# Auditoría de Seguridad: Configuración de Firewall FortiGate

## 📊 Identificación

| Campo | Valor |
|-------|-------|
| **Número de Práctica** | 12 |
| **Título** | Configuración de Firewall de Última Generación con Políticas de Seguridad Avanzadas |
| **Dominio** | REDES Y PERÍMETRO |
| **Tipo de Auditoría** | Laboratorio de Seguridad Perimetral |
| **Instructor** | [Nombre del Docente] |
| **Fecha de Realización** | [DD-MM-YYYY] |
| **Equipo/Grupo** | grupo 4|

---

## 🎯 Objetivos de Aprendizaje

Al completar esta práctica, será capaz de:

-   Configurar desde cero un firewall FortiGate en entorno virtualizado

-   Implementar políticas de seguridad basadas en zonas (LAN/DMZ)

-   Gestionar control granular de servicios (SSH, HTTP, HTTPS, ICMP)

-   Configurar políticas asimétricas de seguridad

-   Implementar Virtual IPs (VIP) para port forwarding

-   Aplicar filtrado de DNS y políticas basadas en objetos

-   Configurar policy routing y web proxy transparente

-   Analizar logs y realizar troubleshooting en FortiGate

-   Comprender el rol del firewall como perímetro de seguridad

**Requisitos Previos**

**Conocimientos**

-   Experiencia intermedia con redes TCP/IP (direccionamiento,
    subnetting, routing básico)

-   Familiaridad con VirtualBox (gestión de VMs, adaptadores de red)

-   Conocimientos básicos de Linux (comandos de red: ping, ssh, curl,
    nmap)

-   Comprensión de protocolos: HTTP/HTTPS, SSH, DNS, ICMP

-   NO se requiere experiencia previa con FortiGate o firewalls UTM

**Entorno Técnico**

-   **VirtualBox** 6.1 o superior instalado

-   **3 Máquinas Virtuales**:

    i.  **Kali Linux** (última versión) - Rol: Cliente LAN

    ii. **FortiGate VM** (imagen proporcionada por el instructor) - Rol:
        Firewall UTM

    iii. **Metasploitable2** - Rol: Servidor DMZ

-   **Recursos mínimos recomendados**:

    i.  Host: 8GB RAM, 4 cores, 40GB espacio libre

    ii. Kali: 2GB RAM, 2 cores

    iii. FortiGate: 2GB RAM, 1 core

    iv. Metasploitable2: 512MB RAM, 1 core

```{=html}
<!-- -->
```
-   **Conectividad**: Las tres VMs deben estar en el mismo host de
    VirtualBox

**Materiales Proporcionados por el docente**

-   Imagen OVA de FortiGate (importar en VirtualBox)

-   Credenciales por defecto del FortiGate

-   Plantilla de reporte para capturas de pantalla

**\
**

**Escenario / Topología**

**Contexto Profesional**

Has sido contratado como administrador de seguridad de una pequeña
empresa que necesita segmentar su red. La organización tiene:

-   Una **red LAN** donde operan los usuarios (simulada con Kali Linux)

-   Una **zona DMZ** donde se alojan servidores accesibles (simulada con
    Metasploitable2)

-   Un **firewall FortiGate** que debe actuar como perímetro de
    seguridad

Tu misión es configurar el FortiGate desde cero e implementar políticas
de seguridad progresivamente más complejas.

**Diagrama de Topología**

![](./image1.png){width="6.1375in" height="6.485416666666667in"}

**Tabla de Direccionamiento**

  -----------------------------------------------------------------------------------
  Dispositivo       Interface   Dirección IP    Máscara   Gateway        Rol
  ----------------- ----------- --------------- --------- -------------- ------------
  Kali Linux        eth0        192.168.10.10   /24       192.168.10.1   Cliente LAN

  FortiGate         port1       192.168.10.1    /24       \-             Interface
                                                                         LAN

  FortiGate         port2       200.100.10.1    /24       \-             Interface
                                                                         DMZ

  FortiGate         port3       DHCP            \-        \-             WAN
                                                                         (opcional)

  Metasploitable2   eth0        200.100.10.10   /24       200.100.10.1   Servidor DMZ
  -----------------------------------------------------------------------------------

**Configuración de Adaptadores de Red en VirtualBox**

  ----------------------------------------------------------------------------
  VM                Adaptador 1            Adaptador 2            Adaptador 3
  ----------------- ---------------------- ---------------------- ------------
  Kali Linux        Red                    \-                     \-
                    Interna: LAN_Segment                          

  FortiGate         Red                    Red                    NAT
                    Interna: LAN_Segment   Interna: DMZ_Segment   (opcional)

  Metasploitable2   Red                    \-                     \-
                    Interna: DMZ_Segment                          
  ----------------------------------------------------------------------------

**FASE 1: Preparación del Entorno de Laboratorio (15 minutos)**

**Objetivo de la Fase**

Importar y configurar las tres máquinas virtuales en VirtualBox,
estableciendo la topología de red correcta antes de iniciar la
configuración del FortiGate.

**Paso 1.1: Importar la Imagen del FortiGate**

**Acción en VirtualBox**:

1.  Abra VirtualBox

2.  Menú: Archivo → Importar servicio virtualizado

3.  Seleccione el archivo OVA de FortiGate

4.  En la pantalla de configuración:

    -   **Nombre**: FortiGate-Firewall

    -   **RAM**: 2048 MB

    -   **CPU**: 1 core

5.  Clic en Importar

**Tiempo estimado**: 2-3 minutos

**\
**

**Paso 1.2: Configurar Adaptadores de Red del FortiGate**

**Acción**:

1.  Seleccione la VM FortiGate-Firewall (NO la inicie aún)

2.  Clic derecho → Configuración → Red

**Adaptador 1 (port1 - LAN)**:

-   Habilitar adaptador de red

-   Conectado a: Red interna

-   Nombre: LAN_Segment

**Adaptador 2 (port2 - DMZ)**:

-   Habilitar adaptador de red

-   Conectado a: Red interna

-   Nombre: DMZ_Segment

**Adaptador 3 (port3 - WAN - Opcional)**:

-   Habilitar adaptador de red

-   Conectado a: NAT

-   (Este adaptador permite al FortiGate acceder a Internet para
    actualizaciones)

3.  Clic en Aceptar

![alt text](https://imgur.com/KC7BDiv)

**Paso 1.3: Configurar Kali Linux**

**Acción**:

1.  Seleccione su VM de Kali Linux

2.  Configuración → Red

**Adaptador 1**:

-   Habilitar adaptador de red

-   Conectado a: Red interna

-   Nombre: LAN_Segment

3.  Inicie Kali Linux y abra una terminal

**Configurar IP estática**:

\# Verificar nombre de la interfaz

ip addr show

\# Editar configuración de red (asumiendo interfaz eth0)

sudo nano /etc/network/interfaces

Agregue estas líneas:

auto eth0

iface eth0 inet static

address 192.168.10.10

netmask 255.255.255.0

gateway 192.168.10.1

dns-nameservers 8.8.8.8

Guarde (Ctrl+O, Enter, Ctrl+X) y aplique:

sudo systemctl restart networking

\# O reinicie la interfaz

sudo ifdown eth0 && sudo ifup eth0

\# Verificar configuración

ip addr show eth0

**Salida esperada**:

2: eth0: \<BROADCAST,MULTICAST,UP,LOWER_UP\> mtu 1500 qdisc pfifo_fast
state UP group default qlen 1000

inet 192.168.10.10/24 brd 192.168.10.255 scope global eth0

**PREGUNTA DE VERIFICACIÓN #1**: ¿Por qué configuramos el gateway como
192.168.10.1? ¿Qué dispositivo tiene esa IP?

**Paso 1.4: Configurar Metasploitable2**

**Acción**:

1.  Seleccione su VM de Metasploitable2

2.  Configuración → Red

**Adaptador 1**:

-   Habilitar adaptador de red

-   Conectado a: Red interna

-   Nombre: DMZ_Segment

3.  Inicie Metasploitable2 (credenciales por
    defecto: msfadmin / msfadmin)

**Configurar IP estática**:

\# Editar configuración de red

sudo nano /etc/network/interfaces

Modifique/agregue:

auto eth0

iface eth0 inet static

address 200.100.10.10

netmask 255.255.255.0

gateway 200.100.10.1

Aplique cambios:

sudo /etc/init.d/networking restart

\# Verificar

ifconfig eth0

**Salida esperada**:

eth0 Link encap:Ethernet HWaddr 08:00:27:xx:xx:xx

inet addr:200.100.10.10 Bcast:200.100.10.255 Mask:255.255.255.0

![alt text](https://imgur.com/jyBe0dF)

**Paso 1.5: Verificación Inicial de Conectividad**

**Desde Kali Linux**, intente hacer ping a las IPs que configurará en el
FortiGate:

ping -c 4 192.168.10.1

ping -c 4 200.100.10.10

**Resultado esperado**: Ambos pings deben FALLAR

**📋 Registro de Pruebas de Conectividad Inicial**

En los siguientes registros se adjuntan los resultados de los intentos de ping fallidos, donde se aprecia claramente que la conexión es **rechazada por ausencia de rutas** hacia los destinos solicitados:

``` bash
──(kali㉿kali)-[~]
└─$ ping -c 4 192.168.10.1
PING 192.168.10.1 (192.168.10.1) 56(84) bytes of data.
From 192.168.100.10 icmp_seq=1 Destination Host Unreachable
From 192.168.100.10 icmp_seq=2 Destination Host Unreachable
From 192.168.100.10 icmp_seq=3 Destination Host Unreachable
From 192.168.100.10 icmp_seq=4 Destination Host Unreachable

--- 192.168.10.1 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 3067ms
pipe 4
                                                                             
┌──(kali㉿kali)-[~]
└─$ ping -c 4 200.100.10.10
PING 200.100.10.10 (200.100.10.10) 56(84) bytes of data.
From 192.168.100.10 icmp_seq=1 Destination Host Unreachable
From 192.168.100.10 icmp_seq=2 Destination Host Unreachable
From 192.168.100.10 icmp_seq=3 Destination Host Unreachable
From 192.168.100.10 icmp_seq=4 Destination Host Unreachable

--- 200.100.10.10 ping statistics ---
4 packets transmitted, 0 received, +4 errors, 100% packet loss, time 3053ms
pipe 4
```

**📌 Análisis de Resultados**

| Aspecto | Observación |
|--------|-------------|
| **Estado de ICMP** | 100% packet loss en ambos destinos |
| **Motivo del rechazo** | Destination Host Unreachable (ausencia de interfaz activa) |
| **Causa raíz** | FortiGate no configurado aún; interfaces sin IPs asignadas |
| **Conclusión** | **ESPERADO Y CORRECTO** - Comportamiento baseline antes de implementar la configuración |

**Justificación técnica**: El kernel de Linux en Kali rechaza los paquetes ICMP porque no encuentra ruta disponible hacia los destinos 192.168.10.1 (port1 del FortiGate) ni 200.100.10.10 (Metasploitable2 en DMZ). Estos errores desaparecerán una vez que configuremos las interfaces de red y las políticas de firewall en el FortiGate.

**PREGUNTA DE VERIFICACIÓN #2**: ¿Por qué el ping a 200.100.10.10 falla
si Kali está en una red diferente (192.168.10.0/24)?

**FASE 2: Configuración Inicial del FortiGate (15 minutos)**

**Objetivo de la Fase**

Acceder al FortiGate por primera vez, configurar las interfaces de red
(port1 y port2) con sus respectivas IPs y zonas de seguridad.

**Paso 2.1: Primer Acceso al FortiGate**

**Inicie la VM del FortiGate**. Verá una consola de texto.

**Credenciales por defecto (Observe la pizarra)**

-   Usuario: 

-   Contraseña:

**Primer acceso**: El sistema le pedirá cambiar la contraseña.

You are forced to change your password. Please input a new password.

New Password: FortiGate2025!

Confirm Password: FortiGate2025!

**IMPORTANTE**: Anote esta contraseña, la necesitará durante toda la
práctica.

![alt text](https://imgur.com/t4kEjwG)
**\
**

**Paso 2.2: Configuración de la Interfaz port1 (LAN)**

**En la consola del FortiGate**, ejecute:

\# Entrar al modo de configuración

config system interface

edit port1

set mode static

set ip 192.168.10.1 255.255.255.0

set allowaccess ping https ssh http

set alias \"LAN\"

set role lan

next

end

**Explicación de cada comando**:

-   set mode static: Configura IP estática (vs DHCP)

-   set ip 192.168.10.1 255.255.255.0: Asigna IP y máscara

-   set allowaccess ping https ssh http: Permite gestión del firewall
    desde esta interfaz

-   set alias \"LAN\": Etiqueta descriptiva

-   set role lan: Define el rol de seguridad (importante para políticas)

**Verificar configuración**:

show system interface port1

**Salida esperada**:

config system interface

edit \"port1\"

set vdom \"root\"

set ip 192.168.10.1 255.255.255.0

set allowaccess ping https ssh http

set alias \"LAN\"

set role lan

\...

next

end

**PREGUNTA DE VERIFICACIÓN #3**: ¿Qué significa set allowaccess ping
https ssh http? ¿Qué pasaría si no incluyéramos https?

**\
**

**Paso 2.3: Configuración de la Interfaz port2 (DMZ)**

config system interface

edit port2

set mode static

set ip 200.100.10.1 255.255.255.0

set allowaccess ping

set alias \"DMZ\"

set role dmz

next

end

**Nota importante**: En port2 (DMZ) solo permitimos ping para gestión,
NO incluimos https/ssh/http por seguridad. La gestión del firewall debe
hacerse desde la LAN.

**Verificar**:

show system interface port2

![alt text](https://imgur.com/GREem3A)

**Paso 2.4: Verificación de Conectividad Básica**

**Desde Kali Linux**, ahora intente:

\# Ping al gateway (FortiGate port1)

ping -c 4 192.168.10.1

**Resultado esperado**: Debe funcionar (4 packets transmitted, 4
received)

\# Ping a Metasploitable2 (aún en otra red)

ping -c 4 200.100.10.10

**Resultado esperado**: Debe FALLAR (aún no hay políticas de firewall
que permitan tráfico entre zonas)

**Explicación**: El FortiGate responde en su interfaz LAN, pero por
defecto bloquea todo tráfico entre zonas hasta que creemos políticas
explícitas.

**Paso 2.5: Acceso a la Interfaz Gráfica (GUI)**

**Desde Kali Linux**, abra Firefox:

https://192.168.10.1

**Acepte el certificado autofirmado** (Add Exception → Confirm)

**Login**:

-   Usuario: admin

-   Contraseña: FortiGate2025! (la que configuró anteriormente)

![alt text](https://imgur.com/iZeNi5O)

![alt text](https://imgur.com/undefined)
**\
**

**Paso 2.6: Exploración de la Interfaz GUI**

**Navegue por estos menús** (solo observación, no modifique aún):

1.  **Dashboard**: Vista general del estado del firewall

2.  **Network → Interfaces**: Vea port1 y port2 configuradas

3.  **Policy & Objects → Firewall Policy**: Actualmente vacía (por eso
    no hay conectividad entre zonas)

4.  **Log & Report → Forward Traffic**: Logs de tráfico (vacío por
    ahora)

**PREGUNTA DE VERIFICACIÓN #4**: ¿Cuántas políticas de firewall existen
actualmente? ¿Por qué Kali no puede hacer ping a Metasploitable2?

**Paso 2.7: Configuración Opcional de port3 (WAN)**

**Solo si necesita acceso a Internet desde el FortiGate**:

config system interface

edit port3

set mode dhcp

set allowaccess ping

set alias \"WAN\"

set role wan

next

end

**Verificar que obtuvo IP:**

get system interface port3

**Nota**: Este paso es opcional para la práctica. Si no necesita
actualizaciones o acceso externo, puede omitirlo.

**FASE 3: Implementación de Políticas de Seguridad (50 minutos)**

**Objetivo de la Fase**

Configurar políticas de firewall progresivamente más complejas, desde
conectividad básica hasta control granular de servicios y políticas
asimétricas.

**Ejercicio 1: Interconexión Básica LAN ↔ DMZ (Ping Bidireccional)**

**Objetivo**

Permitir que Kali (LAN) y Metasploitable2 (DMZ) puedan hacerse ping
mutuamente.

**\
**

**Paso 3.1.1: Crear Política LAN → DMZ (Permitir Todo)**

**Vía GUI**:

1.  Navegue a: Policy & Objects → Firewall Policy

2.  Clic en Create New

3.  Configure:

  -------------------------------------------------------------------------
  Campo             Valor                  Explicación
  ----------------- ---------------------- --------------------------------
  Name              LAN_to_DMZ_Allow_All   Nombre descriptivo

  Incoming          port1 (LAN)            Origen del tráfico
  Interface                                

  Outgoing          port2 (DMZ)            Destino del tráfico
  Interface                                

  Source            all                    Cualquier IP de origen

  Destination       all                    Cualquier IP de destino

  Schedule          always                 Siempre activa

  Service           ALL                    Todos los servicios/puertos

  Action            ACCEPT                 Permitir tráfico

  NAT               Deshabilitado          No necesitamos NAT entre redes
                                           internas

  Log Allowed       Habilitado             Para auditoría
  Traffic                                  
  -------------------------------------------------------------------------

4.  Clic en OK

**Vía CLI** (alternativa):

config firewall policy

edit 1

set name \"LAN_to_DMZ_Allow_All\"

set srcintf \"port1\"

set dstintf \"port2\"

set srcaddr \"all\"

set dstaddr \"all\"

set action accept

set schedule \"always\"

set service \"ALL\"

set logtraffic all

next

end

![alt text](https://imgur.com/V7a7v8q)
**\
**

**Paso 3.1.2: Crear Política DMZ → LAN (Permitir Todo)**

**Repita el proceso anterior** con estos valores:

  -----------------------------------------------------------------------
  Campo                             Valor
  --------------------------------- -------------------------------------
  Name                              DMZ_to_LAN_Allow_All

  Incoming Interface                port2 (DMZ)

  Outgoing Interface                port1 (LAN)

  Source                            all

  Destination                       all

  Service                           ALL

  Action                            ACCEPT

  NAT                               Deshabilitado

  Log Allowed Traffic               Habilitado
  -----------------------------------------------------------------------

**Vía CLI**:

config firewall policy

edit 2

set name "DMZ_to_LAN_Allow_All"

set srcintf "port2"

set dstintf "port1"

set srcaddr "all"

set dstaddr "all"

set action accept

set schedule "always"

set service "ALL"

set logtraffic all

next

end

**Paso 3.1.3: Verificación de Conectividad**

**Desde Kali Linux**:

\# Ping a Metasploitable2

ping -c 4 200.100.10.10

**Resultado esperado**: Debe funcionar

PING 200.100.10.10 (200.100.10.10) 56(84) bytes of data.

64 bytes from 200.100.10.10: icmp_seq=1 ttl=63 time=0.5 ms

64 bytes from 200.100.10.10: icmp_seq=2 ttl=63 time=0.4 ms

\...

\-\-- 200.100.10.10 ping statistics \-\--

4 packets transmitted, 4 received, 0% packet loss

**Desde Metasploitable2**:

\# Ping a Kali

ping -c 4 192.168.10.10

**Resultado esperado**: Debe funcionar

NO FUNCIONA

![alt text](https://imgur.com/dDqfncw)

NO FUNCIONA

**Paso 3.1.4: Verificación en Logs del FortiGate**

**En la GUI del FortiGate**:

1.  Navegue a: Log & Report → Forward Traffic

2.  Observe las entradas de tráfico ICMP permitido

3.  Identifique:

    -   Source IP

    -   Destination IP

    -   Policy ID aplicada

    -   Action (accept)

**PREGUNTA DE VERIFICACIÓN #5**: ¿Qué Policy ID se aplicó al ping desde
Kali hacia Metasploitable2? ¿Y en la dirección inversa?

**Ejercicio 2: Restringir Gestión del Firewall (GUI Solo desde LAN)**

**Objetivo**

Permitir acceso a la GUI del FortiGate desde Kali (LAN) pero bloquearlo
desde Metasploitable2 (DMZ).

**Paso 3.2.1: Verificar Acceso Actual desde DMZ**

**Desde Metasploitable2**, intente acceder a la GUI:

\# Instalar curl si no está disponible

sudo apt-get update && sudo apt-get install -y curl

También puede hacer un wget como lo hemos venido haciendo en otras
prácticas.

\# Intentar acceso HTTPS al FortiGate

curl -k https://200.100.10.1

**Resultado actual**: Probablemente funcione (recibe HTML de la página
de login)

**Explicación**: Actualmente la política DMZ_to_LAN_Allow_All permite
todo tráfico, incluyendo HTTPS al FortiGate.

**\
**

**Paso 3.2.2: Modificar Configuración de port2 (DMZ)**

**Objetivo**: Remover el acceso de gestión desde la interfaz DMZ.

**Vía CLI** (recomendado para este cambio):

config system interface

edit port2

set allowaccess ping

\# Removemos https, ssh, http

next

end

**Vía GUI**:

1.  Network → Interfaces

2.  Editar port2

3.  En la sección **Administrative Access**:

    -   Mantener: PING

    -   Desmarcar: HTTPS, HTTP, SSH, SNMP, etc.

4.  OK

**CAPTURA REQUERIDA #8**: Screenshot de la configuración de
Administrative Access de port2 mostrando solo PING habilitado.

**Paso 3.2.3: Verificar Bloqueo desde DMZ**

**Desde Metasploitable2**:

\# Intentar acceso HTTPS

curl -k https://200.100.10.1 \--connect-timeout 5

**Resultado esperado**: Debe fallar (Connection timeout o refused)

**Desde Kali Linux**:

\# Verificar que SÍ funciona desde LAN

curl -k https://192.168.10.1 \| head -n 5

**Resultado esperado**: Debe funcionar (recibe HTML)

**PREGUNTA DE VERIFICACIÓN #6**: ¿Por qué bloqueamos la gestión desde
DMZ? ¿Qué riesgo de seguridad representa permitirla?

**Ejercicio 3: Permitir Solo SSH (LAN → DMZ)**

**Objetivo**

Bloquear todos los servicios excepto SSH desde Kali hacia
Metasploitable2.

**Paso 3.3.1: Eliminar Políticas Permisivas Actuales**

**Vía GUI**:

1.  Policy & Objects → Firewall Policy

2.  Seleccione la política LAN_to_DMZ_Allow_All (ID 1)

3.  Clic en Delete → Confirmar

4.  **NO elimine** DMZ_to_LAN_Allow_All (la modificaremos después)

**Vía CLI**:

config firewall policy

delete 1

end

**\
**

**Verificación inmediata** desde Kali:

ping -c 2 200.100.10.10

**Resultado esperado**: Debe fallar (no hay política que permita
tráfico)

**Paso 3.3.2: Crear Política Restrictiva (Solo SSH)**

**Vía GUI**:

1.  Policy & Objects → Firewall Policy

2.  Create New

3.  Configure:

  -----------------------------------------------------------------------
  Campo                   Valor
  ----------------------- -----------------------------------------------
  Name                    LAN_to_DMZ_SSH_Only

  Incoming Interface      port1

  Outgoing Interface      port2

  Source                  all

  Destination             all

  Schedule                always

  Service                 SSH (seleccionar del dropdown, NO \"ALL\")

  Action                  ACCEPT

  NAT                     Deshabilitado

  Log Allowed Traffic     Habilitado
  -----------------------------------------------------------------------

4.  OK

**Vía CLI**:

config firewall policy

edit 3

set name \"LAN_to_DMZ_SSH_Only\"

set srcintf \"port1\"

set dstintf \"port2\"

set srcaddr \"all\"

set dstaddr \"all\"

set action accept

set schedule \"always\"

set service \"SSH\"

set logtraffic all

next

end

**CAPTURA REQUERIDA #9**: Screenshot de la política mostrando claramente
que el servicio es **SSH** (no ALL).

**\
**

**Paso 3.3.3: Verificación de Servicios**

**Desde Kali Linux**:

**Test 1: SSH (debe funcionar)**

\# Intentar conexión SSH

ssh msfadmin@200.100.10.10

\# Password: msfadmin

**Resultado esperado**: Debe conectar exitosamente

The authenticity of host \'200.100.10.10 (200.100.10.10)\' can\'t be
established.

RSA key fingerprint is SHA256:\...

Are you sure you want to continue connecting (yes/no)? yes

msfadmin@200.100.10.10\'s password:

\...

msfadmin@metasploitable:\~\$

Salga de la sesión SSH: exit

**Test 2: HTTP (debe fallar)**

\# Intentar acceso web

curl http://200.100.10.10 \--connect-timeout 5

**Resultado esperado**: Debe fallar (Connection timeout)

**Test 3: ICMP/Ping (debe fallar)**

ping -c 2 200.100.10.10

**Resultado esperado**: Debe fallar (no packets received)

**Test 4: Escaneo de puertos con nmap**

sudo nmap -p 22,80,443 200.100.10.10

**Resultado esperado**:

PORT STATE SERVICE

22/tcp open ssh

80/tcp filtered http

443/tcp filtered https

**Explicación**:

-   open: Puerto accesible (SSH permitido por política)

-   filtered: Puerto bloqueado por firewall (HTTP/HTTPS bloqueados)

**CAPTURA REQUERIDA #10**: Screenshot mostrando SSH exitoso y curl/ping
fallando.

**PREGUNTA DE VERIFICACIÓN #7**: ¿Qué diferencia hay entre un puerto
\"filtered\" y \"closed\" en nmap? ¿Qué información revela esto sobre el
firewall?

**\
**

**Ejercicio 4: Política Asimétrica de ICMP (Ping Unidireccional)**

**Objetivo**

Permitir que Kali pueda hacer ping a Metasploitable2, pero que
Metasploitable2 NO pueda hacer ping a Kali.

**Paso 4.1: Modificar Política LAN → DMZ (Agregar ICMP)**

**Vía GUI**:

1.  Editar política LAN_to_DMZ_SSH_Only

2.  En el campo **Service**:

    -   Cambiar de SSH a Create New → Service Group

    -   Nombre del grupo: SSH_and_ICMP

    -   Miembros: SSH + PING (o ALL_ICMP)

3.  OK

**Vía CLI** (método alternativo - crear grupo de servicios):

\# Crear grupo de servicios

config firewall service group

edit \"SSH_and_ICMP\"

set member \"SSH\" \"PING\"

next

end

\# Modificar política para usar el grupo

config firewall policy

edit 3

set service \"SSH_and_ICMP\"

next

end

**Verificación**:

\# Desde Kali

ping -c 4 200.100.10.10

**Resultado esperado**: Debe funcionar

**\
**

**Paso 4.2: Modificar Política DMZ → LAN (Bloquear ICMP)**

**Actualmente** la política DMZ_to_LAN_Allow_All permite todo. Vamos a
restringirla.

**Opción A - Eliminar la política completamente**:

config firewall policy

delete 2

end

**Opción B - Modificarla para permitir solo tráfico establecido** (más
realista):

**Vía GUI**:

1.  Editar política DMZ_to_LAN_Allow_All

2.  Cambiar **Service** de ALL a servicios específicos que necesite (ej:
    HTTP, HTTPS para respuestas)

3.  O mejor: Eliminar esta política y confiar en el **stateful
    firewall** del FortiGate

**Explicación del Stateful Firewall**:

FortiGate es un firewall **stateful** (con estado). Esto significa:

-   Cuando Kali inicia una conexión SSH hacia Metasploitable2, el
    FortiGate **recuerda** esa sesión

-   Las respuestas de Metasploitable2 hacia Kali son **automáticamente
    permitidas** (tráfico de retorno)

-   **NO necesitamos** una política explícita DMZ → LAN para respuestas

Por lo tanto, **elimine la política DMZ → LAN**:

config firewall policy

delete 2

end

**Paso 4.3: Verificación de Asimetría**

**Test 1: Desde Kali → Metasploitable2**

ping -c 4 200.100.10.10

**Resultado esperado**: Funciona

**Test 2: Desde Metasploitable2 → Kali**

ping -c 4 192.168.10.10

**Resultado esperado**: Falla (Destination Host Unreachable o timeout)

**Test 3: Verificar que SSH sigue funcionando**

\# Desde Kali

ssh msfadmin@200.100.10.10

\# Dentro de la sesión SSH, ejecute:

whoami

exit

**Resultado esperado**: SSH funciona (el tráfico de retorno es permitido
automáticamente)

**CAPTURA REQUERIDA #11**: Screenshot mostrando:

-   Ping desde Kali exitoso

-   Ping desde Metasploitable2 fallando

-   SSH desde Kali funcionando

**PREGUNTA DE VERIFICACIÓN #8**: Explique con sus propias palabras cómo
el firewall stateful permite que SSH funcione sin necesidad de una
política DMZ → LAN explícita.

**Ejercicio 5: Cambiar Servicios Permitidos (Bloquear SSH, Permitir
HTTP/HTTPS)**

**Objetivo**

Modificar la política para bloquear SSH y permitir tráfico web (HTTP y
HTTPS).

**Paso 5.1: Modificar la Política Existente**

**Vía GUI**:

1.  Editar política LAN_to_DMZ_SSH_Only (ID 3)

2.  Cambiar **Name** a: LAN_to_DMZ_Web_Only

3.  Cambiar **Service**:

    -   Remover: SSH_and_ICMP

    -   Agregar: HTTP y HTTPS

    -   O usar el grupo predefinido: Web Access

4.  OK

**Vía CLI**:

config firewall policy

edit 3

set name \"LAN_to_DMZ_Web_Only\"

set service \"HTTP\" \"HTTPS\"

next

end

**CAPTURA REQUERIDA #12**: Screenshot de la política modificada
mostrando HTTP y HTTPS como servicios permitidos.

**\
**

**Paso 5.2: Verificación de Servicios**

**Test 1: SSH (debe fallar)**

ssh msfadmin@200.100.10.10

**Resultado esperado**: Connection timeout (el firewall bloquea el
intento)

**Test 2: HTTP (debe funcionar)**

curl http://200.100.10.10

**Resultado esperado**: Recibe HTML de la página de Metasploitable2

\<html\>

\<head\>

\<title\>Metasploitable2 - Linux\</title\>

\...

**Test 3: HTTPS (debe funcionar si está configurado)**

curl -k https://200.100.10.10

**Nota**: Metasploitable2 por defecto no tiene HTTPS habilitado. Si
falla, es esperado.

**Test 4: Acceso desde navegador**

En Kali, abra Firefox y navegue a:

http://200.100.10.10

**Resultado esperado**: Página web de Metasploitable2 carga
correctamente

**CAPTURA REQUERIDA #13**: Screenshot del navegador mostrando la página
web de Metasploitable2.

**Paso 5.3: Análisis de Logs**

**En FortiGate GUI**:

1.  Log & Report → Forward Traffic

2.  Filtre por:

    -   Source: 192.168.10.10

    -   Destination: 200.100.10.10

3.  Observe:

    -   Entradas con **Action: accept** para HTTP (puerto 80)

    -   Entradas con **Action: deny** para SSH (puerto 22) si intentó
        conectar

**PREGUNTA DE VERIFICACIÓN #9**: ¿Qué información adicional proporcionan
los logs además de accept/deny? Mencione al menos 3 campos útiles para
auditoría.

**\
**

**Ejercicio 6: Port Forwarding con Virtual IP (VIP)**

**Objetivo**

Configurar un Virtual IP para que cuando Kali acceda al puerto 1080 del
FortiGate, el tráfico sea redirigido al puerto 80 de Metasploitable2.

**Paso 6.1: Crear el Virtual IP (VIP)**

**Concepto**: Un VIP es un objeto que mapea una IP:puerto externa a una
IP:puerto interna diferente.

**Vía GUI**:

1.  Navegue a: Policy & Objects → Virtual IPs

2.  Clic en Create New → Virtual IP

3.  Configure:

  ------------------------------------------------------------------------
  Campo                      Valor              Explicación
  -------------------------- ------------------ --------------------------
  Name                       VIP_Web_Port1080   Nombre descriptivo

  Interface                  port1              Interfaz donde se
                                                \"escucha\"

  External IP Address/Range  192.168.10.1       IP del FortiGate en LAN

  Mapped IP Address/Range    200.100.10.10      IP real de Metasploitable2

  Port Forwarding            Habilitado         

  External Service Port      1080               Puerto \"público\"

  Map to Port                80                 Puerto real del servicio
  ------------------------------------------------------------------------

4.  OK

**Vía CLI**:

config firewall vip

edit \"VIP_Web_Port1080\"

set extip 192.168.10.1

set mappedip \"200.100.10.10\"

set extintf \"port1\"

set portforward enable

set extport 1080

set mappedport 80

next

end

**CAPTURA REQUERIDA #14**: Screenshot del VIP creado mostrando la
configuración de port forwarding.

**\
**

**Paso 6.2: Crear Política de Firewall para el VIP**

**Importante**: El VIP solo define el mapeo, pero necesitamos una
**política** que permita el tráfico.

**Vía GUI**:

1.  Policy & Objects → Firewall Policy

2.  Create New

3.  Configure:

  -----------------------------------------------------------------------
  Campo                 Valor
  --------------------- -------------------------------------------------
  Name                  LAN_to_VIP_Web

  Incoming Interface    port1

  Outgoing Interface    port2

  Source                all

  Destination           VIP_Web_Port1080 (seleccionar el VIP, NO \"all\")

  Schedule              always

  Service               HTTP

  Action                ACCEPT

  NAT                   Habilitado (Use Destination Interface Address)
  -----------------------------------------------------------------------

4.  OK

**Vía CLI**:

config firewall policy

edit 4

set name \"LAN_to_VIP_Web\"

set srcintf \"port1\"

set dstintf \"port2\"

set srcaddr \"all\"

set dstaddr \"VIP_Web_Port1080\"

set action accept

set schedule \"always\"

set service \"HTTP\"

set nat enable

next

end

**Nota Crítica**: El campo **Destination** debe ser el VIP, no \"all\".
Esto es fundamental para que el port forwarding funcione.

**Paso 6.3: Verificación del Port Forwarding**

**Desde Kali Linux**:

\# Acceder al puerto 1080 del FortiGate

curl http://192.168.10.1:1080

**Resultado esperado**: Recibe el HTML de Metasploitable2 (puerto 80)

\<html\>

\<head\>

\<title\>Metasploitable2 - Linux\</title\>

\...

**Desde navegador**:

http://192.168.10.1:1080

**Resultado esperado**: Página web de Metasploitable2 carga

**Verificación avanzada con tcpdump**:

En Metasploitable2, capture tráfico:

sudo tcpdump -i eth0 port 80 -n

Desde Kali, acceda al VIP:

curl http://192.168.10.1:1080

**En el tcpdump** debería ver:

IP 200.100.10.1.xxxxx \> 200.100.10.10.80: Flags \[S\], seq \...

**Observación importante**: La IP de origen es 200.100.10.1 (FortiGate
DMZ interface), NO 192.168.10.10 (Kali). Esto es porque el FortiGate
hace **SNAT** (Source NAT) además del DNAT.

**CAPTURA REQUERIDA #15**: Screenshot mostrando:

-   Comando curl exitoso al puerto 1080

-   Página web cargando en navegador desde puerto 1080

**PREGUNTA DE VERIFICACIÓN #10**: ¿Cuál es la diferencia entre DNAT
(Destination NAT) y SNAT (Source NAT)? ¿Cuál se aplica en este VIP?

**Ejercicio 7: DNS Filtering (Filtrado de Categorías)**

**Objetivo**

Configurar el FortiGate para bloquear categorías específicas de sitios
web utilizando FortiGuard DNS Filtering.

**Paso 7.1: Crear un Perfil de DNS Filter**

**Vía GUI**:

1.  Navegue a: Security Profiles → DNS Filter

2.  Clic en Create New

3.  Configure:

  -----------------------------------------------------------------------
  Campo                                       Valor
  ------------------------------------------- ---------------------------
  Name                                        Block_Malicious_Sites

  FortiGuard Category Based Filter            Habilitado
  -----------------------------------------------------------------------

4.  En la tabla de categorías, configure:

  -----------------------------------------------------------------------
  Categoría                                                Acción
  -------------------------------------------------------- --------------
  Malicious Websites                                       Block

  Phishing                                                 Block

  Spam URLs                                                Block

  Adult/Mature Content (opcional)                          Block

  Gambling (opcional)                                      Block
  -----------------------------------------------------------------------

5.  En **DNS Translation**:

    -   **Redirect Portal**: (dejar por defecto o personalizar mensaje
        de bloqueo)

6.  OK

**Vía CLI**:

config dnsfilter profile

edit \"Block_Malicious_Sites\"

config ftgd-dns

config filters

edit 1

set category 26

set action block

next

edit 2

set category 61

set action block

next

edit 3

set category 86

set action block

next

end

end

next

end

**Nota**: Los números de categoría (26, 61, 86) corresponden a
Malicious, Phishing, Spam. Consulte la documentación de FortiGuard para
IDs completos.

**CAPTURA REQUERIDA #16**: Screenshot del perfil de DNS Filter mostrando
las categorías bloqueadas.

**Paso 7.2: Aplicar el Perfil a una Política**

**Vía GUI**:

1.  Edite la política LAN_to_DMZ_Web_Only (ID 3)

2.  En la sección **Security Profiles**:

    -   Habilite **DNS Filter**

    -   Seleccione el perfil: Block_Malicious_Sites

3.  OK

**Vía CLI**:

config firewall policy

edit 3

set dnsfilter-profile \"Block_Malicious_Sites\"

next

end

**\
**

**Paso 7.3: Configurar Kali para Usar FortiGate como DNS**

Para que el DNS filtering funcione, Kali debe usar el FortiGate como
servidor DNS.

**En Kali Linux**:

\# Editar configuración de red

sudo nano /etc/resolv.conf

Reemplace el contenido con:

nameserver 192.168.10.1

Guarde y cierre.

**Verificar**:

cat /etc/resolv.conf

**Alternativa permanente** (editar /etc/network/interfaces):

sudo nano /etc/network/interfaces

Agregue/modifique:

auto eth0

iface eth0 inet static

address 192.168.10.10

netmask 255.255.255.0

gateway 192.168.10.1

dns-nameservers 192.168.10.1

**Paso 7.4: Verificación del DNS Filtering**

**Test básico** (si tiene conectividad):

\# Intentar resolver un dominio malicioso conocido (ejemplo ficticio)

nslookup malicious-test-domain.com

\# Intentar acceder a un sitio de prueba de phishing

curl http://testphishing.com

**Resultado esperado**:

-   El FortiGate debería bloquear la resolución DNS

-   O redirigir a una página de bloqueo

**Verificación en logs**:

1.  Log & Report → Security Events → DNS Query

2.  Busque entradas con **Action: blocked**

**CAPTURA REQUERIDA #17**: Screenshot de los logs mostrando una consulta
DNS bloqueada (si es posible en su entorno).

**PREGUNTA DE VERIFICACIÓN #11**: ¿Cuál es la ventaja de usar DNS
filtering en el firewall en lugar de solo bloquear IPs? ¿Qué
limitaciones tiene?

**\
**

**Ejercicio 8: IPv4 Policy con Objetos (Address Objects y Service
Groups)**

**Objetivo**

Crear objetos reutilizables (direcciones y servicios) para hacer las
políticas más mantenibles y escalables.

**Paso 8.1: Crear Address Objects**

**Vía GUI**:

1.  Navegue a: Policy & Objects → Addresses

2.  Clic en Create New → Address

**Objeto 1: Kali Linux**

  -----------------------------------------------------------------------
  Campo                         Valor
  ----------------------------- -----------------------------------------
  Name                          Host_Kali

  Type                          Subnet

  IP/Netmask                    192.168.10.10/32

  Interface                     port1
  -----------------------------------------------------------------------

3.  OK

**Objeto 2: Metasploitable2**

  -----------------------------------------------------------------------
  Campo                       Valor
  --------------------------- -------------------------------------------
  Name                        Host_Metasploitable

  Type                        Subnet

  IP/Netmask                  200.100.10.10/32

  Interface                   port2
  -----------------------------------------------------------------------

4.  OK

**Objeto 3: Red LAN completa**

  -----------------------------------------------------------------------
  Campo                          Valor
  ------------------------------ ----------------------------------------
  Name                           Net_LAN

  Type                           Subnet

  IP/Netmask                     192.168.10.0/24

  Interface                      port1
  -----------------------------------------------------------------------

5.  OK

**Vía CLI**:

config firewall address

edit \"Host_Kali\"

set subnet 192.168.10.10 255.255.255.255

set associated-interface \"port1\"

next

edit \"Host_Metasploitable\"

set subnet 200.100.10.10 255.255.255.255

set associated-interface \"port2\"

next

edit \"Net_LAN\"

set subnet 192.168.10.0 255.255.255.0

set associated-interface \"port1\"

next

end

**CAPTURA REQUERIDA #18**: Screenshot mostrando los 3 address objects
creados.

**Paso 8.2: Crear Address Group**

**Vía GUI**:

1.  Policy & Objects → Addresses

2.  Clic en Create New → Address Group

3.  Configure:

  -----------------------------------------------------------------------
  Campo              Valor
  ------------------ ----------------------------------------------------
  Name               Group_Internal_Hosts

  Members            Host_Kali, Host_Metasploitable
  -----------------------------------------------------------------------

4.  OK

**Vía CLI**:

config firewall addrgrp

edit \"Group_Internal_Hosts\"

set member \"Host_Kali\" \"Host_Metasploitable\"

next

end

**Paso 8.3: Crear Service Objects**

**Vía GUI**:

1.  Policy & Objects → Services

2.  Clic en Create New → Service

**Servicio personalizado: Web Admin**

  -----------------------------------------------------------------------
  Campo                              Valor
  ---------------------------------- ------------------------------------
  Name                               Web_Admin_8080

  Protocol                           TCP

  Destination Port                   8080
  -----------------------------------------------------------------------

3.  OK

**Vía CLI**:

config firewall service custom

edit \"Web_Admin_8080\"

set tcp-portrange 8080

next

end

**Paso 8.4: Crear Service Group**

**Vía GUI**:

1.  Policy & Objects → Services

2.  Clic en Create New → Service Group

3.  Configure:

  -----------------------------------------------------------------------
  Campo             Valor
  ----------------- -----------------------------------------------------
  Name              Group_Web_Services

  Members           HTTP, HTTPS, Web_Admin_8080
  -----------------------------------------------------------------------

4.  OK

**Vía CLI**:

config firewall service group

edit \"Group_Web_Services\"

set member \"HTTP\" \"HTTPS\" \"Web_Admin_8080\"

next

end

**CAPTURA REQUERIDA #19**: Screenshot del service group mostrando los 3
servicios.

**Paso 8.5: Crear Política Usando Objetos**

**Vía GUI**:

1.  Policy & Objects → Firewall Policy

2.  Create New

3.  Configure:

  -----------------------------------------------------------------------
  Campo                         Valor
  ----------------------------- -----------------------------------------
  Name                          Kali_to_Meta_Web_Services

  Incoming Interface            port1

  Outgoing Interface            port2

  Source                        Host_Kali (objeto, no \"all\")

  Destination                   Host_Metasploitable (objeto)

  Schedule                      always

  Service                       Group_Web_Services (grupo)

  Action                        ACCEPT

  Log Allowed Traffic           Habilitado
  -----------------------------------------------------------------------

4.  OK

**Vía CLI**:

config firewall policy

edit 5

set name \"Kali_to_Meta_Web_Services\"

set srcintf \"port1\"

set dstintf \"port2\"

set srcaddr \"Host_Kali\"

set dstaddr \"Host_Metasploitable\"

set action accept

set schedule \"always\"

set service \"Group_Web_Services\"

set logtraffic all

next

end

**CAPTURA REQUERIDA #20**: Screenshot de la política mostrando el uso de
objetos en Source, Destination y Service.

**\
**

**Paso 8.6: Verificación y Ventajas**

**Test**:

\# Desde Kali

curl http://200.100.10.10

**Resultado esperado**: Funciona (la política con objetos permite HTTP)

**Ventajas de usar objetos**:

1.  **Reutilización**: Un objeto puede usarse en múltiples políticas

2.  **Mantenibilidad**: Si la IP de Kali cambia, solo actualiza el
    objeto Host_Kali

3.  **Claridad**: Las políticas son más legibles
    (Host_Kali vs 192.168.10.10)

4.  **Escalabilidad**: Fácil agregar/remover miembros de grupos

**PREGUNTA DE VERIFICACIÓN #12**: Si necesita cambiar la IP de
Metasploitable2, ¿cuántos lugares debe modificar si usa objetos vs si
usa IPs directamente en políticas?

**Ejercicio 9: Policy Routing (Enrutamiento Basado en Políticas)**

**Objetivo**

Configurar policy routing para que el tráfico desde Kali hacia un
destino específico use una ruta diferente (útil para balanceo de carga o
ISPs múltiples).

**Paso 9.1: Escenario de Policy Routing**

**Contexto**: Imagine que tiene dos conexiones WAN:

-   **port3**: ISP Principal (ya configurado con NAT)

-   **port4**: ISP Secundario (hipotético para este ejercicio)

**Objetivo**: Todo el tráfico desde Kali hacia Internet usa port3,
**EXCEPTO** tráfico hacia un rango específico (ej: 8.8.8.0/24) que debe
usar port4.

**Nota**: Como probablemente solo tiene port3 configurado, este
ejercicio será **conceptual/demostrativo**. Si no tiene port4, puede
simular con port2 para fines educativos.

**Paso 9.2: Crear una Ruta Estática Específica**

**Vía GUI**:

1.  Navegue a: Network → Static Routes

2.  Clic en Create New

3.  Configure:

  -----------------------------------------------------------------------
  Campo                   Valor
  ----------------------- -----------------------------------------------
  Destination             8.8.8.0/24

  Gateway Address         200.100.10.10 (Metasploitable como gateway
                          ficticio)

  Interface               port2

  Administrative Distance 10 (menor que la ruta por defecto)
  -----------------------------------------------------------------------

4.  OK

**\
**

**Vía CLI**:

config router static

edit 1

set dst 8.8.8.0 255.255.255.0

set gateway 200.100.10.10

set device \"port2\"

set distance 10

next

end

**Paso 9.3: Crear Policy Route**

**Vía GUI**:

1.  Navegue a: Network → Policy Routes

2.  Clic en Create New

3.  Configure:

  -----------------------------------------------------------------------
  Campo                     Valor
  ------------------------- ---------------------------------------------
  Incoming Interface        port1

  Source Address            Host_Kali

  Destination Address       8.8.8.0/24 (crear objeto si no existe)

  Protocol                  Any

  Gateway Address           200.100.10.10

  Outgoing Interface        port2
  -----------------------------------------------------------------------

4.  OK

**Vía CLI**:

config router policy

edit 1

set input-device \"port1\"

set src \"192.168.10.10/32\"

set dst \"8.8.8.0/24\"

set gateway 200.100.10.10

set output-device \"port2\"

next

end

**CAPTURA REQUERIDA #21**: Screenshot de la policy route configurada.

**Paso 9.4: Verificación (Conceptual)**

**Test**:

\# Desde Kali, intentar acceder a 8.8.8.8 (Google DNS)

ping -c 2 8.8.8.8

\# Verificar ruta tomada

traceroute 8.8.8.8

**Resultado esperado** (en un entorno completo):

-   El primer salto sería 200.100.10.10 (Metasploitable)

-   En lugar del gateway por defecto 192.168.10.1

**En logs del FortiGate**:

1.  Log & Report → Forward Traffic

2.  Filtre por destination 8.8.8.8

3.  Verifique que la **Outgoing Interface** sea port2

**PREGUNTA DE VERIFICACIÓN #13**: ¿En qué escenarios reales sería útil
el policy routing? Mencione al menos 2 casos de uso empresariales.

**Ejercicio 10: Web Proxy Transparente**

**Objetivo**

Configurar el FortiGate como proxy web transparente para inspeccionar y
controlar el tráfico HTTP/HTTPS desde la LAN.

**Paso 10.1: Habilitar Web Proxy Explícito**

**Vía GUI**:

1.  Navegue a: Network → Explicit Proxy

2.  Configure:

  -----------------------------------------------------------------------
  Campo                                         Valor
  --------------------------------------------- -------------------------
  Explicit Web Proxy                            Habilitado

  HTTP Port                                     8080

  HTTPS Port                                    8443

  Incoming Interface                            port1
  -----------------------------------------------------------------------

3.  OK

**Vía CLI**:

config web-proxy explicit

set status enable

set http-incoming-port 8080

set https-incoming-port 8443

set incoming-ip 192.168.10.1

end

**Paso 10.2: Crear Perfil de Web Filter**

**Vía GUI**:

1.  Navegue a: Security Profiles → Web Filter

2.  Clic en Create New

3.  Configure:

  -----------------------------------------------------------------------
  Campo                                        Valor
  -------------------------------------------- --------------------------
  Name                                         Block_Social_Media

  FortiGuard Category Based Filter             Habilitado
  -----------------------------------------------------------------------

4.  En la tabla de categorías:

  -----------------------------------------------------------------------
  Categoría                                              Acción
  ------------------------------------------------------ ----------------
  Social Networking                                      Block

  Instant Messaging                                      Block

  Web-based Email (opcional)                             Monitor
  -----------------------------------------------------------------------

5.  En **Static URL Filter** (opcional):

    -   Agregar URLs específicas para bloquear (ej: \*.facebook.com)

6.  OK

**Vía CLI**:

config webfilter profile

edit \"Block_Social_Media\"

config ftgd-wf

config filters

edit 1

set category 5

set action block

next

edit 2

set category 52

set action block

next

end

end

next

end

**CAPTURA REQUERIDA #22**: Screenshot del perfil de Web Filter mostrando
las categorías bloqueadas.

**Paso 10.3: Aplicar Web Filter a Política**

**Vía GUI**:

1.  Edite una política existente que permita tráfico web
    (ej: LAN_to_DMZ_Web_Only)

2.  En **Security Profiles**:

    -   Habilite **Web Filter**

    -   Seleccione: Block_Social_Media

3.  OK

**Vía CLI**:

config firewall policy

edit 3

set webfilter-profile \"Block_Social_Media\"

next

end

**Paso 10.4: Configurar Proxy Transparente (Modo Transparente)**

**Para hacer el proxy verdaderamente transparente** (sin configuración
en clientes):

**Vía GUI**:

1.  Navegue a: Network → Explicit Proxy

2.  En **Transparent Mode**:

    -   Habilitar **Transparent Mode**

    -   Interfaces: Seleccionar port1

**Vía CLI**:

config web-proxy global

set proxy-fqdn \"fortigate.local\"

set max-message-length 32

end

config firewall proxy-policy

edit 1

set proxy explicit-web

set dstintf \"port2\"

set srcaddr \"Net_LAN\"

set dstaddr \"all\"

set service \"webproxy\"

set action accept

set schedule \"always\"

set webfilter-profile \"Block_Social_Media\"

next

end

**Nota**: El modo transparente requiere configuración adicional de
políticas de proxy específicas.

**Paso 10.5: Verificación del Web Proxy**

**Limitación**: Para probar completamente, necesitaría acceso a sitios
de redes sociales (requiere Internet).

**Test básico** (si tiene conectividad):

\# Desde Kali, intentar acceder a un sitio bloqueado

curl http://www.facebook.com

**Resultado esperado**:

-   Página de bloqueo del FortiGate

-   O error de conexión

**Verificación en logs**:

1.  Log & Report → Security Events → Web Filter

2.  Busque entradas con:

    -   **URL**: facebook.com

    -   **Action**: blocked

    -   **Category**: Social Networking

**CAPTURA REQUERIDA #23**: Screenshot de los logs de Web Filter
mostrando un bloqueo (si es posible).

**PREGUNTA DE VERIFICACIÓN #14**: ¿Cuál es la diferencia entre un proxy
explícito y un proxy transparente? ¿Cuál es más fácil de implementar en
una organización?

**FASE 4: Análisis Avanzado y Optimización (10 minutos)**

**Objetivo de la Fase**

Optimizar las políticas creadas, analizar el orden de evaluación y
comprender el impacto en el rendimiento.

**\
**

**Paso 4.1: Análisis del Orden de Políticas**

**Concepto crítico**: FortiGate evalúa las políticas **de arriba hacia
abajo**. La primera política que coincide con el tráfico es la que se
aplica.

**Vía GUI**:

1.  Policy & Objects → Firewall Policy

2.  Observe el orden actual de sus políticas

**Ejemplo de orden ineficiente**:

1\. LAN_to_DMZ_Allow_All (Service: ALL)

2\. LAN_to_DMZ_SSH_Only (Service: SSH)

**Problema**: La política #2 **nunca se evaluará** porque #1 ya permite
todo.

**Orden correcto**:

1\. LAN_to_DMZ_SSH_Only (Service: SSH)

2\. LAN_to_DMZ_Allow_All (Service: ALL)

**Paso 4.2: Reordenar Políticas**

**Vía GUI**:

1.  En la lista de políticas, use los íconos de **flechas
    arriba/abajo** para reordenar

2.  Coloque las políticas **más específicas primero**

3.  Políticas generales (deny all, allow all) al final

**Vía CLI**:

config firewall policy

move 5 before 3

end

**Best Practice**: Orden recomendado:

1.  **Políticas de gestión** (acceso a GUI/SSH del firewall)

2.  **Políticas específicas por host** (Host_Kali → Host_Metasploitable)

3.  **Políticas por servicio** (SSH only, Web only)

4.  **Políticas de red completa** (Net_LAN → DMZ)

5.  **Política de denegación implícita** (opcional, FortiGate ya tiene
    deny implícito)

**CAPTURA REQUERIDA #24**: Screenshot mostrando el orden final de todas
sus políticas.

**Paso 4.3: Consolidación de Políticas**

**Identifique políticas redundantes** que puedan combinarse:

**Ejemplo**:

Política A: Kali → Meta, Service: HTTP

Política B: Kali → Meta, Service: HTTPS

**Consolidar en**:

Política C: Kali → Meta, Service: Group_Web_Services (HTTP + HTTPS)

**Acción**:

1.  Elimine políticas redundantes

2.  Use service groups para combinar servicios similares

3.  Use address groups para combinar hosts con mismo nivel de acceso

**PREGUNTA DE VERIFICACIÓN #15**: ¿Por qué es importante mantener el
número de políticas al mínimo? ¿Qué impacto tiene en el rendimiento?

**Paso 4.4: Habilitar Session Helpers (Opcional)**

**Para protocolos complejos** que requieren múltiples conexiones (FTP,
SIP, H.323):

**Vía CLI**:

config system session-helper

show

end

**Ejemplo - Habilitar FTP helper**:

config system session-helper

edit 1

set name \"ftp\"

set protocol 6

set port 21

next

end

**Nota**: Esto es avanzado y solo necesario para protocolos específicos.

**FASE 5: Verificación, Troubleshooting y Análisis de Logs (15
minutos)**

**Objetivo de la Fase**

Dominar las herramientas de diagnóstico del FortiGate para resolver
problemas y auditar el tráfico.

**Paso 5.1: Revisión Completa de Logs**

**Log de Forward Traffic**:

1.  Log & Report → Forward Traffic

2.  Configure filtros:

    -   **Time Range**: Last 1 Hour

    -   **Source**: 192.168.10.10

    -   **Action**: All

**Columnas importantes**:

  ------------------------------------------------------------------------
  Columna              Descripción           Uso
  -------------------- --------------------- -----------------------------
  Time                 Timestamp del evento  Correlación temporal

  Source               IP origen             Identificar quién generó
                                             tráfico

  Destination          IP destino            Identificar objetivo

  Service              Puerto/protocolo      Qué servicio se usó

  Action               accept/deny           Si fue permitido o bloqueado

  Policy               ID de política        Qué regla se usó
                       aplicada              

  Bytes Sent/Received  Volumen de datos      Detectar transferencias
                                             grandes
  ------------------------------------------------------------------------

**CAPTURA REQUERIDA #25**: Screenshot de los logs de Forward Traffic
mostrando al menos 5 entradas diferentes.

**\
**

**Paso 5.2: Análisis de Sesiones Activas**

**Vía GUI**:

1.  Dashboard → Sessions widget

2.  O navegue a: Log & Report → System Events → Sessions

**Vía CLI** (más detallado):

\# Ver todas las sesiones activas

diagnose sys session list

\# Filtrar por IP específica

diagnose sys session filter src 192.168.10.10

diagnose sys session list

\# Ver estadísticas de sesiones

diagnose sys session stat

**Salida ejemplo**:

session info: proto=6 proto_state=01 duration=12 expire=3599
timeout=3600

src=192.168.10.10:45678 dst=200.100.10.10:80

origin-shaper=

reply-shaper=

per_ip_shaper=

class_id=0 ha_id=0 policy_dir=0 tunnel=/ vlan_cos=0/255

state=may_dirty npu

statistic(bytes/packets/allow_err): org=245/5/1 reply=1024/8/1 tuples=2

tx speed(Bps/kbps): 20/0 rx speed(Bps/kbps): 85/0

orgin-\>sink: org pre-\>post, reply pre-\>post dev=4-\>5/5-\>4
gwy=200.100.10.10/192.168.10.10

hook=post dir=org act=snat
192.168.10.10:45678-\>200.100.10.1:45678(200.100.10.10:80)

hook=pre dir=reply act=dnat
200.100.10.10:80-\>200.100.10.1:45678(192.168.10.10:45678)

pos/(before,after) 0/(0,0), 0/(0,0)

misc=0 policy_id=3 auth_info=0 chk_client_info=0 vd=0

serial=00000abc tos=ff/ff app_list=0 app=0 url_cat=0

**Información clave**:

-   **proto=6**: TCP (17 sería UDP)

-   **src/dst**: IPs y puertos

-   **policy_id=3**: Política que permitió la sesión

-   **act=snat/dnat**: NAT aplicado

**PREGUNTA DE VERIFICACIÓN #16**: ¿Qué significa que una sesión tenga
act=snat? ¿En qué ejercicio de esta práctica vimos SNAT?

**\
**

**Paso 5.3: Packet Capture (Sniffer)**

**Herramienta más poderosa para troubleshooting**: Capturar paquetes
directamente en el FortiGate.

**Vía CLI**:

\# Captura básica en port1

diagnose sniffer packet port1 \'host 192.168.10.10\' 4 100

\# Parámetros:

\# port1: Interfaz a capturar

\# \'host 192.168.10.10\': Filtro BPF (Berkeley Packet Filter)

\# 4: Nivel de detalle (1-6, 4 es recomendado)

\# 100: Número de paquetes a capturar

**Niveles de detalle**:

  -----------------------------------------------------------------------
  Nivel      Información mostrada
  ---------- ------------------------------------------------------------
  1          Solo headers básicos

  2          Headers + tamaño de payload

  3          Headers + primeros bytes de payload

  4          Headers + payload completo (hex)

  5          Formato completo con ASCII

  6          Máximo detalle (puede ser abrumador)
  -----------------------------------------------------------------------

**Ejemplo de captura**:

\# Capturar tráfico HTTP desde Kali

diagnose sniffer packet port1 \'host 192.168.10.10 and port 80\' 4 50

**Mientras corre el sniffer**, desde Kali ejecute:

curl http://200.100.10.10

**Salida esperada en FortiGate**:

2024-12-08 12:34:56.123456 port1 in 192.168.10.10.45678 -\>
200.100.10.10.80: syn 1234567890

2024-12-08 12:34:56.123789 port2 out 200.100.10.1.45678 -\>
200.100.10.10.80: syn 1234567890

2024-12-08 12:34:56.124012 port2 in 200.100.10.10.80 -\>
200.100.10.1.45678: syn ack 1234567891

2024-12-08 12:34:56.124234 port1 out 200.100.10.10.80 -\>
192.168.10.10.45678: syn ack 1234567891

**Análisis**:

-   Línea 1: Paquete SYN entra por port1 (Kali inicia conexión)

-   Línea 2: FortiGate reenvía por port2 con SNAT (IP origen cambia a
    200.100.10.1)

-   Línea 3: Metasploitable responde SYN-ACK

-   Línea 4: FortiGate reenvía respuesta a Kali

**CAPTURA REQUERIDA #26**: Screenshot de una captura de paquetes
mostrando el three-way handshake de TCP.

**Paso 5.4: Debug Flow (Seguimiento de Decisiones del Firewall)**

**Herramienta avanzada**: Ver exactamente cómo el FortiGate procesa un
paquete.

**Vía CLI**:

\# Configurar debug para una IP específica

diagnose debug flow filter addr 192.168.10.10

diagnose debug flow filter port 80

diagnose debug flow show function-name enable

diagnose debug flow show iprope enable

diagnose debug flow trace start 10

diagnose debug enable

**Mientras el debug está activo**, desde Kali:

curl http://200.100.10.10

**Salida esperada en FortiGate**:

id=20085 trace_id=123 func=print_pkt_detail line=5620 msg=\"vd-root:0
received a packet(proto=6, 192.168.10.10:45678-\>200.100.10.10:80) from
port1.\"

id=20085 trace_id=123 func=resolve_ip_tuple_fast line=5680 msg=\"Find an
existing session, id-00ab1234, original direction\"

id=20085 trace_id=123 func=vf_ip_route_input_common line=2605 msg=\"find
a route: flag=04000000 gw-200.100.10.10 via port2\"

id=20085 trace_id=123 func=fw_forward_handler line=770 msg=\"Allowed by
Policy-3: SNAT\"

id=20085 trace_id=123 func=ip_session_handle_no_offload line=5844
msg=\"SNAT 192.168.10.10:45678-\>200.100.10.1:45678\"

**Información crítica**:

-   **received a packet**: Paquete entrante

-   **Find an existing session**: Sesión ya existe (stateful)

-   **find a route**: Decisión de routing

-   **Allowed by Policy-3**: Política que permitió el tráfico

-   **SNAT**: NAT aplicado

**Detener debug**:

diagnose debug flow trace stop

diagnose debug disable

diagnose debug reset

**PREGUNTA DE VERIFICACIÓN #17**: ¿En qué situación usarías diagnose
debug flow en lugar de diagnose sniffer packet?

**\
**

**Paso 5.5: Troubleshooting de Problemas Comunes**

**Tabla de Resolución de Problemas**:

  ------------------------------------------------------------------------
  Síntoma      Causa Probable     Solución              Comando de
                                                        Verificación
  ------------ ------------------ --------------------- ------------------
  Ping no      No hay política    Crear política con    diagnose debug
  funciona     que permita ICMP   servicio PING         flow

  SSH timeout  Política bloquea   Verificar servicio en show firewall
               puerto 22          política              policy

  Web lenta    Inspección SSL     Deshabilitar SSL      diagnose sys top
               activa             inspection            
                                  temporalmente         

  No aparece   Logging            Habilitar set         show firewall
  en logs      deshabilitado en   logtraffic all        policy X
               política                                 

  Política no  Orden incorrecto   Mover política más    config firewall
  aplica       de políticas       arriba                policy; move X
                                                        before Y

  NAT no       set nat enable no  Habilitar NAT en      show firewall
  funciona     configurado        política              policy X

  DNS no       FortiGate no tiene Configurar DNS        show system dns
  resuelve     DNS configurado    servers               

  VIP no       Política no usa    Cambiar dstaddr a VIP show firewall
  responde     VIP como destino   object                policy
  ------------------------------------------------------------------------

**Paso 5.6: Verificación de Salud del Sistema**

**Vía CLI**:

\# Estado general del sistema

get system status

\# Uso de CPU y memoria

diagnose sys top

\# Estadísticas de interfaces

diagnose hardware deviceinfo nic port1

diagnose hardware deviceinfo nic port2

\# Tabla de sesiones

diagnose sys session stat

\# Contadores de políticas (cuántos paquetes por política)

diagnose firewall iprope list 100

**\
**

**Salida de get system status**:

Version: FortiGate-VM64 v7.0.0,build0157,201029 (GA)

Virus-DB: 1.00000(2020-10-30 00:00)

Extended DB: 1.00000(2020-10-30 00:00)

IPS-DB: 6.00741(2015-12-01 02:30)

Serial-Number: FGVMEVZFNTS8B7C2

BIOS version: 04000002

Log hard disk: Available

Hostname: FortiGate-Firewall

Operation Mode: NAT

Current virtual domain: root

Max number of virtual domains: 1

Virtual domains status: 1 in NAT mode, 0 in TP mode

Virtual domain configuration: disable

FIPS-CC mode: disable

Current HA mode: standalone

\...

**CAPTURA REQUERIDA #27**: Screenshot de la salida de get system status.

**Tabla de Verificación Final**

**Complete esta tabla para confirmar que todos los ejercicios
funcionan**:

  --------------------------------------------------------------------------------
  \#   Ejercicio       Desde   Hacia            Servicio     ¿Funciona?   Policy
                                                                          ID
  ---- --------------- ------- ---------------- ------------ ------------ --------
  1    Ping            Kali    Meta             ICMP                      
       bidireccional                                                      

  1    Ping            Meta    Kali             ICMP                      
       bidireccional                                                      

  2    Gestión GUI     Kali    FortiGate        HTTPS                     N/A

  2    Gestión GUI     Meta    FortiGate        HTTPS                     N/A

  3    SSH only        Kali    Meta             SSH                       

  3    HTTP bloqueado  Kali    Meta             HTTP                      

  4    Ping asimétrico Kali    Meta             ICMP                      

  4    Ping asimétrico Meta    Kali             ICMP                      

  5    Web permitido   Kali    Meta             HTTP/HTTPS                

  5    SSH bloqueado   Kali    Meta             SSH                       

  6    Port forwarding Kali    FortiGate:1080   HTTP                      

  8    Política con    Kali    Meta             Web Services              
       objetos                                                            
  --------------------------------------------------------------------------------

**CAPTURA REQUERIDA #28**: Screenshot de esta tabla completada con sus
resultados.

**Errores Comunes y Soluciones**

**Error 1: \"No se puede acceder a la GUI del FortiGate\"**

**Síntomas**:

curl https://192.168.10.1

curl: (7) Failed to connect to 192.168.10.1 port 443: Connection refused

**Causas posibles**:

1.  **Interfaz no configurada correctamente**

\# Verificar

show system interface port1

\# Solución

config system interface

edit port1

set allowaccess https ping

next

end

2.  **IP incorrecta en Kali**

\# Verificar

ip addr show eth0

\# Debe mostrar 192.168.10.10

3.  **Adaptador de red en VirtualBox mal configurado**

    -   Verificar que Kali y FortiGate estén en LAN_Segment

**Error 2: \"Ping funciona pero SSH no\"**

**Síntomas**:

ping 200.100.10.10 \# Funciona

ssh msfadmin@200.100.10.10 \# Timeout

**Causas posibles**:

1.  **Política no incluye servicio SSH**

\# Verificar

show firewall policy

\# Buscar la política LAN→DMZ y verificar campo \"service\"

2.  **SSH no está corriendo en Metasploitable2**

\# En Metasploitable2

sudo service ssh status

\# Si no está corriendo:

sudo service ssh start

3.  **Orden de políticas incorrecto**

    -   Una política más general (allow all) puede estar antes de la
        específica (SSH only)

**\
**

**Error 3: \"VIP no funciona (port forwarding)\"**

**Síntomas**:

curl http://192.168.10.1:1080

curl: (7) Failed to connect to 192.168.10.1 port 1080: Connection
refused

**Causas posibles**:

1.  **Política no usa el VIP como destino**

\# Verificar

show firewall policy

\# El campo \"dstaddr\" DEBE ser el nombre del VIP, no \"all\"

\# Solución

config firewall policy

edit X

set dstaddr \"VIP_Web_Port1080\"

next

end

2.  **NAT no habilitado en la política**

config firewall policy

edit X

set nat enable

next

end

3.  **VIP mal configurado**

show firewall vip

\# Verificar:

\# - extip: 192.168.10.1

\# - mappedip: 200.100.10.10

\# - portforward: enable

\# - extport: 1080

\# - mappedport: 80

**Error 4: \"Logs no aparecen\"**

**Síntomas**: No hay entradas en Forward Traffic logs.

**Causas posibles**:

1.  **Logging deshabilitado en política**

config firewall policy

edit X

set logtraffic all

next

end

2.  **Filtros de log muy restrictivos**

    -   En GUI, remover todos los filtros y buscar de nuevo

3.  **Disco de logs lleno** (raro en VM)

diagnose sys logdisk usage

**\
**

**Error 5: \"Metasploitable2 no puede hacer ping al gateway\"**

**Síntomas**:

\# En Metasploitable2

ping 200.100.10.1 \# Falla

**Causas posibles**:

1.  **Gateway mal configurado**

\# Verificar

route -n

\# Debe mostrar 200.100.10.1 como gateway por defecto

\# Solución

sudo route add default gw 200.100.10.1

2.  **Interfaz port2 no tiene allowaccess ping**

config system interface

edit port2

set allowaccess ping

next

end

**\
**

**Conclusiones de la práctica.**

**Instrucciones**: Responda las siguientes preguntas con base en su
experiencia durante la práctica. Sea específico y use ejemplos de su
configuración.

**Pregunta 1: Arquitectura de Seguridad**

**¿Por qué es importante segmentar la red en zonas (LAN, DMZ, WAN)?
Explique con un ejemplo concreto de esta práctica cómo la segmentación
previene un ataque.**

**Espacio para respuesta** (mínimo 100 palabras):

**Pregunta 2: Políticas de Firewall**

**Explique la diferencia entre una política \"stateless\" y
\"stateful\". ¿Cómo se comportó el FortiGate en el Ejercicio 4 (ping
asimétrico) que demuestra que es stateful?**

**Espacio para respuesta**:

**Pregunta 3: NAT y VIPs**

**En el Ejercicio 6 (Port Forwarding), describa paso a paso qué sucede
con un paquete desde que sale de Kali hacia 192.168.10.1:1080 hasta que
llega a Metasploitable2:80. Incluya:**

-   **Cambios de IP origen/destino**

-   **Cambios de puerto**

-   **Interfaces por las que pasa**

**Espacio para respuesta**:

**Pregunta 4: Orden de Políticas**

**¿Por qué el orden de las políticas de firewall es crítico? Proporcione
un ejemplo de dos políticas que, si se invierten, cambiarían
completamente el comportamiento del firewall.**

**Espacio para respuesta**:

**Pregunta 5: Objetos vs IPs Directas**

**¿Cuáles son las ventajas de usar Address Objects y Service Groups en
lugar de IPs y puertos directamente en las políticas? Mencione al menos
3 ventajas con ejemplos.**

**Espacio para respuesta**:

**Pregunta 6: Troubleshooting**

**Durante la práctica, ¿qué herramienta de diagnóstico le pareció más
útil: logs de Forward Traffic, diagnose sniffer packet, o diagnose debug
flow? Justifique su respuesta con un caso específico.**

**Espacio para respuesta**:

**\
**

**Pregunta 7: Seguridad de Gestión**

**¿Por qué bloqueamos el acceso a la GUI del FortiGate desde la DMZ
(Ejercicio 2)? ¿Qué riesgo de seguridad representa permitir gestión
desde una zona menos confiable?**

**Espacio para respuesta**:

**Pregunta 8: Web Filtering**

**Explique cómo funciona el DNS Filtering del FortiGate. ¿En qué momento
del proceso de navegación se bloquea un sitio malicioso: antes o después
de resolver el DNS?**

**Espacio para respuesta**:

**Pregunta 9: Policy Routing**

**Describa un escenario empresarial real donde sería necesario
implementar Policy Routing. ¿Qué problema resuelve que el routing
tradicional no puede resolver?**

**Espacio para respuesta**:

**Pregunta 10: Reflexión Final**

**Después de completar esta práctica, ¿cómo cambió su comprensión del
rol de un firewall de última generación en la seguridad perimetral? ¿Qué
funcionalidad le sorprendió más y por qué?**

**Espacio para respuesta** (mínimo 150 palabras):

**\
**

**Recursos Adicionales**

**Documentación Oficial**

-   **FortiGate Administration
    Guide**: <https://docs.fortinet.com/product/fortigate/>

-   **FortiGate CLI
    Reference**: <https://docs.fortinet.com/document/fortigate/7.0.0/cli-reference>

-   **FortiGate
    Cookbook**: <https://docs.fortinet.com/document/fortigate/7.0.0/cookbook>

**Certificaciones Fortinet**

-   **NSE 1**: FortiGate Security (gratuito, online)

-   **NSE 2**: FortiGate Infrastructure (gratuito, online)

-   **NSE 4**: FortiGate Security Professional (certificación de pago,
    recomendada)

-   **NSE 7**: FortiGate Enterprise Firewall (nivel experto)

**Comunidad y Soporte**

-   **Fortinet Community**: <https://community.fortinet.com/>

-   **FortiGate Subreddit**: r/fortinet

-   **YouTube - Fortinet Training**: Canal oficial con tutoriales

**Laboratorios Adicionales**

-   **FortiGate VM
    Trial**: <https://www.fortinet.com/products/fortigate/virtual-appliances>

-   **Fortinet Training Institute**: Cursos oficiales gratuitos

-   **GNS3 con FortiGate**: Integración para topologías complejas

**Herramientas Complementarias**

-   **Wireshark**: Análisis de capturas de paquetes

-   **GNS3**: Simulación de redes complejas

-   **EVE-NG**: Plataforma de emulación de red

-   **Ansible**: Automatización de configuración de FortiGate

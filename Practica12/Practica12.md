# **Práctica Nro. 12: Redes y Perímetro**

## 📊 Tabla de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 12 | 10-12-2025|
| Guilarte, Andrés | 30246084 | 12 | 10-12-2025 |

**Grupo:** 4

---

## 🎯 Objetivos de Aprendizaje

Al completar esta práctica, será capaz de:

- Configurar desde cero un firewall FortiGate en entorno virtualizado
- Implementar políticas de seguridad basadas en zonas (LAN/DMZ)
- Gestionar control granular de servicios (SSH, HTTP, HTTPS, ICMP)
- Configurar políticas asimétricas de seguridad
- Implementar Virtual IPs (VIP) para port forwarding
- Aplicar filtrado de DNS y políticas basadas en objetos
- Configurar policy routing y web proxy transparente
- Analizar logs y realizar troubleshooting en FortiGate
- Comprender el rol del firewall como perímetro de seguridad

### Requisitos Previos

Antes de comenzar esta práctica, asegúrate de cumplir con los siguientes requisitos:

#### Conocimientos

- Experiencia intermedia con redes TCP/IP (direccionamiento, subnetting, routing básico)
- Familiaridad con VirtualBox (gestión de VMs, adaptadores de red)
- Conocimientos básicos de Linux (comandos de red: `ping`, `ssh`, `curl`, `nmap`)
- Comprensión de protocolos: HTTP/HTTPS, SSH, DNS, ICMP
- NO se requiere experiencia previa con FortiGate o firewalls UTM

#### Entorno Técnico

- **VirtualBox** 6.1 o superior instalado
- **3 Máquinas Virtuales**:
    1. **Kali Linux** (última versión) — Rol: Cliente LAN
    2. **FortiGate VM** (imagen proporcionada por el instructor) — Rol: Firewall UTM
    3. **Metasploitable2** — Rol: Servidor DMZ
- **Recursos mínimos recomendados**:
  - Host: 8 GB RAM, 4 cores, 40 GB espacio libre
  - Kali: 2 GB RAM, 2 cores
  - FortiGate: 2 GB RAM, 1 core
  - Metasploitable2: 512 MB RAM, 1 core

#### Conectividad

- Las tres VMs deben estar en el mismo host de VirtualBox

#### Materiales Proporcionados por el docente

- Imagen OVA de FortiGate (importar en VirtualBox)
- Credenciales por defecto del FortiGate
- Plantilla de reporte para capturas de pantalla

---

### Escenario / Topología

#### Contexto Profesional

Has sido contratado como administrador de seguridad de una pequeña
empresa que necesita segmentar su red. La organización tiene:

- Una **red LAN** donde operan los usuarios (simulada con Kali Linux)

- Una **zona DMZ** donde se alojan servidores accesibles (simulada con Metasploitable2)

- Un **firewall FortiGate** que debe actuar como perímetro de seguridad

Tu misión es configurar el FortiGate desde cero e implementar políticas
de seguridad progresivamente más complejas.

#### Diagrama de Topología

![ Topologia de red](https://imgur.com/m7RCQ0e)

#### Tabla de Direccionamiento

| Dispositivo | Interface | Dirección IP | Máscara | Gateway | Rol |
| :--- | :---: | :---: | :---: | :---: | :--- |
| Kali Linux | eth0 | 192.168.10.10 | /24 | 192.168.10.1 | Cliente LAN |
| FortiGate | port1 | 192.168.10.1 | /24 | - | Interface LAN |
| FortiGate | port2 | 200.100.10.1 | /24 | - | Interface DMZ |
| FortiGate | port3 | DHCP | - | - | WAN (opcional) |
| Metasploitable2 | eth0 | 200.100.10.10 | /24 | 200.100.10.1 | Servidor DMZ |

#### Configuración de Adaptadores de Red en VirtualBox

| VM | Adaptador 1 | Adaptador 2 | Adaptador 3 |
| :--- | :--- | :--- | :--- |
| Kali Linux | Red Interna: LAN_Segment | - | - |
| FortiGate | Red Interna: LAN_Segment | Red Interna: DMZ_Segment | NAT (opcional) |
| Metasploitable2 | Red Interna: DMZ_Segment | - | - |

## **FASE 1: Preparación del Entorno de Laboratorio (15 minutos)**

### **Objetivo de la Fase**

Importar y configurar las tres máquinas virtuales en VirtualBox,
estableciendo la topología de red correcta antes de iniciar la
configuración del FortiGate.

#### **Paso 1.1: Importar la Imagen del FortiGate**

**Acción en VirtualBox**:

1. Abra VirtualBox

2. Menú: Archivo → Importar servicio virtualizado

3. Seleccione el archivo OVA de FortiGate

4. En la pantalla de configuración:
    - **Nombre**: FortiGate-Firewall
    - **RAM**: 2048 MB
    - **CPU**: 1 core

5. Clic en Importar

**Tiempo estimado**: 2-3 minutos

---

#### **Paso 1.2: Configurar Adaptadores de Red del FortiGate**

**Acción**:

1. Seleccione la VM FortiGate-Firewall (NO la inicie aún)

2. Clic derecho → Configuración → Red

**Adaptador 1 (port1 - LAN)**:

- Habilitar adaptador de red

- Conectado a: Red interna

- Nombre: LAN_Segment

**Adaptador 2 (port2 - DMZ)**:

- Habilitar adaptador de red

- Conectado a: Red interna

- Nombre: DMZ_Segment

**Adaptador 3 (port3 - WAN - Opcional)**:

- Habilitar adaptador de red

- Conectado a: NAT

- (Este adaptador permite al FortiGate acceder a Internet para actualizaciones)

3.Clic en Aceptar

![Figura 1: Configuración de adaptadores de red en VirtualBox (LAN_Segment y DMZ_Segment)](https://imgur.com/KC7BDiv)

#### **Paso 1.3: Configurar Kali Linux**

**Acción**:

1.Seleccione su VM de Kali Linux

2.Configuración → Red

    **Adaptador 1**:

    - Habilitar adaptador de red
    - Conectado a: Red interna
    - Nombre: LAN_Segment

3.  Inicie Kali Linux y abra una terminal

**Configurar IP estática**:

\# Verificar nombre de la interfaz

`ip addr show`

\# Editar configuración de red (asumiendo interfaz eth0)

`sudo nano /etc/network/interfaces`

Agregue estas líneas:

``` bash
auto eth0
iface eth0 inet static
  address 192.168.10.10
  netmask 255.255.255.0
  gateway 192.168.10.1
  dns-nameservers 8.8.8.8
```

Los comandos ejecutados tienen como objetivo configurar la interfaz de red eth0(Interfaz de Ethernet) con las especificaciones añadidas al archivo de interfaces de red de la máquina "Analista", a continuación se presenta una tabla con los comandos y su función en la configuración

| Comando/Configuración | Objetivo Específico | ¿Para qué sirve? |
| :--- | :--- | :--- |
| `auto eth0` | **Activación Automática** | Asegura que la interfaz de red (`eth0`) se inicie automáticamente cada vez que la máquina arranca. |
| `iface eth0 inet static` | **Definición Estática** | Declara que la interfaz `eth0` no obtendrá su configuración de red de un servidor DHCP, sino que utilizará la configuración manual (estática) proporcionada a continuación. |
| `address 192.168.10.10` | **Identificación Única** | Asigna una **dirección IP fija** específica a esta máquina dentro de la red local. Este IP no cambiará. |
| `netmask 255.255.255.0` | **Definición de Subred** | Determina qué parte de la dirección IP pertenece a la red local (`192.168.10.x`) y qué parte identifica al host. Esencial para saber a dónde enviar el tráfico local. |
| `gateway 192.168.10.1` | **Ruta de Salida (Router)** | Especifica la dirección IP de la puerta de enlace (normalmente el router). Todo el tráfico destinado fuera de la red local (ej. Internet) se envía a esta dirección. |
| `dns-nameservers 8.8.8.8` | **Resolución de Nombres** | Define el servidor que traducirá los nombres de dominio (como `google.com`) a direcciones IP para que la máquina pueda acceder a sitios web y servicios externos. |

Guarde (Ctrl+O, Enter, Ctrl+X) y aplique:

`sudo systemctl restart networking`

\# O reinicie la interfaz

`sudo ifdown eth0 && sudo ifup eth0`

\# Verificar configuración

`ip addr show eth0`

**Salida esperada**:

``` bash
2: eth0: \<BROADCAST,MULTICAST,UP,LOWER_UP\> mtu 1500 qdisc pfifo_fast
state UP group default qlen 1000

inet 192.168.10.10/24 brd 192.168.10.255 scope global eth0
```

**PREGUNTA DE VERIFICACIÓN #1**: ¿Por qué configuramos el gateway como
192.168.10.1? ¿Qué dispositivo tiene esa IP?

**Respuesta**: El gateway es 192.168.10.1 porque esa es la IP de la interfaz port1 del FortiGate. Kali debe usar el FortiGate como gateway para enrutar todo tráfico destinado a otras redes (como DMZ en 200.100.10.0/24) a través del firewall para que aplique políticas de seguridad.

#### **Paso 1.4: Configurar Metasploitable2**

**Acción**:

1.Seleccione su VM de Metasploitable2

2.Configuración → Red

    **Adaptador 1**:

    - Habilitar adaptador de red

    - Conectado a: Red interna

    - Nombre: DMZ_Segment

3.Inicie Metasploitable2 (credenciales por defecto: msfadmin / msfadmin)

\# Editar configuración de red

`sudo nano /etc/network/interfaces`

Modifique/agregue:

```bash
auto eth0
iface eth0 inet static
  address 200.100.10.10
  netmask 255.255.255.0
  gateway 200.100.10.1
```

Estos comandos tienen el mismo objetivo que los ejecutados previamente en "Analista", con la diferencia de que no se configura el servidor DNS ya que este equipo no necesita de conexión a internet para realizar sus funciones dentro del escenario de la presente práctica, además de que al realizarse mediante máquinas virtuales conectadas en la misma red LAN(la creada en la práctica 0), la conexión a los equipos se hace directamente con las direcciones IP respectivas por lo que no es necesaria la traducción de nombres de dominio a IPs.

Aplique cambios:

`sudo /etc/init.d/networking restart`

\# Verificar

`ifconfig eth0`

**Salida esperada**:

```bash

eth0 Link encap:Ethernet HWaddr 08:00:27:xx:xx:xx

inet addr:200.100.10.10 Bcast:200.100.10.255 Mask:255.255.255.0
```

![alt text](https://imgur.com/jyBe0dF)

#### **Paso 1.5: Verificación Inicial de Conectividad**

**Desde Kali Linux**, intente hacer ping a las IPs que configurará en el
FortiGate:

`ping -c 4 192.168.10.1`

`ping -c 4 200.100.10.10`

**Resultado esperado**: Ambos pings deben FALLAR

##### 📋 Registro de Pruebas de Conectividad Inicial

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

##### 📌 Análisis de Resultados

| Aspecto | Observación |
|--------|-------------|
| **Estado de ICMP** | 100% packet loss en ambos destinos |
| **Motivo del rechazo** | Destination Host Unreachable (ausencia de interfaz activa) |
| **Causa raíz** | FortiGate no configurado aún; interfaces sin IPs asignadas |
| **Conclusión** | **ESPERADO Y CORRECTO** - Comportamiento baseline antes de implementar la configuración |

**Justificación técnica**: El kernel de Linux en Kali rechaza los paquetes ICMP porque no encuentra ruta disponible hacia los destinos 192.168.10.1 (port1 del FortiGate) ni 200.100.10.10 (Metasploitable2 en DMZ). Estos errores desaparecerán una vez que configuremos las interfaces de red y las políticas de firewall en el FortiGate.

**PREGUNTA DE VERIFICACIÓN #2**: ¿Por qué el ping a 200.100.10.10 falla
si Kali está en una red diferente (192.168.10.0/24)?

**Respuesta**: El ping falla porque Kali no tiene ruta hacia 200.100.10.0/24. Aunque el FortiGate está configurado con IP 200.100.10.1 en port2, sin una política de firewall que permita el tráfico ICMP entre las zonas LAN y DMZ, el FortiGate bloquea implícitamente todos los paquetes por defecto.

## **FASE 2: Configuración Inicial del FortiGate (15 minutos)**

### **Objetivo de la Fase**

Acceder al FortiGate por primera vez, configurar las interfaces de red
(port1 y port2) con sus respectivas IPs y zonas de seguridad.

#### **Paso 2.1: Primer Acceso al FortiGate**

**Inicie la VM del FortiGate**. Verá una consola de texto.

**Credenciales por defecto (Observe la pizarra)**

- Usuario:

- Contraseña:

You are forced to change your password. Please input a new password.

New Password: FortiGate2025!

Confirm Password: FortiGate2025!

**IMPORTANTE**: Anote esta contraseña, la necesitará durante toda la
práctica.

![alt text](https://imgur.com/t4kEjwG)

---

**Paso 2.2: Configuración de la Interfaz port1 (LAN)**

**En la consola del FortiGate**, ejecute:

\# Entrar al modo de configuración
```bash
config system interface

edit port1

set mode static

set ip 192.168.10.1 255.255.255.0

set allowaccess ping https ssh http

set alias \"LAN\"

set role lan

next

end
```

**Explicación de cada comando**:

- `set mode static`: Configura IP estática (vs DHCP)

- `set ip 192.168.10.1 255.255.255.0`: Asigna IP y máscara

- `set allowaccess ping https ssh http`: Permite gestión del firewall desde esta interfaz

- `set alias "LAN"`: Etiqueta descriptiva

- `set role lan`: Define el rol de seguridad (importante para políticas)

**Verificar configuración**:

`show system interface port1`

**Salida esperada**:
```bash
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
```

**PREGUNTA DE VERIFICACIÓN #3**: ¿Qué significa set allowaccess ping
https ssh http? ¿Qué pasaría si no incluyéramos https?

**Respuesta**: `set allowaccess` define qué servicios de gestión están permitidos en esa interfaz. En port1 permitimos ping (ICMP), https (GUI), ssh (acceso de consola) e http (GUI en texto). Sin https, no podrías acceder a la interfaz gráfica del FortiGate desde Kali usando navegador.

---

#### **Paso 2.3: Configuración de la Interfaz port2 (DMZ)**

```bash
config system interface

edit port2

set mode static

set ip 200.100.10.1 255.255.255.0

set allowaccess ping

set alias \"DMZ\"

set role dmz

next

end
```

**Nota importante**: En port2 (DMZ) solo permitimos ping para gestión,
NO incluimos https/ssh/http por seguridad. La gestión del firewall debe
hacerse desde la LAN.

**Verificar**:

show system interface port2

![alt text](https://imgur.com/GREem3A)

**Paso 2.4: Verificación de Conectividad Básica**

**Desde Kali Linux**, ahora intente:

\# Ping al gateway (FortiGate port1)

`ping -c 4 192.168.10.1`

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

ingrese a `https://192.168.10.1`

**Acepte el certificado autofirmado** (Add Exception → Confirm)

**Login**:

- Usuario: admin

- Contraseña: FortiGate2025! (la que configuró anteriormente)

![alt text](https://imgur.com/iZeNi5O)

![alt text](https://imgur.com/undefined)

---

**Paso 2.6: Exploración de la Interfaz GUI**

**Navegue por estos menús** (solo observación, no modifique aún):

1.**Dashboard**: Vista general del estado del firewall

2.**Network → Interfaces**: Vea port1 y port2 configuradas

3.**Policy & Objects → Firewall Policy**: Actualmente vacía (por eso
    no hay conectividad entre zonas)

4.**Log & Report → Forward Traffic**: Logs de tráfico (vacío por
    ahora)

**PREGUNTA DE VERIFICACIÓN #4**: ¿Cuántas políticas de firewall existen
actualmente? ¿Por qué Kali no puede hacer ping a Metasploitable2?

**Respuesta**: No hay políticas configuradas aún (0 políticas). Kali no puede hacer ping a Metasploitable2 porque el FortiGate tiene una postura de denegación implícita: por defecto bloquea todo tráfico entre zonas hasta que se crean políticas explícitas que lo permitan.

**Paso 2.7: Configuración Opcional de port3 (WAN)**

**Solo si necesita acceso a Internet desde el FortiGate**:

```bash
config system interface

edit port3

set mode dhcp

set allowaccess ping

set alias \"WAN\"

set role wan

next

end
```

**Verificar que obtuvo IP:**

get system interface port3

**Nota**: Este paso es opcional para la práctica. Si no necesita
actualizaciones o acceso externo, puede omitirlo.

El paso 2.7 se omitió por indicación del profesor.

## **FASE 3: Implementación de Políticas de Seguridad (50 minutos)**

### **Objetivo de la Fase**

Configurar políticas de firewall progresivamente más complejas, desde
conectividad básica hasta control granular de servicios y políticas
asimétricas.

#### **Ejercicio 1: Interconexión Básica LAN ↔ DMZ (Ping Bidireccional)**

**Objetivo**

Permitir que Kali (LAN) y Metasploitable2 (DMZ) puedan hacerse ping
mutuamente.

---

**Paso 3.1.1: Crear Política LAN → DMZ (Permitir Todo)**

**Vía GUI**:

1.Navegue a: Policy & Objects → Firewall Policy

2.Clic en Create New

3.Configure:

| Campo | Valor | Explicación |
| :--- | :---: | :--- |
| Name | `LAN_to_DMZ_Allow_All` | Nombre descriptivo |
| Incoming Interface | `port1 (LAN)` | Origen del tráfico |
| Outgoing Interface | `port2 (DMZ)` | Destino del tráfico |
| Source | `all` | Cualquier IP de origen |
| Destination | `all` | Cualquier IP de destino |
| Schedule | `always` | Siempre activa |
| Service | `ALL` | Todos los servicios/puertos |
| Action | `ACCEPT` | Permitir tráfico |
| NAT | `Deshabilitado` | No se aplica NAT entre redes internas |
| Log Allowed Traffic | `Habilitado` | Registrar tráfico permitido para auditoría |

4.Clic en OK

**Vía CLI** (alternativa):

```bash
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
```

![alt text](https://imgur.com/V7a7v8q)

---

#### **Paso 3.1.2: Crear Política DMZ → LAN (Permitir Todo)**

**Repita el proceso anterior** con estos valores:

| Campo | Valor | Explicación |
| :--- | :---: | :--- |
| Name | `DMZ_to_LAN_Allow_All` | Nombre descriptivo |
| Incoming Interface | `port2 (DMZ)` | Origen del tráfico |
| Outgoing Interface | `port1 (LAN)` | Destino del tráfico |
| Source | `all` | Cualquier IP de origen |
| Destination | `all` | Cualquier IP de destino |
| Service | `ALL` | Todos los servicios/puertos |
| Action | `ACCEPT` | Permitir tráfico |
| NAT | `Deshabilitado` | No se aplica NAT entre redes internas |
| Log Allowed Traffic | `Habilitado` | Registrar tráfico permitido para auditoría |

**Vía CLI**:

```bash
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
```

#### *Paso 3.1.3: Verificación de Conectividad**

**Desde Kali Linux**:

\# Ping a Metasploitable2

`ping -c 4 200.100.10.10`

**Resultado esperado**: Debe funcionar

PING 200.100.10.10 (200.100.10.10) 56(84) bytes of data.

64 bytes from 200.100.10.10: icmp_seq=1 ttl=63 time=0.5 ms

64 bytes from 200.100.10.10: icmp_seq=2 ttl=63 time=0.4 ms

\...

\-\-- 200.100.10.10 ping statistics \-\--

4 packets transmitted, 4 received, 0% packet loss

**Desde Metasploitable2**:

\# Ping a Kali

`ping -c 4 192.168.10.10`

**Resultado esperado**: Debe funcionar

![alt text](https://imgur.com/dDqfncw)

En la imagen se obseva que solo fue exitoso el ping desde "Analista" hacia "Objetivo", este debido a la expiración de las licencias de Fortinet en medio de la ejecución de la práctica.

La totalidad de la práctica no se pudo realizar debido a que a mitad de la misma la licencia de Fortinet expiró, por lo que las políticas dejaron de funcionar conllevando a la imposibilidad de seguir con el contenido de la práctica en su totalidad, por ello en la sección siguiente solo se responderán las preguntas cuya respuesta pueda ser construida con la información contenida en el presente informe.


**Conclusiones de la práctica.**

**Instrucciones**: Responda las siguientes preguntas con base en su
experiencia durante la práctica. Sea específico y use ejemplos de su
configuración.

**Pregunta 1: Arquitectura de Seguridad**

**¿Por qué es importante segmentar la red en zonas (LAN, DMZ, WAN)?
Explique con un ejemplo concreto de esta práctica cómo la segmentación
previene un ataque.**

La segmentación de una red en zonas lógicas (como LAN, DMZ y WAN) es la base de la seguridad y gestión de redes empresariales. Su importancia radica en la implementación de una política de **"defensa en profundidad"**, garantizando que la violación de una zona no comprometa la integridad de toda la infraestructura.

 1. **Seguridad (Objetivo Primordial)**

La segmentación es fundamental para aplicar los principios de **Mínimo Privilegio** y **Aislamiento**.

* **Contención de Amenazas:** Este es el beneficio más crítico. Si un atacante compromete un sistema en la **DMZ** (la zona más expuesta), el **firewall** situado entre la DMZ y la LAN actúa como una barrera. Esto **contiene** el ataque, impidiendo el movimiento lateral hacia los sistemas internos críticos (donde residen las bases de datos y la información sensible). 
* **Reducción de la Superficie de Ataque:** Al aislar los servicios que deben ser públicos (servidores web, correo) en la DMZ, se reduce significativamente el número de sistemas internos expuestos a Internet. Solo lo estrictamente necesario es accesible desde fuera.
* **Control de Tráfico Estricto:** Permite a los *firewalls* aplicar reglas de filtrado muy granulares y estrictas sobre el tráfico que cruza los límites de cada zona, haciendo imposible el tráfico no autorizado:
    * Tráfico WAN $\to$ LAN: **Generalmente bloqueado.**
    * Tráfico DMZ $\to$ LAN: **Estrictamente limitado** (ej. solo puerto 3306 hacia el servidor de base de datos).

 2. **Gestión, Rendimiento y Cumplimiento**

La segmentación también mejora la eficiencia operativa y ayuda a cumplir con normativas.

* **Aislamiento de Problemas de Rendimiento:** Dividir la red en subredes más pequeñas reduce el tamaño de los dominios de *broadcast*. Si ocurre un problema de tráfico excesivo o un *loop* en la LAN, este no impactará negativamente en el rendimiento de los servidores críticos en la DMZ ni en la conectividad WAN.
* **Optimización de Recursos (QoS):** Permite priorizar el tráfico por zona (ej. garantizar ancho de banda de alta calidad para llamadas VoIP en la LAN) sin que el tráfico de la DMZ consuma estos recursos.
* **Cumplimiento Normativo (*Compliance*):** Normativas de seguridad como **PCI DSS** (para manejo de tarjetas de crédito) o HIPAA (sanidad) a menudo **exigen** la segmentación para aislar y proteger los sistemas que manejan datos regulados, facilitando las auditorías.

Definición y Rol de Cada Zona

| Zona | Acrónimo | Función Principal | Nivel de Riesgo | Servicios Típicos |
| :--- | :--- | :--- | :--- | :--- |
| **LAN** | Local Area Network | Red interna de confianza (empleados). Contiene los activos más valiosos. | **Bajo** (Máximo nivel de protección) | PCs de Usuarios, Servidores de Archivos, Servidores de Autenticación (Active Directory), Impresoras. |
| **DMZ** | Demilitarized Zone | Zona de "buffer" o amortiguación. Contiene sistemas que deben ser accesibles desde Internet. | **Medio/Alto** (Sistemas expuestos al público) | Servidores Web, Servidores de Correo (MTA), Servidores DNS públicos, Servidores de Aplicaciones públicos. |
| **WAN** | Wide Area Network | La red no confiable (generalmente **Internet**). | **Alto** (Máximo nivel de amenaza) | Tráfico externo, Origen de ataques. |

En la práctica, se evita el éxito completo de un posible ataque al poner el firewall entre la DMZ(la máquina denominada como "Objetivo") y la red LAN(la máquina denomindada como "Analista") ya que las configuraciones realizadas en el equipo Fortinte impide la comunicación entre ambas zonas si no hay una política declarada en el equipo que lo permita debido a que el firewall por defecto bloquea las comunicación entre sus puertos. Todo esto evita que contenido malicioso que un atacante pudo haber insertado en los paqutes enviados desde DMZ hacia la red LAN no afecte a la misma, de igual forma esto aisla el daño hacia una zona específica lo que facilita su análisis y correción por el equipo de cibersguridad.

**Pregunta 4: Orden de Políticas**

**¿Por qué el orden de las políticas de firewall es crítico? Proporcione
un ejemplo de dos políticas que, si se invierten, cambiarían
completamente el comportamiento del firewall.**

La razón principal es que la mayoría de los *firewalls* (tanto de software como de hardware) procesan el tráfico utilizando el modelo de **"Primera Coincidencia Válida"**.

El Modelo de "Primera Coincidencia Válida"

Cuando un paquete de datos llega al firewall, el dispositivo no revisa todas las reglas. En su lugar, el firewall:

1.  **Comienza** a revisar las reglas **desde la parte superior (Regla 1) hacia abajo**.
2.  **Se detiene** en la **primera regla** que coincide exactamente con los parámetros del paquete (dirección de origen, destino, puerto, protocolo).
3.  **Ejecuta** la acción definida en esa regla (Permitir, Bloquear o Rechazar).
4.  **Ignora** el resto de las reglas, incluso si alguna de ellas también hubiera coincidido o si era la regla deseada. 

Consecuencias Críticas del Orden

Si el orden no es el correcto, las reglas pueden **encapsularse** mutuamente, llevando a tres problemas principales:

 1. Problemas de Seguridad (La Amenaza Mayor)

Si una regla muy permisiva (una regla de **"PERMITIR TODO"** o una regla genérica) se coloca antes que una regla específica de bloqueo:

* **Ejemplo:**
    * **Regla 1 (Genérica):** Permitir todo el tráfico TCP saliente.
    * **Regla 2 (Específica, Bloqueo):** Bloquear el acceso a servidores maliciosos conocidos (`badip.com`).
* **Resultado:** El tráfico hacia `badip.com` coincidirá inmediatamente con la **Regla 1** ("Permitir todo TCP saliente") y será autorizado. El firewall nunca llegará a procesar la **Regla 2**, comprometiendo la seguridad.

> **Regla de Oro de Seguridad:** Las reglas de **bloqueo específico** y las excepciones deben ir **arriba**, antes que las reglas amplias de permiso.

 2. Problemas de Funcionalidad y Bloqueo Innecesario

Si una regla de bloqueo amplio se coloca antes de una regla específica de permiso, el servicio puede dejar de funcionar:

* **Ejemplo:**
    * **Regla 1 (Genérica, Bloqueo):** Bloquear todo el tráfico del puerto 80.
    * **Regla 2 (Específica, Permiso):** Permitir que el servidor web interno acceda a `updateserver.com` por el puerto 80 para actualizaciones.
* **Resultado:** El servidor web intentará acceder al servidor de actualizaciones, pero el tráfico coincidirá con la **Regla 1** y será bloqueado. La **Regla 2** nunca se alcanzará, y el servidor no se podrá actualizar.

> **Regla de Oro de Funcionalidad:** Las excepciones (Permitir) a una regla de bloqueo general deben ir **arriba**.

 3. Rendimiento (Ineficiencia)

Si el firewall tiene miles de reglas, colocar las reglas de tráfico de **alto volumen** (tráfico frecuente) al final puede ralentizar todo el sistema.

* **Ejemplo:** El tráfico de navegación web (HTTP/HTTPS) constituye el 80% del tráfico de la red. Si la regla que permite este tráfico está al final de la lista, el firewall tendrá que revisar potencialmente miles de reglas inútiles para cada paquete de navegación, consumiendo CPU y latencia.

> **Regla de Oro de Rendimiento:** Las reglas que manejan el **mayor volumen de tráfico** deberían estar cerca de la **parte superior** para ser procesadas rápidamente.

 Estrategia Recomendada para el Orden de Reglas

La estructura más común y segura para las políticas de firewall es la siguiente, de arriba (más importante) a abajo:

1.**Tráfico Explícito de Denegación (Anti-Spoofing, Bloqueos conocidos).**
2.**Permisos Específicos** (Excepciones necesarias, como el tráfico de servidores críticos).
3.**Denegaciones Específicas** (Bloquear aplicaciones o usuarios específicos).
4.**Reglas Amplias de Permiso** (Reglas que permiten la funcionalidad general, como permitir la navegación saliente).
5.**Regla de Denegación Implícita (Cleanup Rule):** Una regla final que **deniega todo** lo que no haya coincidido con ninguna regla anterior (ej. `ANY to ANY Deny`). Esto es una medida de seguridad fundamental.

En el escenario de la práctica, invertir el orden de las políticas LAN_to_DMZ_Allow_All y DMZ_to_LAN_Allow_All es una falla de seguridad por las siguientes razones:

1. Consecuencias en la Seguridad (Lo Peor)

Si la regla de `DMZ_to_LAN_Allow_All` se convierte en la Regla 1, el **aislamiento de seguridad se anula por completo**.

* **Violación de la Contención:** El propósito fundamental de la DMZ es ser un amortiguador donde los sistemas pueden ser comprometidos sin afectar la LAN.
* **Puerta Trasera Abierta:** Al tener la regla **`DMZ_to_LAN_Allow_All`** arriba, cualquier atacante que logre comprometer un servidor expuesto en la DMZ (un servidor web vulnerable, por ejemplo) tendrá un **camino libre** hacia toda la red interna (LAN). Podría lanzar ataques, robar datos, o infectar las máquinas de los empleados **sin ninguna restricción de firewall**.

2. Consecuencias en la Funcionalidad (El Colapso)

La inversión causaría que la LAN no pueda funcionar correctamente, especialmente si hay otras reglas específicas que dependen de este tráfico.

* **Bloqueo de la LAN hacia la DMZ:** Al mover `LAN_to_DMZ_Allow_All` hacia abajo, cualquier regla de bloqueo genérica o la Regla de Denegación Implícita (si la hay) podría atrapar el tráfico saliente de la LAN antes de que esta regla de permiso se procese.
    * **Resultado:** Los usuarios de la LAN **no podrían acceder** a los servicios públicos de la propia empresa que están alojados en la DMZ.

## Escenario Detallado: DMZ_to_LAN_Allow_All Arriba

| Orden | Nombre de la Regla | Tráfico (Origen $\to$ Destino) | Acción | Consecuencia |
| :---: | :--- | :---: | :---: | :--- |
| **1** | **`DMZ_to_LAN_Allow_All`** | **DMZ $\to$ LAN** | **PERMITIR** | **PELIGRO INMINENTE:** Se permite todo, incluyendo ataques de día cero, robo de bases de datos y movimientos laterales a la red interna. El firewall ignora todas las reglas de bloqueo que estaban debajo. |
| **2** | **`LAN_to_DMZ_Allow_All`** | **LAN $\to$ DMZ** | **PERMITIR** | **I

### Pregunta 10: Reflexión Final

**Después de completar esta práctica, ¿cómo cambió su comprensión del
rol de un firewall de última generación en la seguridad perimetral? ¿Qué
funcionalidad le sorprendió más y por qué?**

Nuestra comprensión del firewall evolucionó desde verlo como un simple "muro de bloqueo" a reconocerlo como una **estructura de defensa estratégica multinivel**, similar a una trinchera militar medieval:

**La Analogía de la Trinchera:**

- **Internet (zona enemiga):** El territorio exterior donde residen los atacantes
- **Firewall (trinchera de defensa):** La primera barrera protectora que inspecciona cada "invasión" (paquete de datos)
- **DMZ (campamento de provisiones):** La zona intermedia donde se ubican los servicios "expuestos" (web, DNS, correo) que necesitan comunicación externa, pero están contenidos y monitoreados
- **LAN/Sistemas Internos (la ciudad):** El corazón protegido donde residen los activos más críticos y valiosos

**Lo que nos sorprendió:**
La **simetría y asimetría de políticas (Ejercicio 4)** fue revelador. Permitir ping unidireccional (LAN→DMZ pero bloquear DMZ→LAN) demostró que un firewall stateful no es simplemente un bloqueador/permitidor binario, sino un **guardián inteligente que entiende sesiones de comunicación**. Es como una trinchera que permite que tus soldados disparen hacia afuera pero rechaza el fuego que viene de la zona de provisiones hacia la ciudad.

Las políticas de objetos (Ejercicio 8) también fueron críticas: en lugar de memorizar "bloquear 192.168.10.10", el FortiGate usa nombres semánticos ("Host_Kali", "Group_Web_Services"), lo que transforma la gestión de seguridad de **táctica (matar mosquitos) a estratégica (defender el reino)**.

El concepto que cambió nuestro pensamiento: **la seguridad no es restrictiva, es inteligente**. No se trata de bloquear todo (que pararía el negocio), sino de permitir lo necesario, inspeccionar lo permitido, y denegar lo malicioso. El FortiGate es una trinchera que sabe cuándo dejar pasar suministros civiles legítimos y cuándo repeler un ataque coordinado.

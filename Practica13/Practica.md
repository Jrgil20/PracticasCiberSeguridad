A continuación se presenta el contenido convertido a **Markdown (.md)**, estructurado como **práctica formal**, sin imágenes ni diagramas gráficos, y listo para usar en GitHub, GitLab o Google Docs (vía importación).

---

````md
# Práctica Nro. 10  
## Sniffing & Spoofing

**Universidad Católica Andrés Bello**  
**Carrera:** Ingeniería Informática  
**Asignatura:** Ciberseguridad  
**Semestre:** 2026-15  

---

## Requisitos

- Máquina virtual **Kali Linux**
- Máquina virtual **Parrot**
- Máquina virtual **Metasploitable 2**
- Acceso a Internet
- Herramienta **DNSChef**

---

## DNSChef

DNSChef es un proxy DNS altamente configurable utilizado en **Pruebas de Penetración** y **Análisis de Malware**.  
Un proxy DNS (DNS falso) permite interceptar, analizar y falsificar solicitudes DNS realizadas por aplicaciones o sistemas.

### Características principales

- Falsificación de respuestas DNS basada en listas inclusivas o exclusivas
- Soporte para múltiples tipos de registros DNS
- Soporte para dominios comodín
- Proxy transparente para dominios no manipulados
- Soporte IPv4 e IPv6
- Configuración mediante archivos externos

### Uso recomendado

DNSChef es especialmente útil cuando no es posible forzar manualmente el uso de un proxy tradicional en una aplicación. En estos escenarios, el uso de un proxy DNS permite redirigir conexiones hacia destinos controlados por el atacante.

---

## Sniffing

Un **sniffer** es una herramienta que permite capturar y analizar el tráfico que circula por una red.

Normalmente, una tarjeta de red solo acepta paquetes dirigidos a su dirección MAC. Sin embargo, un sniffer coloca la tarjeta de red en **modo promiscuo**, permitiendo capturar **todo el tráfico** que circula por el segmento de red, independientemente del destinatario.

### Consideraciones clave

- El tráfico **no cifrado** puede ser capturado y analizado.
- Permite inferir relaciones entre usuarios y sistemas.
- Es difícil detectar pasivamente un sniffer.
- Se recomienda el uso de **cifrado en todas las comunicaciones**.

---

## Spoofing

El **spoofing** es una técnica de suplantación de identidad en redes, utilizada generalmente en ataques dirigidos o procesos de investigación ofensiva.

### Tipos de spoofing

- **IP Spoofing:** Suplantación de la dirección IP de origen.
- **ARP Spoofing:** Falsificación de tablas ARP para redirigir tráfico al atacante.
- **DNS Spoofing:** Asociación falsa entre nombres de dominio y direcciones IP.
- **Web Spoofing:** Creación de sitios web falsos para obtener información sensible (phishing).
- **Mail Spoofing:** Suplantación de correos electrónicos para envío de spam o fraude.

---

## PARTE I – DNS Sniffing y Spoofing

Al ejecutar DNSChef sin parámetros, se ejecuta en modo **proxy completo**, reenviando solicitudes DNS al servidor configurado (por defecto: `8.8.8.8`).

### Ejercicio 1 – Modo FakeIP

1. Verifique la dirección IP de Kali Linux:
   ```bash
   ifconfig
````

2. Abra dos terminales.

3. En el **Terminal A**, ejecute:

   ```bash
   dnschef --fakeip <IP_LOCALHOST> -q
   ```

4. En el **Terminal B**, ejecute:

   ```bash
   host -t A mercadolibre.com <IP_LOCALHOST>
   ```

5. Analice el resultado y registre evidencias de ambos terminales.

6. Repita el procedimiento con **una página web de su preferencia**.

7. Detenga DNSChef:

   ```bash
   Ctrl + C
   ```

---

## Tipos de registros DNS comunes

* **A:** Dirección IPv4
* **AAAA:** Dirección IPv6
* **CNAME:** Alias de subdominios
* **MX:** Servidores de correo electrónico

---

## Ejercicio 2 – Falsificación avanzada de registros

1. En el **Terminal A**, ejecute:

   ```bash
   dnschef --interface=<IP_KALI> \
           --fakeip 200.200.200.200 \
           --fakeipv6 ::1 \
           --fakemail correo.dominioatacante.com \
           -q
   ```

2. En el **Terminal B**, ejecute:

   ```bash
   host -v mercadolibre.com <IP_KALI>
   ```

3. Registre evidencias y analice los resultados.

4. Repita el ejercicio con **otro dominio de su elección**.

---

## PARTE II – ARP Spoofing

### Preparación

* Inicie las máquinas virtuales:

  * Kali Linux
  * Parrot
  * Metasploitable 2
* Verifique que todas estén en la **misma red NAT**
* Registre direcciones **IP** y **MAC** de cada máquina en una tabla

---

### Ataque desde Kali Linux

1. Descubra los dispositivos en la red:

   ```bash
   netdiscover
   ```

2. Habilite el reenvío de paquetes:

   ```bash
   echo 1 > /proc/sys/net/ipv4/ip_forward
   ```

   **Explique la función de este comando en el contexto del ataque.**

3. Ejecute el ataque ARP:

   ```bash
   arpspoof -i eth0 -t <IP_VICTIMA_1> <IP_VICTIMA_2>
   ```

4. Desde otra consola:

   ```bash
   arpspoof -i eth0 -t <IP_VICTIMA_2> <IP_VICTIMA_1>
   ```

5. Analice qué está ocurriendo en cada caso.

---

### Monitoreo del ataque

1. Inicie **Wireshark** en la máquina Parrot.
2. Navegue desde Parrot hacia Metasploitable 2.
3. Acceda a la aplicación **DVWA**.
4. Filtre tráfico **HTTP**.
5. Analice los paquetes capturados:

   * Direcciones IP involucradas
   * Flujo de comunicación
   * Evidencia de intermediación por Kali Linux
6. Capture las credenciales utilizadas para DVWA.

---

## Conclusiones

1. ¿Qué diferencia fundamental observó entre la respuesta DNS falsificada y una respuesta DNS legítima (ej. 8.8.8.8)?
2. ¿Por qué esta diferencia es relevante desde la perspectiva de un atacante?
3. Describa un escenario realista donde DNSChef podría comprometer la seguridad de usuarios o redes.
4. En la Parte II:

   * ¿Cómo se evidenció que el tráfico no fluía directamente entre Parrot y Metasploitable 2?
   * ¿Qué rol jugó Kali Linux en la comunicación?

---

**Fecha:** Diciembre 2025
**Formato elaborado por:** Francis Ferrer

```

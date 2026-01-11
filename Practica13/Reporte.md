# Informe de Seguridad – Práctica 10 (Parte I) DNS Sniffing & Spoofing

## 📊 Tabla de Identificación
| Apellido, Nombre | Cédula | Práctica/Proyecto | Fecha | Equipo |
|------------------|--------|-------------------|-------|--------|
| Gil, Jesús | 30175126 | 10 – Sniffing & Spoofing (Parte I) | 11-01-2026 | Grupo 4 |

## 🎭 Contexto del Escenario
Simulación de un laboratorio de pruebas de seguridad en redes internas para un cliente ficticio ("TechCorp Labs") que desea validar su exposición ante ataques de manipulación DNS y MITM. El alcance cubre la fase de DNS Sniffing y Spoofing usando DNSChef en entorno controlado. La fase de ARP Spoofing no se ejecutó por falta temporal de las máquinas virtuales; se documenta el plan teórico de ejecución para asegurar trazabilidad del procedimiento.

## 🎯 Objetivos
### Objetivos de Seguridad
- Validar la capacidad de falsificar respuestas DNS en un entorno controlado usando DNSChef.
- Identificar riesgos asociados a la ausencia de validación de integridad en las respuestas DNS (falta de DNSSEC o controles equivalentes).

### Objetivos de Aprendizaje
- Fortalecer la comprensión de sniffing y spoofing en redes locales.
- Practicar la ejecución y el análisis de comandos ofensivos con verificación forense posterior.

## 🔧 Requisitos Técnicos
### Infraestructura
- **Sistema Objetivo (cliente de pruebas):** Kali Linux (10.0.2.15 / loopback 127.0.0.1)
- **Sistema Atacante:** Kali Linux (misma máquina en laboratorio local para DNSChef)
- **Red:** NAT virtual; pruebas DNS locales sobre loopback. La parte ARP se deja planificada con IP real 10.0.2.15.

### Herramientas Utilizadas
| Herramienta | Versión | Propósito | Licencia |
|-------------|---------|-----------|----------|
| dnschef | 0.5.x | Falsificación y proxy de respuestas DNS | GPL |
| host (bind-utils) | 9.x | Consulta y validación de registros DNS | ISC |
| ifconfig (net-tools) | 2.x | Verificación de interfaz y estado de red | GPL |
| tee | coreutils 9.x | Registro persistente de salidas de comandos | GPL |

## 🔍 METODOLOGÍA Y PROCEDIMIENTO

### Fase 1: Verificación de red y preparación del entorno
```bash
ifconfig

# DESGLOSE
# ifconfig: herramienta de net-tools para inspección de interfaces.
# - Muestra IPs, MAC y estado de cada interfaz.
# USO EN EL LAB: confirmar loopback 127.0.0.1 y la interfaz eth0 con 10.0.2.15.
# EVIDENCIA: registrar salida a archivo para trazabilidad.
ifconfig | tee recon/ifconfig_inicial.txt
```

### Fase 2: Ejecución de DNSChef en modo FakeIP (loopback)
```bash
dnschef --fakeip 127.0.0.1 -q

# DESGLOSE
# dnschef: proxy/faker DNS.
# --fakeip 127.0.0.1: responde con la IP falsa (loopback) a cualquier consulta tipo A.
# -q: modo quiet (silencia logs verbosos, mantiene sólo esenciales).
# RAZÓN TÉCNICA: en laboratorio local, el binding en loopback garantiza que las respuestas
# manipuladas no salgan a la red; sirve para demostrar suplantación controlada.
```

### Fase 3: Consulta dirigida al DNS falso
```bash
host -t A mercadolibre.com 127.0.0.1

# DESGLOSE
# host: cliente DNS simple.
# -t A: consulta registro A (IPv4).
# mercadolibre.com: dominio de prueba.
# 127.0.0.1: servidor DNS objetivo (DNSChef en loopback).
# EXPECTATIVA: la respuesta A debe ser 127.0.0.1 (IP falsificada por DNSChef).
```

### Fase 4: Repetición con dominio alterno y evidencias
```bash
host -t A example.com 127.0.0.1 | tee evidencias/host_example_fakeip.txt

# DESGLOSE
# Se documenta salida en archivo para anexos y comparación futura.
```

### Fase 5: Verificación forense y evidencia de manipulación
```bash
# Confirmar identidad y entorno tras las pruebas
whoami | tee evidencias/whoami.txt
id | tee -a evidencias/whoami.txt
hostname | tee -a evidencias/whoami.txt

# Registrar estado de red post-prueba
netstat -tuln | tee evidencias/netstat_post_dnschef.txt

# EVIDENCIA IRREFUTABLE
timestamp=$(date +%Y%m%d_%H%M%S)
evidence_file="evidencias/EVIDENCIA_DNS_${timestamp}_EQUIPO4.txt"
echo "=== EVIDENCIA DE COMPROMISO DNS ===" > "$evidence_file"
echo "Timestamp: $(date)" >> "$evidence_file"
echo "Usuario: $(whoami)" >> "$evidence_file"
echo "UID/GID: $(id)" >> "$evidence_file"
echo "Sistema: $(hostname)" >> "$evidence_file"
echo "Kernel: $(uname -r)" >> "$evidence_file"
echo "Técnica: DNS Spoofing con DNSChef (FakeIP)" >> "$evidence_file"
echo "Equipo: Grupo 4" >> "$evidence_file"
cat "$evidence_file"
ls -la "$evidence_file"
```

## Evidencias (Parte I)
![ifconfig – estado inicial](https://imgur.com/Q7ddbLZ "ifconfig – estado inicial")
*Figura 1: Salida de ifconfig mostrando loopback 127.0.0.1 y la interfaz eth0 (10.0.2.15) activa para referencia.*

![DNSChef en modo FakeIP](https://imgur.com/heNGaU5 "DNSChef en modo FakeIP")
*Figura 2: DNSChef respondiendo con 127.0.0.1 a consultas A, validando la falsificación local.*

![DNSChef con múltiples registros falsificados](https://imgur.com/sAfcpD0 "DNSChef con múltiples registros falsificados")
*Figura 3: Configuración extendida con registros A/AAAA/MX falsificados para pruebas de respuesta multirregistro.*

## Limitaciones y Alcance
- La **Parte II – ARP Spoofing** no se ejecutó por indisponibilidad temporal de las máquinas Parrot y Metasploitable 2. Se incluye el plan teórico para asegurar continuidad y trazabilidad.
- Regla aplicada en el informe: **DNSChef local/laboratorio usa 127.0.0.1**; **ataques de red (ARP, MITM) requieren la IP real de la interfaz (10.0.2.15)**. Loopback se reserva para pruebas locales; no sustituye el binding externo cuando se ataca tráfico real.

## Plan Teórico – PARTE II: ARP Spoofing (sin ejecución práctica)
1. **Descubrimiento de red**
	```bash
	netdiscover -i eth0

	# DESGLOSE
	# -i eth0: define la interfaz real (10.0.2.15). Busca hosts activos en la red NAT.
	# OBJETIVO: identificar IP/MAC de Parrot y Metasploitable 2.
	```

2. **Habilitar reenvío de paquetes**
	```bash
	echo 1 > /proc/sys/net/ipv4/ip_forward

	# DESGLOSE
	# Activa forwarding para que Kali funcione como puente MITM.
	# IMPACTO: permite que el tráfico fluya a través del atacante tras la falsificación ARP.
	```

3. **Ataque ARP bidireccional**
	```bash
	arpspoof -i eth0 -t <IP_VICTIMA_1> <IP_VICTIMA_2>
	arpspoof -i eth0 -t <IP_VICTIMA_2> <IP_VICTIMA_1>

	# DESGLOSE
	# -i eth0: usa la interfaz real; no aplica loopback.
	# -t: objetivo específico; se envían respuestas ARP envenenadas a ambos extremos.
	# EFECTO: Kali (10.0.2.15) se posiciona como gateway falso, interceptando tráfico.
	```

4. **Monitoreo y captura**
	```bash
	wireshark &            # Captura en Parrot
	tcpdump -i eth0 -nn port 80 or port 443 | tee evidencias/tcpdump_arp.txt

	# DESGLOSE
	# wireshark: inspección visual en la víctima para evidenciar intermediación.
	# tcpdump: evidencia CLI de sesiones HTTP/HTTPS redirigidas.
	# VALIDACIÓN: filtrar credenciales DVWA y verificar que la MAC de origen coincide con Kali.
	```

5. **Verificación post-ataque y limpieza**
	```bash
	ip neigh flush all     # Limpia caché ARP en víctimas (cuando sea posible).
	sysctl -w net.ipv4.ip_forward=0

	# DESGLOSE
	# Restituye el estado de red para evitar persistir envenenamiento.
	```

## 📊 Resumen de Hallazgos de Seguridad

| # | Vulnerabilidad / Riesgo | Impacto CIA | Severidad | Remediación | CVE | Estado |
|---|-------------------------|------------|-----------|-------------|-----|--------|
| 1 | Ausencia de validación DNS (posible DNS spoofing local) | C:Alto I:Medio A:Bajo | 🟡 Alta | Implementar DNSSEC o DoT/DoH; restringir DNS no autorizados; monitoreo de respuestas manipuladas | CWE-354 | Observado |

**Leyenda de Severidad:** 🔴 Crítica | 🟡 Alta | 🟢 Media | 🔵 Baja

## 🔬 Análisis Detallado de Vulnerabilidades

### 🟡 Alta Vulnerabilidad: Ausencia de validación DNS (entorno de laboratorio)

#### 📖 Definición Técnica
La falta de validación criptográfica en respuestas DNS permite a un atacante responder con registros falsos (DNS spoofing). DNSChef demostró que un cliente acepta registros falsificados sin verificación de integridad.

**Mecanismo de Explotación:** el atacante ejecuta un servidor DNS falso y redirige consultas del cliente hacia él (en laboratorio, binding en 127.0.0.1). Las respuestas manipuladas apuntan a IPs controladas, posibilitando phishing, malware staging o MITM.

#### 💥 Impacto en Seguridad
- **Confidencialidad:** Alto; permite redirigir tráfico a servidores controlados y capturar credenciales.
- **Integridad:** Medio; posibilita entrega de contenido alterado.
- **Disponibilidad:** Bajo; el impacto principal es control de flujo, no denegación.

**Impacto en el Negocio:** usuarios pueden ser redirigidos a portales fraudulentos, exfiltrando credenciales o datos sensibles, con riesgo reputacional y de fraude.

#### 🔬 Evidencia de Explotación
```bash
dnschef --fakeip 127.0.0.1 -q
host -t A mercadolibre.com 127.0.0.1

# Salida resumida (esperada)
mercadolibre.com has address 127.0.0.1

# Verificación
whoami
id
hostname
```

**Captura de Pantalla:** ver Figuras 1–3.

#### 📚 Referencias Técnicas
- **CWE:** CWE-354 (Improper Validation of Integrity Check Value)
- **OWASP Top 10:** A01-Broken Access Control (aplicable por control de flujo hacia destinos no autorizados)

#### 🛠️ Remediación Técnica Específica
**Solución Inmediata (Mitigación):**
```bash
# Forzar DNS seguro (DoT/DoH) en clientes
resolvectl dns eth0 1.1.1.1 1.0.0.1
resolvectl dnsovertls eth0 yes

# Bloquear DNS saliente no autorizado (ejemplo en iptables)
iptables -A OUTPUT -p udp --dport 53 ! -d 1.1.1.1 -j DROP
iptables -A OUTPUT -p tcp --dport 53 ! -d 1.1.1.1 -j DROP
```

**Solución Permanente:**
```bash
# Implementar validación DNSSEC en el resolver interno (ejemplo Unbound)
sudo apt install unbound
sudo sh -c 'echo "auto-trust-anchor-file: \"/var/lib/unbound/root.key\"" >> /etc/unbound/unbound.conf'
sudo unbound-anchor
sudo systemctl enable --now unbound

# Configurar clientes para usar el resolver validado
nmcli con mod "Wired connection 1" ipv4.dns "10.0.2.1"
nmcli con up "Wired connection 1"
```

**Validación de Corrección:**
```bash
# Verificar que DNSSEC esté activo
dig +dnssec cloudflare.com @10.0.2.1 | grep "ad"

# Probar bloqueo de DNS no autorizados
nc -vuz 8.8.8.8 53   # Debe fallar si el firewall aplica
```

## 🛠️ Plan de Remediación
- Prioridad 1: Activar DNSSEC/DoT en clientes y resolver interno; bloquear DNS saliente no autorizado.
- Prioridad 2: Supervisar logs de DNS para detectar respuestas anómalas o variaciones de TTL.
- Prioridad 3: Documentar y entrenar al equipo sobre la diferencia entre pruebas en loopback y ataques reales con IP de interfaz (10.0.2.15).

## 📈 Conclusiones
### Resumen Ejecutivo
Se demostró la viabilidad de falsificar respuestas DNS en laboratorio usando DNSChef en loopback, evidenciando la necesidad de controles de integridad (DNSSEC/DoT) y bloqueo de resolutores no autorizados. La fase ARP MITM queda pendiente por falta de infraestructura, pero el plan está listo para ejecución.

### Conclusiones Técnicas
- DNS sin validación puede ser manipulado fácilmente; DNSChef respondió con IPs falsas y el cliente las aceptó.
- El binding en loopback es seguro para laboratorio; para ataques reales se requiere la IP de interfaz (10.0.2.15) y control de flujo de red.
- Sin medidas como DNSSEC/DoT y filtrado de DNS saliente, los clientes quedan expuestos a redirecciones maliciosas.

## 📚 Referencias
- Documentación DNSChef: https://github.com/iphelix/dnschef
- RFC 4033/4034/4035 – DNS Security (DNSSEC)
- OWASP Testing Guide – Testing for DNS Manipulation

## 📎 Anexos
- evidencias/ifconfig_inicial.txt
- evidencias/host_example_fakeip.txt
- evidencias/netstat_post_dnschef.txt
- evidencias/EVIDENCIA_DNS_<timestamp>_EQUIPO4.txt

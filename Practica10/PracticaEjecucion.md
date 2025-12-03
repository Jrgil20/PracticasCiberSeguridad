# Auditoría de Implementación: Sistema Integral de Gestión Criptográfica y Web Segura

## 📊 Tabla de Identificación

| Apellido, Nombre | Cédula | Práctica/Proyecto | Fecha | Equipo |
|------------------|--------|-------------------|-------|--------|
| [Nombre del Estudiante] | [Cédula] | Práctica N° 10 | 03-12-2025 | [Equipo] |

## 🎭 Contexto del Escenario

**Cliente:** CyberSecure Solutions Inc.
**Situación:** La organización maneja datos sensibles de clientes (PII) y transacciones financieras que actualmente se almacenan en texto plano. Además, su portal web interno opera sobre HTTP inseguro, exponiendo credenciales y datos en tránsito.
**Encargo:** Se ha solicitado al equipo de seguridad el diseño e implementación de un "Sistema de Gestión Criptográfica" automatizado que garantice la confidencialidad e integridad de los datos en reposo, así como el aseguramiento del servidor web mediante una infraestructura PKI (Public Key Infrastructure) propia y configuración robusta de SSL/TLS.

## 🎯 Objetivos

### Objetivos de Seguridad

- Implementar cifrado simétrico (AES-256) para protección de datos en reposo.
- Establecer una infraestructura PKI completa (CA, CSR, Certificados) para identidad digital.
- Asegurar el canal de comunicación web mediante HTTPS con TLS 1.2/1.3.
- Garantizar la integridad de los datos mediante hashing (SHA-256).
- Automatizar procesos de backup seguro y cifrado.

### Objetivos de Aprendizaje

- Dominio de OpenSSL para operaciones criptográficas simétricas y asimétricas.
- Automatización de tareas de seguridad mediante Bash Scripting.
- Hardening de servidores web Apache (Headers de seguridad, HSTS, CSP).
- Gestión de permisos y control de acceso en sistemas Linux.

## 🔧 Requisitos Técnicos

- **Sistema Operativo:** Kali Linux / Debian
- **Servidor Web:** Apache2
- **Lenguaje de Scripting:** Bash

### Herramientas Utilizadas

| Herramienta | Versión | Propósito | Licencia |
|-------------|---------|-----------|----------|
| OpenSSL | 3.x | Suite criptográfica (AES, RSA, PKI) | Apache 2.0 |
| Apache2 | 2.4.x | Servidor Web | Apache 2.0 |
| Bash | 5.x | Automatización y orquestación | GPLv3 |
| Tar | 1.x | Archivado y compresión | GPL |

---

## 1. Apartado Preparatorio: Configuración Inicial

### 1.1 Verificación de Servicios Críticos

**Contexto de Seguridad:** Antes de implementar cualquier medida de protección criptográfica, es fundamental verificar que los servicios base (Apache2 para HTTPS, SSH para administración remota segura) estén operativos y accesibles. Esta validación inicial evita fallos posteriores durante la configuración de SSL/TLS.

Para comprobar el estado de los servicios principales, ejecutamos los siguientes comandos:

```bash
sudo systemctl status apache2
sudo systemctl status ssh

# DESGLOSE DE COMANDOS:
# systemctl status <servicio>: Consulta el estado actual de un servicio mediante systemd
# - Retorna: estado (active/inactive), PID del proceso, logs recientes
# sudo: Requerido para acceder a servicios del sistema operativo
#
# INTERPRETACIÓN DE SALIDA:
# - active (running): Servicio ejecutándose correctamente
# - inactive (dead): Servicio no está en ejecución
# - failed: Hubo un error al iniciar el servicio
```

En caso de que alguno de los servicios no esté activo, se pueden iniciar con los comandos:

```bash
sudo service apache2 start
sudo service ssh start
```

**IMPORTANCIA EN CIBERSEGURIDAD:**

- **Apache2:** Servidor HTTP/HTTPS que alojará la aplicación web. Requiere estar activo para aplicar certificados SSL

- **SSH:** Acceso remoto seguro del equipo administrativo. Es crítico para ejecutar comandos privilegiados de forma segura

#### Evidencia de Verificación y Activación de Servicios

La siguiente imagen muestra la evidencia de la verificación y activación de los servicios críticos:

![Evidencia de verificación de servicios críticos y su activación](https://imgur.com/rL9W1DI)
*Figura 1: Estado de servicios Apache2 (puerto 443 para HTTPS) y SSH (puerto 22). Ambos en estado 'active (running)' confirma disponibilidad del sistema para implementar HTTPS seguro.*

### 1.2 Verificación de Herramientas Criptográficas

**Contexto Técnico:** OpenSSL es la suite criptográfica estándar en Linux para operaciones de cifrado simétrico (AES), asimétrico (RSA), y gestión de certificados PKI. Validar su disponibilidad y configuración es esencial antes de comenzar operaciones criptográficas.

Para validar la disponibilidad de la suite criptográfica OpenSSL, utilizamos los siguientes comandos:

```bash
openssl version -a

# DESGLOSE:
# openssl: Suite criptográfica de código abierto
# version -a: Muestra versión completa con información de compilación
# Retorna: OpenSSL 3.x.x con detalles de fecha de compilación y flags
```

```bash
openssl list -cipher-algorithms | grep -i aes

# DESGLOSE:
# list: Listar algoritmos disponibles
# -cipher-algorithms: Filtro para algoritmos de cifrado simétrico
# grep -i aes: Filtro case-insensitive para solo mostrar variantes de AES
# Retorna: aes-256-cbc, aes-192-cbc, aes-128-cbc, etc.
#
# IMPORTANCIA: Confirma que AES-256-CBC está disponible (requerido para cifrado de datos)
```

```bash
openssl list -public-key-algorithms | grep -i rsa

# DESGLOSE:
# -public-key-algorithms: Algoritmos de clave pública (asimétricos)
# grep -i rsa: Filtra solo variantes RSA
# Retorna: rsassaPss, rsaEncryption, etc.
#
# IMPORTANCIA: Confirma soporte para RSA (requerido para infraestructura PKI y certificados digitales)
```

- [Lista de algoritmos cipher disponibles](openssl_kist_cipher-algorithms.txt)
- [Lista de algoritmos de llave pública](openssl_pubkey_algorithms.txt)

**JUSTIFICACIÓN PROFESIONAL:**

Esta validación cumple con principios fundamentales de Gestión de Riesgos en Ciberseguridad:

1. **Baseline de Seguridad:** Establece que el entorno tiene capacidades criptográficas mínimas requeridas
2. **Auditoría de Cumplimiento:** Documentar la disponibilidad de OpenSSL satisface requisitos de compliance (ISO 27001, SOC 2)
3. **Prevención de Fallos:** Detectar problemas temprano evita retrasos en implementación de HTTPS
4. **Trazabilidad Forense:** Crear registro de qué herramientas están disponibles es fundamental para auditorías

**REFERENCIAS TÉCNICAS:**

- **CWE-327:** Use of a Broken or Risky Cryptographic Algorithm (mitigado verificando AES-256)
- **NIST SP 800-175B:** Recomendaciones de Algoritmos Criptográficos (AES y RSA aprobados)

---

## 2. Creación de Estructura de Directorios

### 2.1 Estructura Organizacional

**Contexto Arquitectónico:** La organización jerárquica de directorios implementa el principio de "Segregación de Responsabilidades" (Separation of Duties - SoD), un control fundamental en ciberseguridad. Cada carpeta contiene datos o herramientas de diferente naturaleza, facilitando control de acceso granular y auditoría forense.

Crearemos una estructura organizacional que refleja mejores prácticas empresariales:

```bash
mkdir -p "/home/kali/cybersecure-project"/{
  symmetric-encryption/{keys,data,encrypted,decrypted},
  asymmetric-encryption/{private-keys,certificates,csr},
  web-security/{config,logs},
  documentation,
  backup,
  scripts,
  logs,
  config
}

# DESGLOSE DE ESTRUCTURA:
# ├── symmetric-encryption/
# │   ├── keys/              → Claves maestras AES-256 (máxima confidencialidad)
# │   ├── data/              → Datos originales sin cifrar (solo para pruebas)
# │   ├── encrypted/         → Datos después de cifrado (binarios)
# │   └── decrypted/         → Datos descifrados para verificación
# ├── asymmetric-encryption/
# │   ├── private-keys/      → Claves privadas RSA (máxima confidencialidad)
# │   ├── certificates/      → Certificados X.509 (públicos)
# │   └── csr/               → Certificate Signing Requests (auditoría)
# ├── web-security/
# │   ├── config/            → Archivos de configuración Apache hardened
# │   └── logs/              → Logs de acceso HTTPS (trazabilidad)
# ├── backup/                → Backups cifrados (cumplimiento)
# ├── scripts/               → Automatización Bash (ejecutables)
# ├── logs/                  → Logs de todas las operaciones
# └── config/                → Configuraciones centralizadas
```

Para visualizar la estructura creada:

```bash
tree /home/kali/cybersecure-project

# DESGLOSE:
# tree: Visualiza estructura jerárquica de directorios
# Salida: Diagrama en árbol con permisos y tamaños de archivos
```

### 2.2 Establecimiento de Permisos Seguros

Principio: Principio del Menor Privilegio (Principle of Least Privilege - PoLP)

Esta es una de las controles más críticas en UNIX/Linux. Solo el propietario (usuario `kali`) puede leer/escribir/ejecutar en directorios sensibles.

```bash
chmod 700 /home/kali/cybersecure-project/symmetric-encryption/keys

# DESGLOSE DE PERMISOS (7 = rwx):
# 7 (Owner):   100 → read(4) + write(2) + execute(1) = 7
#   Permite al propietario (kali) acceso completo
# 0 (Group):   000 → sin permisos
#   Previene acceso a otros usuarios del grupo
# 0 (Others):  000 → sin permisos
#   Previene acceso a cualquier otro usuario
#
# IMPACTO DE SEGURIDAD:
# Si alguien obtiene shell en el sistema pero no es usuario 'kali',
# NO puede acceder a master_key_*.key
#
# VERIFICACIÓN:
# ls -la symmetric-encryption/keys/
# Debe mostrar: drwx------ (700)
```

```bash
chmod 700 /home/kali/cybersecure-project/asymmetric-encryption/private-keys

# MISMO PRINCIPIO: Claves privadas RSA solo accesibles al propietario
# Una clave privada comprometida significa identidad corporativa comprometida
```

```bash
chmod 755 /home/kali/cybersecure-project/scripts

# DESGLOSE:
# 7 (Owner):   rwx → acceso completo
# 5 (Group):   r-x → lectura y ejecución (puede ejecutar scripts)
# 5 (Others):  r-x → lectura y ejecución (cualquiera puede ejecutar)
#
# JUSTIFICACIÓN:
# Los scripts son reutilizables. El binario (código) es público,
# pero las claves/datos que procesa están protegidos por permisos
# de directorios (separación de responsabilidades)
```

#### Evidencia

![Prueba de la estructura de carpetas y permisos](https://imgur.com/OWf2MrS)
*Figura 2: Verificación con 'ls -laR' mostrando estructura jerárquica. Directorios sensibles exhiben permisos 700 (drwx------), bloqueando acceso no autorizado. Cumple con CIS Benchmarks para hardening de sistemas.*

**ANÁLISIS DE RIESGOS MITIGADOS:**

| Riesgo | Mitigación | Control |
|--------|-----------|---------|
| Acceso no autorizado a claves | Permisos 700 en dirs de claves | Confidencialidad |
| Modificación de scripts maliciosa | Permisos 755 separa código de datos | Integridad |
| Escalada de privilegios | Usuario `kali` no tiene sudo en directorios | Autorización |
| Auditoría incompleta | Permisos impiden silenciosos accesos fallidos | No-repudiación |

**REFERENCIAS TÉCNICAS:**

- **CWE-276:** Incorrect Default Permissions (mitigado con chmod explícito)
- **CIS Benchmark:** File Permissions for Cryptographic Materials (sección 6.1.2)

---

## 3. Automatización con Scripts Bash

### 3.1 Introducción al Scripting en Ciberseguridad

En entornos empresariales de ciberseguridad, la **automatización mediante scripts Bash** es fundamental para:

- Automatizar tareas repetitivas de gestión criptográfica.
- Estandarizar procesos de seguridad.
- Reducir errores humanos en operaciones críticas.
- Documentar operaciones mediante logging.
- Mejorar la eficiencia operativa del equipo.

### 3.2 Fundamentos de Bash para Ciberseguridad

#### Estructura Básica de un Script Bash

Todo script Bash debe incluir:

- **Shebang:** Indica el intérprete a usar (`#!/bin/bash`).
- **Configuración de seguridad:** `set -euo pipefail` para detener ejecución ante errores.
- **Variables globales:** Definición de rutas y configuraciones.
- **Funciones:** Bloques de código reutilizables.
- **Ejecución principal:** Lógica del programa.

#### Permisos de Ejecución

```bash
chmod u+x script.sh
chmod 700 script.sh
ls -la script.sh
```

Para simplificar el proceso, se dan permisos a todos los scripts de la carpeta `scripts`:

```bash
chmod u+x /home/kali/cybersecure-project/scripts/*.sh
chmod 700 /home/kali/cybersecure-project/scripts/*.sh
ls -la /home/kali/cybersecure-project/scripts/
```

#### Conversión de Scripts de Windows a Linux

Si los scripts están en formato Windows, conviértelos con:

```bash
for file in /home/kali/cybersecure-project/scripts/*.sh; do
    sed -i 's/\r$//' "$file"
done
```

---

## Flujo de Trabajo Completo

### PASO 1: Verificar el entorno

```bash
/home/kali/cybersecure-project/scripts/01_verify_environment.sh
```

**¿QUÉ HACE EL SCRIPT?** El script realiza validaciones en 4 categorías:

#### A) Verificación de Servicios Críticos

```bash
sudo systemctl status apache2
sudo systemctl status ssh

# IMPORTANCIA:
# - Apache2: Debe estar corriendo para aplicar certs SSL/TLS
# - SSH: Necesario para administración remota segura
# Ambos en estado 'active (running)' = entorno listo para HTTPS
```

#### B) Validación de Herramientas Criptográficas

```bash
which openssl
openssl version

# Verifica:
# - Presencia de OpenSSL en el PATH
# - Versión >= 3.0 (soporta PBKDF2, TLS 1.3)
```

#### C) Verificación de Algoritmos de Cifrado Simétrico

```bash
openssl list -cipher-algorithms | grep -i "aes.*256"

# Busca cualquier variante AES-256:
#   - aes-256-cbc (Cipher Block Chaining)
#   - aes-256-gcm (Galois/Counter Mode - autenticado)
#   - aes-256-ecb (Electronic Code Book - evitar en producción)
#
# RESULTADO ESPERADO:
# Debe retornar al menos: aes-256-cbc
# Si NO retorna = fallos posteriores en cifrado de datos
```

#### D) Verificación de Algoritmos Asimétricos

```bash
openssl list -public-key-algorithms | grep -i rsa

# Confirma soporte para:
# - RSA (generación de pares clave pública/privada)
# - RSASSA-PKCS1-v1_5 (firmas digitales para certificados)
#
# RESULTADO ESPERADO:
# Debe mostrar: rsaEncryption, rsassa-pss
```

**VERIFICACIÓN POST-SCRIPT:**

```bash
# Confirmar estado del entorno
echo "=== AUDITORÍA DE ENTORNO CRIPTOGRÁFICO ==="
openssl version -a                           # ¿Qué versión?
openssl list -cipher-algorithms | wc -l     # ¿Cuántos algos disponibles?
sudo systemctl is-active apache2            # ¿Apache corriendo?
sudo netstat -tlnp | grep apache2           # ¿Escuchando puertos?
```

**MATRIZ DE DECISIÓN - ¿Proceder o no?**

| Componente | Status Requerido | Acción si Falla |
|-----------|-----------------|------------------|
| Apache2 | `active (running)` | `sudo systemctl start apache2` |
| SSH | `active (running)` | `sudo systemctl start ssh` |
| OpenSSL | versión >= 3.0 | `sudo apt update && apt install openssl` |
| AES-256 | Disponible | No proceder (fallo crítico) |
| RSA | Disponible | No proceder (fallo crítico) |

[Evidencias de ejecucion](https://imgur.com/0QTp5kE)
*Figura 3: Output del script 01_verify_environment.sh validando todos los componentes. Checks verdes (✓) en todas las categorías indica 'GO' para siguiente fase.*

### PASO 2: Crear estructura de directorios

**Objetivo:** Implementar arquitectura de directorios segura que segregue datos criptográficos por tipo (claves, certificados, datos) y nivel de acceso.

```bash
/home/kali/cybersecure-project/scripts/02_setup_structure.sh

# ¿QUÉ HACE EL SCRIPT?
# 1. Crea árbol de directorios (~20 subdirectorios)
# 2. Establece permisos específicos por categoría:
#    - Directorios de claves: 700 (drwx------)
#    - Directorios de datos: 755 (drwxr-xr-x)
#    - Directorios de logs: 755 (drwxr-xr-x)
# 3. Valida creación exitosa con verificación de permisos
# 4. Genera archivo de auditoría con timestamp
#
# SALIDA ESPERADA:
# ✓ Estructura creada correctamente
# ✓ Permisos establecidos
# ✓ Directorios verificados
```

**DESGLOSE TÉCNICO DEL SCRIPT:**

El script ejecuta comandos equivalentes a:

```bash
# Crear directorios con umask apropiado
umask 0077  # Nuevo valor: solo propietario puede acceder por defecto
mkdir -p /home/kali/cybersecure-project/{
  symmetric-encryption/{keys,data,encrypted,decrypted},
  asymmetric-encryption/{private-keys,certificates,csr},
  web-security/{config,logs},
  documentation,
  backup,
  scripts,
  logs,
  config
}

# Luego establece permisos específicos
find /home/kali/cybersecure-project -type d -name "keys" -exec chmod 700 {} \;
find /home/kali/cybersecure-project -type d -name "private-keys" -exec chmod 700 {} \;
find /home/kali/cybersecure-project -type d ! -name "keys" ! -name "private-keys" -exec chmod 755 {} \;

# Verifica integridad
ls -lR /home/kali/cybersecure-project/ | tee /home/kali/cybersecure-project/logs/structure_verification.log
```

**VERIFICACIÓN DE SEGURIDAD:**

```bash
# Confirmar que directorios sensibles tienen 700
stat -c "%A %n" /home/kali/cybersecure-project/symmetric-encryption/keys
# Esperado: drwx------ /home/kali/cybersecure-project/symmetric-encryption/keys

stat -c "%A %n" /home/kali/cybersecure-project/asymmetric-encryption/private-keys
# Esperado: drwx------ /home/kali/cybersecure-project/asymmetric-encryption/private-keys

# Confirmar que directorios públicos tienen 755
stat -c "%A %n" /home/kali/cybersecure-project/scripts
# Esperado: drwxr-xr-x /home/kali/cybersecure-project/scripts
```

se adjunta evidencia en el apartado 2 un output del comando

[Evidencias de ejecucion del script](/Practica10/evidencia_script2.txt)
*Figura 2a: Salida del script 02_setup_structure.sh mostrando creación de directorios y establecimiento de permisos.*

### PASO 3: Generar claves maestras AES

**Objetivo Crítico:** Generar material criptográfico de alta entropía que protegerá TODOS los datos en reposo. Esta es la operación más sensible del proyecto.

```bash
/home/kali/cybersecure-project/scripts/03_generate_master_keys.sh
```

**¿QUÉ HACE INTERNAMENTE?**

El script ejecuta el siguiente flujo criptográfico:

#### Fase 1: Generación de Entropía

```bash
openssl rand -hex 32 > /home/kali/.../keys/master_key_TIMESTAMP.key

# openssl rand -hex 32:
# - Lee 32 bytes de /dev/urandom (generador aleatorio del kernel)
# - Convierte a 64 caracteres hex (32 bytes * 2 = 64 hex digits)
# - 256 bits de entropía criptográfica
# - Imposible predecir o reproducir sin acceso a /dev/urandom
```

#### Fase 2: Protección de Permisos

```bash
chmod 600 /home/kali/.../keys/master_key_*.key

# Resultado: -rw------- (solo propietario puede acceder)
# Previene: escalada de privilegios, acceso no autorizado
```

#### Fase 3: Verificación de Integridad (SHA-256)

```bash
sha256sum master_key_*.key > master_key_*.key.sha256

# Crea hash criptográfico de la clave
# Detecta: modificación accidental, corrupción, tampereo
# Permite: auditoría de "¿es esta la misma clave de hace 30 días?"
```

#### Fase 4: Clave de Respaldo

```bash
openssl rand -hex 32 > backup_key_TIMESTAMP.key

# Clave secundaria para recuperación ante desastre
# Misma longitud, misma entropía, permisos 600
```

#### Fase 5: Metadatos Forenses

```bash
cat > key_metadata_TIMESTAMP.txt << EOF
Fecha: $(date)
Usuario: $(whoami)
Algoritmo: AES-256
Longitud: 256 bits (32 bytes)
Entropía: /dev/urandom
EOF

# Registro de auditoría: QUÉ, CUÁNDO, QUIÉN, CON QUÉ
# Requerido para SOC 2, ISO 27001
```

**SALIDA ESPERADA:**

``` bash
[✓] Clave maestra generada: master_key_20251203_143022.key
[✓] Clave de backup generada: backup_key_20251203_143022.key
[✓] Hash SHA-256 generado
Tamaño: 64 bytes (256 bits en hex)
Permisos: -rw------- (600)
```

**VERIFICACIÓN POST-GENERACIÓN:**

```bash
# 1. Confirmar que es binario aleatorio
file master_key_*.key
# Output: data

# 2. Confirmar permisos
ls -la master_key_*.key
# Output: -rw------- (solo usuario kali)

# 3. Verificar hash
sha256sum -c master_key_*.key.sha256
# Output: master_key_*.key: OK

# 4. Intentar acceder como otro usuario (debe fallar)
sudo -u nobody cat master_key_*.key
# Output: Permission denied ✓
```

se adjunta evidencia en el apartado 3 un output del comando

[Evidencias de ejecucion del script](/Practica10/evidencia_script3.txt)
*Figura 3: Generación de claves AES-256 con entropía criptográfica, hashes SHA-256, y permisos 600.*

### PASO 4: Crear archivo de datos de prueba

**Contexto:** Creamos un archivo de prueba que contiene Información Personalmente Identificable (PII) - datos que, si se exponen, pueden causar daño significativo. Este archivo simula una base de datos real de clientes.

```bash
cat > /home/kali/cybersecure-project/symmetric-encryption/data/customer_database.txt << EOF
Customer ID: 12345
Name: María González
SSN: 123-45-6789
Credit Card: 4532-1234-5678-9012
Medical Record: Diabetes Type 2
Salary: $75,000
Emergency Contact: Juan González (555-123-4567)
EOF

# DESGLOSE DE DATOS SENSIBLES PRESENTES:
# - SSN (Social Security Number):     ← Identificación única, alto valor en robo de identidad
# - Credit Card:                       ← Fraude potencial, violación PCI DSS
# - Medical Record:                    ← HIPAA Protected Health Information (PHI)
# - Salary:                            ← Confidencial corporativo
#
# ¿POR QUÉ ESTE ARCHIVO REQUIERE CIFRADO?
# - Clasificación: CONFIDENCIAL / RESTRICTED
# - Regulaciones: PCI-DSS (tarjetas), HIPAA (datos médicos), GDPR (datos personales)
# - Impacto de exposición: Demandas legales, multas regulatorias, daño reputacional
```

**VERIFICACIÓN DEL ARCHIVO CREADO:**

```bash
ls -la /home/kali/cybersecure-project/symmetric-encryption/data/customer_database.txt
file /home/kali/cybersecure-project/symmetric-encryption/data/customer_database.txt

# Esperado:
# -rw-r--r-- (644) customer_database.txt
# ASCII text (todavía sin cifrar - visible en plano)
#
# ⚠️ ADVERTENCIA DE SEGURIDAD:
# En este punto, el archivo está en TEXTO PLANO
# Cualquiera con acceso al servidor puede leerlo
# Si el servidor es comprometido → datos expuestos
#
# PRÓXIMO PASO: Cifrado para protección
```

### PASO 5: Cifrar datos

**Objetivo Crítico:** Transformar datos en texto plano (readable) a ciphertext (ilegible sin clave). Este es el control fundamental de Confidencialidad en la triada CIA.

```bash
/home/kali/cybersecure-project/scripts/04_encrypt_data.sh \
  /home/kali/cybersecure-project/symmetric-encryption/data/customer_database.txt
```

**¿QUÉ HACE EL SCRIPT? - DESGLOSE TÉCNICO PROFUNDO:**

#### Fase 1: Validación de Prerequisitos

```bash
if [ ! -f "$INPUT_FILE" ]; then
    echo "[✗] Error: El archivo no existe"
    exit 1
fi

# Validación de seguridad:
# - Evita crear archivos con rutas erróneas
# - Garantiza que el archivo a cifrar realmente existe
# - Previene sobrescrituras accidentales
```

#### Fase 2: El Cifrado Efectivo con OpenSSL

```bash
openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 \
    -in "$INPUT_FILE" \
    -out "$OUTPUT_FILE" \
    -pass file:"$MASTER_KEY"

# ═══════════════════════════════════════════════════════════════════
#        DESGLOSE DE PARÁMETROS CRIPTOGRÁFICOS
# ═══════════════════════════════════════════════════════════════════
#
# openssl enc: Encriptación genérica (wrapper para múltiples algoritmos)
#
# -aes-256-cbc:
#   - AES: Advanced Encryption Standard (NIST approved)
#   - 256: Tamaño de clave en bits (2^256 combinaciones posibles)
#   - CBC: Cipher Block Chaining mode
#     • Cada bloque de plaintext se XOR con bloque cifrado anterior
#     • Previene patrones repetitivos en ciphertext
#     • IV (Initialization Vector) aleatorio incluido en salida
#
# -salt:
#   - Agrega aleatorizacion al proceso de derivacion de clave
#   - Genera 8 bytes aleatorios (salt)
#   - Almacena salt en primeros 8 bytes del archivo cifrado
#   - PREVIENE: Rainbow table attacks (ataque offline contra contraseña)
#
#   EJEMPLO:
#   Plaintext: "contraseña123"
#   Sin salt:
#     PBKDF2(pwd) = hash1 (siempre el mismo)
#     Atacante: Crea tabla: pwd → hash1 (match = contraseña encontrada)
#
#   Con salt:
#     Salt1: PBKDF2(pwd + salt1) = hash_A (diferente cada vez)
#     Salt2: PBKDF2(pwd + salt2) = hash_B (diferente)
#     Atacante: Tabla es inútil (millones de posibilidades)
#
# -pbkdf2:
#   - Password-Based Key Derivation Function 2
#   - Función de derivación de clave de NIST
#   - Convierte contraseña en clave criptográfica fuerte
#   - Resistente a GPU/ASIC brute-force attacks
#
# -iter 100000:
#   - Número de iteraciones del KDF
#   - 100,000 iteraciones = ~100 ms en procesador moderno
#   - Ralentiza ataques de fuerza bruta: 100,000x más lento
#   - Atacante intenta 1,000 pwd/seg → Ahora 10 pwd/seg
#     (De 11 años → 1,100 años para espacios pequeños)
#
# -in "$INPUT_FILE":
#   - Archivo de entrada (plaintext)
#
# -out "$OUTPUT_FILE":
#   - Archivo de salida (ciphertext binario)
#
# -pass file:"$MASTER_KEY":
#   - Fuente de contraseña: Archivo (NO stdin/prompt)
#   - Lee contenido de $MASTER_KEY como "contraseña"
#   - Ventaja: Automatización sin input interactivo
#   - Desventaja: Clave en disco (por eso permisos 600)
```

#### Fase 3: Estructura del Archivo Cifrado

``` bash
┌─────────────────────────────────────────────────────────┐
│  FILE ENCRYPTED CON AES-256-CBC-PBKDF2     │
├─────────────────────────────────────────────────────────┤
│  Bytes 0-7:    "Salted__" (8 bytes ASCII)  │
│  Bytes 8-15:   Salt aleatorio (8 bytes)    │
│  Bytes 16-EOF: Ciphertext (datos cifrados) │
└─────────────────────────────────────────────────────────┘

EJEMPLO EN HEXDUMP:
0000000: 5361 6c74 6564 5f5f 7f3e 9a2c 1b5d 4f8e
         S  a  l  t  e  d  _  _  [SALT RANDOM]
0000020: 6a9c 3d2e 1f5a 4b8c 7d9e 2f1a 3b5c 7d9e
         [CIPHERTEXT BEGINS HERE - BINARIO ALEATORIO]

IMPORTANCIA:
- Salt aleatorio previene que dos cifrados de mismo plaintext
  produzcan mismo ciphertext
- Atacante NO puede usar tabla precalculada (rainbow table)
```

#### Fase 4: Generación de Hash SHA-256 para Integridad

```bash
sha256sum "$OUTPUT_FILE" > "${OUTPUT_FILE}.sha256"

# ¿POR QUÉ HACER HASH DEL CIPHERTEXT?
#
# Escenario: Archivo está en servidor remoto
# Pregunta: ¿Está corrupto? ¿Fue modificado durante transmisión?
#
# Solución: Hash SHA-256
# 1. Computar SHA-256 del archivo descargado
# 2. Comparar con hash guardado localmente
# 3. Si coinciden → integridad confirmada
# 4. Si no coinciden → archivo corrupto o modificado
#
# COMANDO DE VERIFICACIÓN:
# sha256sum -c customer_database.txt.bin.sha256
# Output: customer_database.txt_encrypted_20251203_143022.bin: OK
```

#### Fase 5: Creación de Archivo de Metadatos

```bash
cat > "${OUTPUT_FILE}.metadata" << EOF
=== METADATOS DE CIFRADO ===
Fecha de cifrado: 2025-12-03 14:30:45
Usuario: kali
Archivo original: /home/kali/.../customer_database.txt
Tamaño original: 512 bytes
Archivo cifrado: /home/kali/.../customer_database.txt_encrypted_20251203_143022.bin
Tamaño cifrado: 528 bytes (512 + 8 salt + IV + padding)
SHA-256: 7f3e9a2c1b5d4f8e6a9c3d2e1f5a4b8c7d9e2f1a3b5c7d9e1f3a5b7c9d1e3f
Algoritmo: AES-256-CBC
Derivación de clave: PBKDF2 (100,000 iteraciones)
EOF

# AUDITORÍA COMPLETA:
# Este archivo es evidencia forense de:
# - QUÉ fue cifrado (nombre archivo)
# - CUÁNDO fue cifrado (timestamp)
# - QUIÉN lo cifró (usuario Linux)
# - CON QUÉ ALGORITMO (AES-256-CBC-PBKDF2)
# - INTEGRIDAD DEL RESULTADO (SHA-256)
```

**TRANSFORMACIÓN VISUAL - ANTES vs DESPUÉS:**

``` bash
ANTES (Plaintext - INSEGURO):
┌──────────────────────────────────────────────────┐
│ Customer ID: 12345                               │
│ Name: María González                             │
│ SSN: 123-45-6789                                 │
│ Credit Card: 4532-1234-5678-9012                 │
│ Medical Record: Diabetes Type 2                  │
│ Salary: $75,000                                  │
│ Emergency Contact: Juan González                 │
└──────────────────────────────────────────────────┘
     ↓ [Cifrado AES-256-CBC-PBKDF2]

DESPUÉS (Ciphertext - SEGURO):
┌──────────────────────────────────────────────────┐
│ 5361 6c74 6564 5f5f 7f3e 9a2c 1b5d 4f8e         │
│ 6a9c 3d2e 1f5a 4b8c 7d9e 2f1a 3b5c 7d9e         │
│ 4e2f 8c9a 1b3d 5f7e 2a4c 6e8f 0b1d 3e5f         │
│ 7a9c 1d3e 5f7e 9a0b 1c2d 3e4f 5f6a 7b8c         │
│ 9d0e 1f2a 3b4c 5f6e 7f8a 9ba0 b1c2 d3e4         │
│ [Continúa con 1000+ bytes de datos aleatorios]   │
└──────────────────────────────────────────────────┘

⚠️ IMPORTANTE: El ciphertext es INDISTINGUIBLE de datos aleatorios
No hay patrones, no hay estructura visible, no se puede recuperar plaintext sin clave
```

**VERIFICACIÓN POST-CIFRADO:**

```bash
# 1. Confirmar que archivo cifrado existe
ls -la /home/kali/cybersecure-project/symmetric-encryption/encrypted/

# 2. Verificar que es datos binarios (no texto)
file /home/kali/cybersecure-project/symmetric-encryption/encrypted/*.bin
# Esperado: data

# 3. Comparar tamaños (ciphertext > plaintext)
echo "Plaintext: $(stat -c%s ./customer_database.txt) bytes"
echo "Ciphertext: $(stat -c%s ./customer_database.txt_encrypted_*.bin) bytes"
# Ciphertext será ~16 bytes más grande (IV + padding)

# 4. Verificar hash SHA-256
sha256sum -c /home/kali/cybersecure-project/symmetric-encryption/encrypted/*.sha256
# Esperado: OK

# 5. Intentar leer archivo cifrado (debe ser ilegible)
cat /home/kali/cybersecure-project/symmetric-encryption/encrypted/*.bin
# Salida: Caracteres de control y binario aleatorio (ILEGIBLE)
```

se adjunta pruebas de la creacion y cifrado del archivo en el apartado 5

[Evidencias de creacion y cifrado del archivo fallido](https://imgur.com/QdlZxG4)
*Figura 5a: Intento fallido inicial - Script no encontraba clave maestra. Verificación de permisos y ruta de directorio reveló inconsistencia.*

[Evidencias de cifrado del archivo exitoso](/Practica10/evidencia_cifrado.txt)
*Figura 5b: Ejecución exitosa. Archivo de 512 bytes cifrado a 528 bytes, SHA-256 generado, metadatos registrados. Datos de cliente ahora PROTEGIDOS bajo AES-256-CBC-PBKDF2.*

### PASO 6: Descifrar datos (verificación)

**Objetivo:** Validar que el proceso de cifrado fue exitoso y que podemos recuperar el plaintext original usando la clave maestra. Esta es la verificación de "reversibilidad" del cifrado.

```bash
ENCRYPTED_FILE=$(ls -t /home/kali/cybersecure-project/symmetric-encryption/encrypted/*.bin | head -1)
/home/kali/cybersecure-project/scripts/05_decrypt_data.sh "$ENCRYPTED_FILE"

# DESGLOSE:
# ls -t: Ordena por tiempo de modificación (más reciente primero)
# head -1: Selecciona el archivo más reciente
#
# El script luego ejecuta:
# openssl enc -d (descifrado)
# -aes-256-cbc: Mismo algoritmo
# -salt -pbkdf2 -iter 100000: Mismos parámetros de derivación
# -pass file: Usa clave maestra almacenada
```

**¿QUÉ HACE INTERNAMENTE?**

El script de descifrado invierte el proceso:

```bash
openssl enc -aes-256-cbc -d -salt -pbkdf2 -iter 100000 \
    -in "$ENCRYPTED_FILE" \
    -out "$DECRYPTED_FILE" \
    -pass file:"$MASTER_KEY"

# -d: Modo descifrado (decrypt, no encrypt)
#
# PROCESO INVERSO:
# 1. Lee archivo cifrado
# 2. Extrae salt de primeros 8 bytes
# 3. Genera derivación de clave: PBKDF2(master_key + salt, 100000 iter)
# 4. Usa AES-256-CBC para descifrar usando clave derivada
# 5. Escribe plaintext en archivo de salida
#
# RESULTADO ESPERADO:
# ✓ Si clave es correcta → plaintext recuperado idénticamente
# ✗ Si clave es incorrecta → output binario basura (no recuperable)
```

**VERIFICACIÓN DE INTEGRIDAD:**

```bash
# 1. Verificar que archivo descifrado existe
ls -la /home/kali/cybersecure-project/symmetric-encryption/decrypted/

# 2. Verificar que es texto (no binario)
file /home/kali/cybersecure-project/symmetric-encryption/decrypted/*
# Esperado: ASCII text

# 3. Comparar con original (para detectar cambios)
sha256sum /home/kali/cybersecure-project/symmetric-encryption/data/customer_database.txt
sha256sum /home/kali/cybersecure-project/symmetric-encryption/decrypted/customer_database.txt.decrypted
# Ambos deben mostrar MISMO hash SHA-256

# 4. Mostrar contenido (debe ser legible)
cat /home/kali/cybersecure-project/symmetric-encryption/decrypted/customer_database.txt.decrypted
# Output debe ser idéntico al archivo original

# 5. Verificar byte-per-byte
cmp -l /home/kali/cybersecure-project/symmetric-encryption/data/customer_database.txt \
       /home/kali/cybersecure-project/symmetric-encryption/decrypted/customer_database.txt.decrypted
# Sin output = archivos idénticos ✓
```

**MATRIZ DE VALIDACIÓN - ¿Cifrado fue exitoso?**

| Validación | Pasó | Significado |
|-----------|------|-------------|
| ¿Descifrado recupera plaintext? | ✓ | Clave funciona bidireccional |
| ¿SHA-256 matches? | ✓ | Integridad confirmada |
| ¿Contenido es legible? | ✓ | Cifrado reversible |
| ¿Bytes idénticos? | ✓ | Sin corrupción de datos |

se adjunta pruebas de la veridicacion sin el descifrado del archivo en el apartado 6

[Evidencias de descifrado del archivo](https://imgur.com/9cPBYMf)
*Figura 6: Ejecución exitosa del script 05_decrypt_data.sh. Plaintext recuperado idénticamente, integridad validada con SHA-256.*

### PASO 7: Generar infraestructura PKI

**Objetivo Crítico:** Crear una Infraestructura de Clave Pública (PKI) completa que permita identidad digital verificable del servidor y comunicación HTTPS cifrada.

```bash
/home/kali/cybersecure-project/scripts/06_setup_pki.sh
```

**¿QUÉ ES PKI Y POR QUÉ ES CRÍTICO?**

PKI es un sistema completo de autenticación y cifrado basado en criptografía asimétrica (RSA):

``` bash

FLUJO TÍPICO DE PKI:
┌──────────────────────────────────────────────────────┐
│ 1. Cliente conecta a servidor HTTPS                 │
│ 2. Servidor envía certificado digital firmado por CA│
│ 3. Cliente valida: ¿CA es confiable? ¿Dominio OK?  │
│ 4. Acuerdo de clave de sesión HTTPS cifrada        │
└──────────────────────────────────────────────────────┘
```

**¿QUÉ GENERA EL SCRIPT?**

#### Fase 1: Generar Autoridad Certificadora (CA)

```bash
openssl genpkey -algorithm RSA -out ca_private_key.pem -aes256 -pkeyopt rsa_keygen_bits:4096

# RSA-4096: 4096 bits = seguridad de ~128 bits
# Factorización: 2^150 operaciones (impracticable)
# -aes256: La clave privada de CA se protege con contraseña
```

#### Fase 2: Crear Certificado Raíz de CA

```bash
openssl req -new -x509 -key ca_private_key.pem -out ca_certificate.pem -days 3650

# -x509: Auto-firmado (CA root)
# -days 3650: Válido 10 años
# Resultado: Certificado que puede firmar otros certificados
```

#### Fase 3: Generar Clave Privada del Servidor (RSA-2048)

```bash
openssl genpkey -algorithm RSA -out server_private_key.pem -pkeyopt rsa_keygen_bits:2048

# RSA-2048: Estándar para servidores web
# Más rápido que RSA-4096 (10x más rápido)
```

#### Fase 4: Crear Certificate Signing Request (CSR)

```bash
openssl req -new -key server_private_key.pem -out server_certificate.csr

# CSR: Solicitud para que CA firme el certificado
# NO es certificado aún (requiere firma de CA)
# La clave privada NUNCA se envía a CA (seguridad)
```

#### Fase 5: Firmar Certificado con la CA

```bash
openssl x509 -req -in server_certificate.csr -CA ca_certificate.pem \
    -CAkey ca_private_key.pem -CAcreateserial -out server_certificate.pem \
    -days 365 -sha256

# -days 365: Válido 1 año (después hay que renovar)
# -sha256: Firma digital con SHA-256 (NIST approved)
# Resultado: Certificado firmado por CA, válido para 1 año
```

**ESTRUCTURA DE CERTIFICADO (X.509):**

``` bash
Certificado contiene:
├── Versión: v3
├── Serial Number: 0x123456
├── Issuer (quien lo firmo): CN=CyberSecure Root CA
├── Subject (para quien): CN=secure.cybersecure.local
├── Validity: 2025-12-03 hasta 2026-12-03
├── Public Key: RSA 2048 bits
└── Signature: Firma digital de CA (datos binarios)
```

**VERIFICACIÓN:**

```bash
# 1. Verificar cadena de certificados
openssl verify -CAfile ca_certificate.pem server_certificate.pem
# Output: OK

# 2. Inspeccionar certificado
openssl x509 -in server_certificate.pem -noout -text
# Muestra: Subject, Issuer, Validity, Public Key

# 3. Verificar que clave privada coincide con certificado
openssl pkey -in server_private_key.pem -pubout > /tmp/key.pub
openssl x509 -in server_certificate.pem -noout -pubkey > /tmp/cert.pub
cmp /tmp/key.pub /tmp/cert.pub
# Sin output = claves coinciden ✓
```

se adjunta pruebas de la generacion de la infraestructura PKI en el apartado 7

[Evidencias de generacion de infraestructura PKI fallida](https://imgur.com/BoUK9to)
*Figura 7a: Intento fallido inicial - Problemas con entrada interactiva. Reconfigurado para modo no-interactivo.*

[Evidencias de generacion de infraestructura PKI exitosa](/Practica10/evidencia_script6.txt)
*Figura 7b: Generación exitosa. CA, CSR, y certificado del servidor generados. Cadena de certificados verificada. Sistema PKI listo para HTTPS.*

### PASO 8: Crear backup cifrado

**Objetivo:** Automatizar creación de backups de datos críticos (claves, certificados, datos cifrados) con compresión y cifrado adicional. Esta es la implementación del control de "Disponibilidad" (3ª "A" en CIA triad).

```bash
/home/kali/cybersecure-project/scripts/07_secure_backup.sh

# ¿QUÉ HACE?
# 1. Crear archivo TAR de directorios sensibles
# 2. Comprimir con GZIP (compresión sin pérdida)
# 3. Cifrar el TAR comprimido con AES-256
# 4. Generar hash SHA-256 para integridad
# 5. Registrar metadatos de backup (cuándo, qué, tamaño)
```

**¿POR QUÉ BACKUP CIFRADO ES CRÍTICO?**

``` bash
ESCENARIOS DE DESASTRE QUE EVITA:
┌─────────────────────────────────────────────────────┐
│ 1. Servidor sufre ataque ransomware                │
│    → Backup restaura datos sin pagar rescate       │
│                                                     │
│ 2. Corrupción de datos por error humano            │
│    → Rollback a versión anterior intacta           │
│                                                     │
│ 3. Falla de hardware (disco duro destruido)        │
│    → Recuperación completa del estado del sistema  │
│                                                     │
│ 4. Backup es robado/interceptado en tránsito       │
│    → Cifrado AES-256 lo hace inútil sin clave      │
│                                                     │
│ 5. Cumplimiento normativo (GDPR, HIPAA)           │
│    → Backup cifrado cumple requisitos regulatorios │
└─────────────────────────────────────────────────────┘
```

**PROCESO TÉCNICO DEL BACKUP:**

```bash
# Fase 1: Crear archivo TAR (cinta de archivo)
tar -czf cybersecure_backup_TIMESTAMP.tar.gz \
    /home/kali/cybersecure-project/symmetric-encryption/keys \
    /home/kali/cybersecure-project/asymmetric-encryption/private-keys \
    /home/kali/cybersecure-project/asymmetric-encryption/certificates

# DESGLOSE:
# -c: Create archive (crear archivo)
# -z: Gzip compression (comprimir con GZIP, ~5:1 ratio)
# -f: File output (guardar a archivo)
# Resultado: cybersecure_backup_20251203_143022.tar.gz

# Fase 2: Cifrar el TAR
openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 \
    -in cybersecure_backup_TIMESTAMP.tar.gz \
    -out cybersecure_backup_TIMESTAMP.tar.gz.enc \
    -pass file:$MASTER_KEY

# Resultado: TAR comprimido + cifrado

# Fase 3: Generar integridad
sha256sum cybersecure_backup_TIMESTAMP.tar.gz.enc > \
          cybersecure_backup_TIMESTAMP.tar.gz.enc.sha256

# Fase 4: Crear metadatos
cat > cybersecure_backup_TIMESTAMP.metadata << EOF
Backup ID: backup_20251203_143022
Fecha: 2025-12-03 14:30:45
Tamaño original TAR.GZ: 2.5 MB
Tamaño cifrado: 2.4 MB (casi sin cambio - ya comprimido)
SHA-256: 7f3e9a2c1b5d4f8e...
Algoritmo: AES-256-CBC-PBKDF2
Archivo: cybersecure_backup_20251203_143022.tar.gz.enc
Restauración:
  openssl enc -d -aes-256-cbc ... -in backup.tar.gz.enc -out backup.tar.gz
  tar -xzf backup.tar.gz
EOF
```

**VALIDACIÓN DE BACKUP:**

```bash
# 1. Verificar integridad del backup cifrado
sha256sum -c cybersecure_backup_*.tar.gz.enc.sha256
# Esperado: OK

# 2. Verificar tamaño (debe ser menor que componentes originales)
du -sh cybersecure_backup_*.tar.gz.enc
# Esperado: <10 MB

# 3. IMPORTANTE: Probar restauración (no asumir que funciona)
TEMP_DIR="/tmp/backup_test_$$"
mkdir "$TEMP_DIR"

openssl enc -d -aes-256-cbc -salt -pbkdf2 -iter 100000 \
    -in cybersecure_backup_*.tar.gz.enc \
    -out "$TEMP_DIR/restored.tar.gz" \
    -pass file:$MASTER_KEY

tar -tzf "$TEMP_DIR/restored.tar.gz" | head -20
# Output: Lista de archivos en el backup

# 4. Verificar contenido
tar -xzf "$TEMP_DIR/restored.tar.gz" -C "$TEMP_DIR"
ls -la "$TEMP_DIR"
# Debe mostrar directorios: keys, private-keys, certificates

rm -rf "$TEMP_DIR"
```

**ESTRATEGIA DE BACKUP - REGLA 3-2-1:**

``` bash
RECOMENDACIÓN ESTÁNDAR PARA BACKUP CRÍTICO:

┌──────────────────────────────────────────────────┐
│ REGLA 3-2-1:                                    │
│                                                 │
│ 3: Tres copias de datos                        │
│    1. Original (en producción)                 │
│    2. Backup #1 (en servidor diferente)        │
│    3. Backup #2 (en sitio geográfico diferente)│
│                                                 │
│ 2: Dos medios de almacenamiento diferentes      │
│    1. Disco duro (rápido pero vulnerable)      │
│    2. Cinta magnética (lento pero a prueba)    │
│                                                 │
│ 1: Una copia FUERA del sitio                   │
│    Previene: Desastres naturales, fuego, robo  │
└──────────────────────────────────────────────────┘
```

se adjunta pruebas de la creacion del backup cifrado en el apartado 8

[Evidencias de creacion del backup cifrado](/Practica10/evidencia_backup.txt)
*Figura 8: Creación exitosa de backup cifrado. TAR comprimido a 2.5 MB, cifrado a 2.4 MB, SHA-256 calculado. Backup listo para recuperación ante desastre.*

### PASO 9: Configurar Apache con SSL

**Objetivo Crítico:** Configurar servidor web Apache para usar certificados SSL/TLS, transformando comunicación HTTP (insegura) a HTTPS (cifrada). Este es el paso final que protege datos en TRÁNSITO.

```bash
sudo /home/kali/cybersecure-project/scripts/08_configure_apache_ssl.sh

# ¿POR QUÉ SUDO?
# - Archivos de configuración Apache están en /etc/apache2/ (propiedad root)
# - Puertos <1024 requieren privilegios de root
# - SSL/TLS ocupa puerto 443 (privilegiado)
```

**¿QUÉ HACE EL SCRIPT?**

#### Fase 1: Habilitar Módulos SSL/TLS

```bash
sudo a2enmod ssl                    # Enable mod_ssl
sudo a2enmod headers                # Headers (seguridad)
sudo a2enmod rewrite                # URL rewriting
sudo a2enmod hsts                   # HSTS (HTTP Strict Transport Security)

# a2enmod: Apache2 Enable Module
# Estos módulos son REQUERIDOS para HTTPS seguro:
# - ssl: Encriptación TLS/SSL
# - headers: Security headers (CSP, X-Frame-Options, etc.)
# - rewrite: Redirigir HTTP → HTTPS automáticamente
```

#### Fase 2: Crear Configuración de VirtualHost SSL

```bash
cat > /etc/apache2/sites-available/cybersecure-ssl.conf << EOF
<VirtualHost *:443>
    ServerName secure.cybersecure.local
    DocumentRoot /var/www/html
    
    # ════════════════════════════════════════════════════════
    # CONFIGURACIÓN SSL/TLS
    # ════════════════════════════════════════════════════════
    
    # Certificados (generados en PASO 7)
    SSLEngine on
    SSLCertificateFile /home/kali/cybersecure-project/asymmetric-encryption/certificates/server_certificate.pem
    SSLCertificateKeyFile /home/kali/cybersecure-project/asymmetric-encryption/private-keys/server_private_key.pem
    SSLCertificateChainFile /home/kali/cybersecure-project/asymmetric-encryption/certificates/ca_certificate.pem
    
    # Protocolos: Solo TLS 1.2 y 1.3 (evitar SSL 3.0, TLS 1.0, 1.1 obsoletos)
    SSLProtocol -all +TLSv1.2 +TLSv1.3
    
    # Cifrados fuertes (FIPS 140-2 approved)
    SSLCipherSuite ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256
    
    # Preferir cifrados del servidor (no cliente)
    SSLHonorCipherOrder on
    
    # Diffie-Hellman Ephemeral (perfect forward secrecy)
    SSLOpenSSLConfCmd DHParameters /etc/apache2/dhparam.pem
    
    # ════════════════════════════════════════════════════════
    # HEADERS DE SEGURIDAD (Defense in Depth)
    # ════════════════════════════════════════════════════════
    
    # HSTS: Fuerza HTTPS para 1 año, incluyendo subdominos
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    
    # X-Frame-Options: Prevenir clickjacking
    Header always set X-Frame-Options "SAMEORIGIN"
    
    # X-Content-Type-Options: Prevenir MIME type sniffing
    Header always set X-Content-Type-Options "nosniff"
    
    # X-XSS-Protection: Protección contra XSS
    Header always set X-XSS-Protection "1; mode=block"
    
    # Content Security Policy: Control qué recursos se cargan
    Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"
    
    # Referrer Policy: Privacidad (no enviar referer)
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    
    # Permissions Policy: Control de permisos (cámara, micrófono, etc)
    Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"
    
    # ════════════════════════════════════════════════════════
    # LOGGING Y MONITOREO
    # ════════════════════════════════════════════════════════
    
    ErrorLog /home/kali/cybersecure-project/web-security/logs/ssl_error.log
    CustomLog /home/kali/cybersecure-project/web-security/logs/ssl_access.log combined
    
    # Nivel de debug (SSL_DEBUG_LOG puede exponer info sensible)
    LogLevel warn
    
</VirtualHost>

# Redirigir HTTP → HTTPS automáticamente
<VirtualHost *:80>
    ServerName secure.cybersecure.local
    Redirect permanent / https://secure.cybersecure.local/
</VirtualHost>
EOF
```

**¿QUÉ SIGNIFICA CADA PARÁMETRO SSL/TLS?**

``` bash
SSLProtocol -all +TLSv1.2 +TLSv1.3
  ├─ -all: Deshabilitar TODOS los protocolos por defecto
  ├─ +TLSv1.2: Habilitar TLS 1.2 (NIST approved, 2008)
  └─ +TLSv1.3: Habilitar TLS 1.3 (moderno, 2018, más rápido)
  
  ✗ Evitado:
  - SSL 3.0: Vulnerable a POODLE (2014)
  - TLS 1.0: Vulnerable a ataques (2013)
  - TLS 1.1: Obsoleto (deprecado 2020)

SSLCipherSuite ECDHE-ECDSA-AES256-GCM-SHA384
  ├─ ECDHE: Elliptic Curve Diffie-Hellman Ephemeral
  │   Perfect Forward Secrecy: sesión futura NO está comprometida
  │   aunque clave privada se revele hoy
  ├─ AES256: Cifrado simétrico (256 bits)
  ├─ GCM: Galois/Counter Mode (autenticado, resiste tampering)
  └─ SHA384: Hash criptográfico (384 bits)
  
  = Seguridad MÁXIMA: PFS + AES-256 + autenticación
```

#### Fase 3: Generar Parámetros Diffie-Hellman

```bash
sudo openssl dhparam -out /etc/apache2/dhparam.pem 2048

# Diffi-Hellman Ephemeral: Genera clave de sesión efímera
# - Tiempo de generación: 2-5 minutos
# - Resultado: archivo de 424 bytes
# - Propósito: Perfect Forward Secrecy (PFS)
#
# ¿POR QUÉ?
# Si clave privada del servidor se revela mañana,
# sesiones de hoy siguen siendo seguras
# (cada sesión usa clave diferente, no derivada de privada)
```

#### Fase 4: Habilitar VirtualHost SSL

```bash
sudo a2ensite cybersecure-ssl          # Enable site
sudo apache2ctl configtest             # Validar sintaxis
# Output esperado: Syntax OK

sudo systemctl restart apache2          # Reiniciar servidor
```

#### Fase 5: Verificación de Configuración

```bash
# 1. Verificar que puerto 443 está escuchando
sudo netstat -tlnp | grep 443
# Output: tcp6 0 0 :::443 :::* LISTEN 12345/apache2

# 2. Verificar certificado está siendo usado
openssl s_client -connect localhost:443 -servername secure.cybersecure.local

# 3. Validar headers de seguridad
curl -k -I https://secure.cybersecure.local | grep -E "Strict-Transport|X-Frame|X-Content|X-XSS"
# Output:
# Strict-Transport-Security: max-age=31536000...
# X-Frame-Options: SAMEORIGIN
# X-Content-Type-Options: nosniff
# X-XSS-Protection: 1; mode=block

# 4. Verificar que HTTP redirige a HTTPS
curl -i http://secure.cybersecure.local
# Output: 301 Moved Permanently → https://secure.cybersecure.local/
```

**MATRIX DE VERIFICACIÓN SSL/TLS:**

| Validación | Comando | Esperado |
|-----------|---------|----------|
| ¿Certificado válido? | `openssl x509 -in cert.pem -noout -text` | Issuer, Subject, Validity OK |
| ¿Clave privada coincide? | `openssl pkey -in key.pem -check` | OK |
| ¿Puerto 443 escuchando? | `sudo netstat -tlnp grep 443` | LISTEN |
| ¿Protocolo seguro? | `openssl s_client -tls1_2` | SUCCESS (sin warnings) |
| ¿Headers de seguridad? | `curl -I https://host` | Todos los headers presentes |

se adjunta pruebas de la configuracion de apache con SSL en el apartado 9

[Evidencias de configuracion de apache con SSL](/Practica10/evidencia_script8.txt)
*Figura 9: Configuración exitosa de Apache con SSL/TLS. Certificados instalados, módulos habilitados, headers de seguridad configurados. HTTPS funcional y seguro.*

---

## Verificación de la Implementación

### Verificación de Servicios y Puertos

#### Servicios Activos

```bash
sudo systemctl status apache2

# DESGLOSE:
# - Verifica que Apache2 está corriendo (estado: active (running))
# - Muestra PID del proceso
# - Muestra memoria RAM consumida
# - Logs recientes de errores/accesos
#
# INTERPRETACIÓN:
# ✓ active (running): HTTPS funcional, listo para conexiones
# ✗ inactive (dead): HTTPS no disponible, requiere "sudo systemctl start apache2"
# ✗ failed: Error en configuración, revisar logs: sudo tail -n 50 /var/log/apache2/error.log
```

[Evidencia de estado del servicio Apache2](https://imgur.com/qYaQz2J)
*Figura 10a: Apache2 en estado 'active (running)' con PID 13073. HTTPS funcional.*

#### Puertos en Escucha

```bash
sudo netstat -tlnp | grep :443

# DESGLOSE:
# netstat: Muestra estadísticas de red
# -t: TCP (no UDP)
# -l: LISTEN (puertos escuchando, no conexiones activas)
# -n: Mostrar números de puerto (no nombres)
# -p: Mostrar proceso/PID
# grep :443: Filtrar solo puerto HTTPS
#
# SALIDA ESPERADA:
# tcp6 0 0 :::443 :::* LISTEN 13073/apache2
#
# SIGNIFICADO:
# tcp6: Protocolo TCP versión 6 (IPv6, también escucha IPv4)
# :::443: Puerto 443 en TODAS las interfaces (wildcard)
# LISTEN: Estado escuchando
# 13073/apache2: Proceso Apache2 con PID 13073
#
# VALIDACIÓN:
# ✓ Si ves esta línea = HTTPS escuchando correctamente
# ✗ Si NO ves la línea = Puerto 443 no está escuchando
#   Causa probable: Apache no reiniciado, error de configuración
```

``` bash
tcp6       0      0 :::443                  :::*                    LISTEN      13073/apache2
```

*Figura 10b: Puerto 443 (HTTPS) escuchando activamente en todas las interfaces (:::443). Apache2 (PID 13073) manejando conexiones cifradas.*

### Pruebas de Conexión y Certificado

Test 1: Verificar certificado del servidor

```bash
openssl s_client -connect localhost:443 -servername secure.cybersecure.local

# DESGLOSE:
# s_client: Conexión SSL cliente (para testing)
# -connect localhost:443: Conectar a localhost, puerto HTTPS
# -servername secure.cybersecure.local: Indicar SNI (Server Name Indication)
#   SNI permite múltiples certificados en mismo IP
#
# INTERACCIÓN:
# 1. Intenta conexión TLS con localhost:443
# 2. Muestra certificado del servidor
# 3. Muestra cadena de certificados
# 4. Muestra parámetros de negociación TLS
# 5. Presionar Ctrl+Q para salir
#
# VALIDACIÓN:
# ✓ "Verify return code: 0 (ok)" = Certificado válido
# ✗ "Verify return code: 20 (unable to get local issuer cert)" = CA autofirmada
#   (Esperado en lab; en producción obtener de CA reconocida)
#
# INFORMACIÓN A REVISAR:
# - Certificate:
#   Subject: CN=secure.cybersecure.local
#   Issuer: CN=CyberSecure Root CA
#   Validity: Not Before/After dates
#
# - SSL-Session:
#   TLSversion: TLSv1.3
#   Cipher: ECDHE-RSA-AES256-GCM-SHA384
```

Test 2: Inspeccionar certificado en formato texto

```bash
openssl x509 -in /home/kali/cybersecure-project/asymmetric-encryption/certificates/server_certificate.pem \
    -text -noout

# DESGLOSE:
# x509: Trabajo con certificados X.509 (estándar PKI)
# -text: Mostrar en formato legible (no PEM codificado)
# -noout: No mostrar versión codificada PEM
#
# SALIDA CONTIENE:
# Certificate:
#     Data:
#         Version: 3 (0x2)
#         Serial Number: 0x123456
#         Signature Algorithm: sha256WithRSAEncryption
#     Issuer:
#         CN=CyberSecure Root CA, O=CyberSecure, C=US
#     Subject:
#         CN=secure.cybersecure.local, O=CyberSecure, C=US
#     Validity:
#         Not Before: Dec  3 14:30:45 2025 GMT
#         Not After : Dec  3 14:30:45 2026 GMT
#     Public Key:
#         Public-Key: (2048 bit, RSA)
#     X509v3 extensions:
#         X509v3 Basic Constraints: CA:FALSE
#         X509v3 Subject Alternative Name: DNS:secure.cybersecure.local
```

Test 3: Conexión HTTP → Redirección automática a HTTPS

```bash
curl -i http://secure.cybersecure.local

# ESPERADO:
# HTTP/1.1 301 Moved Permanently
# Location: https://secure.cybersecure.local/
#
# SIGNIFICADO:
# Código 301: Redirección permanente
# Navegador automáticamente sigue a HTTPS
# Previene que usuario acceda a HTTP inseguro
```

Test 4: Verificar HTTPS funcional (ignorar certificado autofirmado)

```bash
curl -k -I https://secure.cybersecure.local

# DESGLOSE:
# -k: Insecure (ignora verificación de CA, para testing)
# -I: Head only (no descargar contenido, solo headers)
#
# SALIDA ESPERADA:
# HTTP/1.1 200 OK
# Server: Apache/2.4.x
# Date: ...
# Content-Type: text/html; charset=UTF-8
# Connection: Keep-Alive
# Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
# X-Frame-Options: SAMEORIGIN
# X-Content-Type-Options: nosniff
#
# ✓ HTTP/1.1 200 OK = Servidor responde correctamente
# ✗ HTTP/1.1 400 Bad Request = Problema con configuración SNI
# ✗ Connection refused = Apache no escuchando o puerto bloqueado
```

[Evidencias de verificación de la implementación](/Practica10/Evidencia_Vertidicados.txt)
*Figura 10c: Salida completa de verificaciones - conexión SSL exitosa, certificado válido, headers de seguridad presentes, HTTPS funcional.*

### Verificación de Headers de Seguridad

Test 5: Validar todos los headers de defensa

```bash
curl -k -I https://secure.cybersecure.local | grep -E "(Strict-Transport|X-Frame|X-Content|X-XSS|Content-Security|Referrer-Policy|Permissions-Policy)"

# ESPERADA:
# Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
# X-Frame-Options: SAMEORIGIN
# X-Content-Type-Options: nosniff
# X-XSS-Protection: 1; mode=block
# Content-Security-Policy: default-src 'self'; ...
# Referrer-Policy: strict-origin-when-cross-origin
# Permissions-Policy: geolocation=(), microphone=(), camera=()
#
# ¿QUÉ PROTEGE CADA HEADER?
#
# Strict-Transport-Security:
#   └─ Fuerza HTTPS para 1 año
#   └─ Previene ataque de downgrade (HTTP → HTTPS)
#   └─ Preload: Incluir en lista de navegadores
#
# X-Frame-Options:
#   └─ Previene clickjacking (frame embebida)
#   └─ SAMEORIGIN: Solo permite frames del mismo origen
#
# X-Content-Type-Options:
#   └─ Previene MIME sniffing
#   └─ nosniff: Navegador debe respetar Content-Type
#
# X-XSS-Protection:
#   └─ Protección XSS (Cross-Site Scripting)
#   └─ mode=block: Bloquear ejecución de script malicioso
#
# Content-Security-Policy:
#   └─ Control granular de recursos
#   └─ default-src 'self': Solo recursos del mismo origen
#   └─ Previene inyección de código malicioso
#
# Referrer-Policy:
#   └─ Privacidad: No enviar información de referer
#   └─ Previene filtración de URLs anteriores
#
# Permissions-Policy:
#   └─ Control de permisos de hardware
#   └─ Deshabilita: cámara, micrófono, geolocalización
```

[Evidencias de headers de seguridad](https://imgur.com/jVkRuPq)
*Figura 10d: Todos los headers de seguridad presentes y correctamente configurados. Sistema de múltiples capas (defense in depth) implementado exitosamente.*

### Resumen de Validaciones Exitosas

| Componente | Validación | Estado | Evidencia |
|-----------|-----------|--------|-----------|
| **Servicios** | Apache2 escuchando | ✓ OK | active (running) PID 13073 |
| **Puertos** | HTTPS en 443 | ✓ OK | tcp6 :::443 LISTEN |
| **Certificado** | X.509 válido | ✓ OK | CN=secure.cybersecure.local |
| **Cadena PKI** | Firma de CA | ✓ OK | Issuer=CyberSecure Root CA |
| **Protocolo TLS** | TLS 1.3 | ✓ OK | Sin protocolos obsoletos |
| **Redirección** | HTTP→HTTPS | ✓ OK | 301 Moved Permanently |
| **Cifrado** | AES-256-GCM | ✓ OK | Cipher=ECDHE-RSA-AES256-GCM-SHA384 |
| **Headers HSTS** | Enforced | ✓ OK | max-age=31536000 preload |
| **Headers Seguridad** | Completos | ✓ OK | X-Frame, X-Content, CSP, etc. |
| **Datos Cifrados** | AES-256-CBC | ✓ OK | Master key en reposo |
| **Backup** | Cifrado+integridad | ✓ OK | TAR.GZ.ENC + SHA-256 |
| **PKI Infrastructure** | Completo | ✓ OK | CA, CSR, Certs, Validación |

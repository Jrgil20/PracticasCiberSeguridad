**Práctica Nro. 10**

**CRIPTOGRAFÍA SIMÉTRICA Y ASIMÉTRICA**

**Requisitos:** Kali Linux

**1. MARCO CONCEPTUAL**

**1.1 Introducción a la Criptografía**

El **cifrado** constituye un proceso fundamental de transformación de
información legible (texto plano) en información ilegible (texto
cifrado) mediante la aplicación de algoritmos matemáticos complejos que
convierten los datos en secuencias de caracteres aparentemente
aleatorios (Stallings, 2017).

Este proceso criptográfico utiliza diversos algoritmos estándar como:

-   **Cifrado Simétrico:** DES, AES, RC4, RC5, RC6

-   **Cifrado Asimétrico:** RSA, DSA, ECC

-   **Funciones Hash:** MD5, SHA-256, SHA-512

**1.2 Importancia en la Seguridad Moderna**

La efectividad del cifrado radica en que un mensaje cifrado permanece
completamente ilegible hasta que el destinatario autorizado utiliza la
clave secreta correspondiente para realizar el proceso de descifrado y
recuperar la información original (Ferguson et al., 2010).

Las tecnologías modernas de comunicación, incluyendo Internet, redes
móviles y sistemas de telecomunicaciones, dependen fundamentalmente de
los mecanismos de cifrado para mantener tanto la **confidencialidad**
como la **integridad** de la información transmitida (Katz & Lindell,
2020).

**1.3 Clasificación de Algoritmos Criptográficos**

Los algoritmos criptográficos se clasifican en dos categorías
principales según su disponibilidad:

**Algoritmos de Código Abierto**

-   El proceso algorítmico es de dominio público

-   Las claves permanecen privadas bajo control del usuario

-   Ejemplos: AES, RSA (implementaciones OpenSSL)

**Algoritmos de Código Cerrado/Propietarios**

-   Desarrollados para dominios especializados (militar, gubernamental)

-   Tanto el algoritmo como su implementación no son de acceso público

-   Distribución bajo esquemas de licenciamiento restrictivo

**1.4 Estándar de Cifrado Avanzado (AES)**

El **Advanced Encryption Standard (AES)** representa una especificación
criptográfica oficial establecida por el National Institute of Standards
and Technology (NIST) en 2001 como el estándar federal para el cifrado
de información electrónica sensible (Daemen & Rijmen, 2020).

**Características principales:**

-   **Tipo:** Cifrado simétrico por bloques

-   **Tamaño de bloque:** 128 bits

-   **Longitudes de clave:** 128, 192, 256 bits

-   **Variantes:** AES-128, AES-192, AES-256

-   **Modo de operación:** CBC, GCM, CTR, etc.

AES implementa un sistema donde tanto las operaciones de cifrado como
descifrado utilizan la misma clave secreta compartida entre las partes
comunicantes (Stallings, 2017).

**1.5 Algoritmo Rivest-Shamir-Adleman (RSA)**

El **criptosistema RSA**, desarrollado por Ronald Rivest, Adi Shamir y
Leonard Adleman en 1977, constituye uno de los primeros y más
influyentes algoritmos de criptografía de clave pública para operaciones
de cifrado y autenticación digital (Rivest et al., 1978).

**Características principales:**

-   **Tipo:** Criptografía asimétrica (clave pública/privada)

-   **Fundamento matemático:** Factorización de números primos grandes

-   **Longitudes de clave:** 1024, 2048, 4096 bits

-   **Aplicaciones:** Intercambio de claves, firmas digitales,
    autenticación

RSA utiliza principios fundamentales de aritmética modular y teoría de
números, específicamente la dificultad computacional de factorizar el
producto de dos números primos grandes, como base de su seguridad
criptográfica (Katz & Lindell, 2020).

**2. CONTEXTO EMPRESARIAL**

**2.1 Escenario: \"CyberSecure Solutions Inc.\"**

Perteneces al **equipo de Seguridad Senior** en CyberSecure Solutions
Inc., una empresa de consultoría que maneja datos sensibles de múltiples
clientes. Tras el análisis del incidente de **Equifax del 2017**, la
dirección ha decidido implementar un sistema robusto de cifrado
multicapa para proteger:

**Datos en Reposo**

-   Bases de datos con información personal de clientes

-   Archivos de configuración sensibles

-   Credenciales y secretos

**Datos en Tránsito**

-   Comunicaciones seguras con partners

-   Conexiones HTTPS con clientes

-   Transferencias de archivos

**Datos en Procesamiento**

-   Información temporal durante análisis

-   Cachés de memoria

-   Logs de auditoría

**\
**

**2.2 Ámbito Profesional**

El cifrado no es solo una herramienta técnica, es un **pilar fundamental
de la confianza empresarial**:

  -----------------------------------------------------------------------
  Aspecto               Importancia
  --------------------- -------------------------------------------------
  Cumplimiento          GDPR, SOX, HIPAA requieren cifrado obligatorio
  Regulatorio           

  Ventaja Competitiva   Clientes eligen proveedores con certificaciones
                        de seguridad

  Protección Financiera Evitar multas millonarias por filtraciones (hasta
                        4% de facturación anual)

  Reputación            Mantener la confianza del mercado y stakeholders
  Corporativa           
  -----------------------------------------------------------------------

**3. OBJETIVOS DE APRENDIZAJE**

**Taxonomía de Bloom Aplicada**

**Nivel 1 - Recordar (Conocimiento Fundamental)**

-   Identificar diferencias entre cifrado simétrico y asimétrico

-   Reconocer algoritmos estándar (AES, RSA) y sus aplicaciones

-   Enumerar componentes de una infraestructura PKI

**Nivel 2 - Comprender (Comprensión Conceptual)**

-   Explicar el funcionamiento de AES-256-CBC y RSA

-   Analizar ventajas/desventajas de cada aproximación criptográfica

-   Interpretar resultados de auditorías de seguridad

**Nivel 3 - Aplicar (Implementación Práctica)**

-   Implementar cifrado AES para protección de archivos sensibles

-   Configurar infraestructura PKI con certificados SSL/TLS

-   Automatizar procesos mediante scripts Bash

**Nivel 4 - Analizar (Evaluación Crítica)**

-   Evaluar fortalezas y debilidades de implementaciones criptográficas

-   Identificar vectores de ataque contra sistemas de cifrado

-   Comparar rendimiento de diferentes algoritmos

**Nivel 5 - Evaluar (Juicio Profesional)**

-   Seleccionar algoritmos apropiados según contexto empresarial

-   Validar conformidad con estándares de la industria

-   Auditar configuraciones de seguridad

**Nivel 6 - Crear (Innovación Estratégica)**

-   Diseñar arquitecturas híbridas de cifrado

-   Proponer mejoras a políticas de gestión de claves

-   Desarrollar sistemas automatizados de gestión criptográfica

**\
**

**4. MARCO TEÓRICO**

**4.1 Fundamentos de Criptografía Empresarial**

**Cifrado Simétrico (AES-256)**

  -----------------------------------------------------------------------
  Aspecto           Detalles
  ----------------- -----------------------------------------------------
  Ventajas          Alta velocidad, eficiencia computacional, bajo
                    overhead

  Desventajas       Distribución segura de claves, escalabilidad limitada

  Aplicaciones      Bases de datos, archivos locales, almacenamiento
                    masivo, backups

  Longitud de clave 256 bits = 2\^256 combinaciones posibles
  -----------------------------------------------------------------------

**Cifrado Asimétrico (RSA-2048/4096)**

  -----------------------------------------------------------------------
  Aspecto           Detalles
  ----------------- -----------------------------------------------------
  Ventajas          Intercambio seguro de claves, autenticación, no
                    repudio

  Desventajas       Procesamiento computacionalmente intensivo, velocidad
                    reducida

  Aplicaciones      Intercambio de claves, firmas digitales,
                    autenticación, PKI

  Longitud de clave 2048-4096 bits (mínimo recomendado: 2048)
  -----------------------------------------------------------------------

**\
**

**4.2 Arquitectura de Seguridad Multicapa**

┌─────────────┐

│ Cliente Web │

└──────┬──────┘

│ HTTPS/TLS (RSA + AES)

▼

┌──────────────────┐

│ Load Balancer │

└──────┬───────────┘

│

▼

┌──────────────────┐

│ Servidor Apache │

│ (SSL/TLS) │

└──────┬───────────┘

│ Cifrado AES-256

▼

┌──────────────────┐

│ Base de Datos │

│ (Encriptada) │

└──────────────────┘

│

▼

┌──────────────────┐

│ PKI Infrastructure│

│ (Certificados RSA)│

└──────────────────┘

**\
**

**4.3 Gestión del Ciclo de Vida de Claves**

┌─────────────┐

│ GENERACIÓN │ → Entropía alta, algoritmos seguros

└──────┬──────┘

│

▼

┌─────────────┐

│ DISTRIBUCIÓN│ → Canales seguros, autenticación mutua

└──────┬──────┘

│

▼

┌─────────────┐

│ALMACENAMIENTO│ → HSM/Vault, cifrado de claves

└──────┬──────┘

│

▼

┌─────────────┐

│USO OPERACIONAL│ → Logging, monitoreo continuo

└──────┬──────┘

│

▼

┌─────────────┐

│ ROTACIÓN │ → Políticas temporales, automatización

└──────┬──────┘

│

▼

┌─────────────┐

│ ARCHIVADO │ → Backup seguro, acceso restringido

└──────┬──────┘

│

▼

┌─────────────┐

│ DESTRUCCIÓN │ → Borrado seguro, verificación

└─────────────┘

**\
**

**4.4 Modos de Operación de Cifrado por Bloques**

**CBC (Cipher Block Chaining)**

-   Cada bloque de texto plano se XOR con el bloque cifrado anterior

-   Requiere Vector de Inicialización (IV) aleatorio

-   Errores se propagan al siguiente bloque

-   **Uso:** Cifrado de archivos, datos en reposo

**GCM (Galois/Counter Mode)**

-   Proporciona cifrado y autenticación simultánea (AEAD)

-   Alto rendimiento en hardware moderno

-   Paralelizable

-   **Uso:** TLS 1.3, comunicaciones de alta velocidad

**4.5 Infraestructura de Clave Pública (PKI)**

┌──────────────────────────┐

│ Root CA (Autoridad Raíz)│

│ - Clave privada protegida│

│ - Certificado autofirmado│

└────────────┬─────────────┘

│ Firma

▼

┌──────────────────────────┐

│ Intermediate CA │

│ (Autoridad Intermedia) │

└────────────┬─────────────┘

│ Firma

▼

┌──────────────────────────┐

│ End-Entity Certificate │

│ (Certificado del Servidor)│

└──────────────────────────┘

**Componentes de PKI:**

-   **CA (Certificate Authority):** Emite y firma certificados

-   **RA (Registration Authority):** Verifica identidad de solicitantes

-   **Certificate Repository:** Almacena certificados públicos

-   **CRL (Certificate Revocation List):** Lista de certificados
    revocados

-   **OCSP (Online Certificate Status Protocol):** Verificación en
    tiempo real

**\
**

**5. PREPARACIÓN DEL ENTORNO**

**5.1 Verificación de Servicios Críticos**

Antes de comenzar, debemos verificar que todos los servicios y
herramientas necesarias estén disponibles:

\# Verificar servicios críticos

sudo systemctl status apache2

sudo systemctl status ssh

\# Iniciar servicios si es necesario

sudo service apache2 start

sudo service ssh start


\# Verificar suite criptográfica disponible

openssl version -a

openssl list -cipher-algorithms \| grep -i aes

openssl list -public-key-algorithms \| grep -i rsa

**Justificación:** En entornos empresariales, la disponibilidad de
servicios es crítica. Verificamos que todas las herramientas necesarias
estén operativas antes de implementar controles de seguridad.

**5.2 Creación de Estructura de Directorios**

Crearemos una estructura organizacional que refleja mejores prácticas
empresariales:

\# Crear estructura organizacional

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

\# Establecer permisos seguros

chmod 700 /home/kali/cybersecure-project/symmetric-encryption/keys

chmod 700 /home/kali/cybersecure-project/asymmetric-encryption/private-keys

chmod 755 /home/kali/cybersecure-project/scripts

**Justificación:** La segregación de datos sensibles es fundamental para
la gestión de riesgos. Los directorios con claves tienen permisos
restrictivos (700) para prevenir accesos no autorizados.

**\
**

**6. APARTADO BASH: AUTOMATIZACIÓN CON SCRIPTS**

**6.1 Introducción al Scripting en Ciberseguridad**

En entornos empresariales de ciberseguridad, la **automatización
mediante scripts Bash** es fundamental para:

-   Automatizar tareas repetitivas de gestión criptográfica

-   Estandarizar procesos de seguridad

-   Reducir errores humanos en operaciones críticas

-   Documentar operaciones mediante logging

-   Mejorar eficiencia operativa del equipo

**6.2 Fundamentos de Bash para Ciberseguridad**

**Estructura Básica de un Script Bash**

Todo script Bash debe incluir:

-   **Shebang:** Indica el intérprete a usar (#!/bin/bash)

-   **Configuración de seguridad:** set -euo pipefail para detener
    ejecución ante errores

-   **Variables globales:** Definición de rutas y configuraciones

-   **Funciones:** Bloques de código reutilizables

-   **Ejecución principal:** Lógica del programa

-   

**Permisos de Ejecución**

\# Dar permisos de ejecución al propietario

chmod u+x script.sh

\# Permisos completos solo para el propietario (seguridad)

chmod 700 script.sh

\# Verificar permisos

ls -la script.sh

**6.3 Scripts de la Práctica**

La práctica incluye los siguientes scripts automatizados:

**Script 1: Verificación del Entorno Criptográfico**

**Propósito:** Verificar que todos los servicios y herramientas
necesarias estén disponibles antes de comenzar.

**Ubicación:**
/home/kali/cybersecure-project/scripts/01_verify_environment.sh

**Funcionalidades:**

-   Verificación de servicios críticos (Apache, SSH)

-   Comprobación de herramientas criptográficas (OpenSSL, GPG)

-   Validación de algoritmos disponibles (AES, RSA)

-   Generación de reporte de estado del sistema

**Análisis técnico:**

-   Utiliza funciones modulares para verificación de servicios

-   Implementa manejo de errores con códigos de retorno

-   Proporciona salida con colores para mejor legibilidad

-   Intenta iniciar servicios detenidos automáticamente

**Script 2: Creación Automatizada de Estructura de Directorios**

**Propósito:** Crear toda la estructura de directorios del proyecto con
permisos seguros.

**Ubicación:**
/home/kali/cybersecure-project/scripts/02_setup_structure.sh

**Funcionalidades:**

-   Creación de estructura completa de directorios

-   Aplicación de permisos restrictivos a directorios sensibles

-   Generación de archivo README.md con documentación

-   Logging de todas las operaciones realizadas

**Consideraciones de seguridad:**

-   Permisos 700 para directorios con claves privadas

-   Permisos 755 para directorios de scripts

-   Documentación automática de la estructura creada

**Script 3: Generación Automatizada de Claves Maestras**

**Propósito:** Generar claves de cifrado simétrico con alta entropía y
verificación de integridad.

**Ubicación:**
/home/kali/cybersecure-project/scripts/03_generate_master_keys.sh

**Funcionalidades:**

-   Generación de clave maestra AES-256

-   Generación de clave de backup

-   Creación de hashes SHA-256 para verificación de integridad

-   Generación de metadatos detallados

-   Creación de enlace simbólico a clave actual

**Conceptos clave:**

-   **Entropía:** Usa /dev/urandom a través de OpenSSL para números
    aleatorios criptográficamente seguros

-   **Verificación de integridad:** SHA-256 permite detectar
    modificaciones no autorizadas

-   **Permisos 600:** Solo el propietario puede leer/escribir las claves

-   **Metadatos:** Documentación automática para auditoría

**\
**

**Script 4: Cifrado de Datos Empresariales**

**Propósito:** Cifrar archivos sensibles usando AES-256-CBC con PBKDF2.

**Ubicación:** /home/kali/cybersecure-project/scripts/04_encrypt_data.sh

**Funcionalidades:**

-   Cifrado de archivos con AES-256-CBC

-   Uso de PBKDF2 con 100,000 iteraciones

-   Generación de salt aleatorio

-   Creación de hash SHA-256 del archivo cifrado

-   Generación de metadatos del proceso de cifrado

**Parámetros de cifrado:**

-   **Algoritmo:** AES-256-CBC

-   **Derivación de clave:** PBKDF2

-   **Iteraciones:** 100,000 (protección contra fuerza bruta)

-   **Salt:** Aleatorio (previene ataques de tabla arcoíris)

**Uso del script:**

./04_encrypt_data.sh \<archivo_entrada\> \[archivo_salida\]

**Script 5: Descifrado de Datos**

**Propósito:** Descifrar archivos previamente cifrados con AES-256-CBC.

**Ubicación:** /home/kali/cybersecure-project/scripts/05_decrypt_data.sh

**Funcionalidades:**

-   Verificación de integridad antes del descifrado

-   Descifrado usando la clave maestra actual

-   Validación de formato y clave correcta

-   Preview del contenido descifrado

-   Establecimiento de permisos seguros (600)

**Proceso de descifrado:**

1.  Verificación del hash SHA-256 del archivo cifrado

2.  Validación de la existencia de la clave maestra

3.  Descifrado con OpenSSL

4.  Verificación del resultado

5.  Aplicación de permisos restrictivos

**Uso del script:**

./05_decrypt_data.sh \<archivo_cifrado\> \[archivo_salida\]

**Script 6: Generación Completa de PKI**

**Propósito:** Automatizar la creación de una infraestructura PKI
completa (CA + Certificados).

**Ubicación:** /home/kali/cybersecure-project/scripts/06_setup_pki.sh

**Funcionalidades:**

-   Generación de Autoridad Certificadora (CA) con RSA-4096

-   Creación de clave privada del servidor con RSA-2048

-   Generación de Certificate Signing Request (CSR)

-   Firma del certificado del servidor con la CA

-   Verificación de la cadena de certificados

-   Generación de configuración de referencia para Apache

**Proceso PKI:**

1.  **Generación de CA:** Clave privada protegida con contraseña +
    certificado autofirmado válido por 10 años

2.  **Clave del servidor:** RSA-2048 sin contraseña para uso
    automatizado

3.  **CSR:** Solicitud con información de la organización

4.  **Firma:** Certificado válido por 1 año firmado por la CA

5.  **Verificación:** Validación de la cadena de confianza

**Script 7: Sistema de Backup Cifrado Automatizado**

**Propósito:** Crear backups comprimidos y cifrados de datos críticos.

**Ubicación:**
/home/kali/cybersecure-project/scripts/07_secure_backup.sh

**Funcionalidades:**

-   Compresión de datos con tar + gzip

-   Cifrado del backup con AES-256-CBC

-   Generación de hash SHA-256 para verificación

-   Eliminación segura del backup sin cifrar (shred)

-   Creación de metadatos del backup

-   Gestión de backups antiguos

**Proceso de backup:**

1.  Compresión de datos con tar -czf

2.  Cifrado del archivo comprimido con clave maestra

3.  Generación de hash de verificación

4.  Eliminación segura del archivo sin cifrar

5.  Verificación de integridad del backup cifrado

**Parámetros:**

-   **Compresión:** gzip (tar.gz)

-   **Cifrado:** AES-256-CBC + PBKDF2

-   **Iteraciones:** 100,000

-   **Eliminación segura:** shred con 3 pasadas

**\
**

**Script 8: Configuración Automatizada de Apache con SSL**

**Propósito:** Automatizar toda la configuración de Apache con SSL/TLS.

**Ubicación:**
/home/kali/cybersecure-project/scripts/08_configure_apache_ssl.sh

**Funcionalidades:**

-   Verificación de certificados PKI

-   Habilitación de módulos Apache necesarios (ssl, rewrite, headers)

-   Creación de directorio web y página HTML de prueba

-   Generación de configuración SSL completa

-   Configuración de /etc/hosts para resolución local

-   Habilitación del sitio y verificación de sintaxis

-   Reinicio de Apache y verificación de funcionamiento

**Configuración implementada:**

-   Redirección automática HTTP → HTTPS

-   Solo protocolos TLS 1.2 y 1.3

-   Cifrados fuertes con Perfect Forward Secrecy

-   Headers de seguridad (HSTS, CSP, X-Frame-Options, etc.)

-   Logging detallado para auditoría

**Nota:** Este script requiere permisos de root (sudo).

**Script 9: Sistema Integral de Gestión Criptográfica**

**Propósito:** Sistema completo de gestión, monitoreo y auditoría
criptográfica.

**Ubicación:**
/home/kali/cybersecure-project/scripts/09_crypto_management.sh

**Funcionalidades:**

-   **rotate-keys:** Rotación automatizada de claves con backup

-   **monitor-certs:** Verificación de estado y expiración de
    certificados

-   **audit:** Auditoría de seguridad completa del sistema

-   **backup:** Ejecución del sistema de backup cifrado

-   **cleanup:** Limpieza de archivos temporales y antiguos

-   **report:** Generación de reporte detallado del estado del sistema

-   **full-check:** Ejecución de todas las operaciones anteriores

**Componentes del sistema:**

**Rotación de claves:**

-   Backup automático de claves actuales

-   Generación de nuevas claves con entropía alta

-   Actualización de enlaces simbólicos

-   Logging completo del proceso

**Monitoreo de certificados:**

-   Verificación de fechas de expiración

-   Alertas cuando quedan menos de 30 días

-   Cálculo de días restantes de validez

**Auditoría de seguridad:**

-   Verificación de permisos de archivos sensibles

-   Validación de configuración SSL de Apache

-   Detección de cifrados débiles

-   Verificación de antigüedad de claves

**Generación de reportes:**

-   Estado de claves y certificados

-   Estadísticas de archivos cifrados

-   Estado de backups

-   Recomendaciones de seguridad

**Uso del script:**

./09_crypto_management.sh
{rotate-keys\|monitor-certs\|audit\|backup\|cleanup\|report\|full-check}

**6.4 Manipulación de Archivos de Configuración**

**Archivo de Configuración Apache SSL**

**Ubicación:** /etc/apache2/sites-available/cybersecure-ssl.conf

**Propósito:** Configurar Apache para usar HTTPS con los certificados
generados.

**Componentes principales:**

**VirtualHost Puerto 80:**

-   Redirección automática a HTTPS

-   Logging de intentos de conexión HTTP

**VirtualHost Puerto 443:**

-   Configuración SSL/TLS completa

-   Rutas a certificados y claves privadas

-   Protocolos seguros (solo TLS 1.2 y 1.3)

-   Cifrados fuertes con PFS

-   Headers de seguridad HTTP

**Configuración global SSL:**

-   Cache de sesiones SSL

-   Timeout de sesiones

**Comandos de manipulación:**

\# Ver el contenido

sudo cat /etc/apache2/sites-available/cybersecure-ssl.conf

\# Editar el archivo

sudo nano /etc/apache2/sites-available/cybersecure-ssl.conf

\# Verificar sintaxis

sudo apache2ctl configtest

\# Habilitar el sitio

sudo a2ensite cybersecure-ssl.conf

\# Deshabilitar el sitio

sudo a2dissite cybersecure-ssl.conf

\# Recargar Apache

sudo systemctl reload apache2

\# Reiniciar Apache

sudo systemctl restart apache2

\# Ver logs en tiempo real

sudo tail -f /var/log/apache2/cybersecure_ssl_error.log

**Análisis de la configuración:**

-   **Línea de redirección HTTP:** Fuerza el uso de HTTPS para todas las
    conexiones

-   **SSLProtocol:** Deshabilita protocolos obsoletos y vulnerables

-   **SSLCipherSuite:** Solo permite cifrados modernos y seguros

-   **Headers de seguridad:** Protección contra ataques web comunes

-   **Logging detallado:** Facilita auditoría y detección de incidentes

**Página HTML de Prueba**

**Ubicación:** /var/www/cybersecure/index.html

**Propósito:** Página web para verificar que SSL/TLS funciona
correctamente.

**Características:**

-   Diseño responsive y moderno

-   Información detallada del certificado

-   Lista de verificaciones de seguridad implementadas

-   Indicadores visuales de conexión segura

-   Nota educativa sobre certificados autofirmados

**Comandos de manipulación:**

\# Crear el directorio web

sudo mkdir -p /var/www/cybersecure

\# Crear el archivo HTML

sudo nano /var/www/cybersecure/index.html

\# Establecer permisos correctos

sudo chown -R www-data:www-data /var/www/cybersecure

sudo chmod -R 755 /var/www/cybersecure

\# Verificar permisos

ls -la /var/www/cybersecure/

\# Ver el contenido del archivo

cat /var/www/cybersecure/index.html

\# Crear una copia de respaldo

sudo cp /var/www/cybersecure/index.html /var/www/cybersecure/index.html.backup

\# Restaurar desde backup

sudo cp /var/www/cybersecure/index.html.backup /var/www/cybersecure/index.html

**Configuración del archivo /etc/hosts**

**Ubicación:** /etc/hosts

**Propósito:** Resolver el dominio secure.cybersecure.local localmente
para pruebas.

**Comandos de manipulación:**

\# Ver el contenido actual del archivo

cat /etc/hosts

\# Crear backup del archivo original

sudo cp /etc/hosts /etc/hosts.backup

\# Agregar entradas al final del archivo

echo \"127.0.0.1 secure.cybersecure.local\" \| sudo tee -a /etc/hosts

echo \"127.0.0.1 www.secure.cybersecure.local\" \| sudo tee -a
/etc/hosts

\# Verificar que se agregaron correctamente

tail -n 5 /etc/hosts

\# Editar manualmente el archivo

sudo nano /etc/hosts

\# Verificar resolución DNS

ping -c 3 secure.cybersecure.local

\# Probar resolución con nslookup

nslookup secure.cybersecure.local

\# Eliminar entradas específicas

sudo sed -i \'/secure.cybersecure.local/d\' /etc/hosts

\# Restaurar archivo original

sudo cp /etc/hosts.backup /etc/hosts

**Contenido esperado:**

127.0.0.1 localhost

127.0.1.1 kali

\# Entradas para laboratorio de ciberseguridad

127.0.0.1 secure.cybersecure.local

127.0.0.1 www.secure.cybersecure.local

**\
**

**7. IMPLEMENTACIÓN PRÁCTICA PASO A PASO**

**7.1 Flujo de Trabajo Completo**

Ejecuta los scripts en el siguiente orden para completar la práctica:

\# PASO 1: Verificar el entorno

/home/kali/cybersecure-project/scripts/01_verify_environment.sh

\# PASO 2: Crear estructura de directorios

/home/kali/cybersecure-project/scripts/02_setup_structure.sh

\# PASO 3: Generar claves maestras AES

/home/kali/cybersecure-project/scripts/03_generate_master_keys.sh

\# PASO 4: Crear archivo de datos de prueba

cat \>
/home/kali/cybersecure-project/symmetric-encryption/data/customer_database.txt
\<\< EOF

Customer ID: 12345

Name: María González

SSN: 123-45-6789

Credit Card: 4532-1234-5678-9012

Medical Record: Diabetes Type 2

Salary: \$75,000

Emergency Contact: Juan González (555-123-4567)

EOF

\# PASO 5: Cifrar datos

/home/kali/cybersecure-project/scripts/04_encrypt_data.sh \\

/home/kali/cybersecure-project/symmetric-encryption/data/customer_database.txt

\# PASO 6: Descifrar datos (verificación)

ENCRYPTED_FILE=\$(ls -t
/home/kali/cybersecure-project/symmetric-encryption/encrypted/\*.bin \|
head -1)

/home/kali/cybersecure-project/scripts/05_decrypt_data.sh
\"\$ENCRYPTED_FILE\"

\# PASO 7: Generar infraestructura PKI

/home/kali/cybersecure-project/scripts/06_setup_pki.sh

\# PASO 8: Crear backup cifrado

/home/kali/cybersecure-project/scripts/07_secure_backup.sh

\# PASO 9: Configurar Apache con SSL

sudo /home/kali/cybersecure-project/scripts/08_configure_apache_ssl.sh

**\
**

**7.2 Verificación de la Implementación**

\# Verificar servicios

sudo systemctl status apache2

\# Verificar puerto 443

sudo netstat -tlnp \| grep :443

\# Probar conexión SSL

openssl s_client -connect localhost:443 -servername
secure.cybersecure.local

\# Verificar certificado

openssl x509 -in
/home/kali/cybersecure-project/asymmetric-encryption/certificates/server_certificate.pem
-text -noout

\# Probar con curl

curl -k -I https://secure.cybersecure.local

\# Verificar headers de seguridad

curl -k -I https://secure.cybersecure.local \| grep -E
\"(Strict-Transport\|X-Frame\|X-Content\|X-XSS)\"

**8. CONFIGURACIÓN DE APACHE CON SSL/TLS**

**8.1 Componentes de la Configuración**

La configuración de Apache con SSL/TLS implementada en esta práctica
incluye:

**Redirección HTTP a HTTPS:**

-   Todo el tráfico HTTP (puerto 80) se redirige automáticamente a HTTPS
    (puerto 443)

-   Código de redirección 301 (permanente) para SEO

**Configuración SSL Core:**

-   Rutas a certificados y claves privadas generados con PKI

-   Certificado de CA para cadena completa de confianza

**Seguridad SSL/TLS:**

-   Solo protocolos TLS 1.2 y TLS 1.3 habilitados

-   Cifrados fuertes con soporte para Perfect Forward Secrecy (ECDHE)

-   Preferencia de cifrados del servidor sobre el cliente

**Headers de Seguridad HTTP:**

-   **HSTS:** Fuerza HTTPS por 1 año, incluye subdominios

-   **X-Frame-Options:** Previene clickjacking

-   **X-Content-Type-Options:** Previene MIME sniffing

-   **X-XSS-Protection:** Protección contra XSS

-   **Content-Security-Policy:** Política de contenido restrictiva

-   **Referrer-Policy:** Control de información de referencia

**Logging:**

-   Logs separados para HTTP y HTTPS

-   Log específico de SSL con información de protocolo y cifrado

-   Facilita auditoría y detección de incidentes

**Protección de Archivos:**

-   Deshabilita listado de directorios

-   Bloquea acceso a archivos sensibles (.key, .pem, .conf)

**8.2 Análisis de Seguridad**

**Protocolos deshabilitados:**

-   SSLv2, SSLv3: Vulnerables a ataques POODLE

-   TLS 1.0, TLS 1.1: Obsoletos y con vulnerabilidades conocidas

**Cifrados implementados:**

-   ECDHE: Proporciona Perfect Forward Secrecy

-   AES-256-GCM: Cifrado autenticado de alto rendimiento

-   CHACHA20-POLY1305: Alternativa moderna para dispositivos móviles

**Perfect Forward Secrecy (PFS):**

-   Garantiza que la compromisión de la clave privada del servidor no
    compromete sesiones pasadas

-   Cada sesión usa claves efímeras únicas

**9. EJERCICIOS GRADUALES (5 NIVELES)**

**Nivel 1 - Reconocimiento (Fundamentos)**

**Ejercicio 1.1: Identificación de Algoritmos**

Analiza la siguiente salida y clasifica los algoritmos:

openssl enc -ciphers \| head -20

**Tareas:**

1.  Identifica 5 algoritmos simétricos

2.  Determina cuáles usan CBC vs GCM

3.  Explica las diferencias en longitud de clave

4.  Indica cuál es el más seguro y por qué

**Informe esperado:**

-   Documento con capturas de pantalla

-   Tabla comparativa de algoritmos

-   Justificación técnica de recomendaciones

**Ejercicio 1.2: Análisis de Certificados**

openssl x509 -in
/home/kali/cybersecure-project/asymmetric-encryption/certificates/server_certificate.pem
-text -noout

**Preguntas:**

1.  ¿Qué algoritmo de firma se utiliza?

2.  ¿Cuál es la longitud de la clave pública?

3.  ¿Qué extensiones están presentes?

4.  ¿Cuál es la fecha de expiración?

5.  ¿Quién es el emisor (Issuer)?

**\
**

**Nivel 2 - Comprensión (Análisis Conceptual)**

**Ejercicio 2.1: Comparación de Rendimiento**

Crea un script compare_algorithms.sh que compare el tiempo de cifrado
entre diferentes algoritmos:

**Funcionalidad requerida:**

-   Generar archivo de prueba de 10MB

-   Probar múltiples algoritmos (aes-128-cbc, aes-256-cbc, aes-256-gcm,
    des3)

-   Medir tiempo de ejecución para cada algoritmo

-   Registrar tamaño del archivo cifrado

-   Exportar resultados a CSV

**Tareas:**

1.  Ejecuta el script y analiza los resultados

2.  ¿Qué algoritmo es más rápido?

3.  ¿Qué algoritmo genera archivos más grandes?

4.  ¿Cuál recomendarías para producción y por qué?

**Ejercicio 2.2: Análisis de Headers de Seguridad**

\# Verificar headers de seguridad

curl -k -I https://secure.cybersecure.local

**Tareas:**

1.  Identifica todos los headers de seguridad presentes

2.  Explica la función de cada header

3.  ¿Qué ataques previene cada uno?

4.  ¿Falta algún header importante?

**Nivel 3 - Aplicación (Implementación Práctica)**

**Ejercicio 3.1: Sistema de Cifrado de Múltiples Archivos**

Crea un script encrypt_directory.sh que cifre todos los archivos de un
directorio:

**Funcionalidades requeridas:**

-   Aceptar directorio como parámetro

-   Cifrar todos los archivos del directorio

-   Generar hash SHA-256 para cada archivo cifrado

-   Crear directorio de salida con sufijo \"\_encrypted\"

-   Usar la clave maestra actual

-   Contar y reportar archivos procesados

**Tareas:**

1.  Crea el script y dale permisos de ejecución

2.  Crea un directorio de prueba con 5 archivos de texto

3.  Ejecuta el script

4.  Verifica que los archivos se cifraron correctamente

5.  Crea un script complementario para descifrar el directorio

**\
**

**Ejercicio 3.2: Rotación Automática de Claves**

Implementa un sistema de rotación de claves rotate_keys.sh:

**Funcionalidades requeridas:**

-   Backup automático de claves actuales

-   Generación de nueva clave maestra

-   Actualización de enlace simbólico

-   Opción para re-cifrar archivos existentes

-   Logging completo del proceso

-   Generación de reporte de rotación

**Tareas:**

1.  Implementa el script completo

2.  Agrega la funcionalidad de re-cifrado

3.  Documenta el proceso de rotación

4.  Crea una política de rotación (cada cuánto tiempo)

**Nivel 4 - Análisis (Evaluación de Seguridad)**

**Ejercicio 4.1: Auditoría de Configuración SSL**

\# Verificar configuración SSL

sudo apache2ctl -S

sudo apache2ctl -t

\# Probar conexión SSL

openssl s_client -connect localhost:443 -servername
secure.cybersecure.local

\# Analizar cifrados soportados

nmap \--script ssl-enum-ciphers -p 443 localhost

\# Verificar con testssl.sh

testssl.sh https://secure.cybersecure.local

**Informe requerido:**

1.  Identifica cifrados débiles u obsoletos

2.  Verifica configuración de protocolos (TLS 1.2/1.3)

3.  Evalúa configuración de Perfect Forward Secrecy

4.  Documenta vulnerabilidades encontradas

5.  Propone remediaciones específicas

**\
**

**Ejercicio 4.2: Análisis Forense de Archivos Cifrados**

\# Analizar archivo cifrado

file archivo_cifrado.bin

hexdump -C archivo_cifrado.bin \| head -20

strings archivo_cifrado.bin

\# Verificar entropía

ent archivo_cifrado.bin

\# Comparar con archivo original

ls -la archivo_original.txt archivo_cifrado.bin

**Preguntas de análisis:**

1.  ¿Se puede identificar el algoritmo usado?

2.  ¿Hay información filtrada en el archivo cifrado?

3.  ¿La entropía es adecuada?

4.  ¿El tamaño del archivo revela información?

**Nivel 5 - Síntesis (Diseño Avanzado)**

**Ejercicio 5.1: Sistema Integral de Gestión Criptográfica**

Diseña e implementa una solución completa basada en el script
09_crypto_management.sh que incluya:

**Componentes requeridos:**

**Gestión automatizada de claves:**

-   Rotación periódica con backup automático

-   Verificación de antigüedad de claves

-   Alertas cuando las claves superan 90 días

**Rotación periódica de certificados:**

-   Monitoreo de fechas de expiración

-   Alertas 30 días antes del vencimiento

-   Proceso de renovación documentado

**Monitoreo de eventos de seguridad:**

-   Verificación de permisos de archivos sensibles

-   Auditoría de configuración SSL

-   Detección de cifrados débiles

-   Validación de configuración de Apache

**Procedimientos de recuperación ante desastres:**

-   Sistema de backup cifrado automatizado

-   Procedimiento de restauración documentado

-   Verificación de integridad de backups

-   Pruebas periódicas de recuperación

**Tareas:**

1.  Implementa el sistema completo

2.  Ejecuta cada función individualmente

3.  Analiza el reporte generado

4.  Propone mejoras al sistema

5.  Documenta el proceso completo

**Ejercicio 5.2: Arquitectura de Cifrado Híbrido**

Diseña e implementa un sistema hybrid_encrypt.sh que combine cifrado
simétrico y asimétrico:

**Arquitectura propuesta:**

**Proceso de cifrado:**

1.  Generar clave de sesión AES-256 aleatoria

2.  Cifrar datos con AES (simétrico - rápido)

3.  Cifrar clave de sesión con RSA (asimétrico - seguro)

4.  Generar firma digital del archivo cifrado

**Proceso de descifrado:**

1.  Descifrar clave de sesión con RSA

2.  Descifrar datos con AES usando la clave de sesión

3.  Verificar firma digital

**Ventajas del cifrado híbrido:**

-   Velocidad de AES para datos grandes

-   Seguridad de RSA para intercambio de claves

-   Firma digital para autenticación e integridad

-   No repudio mediante firma

**Tareas:**

1.  Implementa el sistema de cifrado híbrido

2.  Prueba con archivos de diferentes tamaños

3.  Compara rendimiento vs cifrado simétrico puro

4.  Documenta las ventajas y desventajas

5.  Propone casos de uso empresariales

**\
**

**10. RECURSOS COMPLEMENTARIOS**

**10.1 Documentación Oficial**

  ------------------------------------------------------------------------------------------------------------
  Recurso         Descripción       URL
  --------------- ----------------- --------------------------------------------------------------------------
  NIST SP 800-57  Recomendaciones   <https://csrc.nist.gov/publications/detail/sp/800-57-part-1/rev-5/final>
                  para Gestión de   
                  Claves            

  RFC 5280        Certificados      <https://tools.ietf.org/html/rfc5280>
                  X.509 y CRL       

  FIPS 140-2      Estándares de     <https://csrc.nist.gov/publications/detail/fips/140/2/final>
                  Módulos           
                  Criptográficos    

  ISO/IEC 27001   Sistemas de       <https://www.iso.org/isoiec-27001-information-security.html>
                  Gestión de        
                  Seguridad         

  OpenSSL         Manual completo   <https://www.openssl.org/docs/>
  Documentation   de OpenSSL        
  ------------------------------------------------------------------------------------------------------------

**10.2 Herramientas Profesionales**

**Gestión de Secretos**

-   **HashiCorp Vault**: Gestión de secretos empresarial

-   **AWS KMS**: Servicio de gestión de claves en la nube

-   **Azure Key Vault**: Almacenamiento seguro de claves en Azure

-   **CyberArk**: Gestión de credenciales privilegiadas

**Certificados SSL/TLS**

-   **Let\'s Encrypt**: Certificados SSL/TLS gratuitos y automatizados

-   **Certbot**: Cliente ACME para Let\'s Encrypt

-   **DigiCert**: Autoridad certificadora comercial

-   **Sectigo**: Certificados SSL empresariales

**Auditoría y Testing**

-   **testssl.sh**: Herramienta de testing SSL/TLS

-   **SSLyze**: Análisis de configuración SSL

-   **Qualys SSL Labs**: Testing online de SSL

-   **Nmap**: Escaneo de puertos y servicios

**10.3 Laboratorios Adicionales**

  -----------------------------------------------------------------------
  Plataforma       Tipo            Descripción
  ---------------- --------------- --------------------------------------
  CryptoHack       Desafíos        Desafíos de criptografía práctica

  Cryptopals       Ejercicios      Ejercicios de criptoanálisis

  OverTheWire      Wargames        Juegos de seguridad y criptografía

  HackTheBox       CTF             Máquinas virtuales con desafíos

  TryHackMe        Laboratorios    Rutas de aprendizaje guiadas
  -----------------------------------------------------------------------

**\
**

**10.4 Comandos Esenciales de Referencia**

**OpenSSL - Comandos Básicos:**

\# Generar clave privada RSA

openssl genpkey -algorithm RSA -out private.pem -pkeyopt
rsa_keygen_bits:2048

\# Extraer clave pública

openssl rsa -in private.pem -pubout -out public.pem

\# Crear certificado autofirmado

openssl req -new -x509 -key private.pem -out cert.pem -days 365

\# Cifrar archivo con AES

openssl enc -aes-256-cbc -salt -in file.txt -out file.enc

\# Descifrar archivo

openssl enc -aes-256-cbc -d -in file.enc -out file.txt

\# Generar hash SHA-256

openssl dgst -sha256 file.txt

\# Verificar certificado

openssl x509 -in cert.pem -text -noout

\# Probar conexión SSL

openssl s_client -connect example.com:443

**GPG - Comandos Básicos:**

\# Generar par de claves

gpg \--full-generate-key

\# Listar claves

gpg \--list-keys

\# Cifrar archivo

gpg -e -r recipient@email.com file.txt

\# Descifrar archivo

gpg -d file.txt.gpg

\# Firmar archivo

gpg \--sign file.txt

\# Verificar firma

gpg \--verify file.txt.sig

**\
**

**Gestión de Permisos:**

\# Permisos seguros para claves privadas

chmod 600 private.key

\# Permisos para directorios de claves

chmod 700 /path/to/keys/

\# Cambiar propietario

chown user:group file

\# Verificar permisos

ls -la file

**10.5 Checklist de Seguridad**

**Gestión de Claves**

-   Claves generadas con entropía suficiente

-   Longitud de clave adecuada (AES-256, RSA-2048+)

-   Permisos restrictivos (600 para claves privadas)

-   Backup de claves en ubicación segura

-   Rotación periódica implementada

-   Documentación de generación y uso

**Certificados SSL/TLS**

-   Certificados firmados por CA confiable

-   Fecha de expiración monitoreada

-   Cadena de certificados completa

-   Protocolos obsoletos deshabilitados (SSLv2, SSLv3, TLS 1.0/1.1)

-   Solo cifrados fuertes habilitados

-   Perfect Forward Secrecy implementado

**Configuración de Servidor**

-   Headers de seguridad configurados (HSTS, CSP, etc.)

-   Logging habilitado y monitoreado

-   Acceso a archivos sensibles restringido

-   Actualizaciones de seguridad aplicadas

-   Firewall configurado correctamente

-   Auditorías periódicas programadas

**\
**

**11. REFERENCIAS BIBLIOGRÁFICAS**

**Libros y Publicaciones Académicas**

**Anderson, R. (2020).** *Security engineering: A guide to building
dependable distributed systems* (3rd ed.). Wiley.

**Daemen, J., & Rijmen, V. (2020).** *The design of Rijndael: AES - The
Advanced Encryption Standard* (2nd ed.). Springer.

**Ferguson, N., Schneier, B., & Kohno, T. (2010).** *Cryptography
engineering: Design principles and practical applications*. Wiley.

**Katz, J., & Lindell, Y. (2020).** *Introduction to modern
cryptography* (3rd ed.). CRC Press.

**Menezes, A. J., van Oorschot, P. C., & Vanstone, S. A. (2018).**
*Handbook of applied cryptography*. CRC Press.

**Schneier, B. (2015).** *Applied cryptography: Protocols, algorithms,
and source code in C* (20th anniversary ed.). Wiley.

**Stallings, W. (2017).** *Cryptography and network security: Principles
and practice* (7th ed.). Pearson.

**Estándares y Documentos Técnicos**

**NIST. (2021).** *Advanced Encryption Standard (AES) (FIPS PUB 197)*.
National Institute of Standards and Technology.

**NIST. (2020).** *Recommendation for Key Management (SP 800-57 Part 1
Rev. 5)*. National Institute of Standards and Technology.

**Rivest, R. L., Shamir, A., & Adleman, L. (1978).** *A method for
obtaining digital signatures and public-key cryptosystems*.
Communications of the ACM, 21(2), 120-126.

**Recursos Online**

**OWASP Foundation.** *OWASP Top 10*.
<https://owasp.org/www-project-top-ten/>

**Mozilla.** *Mozilla SSL Configuration Generator*.
<https://ssl-config.mozilla.org/>

**Qualys SSL Labs.** *SSL Server Test*.
<https://www.ssllabs.com/ssltest/>

**\
**

**12. CONCLUSIONES Y PRÓXIMOS PASOS**

**12.1 Resumen de Aprendizajes**

En esta práctica has aprendido a:

**Fundamentos de Criptografía**

-   Diferencias entre cifrado simétrico y asimétrico

-   Algoritmos estándar (AES-256, RSA-2048/4096)

-   Modos de operación (CBC, GCM)

**Implementación Práctica**

-   Generación segura de claves criptográficas

-   Cifrado y descifrado de archivos sensibles

-   Creación de infraestructura PKI completa

-   Configuración de Apache con SSL/TLS

**Automatización con Bash**

-   Scripting para operaciones criptográficas

-   Gestión automatizada de claves y certificados

-   Sistemas de backup cifrado

-   Auditoría y monitoreo de seguridad

**Mejores Prácticas Empresariales**

-   Gestión del ciclo de vida de claves

-   Políticas de rotación y backup

-   Logging y auditoría

-   Cumplimiento normative

**12.2 Competencias Desarrolladas**

  -----------------------------------------------------------------------
  Competencia                           Nivel Alcanzado
  ------------------------------------- ---------------------------------
  Criptografía Simétrica                Avanzado

  Criptografía Asimétrica               Avanzado

  Gestión de PKI                        Intermedio-Avanzado

  Scripting Bash                        Avanzado

  Configuración SSL/TLS                 Avanzado

  Auditoría de Seguridad                Intermedio-Avanzado
  -----------------------------------------------------------------------

**\
**

**13. ANEXOS**

**Anexo A: Glosario de Términos**

  -----------------------------------------------------------------------
  Término   Definición
  --------- -------------------------------------------------------------
  AES       Advanced Encryption Standard - Algoritmo de cifrado simétrico
            estándar

  CA        Certificate Authority - Autoridad que emite certificados
            digitales

  CBC       Cipher Block Chaining - Modo de operación de cifrado por
            bloques

  CSR       Certificate Signing Request - Solicitud de firma de
            certificado

  GCM       Galois/Counter Mode - Modo de cifrado autenticado

  HSTS      HTTP Strict Transport Security - Política de seguridad para
            HTTPS

  HSM       Hardware Security Module - Dispositivo físico para gestión de
            claves

  IV        Initialization Vector - Vector de inicialización para cifrado

  PBKDF2    Password-Based Key Derivation Function 2 - Derivación de
            claves

  PFS       Perfect Forward Secrecy - Secreto perfecto hacia adelante

  PKI       Public Key Infrastructure - Infraestructura de clave pública

  RSA       Rivest-Shamir-Adleman - Algoritmo de cifrado asimétrico

  Salt      Valor aleatorio añadido antes del hash

  TLS       Transport Layer Security - Protocolo de seguridad de
            transporte
  -----------------------------------------------------------------------

**Anexo B: Códigos de Error Comunes**

  ------------------------------------------------------------------------
  Error                Causa                     Solución
  -------------------- ------------------------- -------------------------
  bad decrypt          Clave incorrecta o        Verificar clave y archivo
                       archivo corrupto          de origen

  permission denied    Permisos insuficientes    Usar sudo o ajustar
                                                 permisos

  certificate verify   Certificado no confiable  Agregar CA al trust store
  failed                                         

  unable to load       Formato de clave          Verificar formato PEM
  private key          incorrecto                

  port 443 already in  Apache ya corriendo       Reiniciar Apache o
  use                                            verificar procesos
  ------------------------------------------------------------------------

**Anexo C: Script de Limpieza del Proyecto**

Para eliminar completamente el proyecto y restaurar el sistema al estado
inicial, utiliza el siguiente script:

**Ubicación:** /home/kali/cybersecure-project/scripts/cleanup_project.sh

**Funcionalidad:**

-   Detiene el servicio Apache

-   Deshabilita el sitio configurado

-   Elimina el directorio web

-   Elimina la configuración de Apache

-   Elimina entradas del archivo /etc/hosts

-   Elimina todo el directorio del proyecto

**Uso:**

./cleanup_project.sh

**Advertencia:** Este script elimina permanentemente todos los archivos
del proyecto. Asegúrate de tener backups antes de ejecutarlo.

**EVALUACIÓN FINAL**

**Criterios de Evaluación**

  -------------------------------------------------------------------------
  Criterio               Peso   Descripción
  ---------------------- ------ -------------------------------------------
  Implementación Técnica 40%    Correcta ejecución de todos los scripts y
                                configuraciones

  Documentación          20%    Claridad y completitud de la documentación
                                generada

  Análisis de Seguridad  20%    Profundidad en auditorías y análisis de
                                vulnerabilidades

  Creatividad            10%    Propuestas de mejora y soluciones
                                innovadoras

  Presentación           10%    Organización y presentación de resultados
  -------------------------------------------------------------------------

**Entregables**

**Informe Técnico (PDF)**

-   Capturas de pantalla de cada paso

-   Análisis de resultados

-   Conclusiones y aprendizajes

**Scripts Desarrollados**

-   Explicación breve y técnica de los scripts utilizados

**Evidencias de Funcionamiento**

-   Logs de ejecución

-   Certificados generados

-   Reportes de auditoría

**Propuesta de Mejora**

-   Identificación de limitaciones

-   Propuestas de optimización

-   Roadmap de implementación

**\
**

**CHECKLIST DE FINALIZACIÓN**

Marca cada ítem al completarlo:

**Configuración Inicial**

-   Entorno verificado (Script 01)

-   Estructura de directorios creada

**CHECKLIST DE FINALIZACIÓN**

Marca cada ítem al completarlo:

**Configuración Inicial**

-   Entorno verificado (Script 01)

-   Estructura de directorios creada (Script 02)

-   Claves maestras generadas (Script 03)

**Cifrado Simétrico**

-   Archivo de datos creado

-   Datos cifrados correctamente (Script 04)

-   Datos descifrados y verificados (Script 05)

-   Verificación de integridad con SHA-256

**Infraestructura PKI**

-   CA generada con RSA-4096 (Script 06)

-   Certificado de servidor creado con RSA-2048

-   Cadena de certificados verificada

-   CSR generado correctamente

**Configuración Web**

-   Apache configurado con SSL (Script 08)

-   Sitio web accesible vía HTTPS

-   Headers de seguridad verificados

-   Redirección HTTP a HTTPS funcional

**Automatización**

-   Sistema de backup implementado (Script 07)

-   Sistema de gestión criptográfica (Script 09)

-   Auditoría de seguridad ejecutada

-   Reportes generados correctamente

**Ejercicios**

-   Nivel 1 completado (Reconocimiento)

-   Nivel 2 completado (Comprensión)

-   Nivel 3 completado (Aplicación)

-   Nivel 4 completado (Análisis)

-   Nivel 5 completado (Síntesis)

**Documentación**

-   Informe técnico redactado

-   Scripts documentados con comentarios

-   Propuesta de mejora elaborada

-   Evidencias de funcionamiento recopiladas

**Verificaciones Finales**

-   Todos los servicios funcionando correctamente

-   Logs revisados sin errores críticos

-   Backups verificados y accesibles

-   Permisos de archivos validados

**\
**

**FORMATO DE ENTREGA ESTANDAR**

**Estructura del Informe**

**Portada**

-   Título de la práctica

-   Nombre del estudiante

-   Fecha de entrega

-   Institución educativa

**Índice**

-   Numeración de secciones

-   Referencias a páginas

**Sección 1: Introducción**

-   Objetivos de la práctica

-   Alcance del trabajo realizado

-   Metodología aplicada

**Sección 2: Marco Teórico**

-   Conceptos de criptografía aplicados

-   Algoritmos utilizados (AES, RSA)

-   Infraestructura PKI

**Sección 3: Desarrollo de la Práctica**

-   Paso a paso de la implementación

-   Capturas de pantalla con explicaciones

-   Comandos ejecutados y resultados

-   Problemas encontrados y soluciones

**Sección 4: Análisis de Resultados**

-   Evaluación de la implementación

-   Análisis de seguridad

-   Comparación de algoritmos

-   Auditoría de configuración SSL

**Sección 5: Ejercicios Graduales**

-   Desarrollo de cada nivel (1-5)

-   Resultados obtenidos

-   Análisis de aprendizajes

**Sección 6: Propuestas de Mejora**

-   Identificación de limitaciones

-   Propuestas de optimización

-   Implementaciones adicionales sugeridas

**Sección 7: Conclusiones**

-   Resumen de aprendizajes

-   Competencias desarrolladas

-   Reflexión personal

**Sección 8: Referencias Bibliográficas**

-   Formato APA o IEEE

-   Fuentes consultadas

**Anexos**

-   Código de scripts desarrollados

-   Logs completos

-   Certificados generados

-   Configuraciones adicionales

**\
**

**PREGUNTAS FRECUENTES (FAQ)**

**Sobre la Instalación**

**P: ¿Qué versión de Kali Linux debo usar?** R: Se recomienda Kali Linux
2023.x o superior. La práctica es compatible con versiones recientes que
incluyan OpenSSL 1.1.1 o superior.

**P: ¿Puedo realizar la práctica en una máquina virtual?** R: Sí, de
hecho es recomendable usar una VM para mantener el entorno aislado.
VirtualBox o VMware son opciones válidas.

**P: ¿Necesito conexión a Internet?** R: Solo para la instalación
inicial de paquetes si faltan. Una vez configurado el entorno, la
práctica puede realizarse offline.

**Sobre los Scripts**

**P: ¿Debo crear todos los scripts desde cero?** R: Los scripts están
diseñados para ser creados siguiendo las especificaciones de la
práctica. Puedes usar los ejemplos como referencia.

**P: ¿Qué hago si un script no funciona?** R: Verifica los permisos de
ejecución (chmod 700), revisa los logs en
/home/kali/cybersecure-project/logs/ y asegúrate de ejecutar los scripts
en orden.

**P: ¿Puedo modificar los scripts?** R: Sí, se fomenta la
personalización y mejora de los scripts. Documenta los cambios
realizados en tu informe.

**Sobre Cifrado**

**P: ¿Por qué usar 100,000 iteraciones en PBKDF2?** R: Es una medida de
seguridad contra ataques de fuerza bruta. NIST recomienda al menos
10,000 iteraciones, pero 100,000 proporciona mayor seguridad.

**P: ¿Puedo usar algoritmos diferentes a AES-256?** R: Para fines
educativos puedes experimentar con otros algoritmos, pero AES-256 es el
estándar recomendado para producción.

**P: ¿Qué hago si pierdo la clave maestra?** R: Los datos cifrados serán
irrecuperables. Por eso es crítico mantener backups seguros de las
claves, como se indica en la práctica.

**Sobre PKI y Certificados**

**P: ¿Por qué el navegador muestra advertencia de certificado?** R:
Porque es un certificado autofirmado. En producción se usarían
certificados de CA reconocidas como Let\'s Encrypt.

**P: ¿Puedo usar estos certificados en producción?** R: No. Los
certificados autofirmados son solo para desarrollo y pruebas. En
producción usa certificados de CA confiables.

**P: ¿Cuánto tiempo son válidos los certificados?** R: El certificado de
CA es válido por 10 años, el del servidor por 1 año. Estos períodos son
configurables.

**Sobre Apache y SSL**

**P: ¿Por qué Apache no inicia después de la configuración SSL?** R:
Verifica con sudo apache2ctl configtest. Los errores comunes son rutas
incorrectas a certificados o permisos inadecuados.

**P: ¿Cómo verifico que SSL está funcionando correctamente?** R: Usa
openssl s_client -connect localhost:443 o accede a
https://secure.cybersecure.local en tu navegador.

**P: ¿Puedo usar un dominio diferente?** R: Sí, modifica el archivo de
configuración de Apache y /etc/hosts con tu dominio preferido.

**Sobre los Ejercicios**

**P: ¿Son obligatorios todos los niveles de ejercicios?** R: Depende de
los requisitos de tu curso. Se recomienda completar al menos hasta el
Nivel 3 para una comprensión sólida.

**P: ¿Puedo trabajar en equipo?** R: Consulta con tu instructor.
Generalmente se permite colaboración en la implementación pero los
informes deben ser individuales.

**P: ¿Cuánto tiempo toma completar la práctica?** R: Aproximadamente 4-6
horas para la implementación básica. Los ejercicios avanzados pueden
requerir 2-4 horas adicionales.

**SOLUCIÓN DE PROBLEMAS COMUNES**

**Problema 1: Error de permisos al ejecutar scripts**

**Síntoma:**

bash: ./script.sh: Permission denied

**Solución:**

chmod 700 /home/kali/cybersecure-project/scripts/script.sh

**Problema 2: Apache no inicia después de configurar SSL**

**Síntoma:**

Job for apache2.service failed

**Solución:**

\# Verificar configuración

sudo apache2ctl configtest

\# Revisar logs

sudo tail -f /var/log/apache2/error.log

\# Verificar que los certificados existen

ls -la
/home/kali/cybersecure-project/asymmetric-encryption/certificates/

ls -la
/home/kali/cybersecure-project/asymmetric-encryption/private-keys/

\# Verificar permisos

sudo chown -R www-data:www-data /var/www/cybersecure

**Problema 3: Error \"bad decrypt\" al descifrar**

**Síntoma:**

bad decrypt

digital envelope routines:EVP_DecryptFinal_ex:bad decrypt

**Solución:**

-   Verifica que estás usando la misma clave que se usó para cifrar

-   Confirma que el archivo no está corrupto verificando el hash SHA-256

-   Asegúrate de usar los mismos parámetros (algoritmo, iteraciones)

**Problema 4: No se puede acceder a <https://secure.cybersecure.local>**

**Síntoma:** El navegador no puede resolver el dominio

**Solución:**

\# Verificar que está en /etc/hosts

grep secure.cybersecure.local /etc/hosts

\# Si no está, agregarlo

echo \"127.0.0.1 secure.cybersecure.local\" \| sudo tee -a /etc/hosts

\# Verificar que Apache está escuchando en 443

sudo netstat -tlnp \| grep :443

\# Probar con curl

curl -k <https://secure.cybersecure.local>

**Problema 5: Script de PKI pide contraseña repetidamente**

**Síntoma:** El script solicita la contraseña de la CA múltiples veces

**Solución:** Esto es normal. La CA debe estar protegida con contraseña.
Ingresa la misma contraseña cada vez que se solicite durante la
generación y firma de certificados.

**Problema 6: Logs no se están generando**

**Síntoma:** No hay archivos en /home/kali/cybersecure-project/logs/

**Solución:**

\# Crear directorio de logs si no existe

mkdir -p /home/kali/cybersecure-project/logs

\# Verificar permisos

chmod 755 /home/kali/cybersecure-project/logs

\# Verificar que los scripts tienen la ruta correcta

grep LOG_FILE /home/kali/cybersecure-project/scripts/\*.sh

**\
**

**GLOSARIO AMPLIADO**

**Términos Técnicos Adicionales**

**AEAD (Authenticated Encryption with Associated Data)** Modo de cifrado
que proporciona tanto confidencialidad como autenticación en una sola
operación. Ejemplo: AES-GCM.

**Brute Force Attack** Ataque que intenta todas las combinaciones
posibles de una clave hasta encontrar la correcta.

**Certificate Chain** Secuencia de certificados donde cada uno es
firmado por el siguiente, hasta llegar a un certificado raíz confiable.

**Cipher Suite** Conjunto de algoritmos criptográficos que incluye el
intercambio de claves, cifrado, autenticación y hash.

**Entropy** Medida de aleatoriedad o imprevisibilidad. Alta entropía es
esencial para generar claves seguras.

**Forward Secrecy** Ver Perfect Forward Secrecy (PFS).

**Key Derivation Function (KDF)** Función que deriva una o más claves
secretas a partir de un valor secreto como una contraseña.

**Man-in-the-Middle (MITM)** Ataque donde el atacante intercepta y
posiblemente altera la comunicación entre dos partes.

**Nonce** Número usado una sola vez en comunicaciones criptográficas
para prevenir ataques de replay.

**Rainbow Table** Tabla precalculada de hashes usada para revertir
funciones hash criptográficas.

**Salt** Datos aleatorios que se usan como entrada adicional en
funciones hash para proteger contra ataques de diccionario.

**Session Key** Clave temporal usada para cifrar una sesión de
comunicación específica.

**Zero-Day** Vulnerabilidad de seguridad desconocida para el fabricante
del software.

**\
**

**RECURSOS ADICIONALES PARA PROFUNDIZACIÓN**

**Libros Recomendados por Nivel**

**Nivel Principiante:**

-   \"Cryptography and Network Security\" - William Stallings

-   \"Understanding Cryptography\" - Christof Paar y Jan Pelzl

**Nivel Intermedio:**

-   \"Serious Cryptography\" - Jean-Philippe Aumasson

-   \"Real-World Cryptography\" - David Wong

**Nivel Avanzado:**

-   \"Introduction to Modern Cryptography\" - Jonathan Katz y Yehuda
    Lindell

-   \"The Joy of Cryptography\" - Mike Rosulek

**Cursos Online**

**Plataformas:**

-   Coursera: \"Cryptography I\" por Dan Boneh (Stanford)

-   edX: \"Cybersecurity Fundamentals\"

-   Udemy: \"The Complete Cyber Security Course\"

-   Pluralsight: \"Cryptography: The Big Picture\"

**Conferencias y Eventos**

**Conferencias Importantes:**

-   DEF CON (Las Vegas)

-   Black Hat (Global)

-   RSA Conference (San Francisco)

-   OWASP Global AppSec

-   CCC (Chaos Communication Congress)

**Comunidades y Foros**

**Comunidades Online:**

-   Reddit: r/crypto, r/netsec, r/AskNetsec

-   Stack Exchange: Information Security

-   Discord: Cybersecurity servers

-   Twitter: Seguir a expertos en seguridad

**\
**

**CASOS DE ESTUDIO REALES**

**Caso 1: Incidente de Equifax (2017)**

**Contexto:** Filtración masiva de datos que afectó a 147 millones de
personas.

**Lecciones Aprendidas:**

-   Importancia de mantener sistemas actualizados

-   Necesidad de cifrado de datos en reposo

-   Implementación de monitoreo continuo

-   Gestión adecuada de certificados SSL

**Aplicación a la Práctica:** Esta práctica implementa varios controles
que habrían mitigado el impacto del incidente de Equifax.

**Caso 2: Heartbleed (2014)**

**Contexto:** Vulnerabilidad en OpenSSL que permitía leer memoria del
servidor.

**Lecciones Aprendidas:**

-   Importancia de auditorías de código

-   Necesidad de actualizar bibliotecas criptográficas

-   Implementación de Perfect Forward Secrecy

-   Rotación de claves y certificados

**Aplicación a la Práctica:** Los scripts de monitoreo y auditoría
ayudan a detectar configuraciones vulnerables.

**Caso 3: WannaCry (2017)**

**Contexto:** Ransomware que cifró datos en miles de organizaciones
globalmente.

**Lecciones Aprendidas:**

-   Importancia de backups cifrados y offline

-   Necesidad de políticas de actualización

-   Implementación de segmentación de red

-   Procedimientos de recuperación ante desastres

**Aplicación a la Práctica:** El sistema de backup cifrado implementado
protege contra ransomware.

**\
**

**MEJORES PRÁCTICAS EMPRESARIALES**

**Política de Gestión de Claves**

**Generación:**

-   Usar generadores de números aleatorios criptográficamente seguros

-   Longitud mínima: AES-256, RSA-2048

-   Documentar fecha y método de generación

**Almacenamiento:**

-   Usar HSM o soluciones de gestión de secretos

-   Cifrar claves en reposo

-   Implementar control de acceso estricto

-   Mantener backups en ubicaciones separadas

**Distribución:**

-   Usar canales seguros (TLS, SSH)

-   Implementar autenticación mutua

-   Registrar todas las distribuciones

-   Usar key wrapping cuando sea apropiado

**Rotación:**

-   Claves simétricas: cada 90 días

-   Certificados SSL: anualmente

-   Claves de CA: cada 5-10 años

-   Documentar proceso de rotación

**Destrucción:**

-   Usar borrado seguro (shred, wipe)

-   Verificar destrucción completa

-   Documentar fecha de destrucción

-   Mantener registro de auditoría

**Política de Certificados**

**Emisión:**

-   Validar identidad del solicitante

-   Usar CSR con información correcta

-   Período de validez apropiado (1 año para servidores)

-   Documentar emisión en registro

**Renovación:**

-   Iniciar proceso 30 días antes de expiración

-   Verificar información actualizada

-   Probar certificado antes de despliegue

-   Mantener certificado anterior como backup

**Revocación:**

-   Proceso documentado de revocación

-   Actualizar CRL u OCSP

-   Notificar a partes afectadas

-   Emitir nuevo certificado si es necesario

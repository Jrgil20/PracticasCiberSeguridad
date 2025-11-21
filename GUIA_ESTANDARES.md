# 📘 Guía de Estándares para Informes de Práctica

Basado en las mejores prácticas de este repositorio (especialmente la **Práctica 8**, calificada con excelencia), esta guía define los estándares de calidad esperados para la documentación de ejercicios de ciberseguridad.

## 1. Estructura Profesional

Un buen informe no es solo una lista de comandos; debe contar una historia técnica coherente.

### Componentes Esenciales

- **Tabla de Identificación:** Debe estar al inicio del documento con:
  - Nombres completos y cédulas de los autores
  - Número de práctica
  - Fecha de realización
  - Grupo o equipo asignado
  - *Ejemplo:*

    ```markdown
    | Apellido, Nombre | Cédula | Nro. Práctica | Fecha |
    | --- | --- | --- | --- |
    | Gil, Jesús | 30175126 | 8 | 14-11-2025 |
    ```

- **Contexto del Escenario:** Define un escenario realista (ej. "Auditoría a TechCorp Solutions"). Esto demuestra profesionalismo y rol de consultor.
  - Incluye una narrativa que justifique el ejercicio
  - Simula un caso real de pentesting o análisis
  - Proporciona contexto empresarial o técnico

- **Objetivos Claros:** Lista qué se va a lograr y qué herramientas se usarán.
  - Enumera objetivos de aprendizaje específicos
  - Detalla herramientas necesarias (versiones, requisitos mínimos)
  - Establece requisitos de red/infraestructura

## 2. Profundidad Técnica y Explicación

No basta con mostrar el comando; hay que explicarlo. La documentación técnica debe ser educativa.

### Desglose de Comandos

No solo presentes el comando; explica cada componente:

```bash
# ❌ INCORRECTO (sin explicación)
find / -perm -4000 -type f 2>/dev/null

# ✅ CORRECTO (con desglose detallado)
find / -perm -4000 -type f 2>/dev/null
```

La explicación debe incluir:

- **`find /`**: Inicia búsqueda desde la raíz del sistema
- **`-perm -4000`**: Busca archivos con bit SUID (4000 en octal = Set User ID)
- **`-type f`**: Limita a archivos regulares (no directorios)
- **`2>/dev/null`**: Redirige errores a null para limpiar la salida

### Conceptos Clave

Siempre define la vulnerabilidad antes de explotarla:

- **Qué es:** Definición clara y concisa
- **Por qué es crítica:** Impacto en la seguridad del sistema
- **Cómo se explota:** El mecanismo técnico general
- **Referencia CVE:** Si aplica (ej. CVE-2008-0600)

*Ejemplo:*
> **SUID (Set User ID)**: Permiso especial en Unix que permite ejecutar archivos con privilegios del propietario (usualmente root). Es crítico porque un usuario limitado puede escalar privilegios ejecutando binarios SUID mal configurados. Esto constituye una vulnerabilidad Local Privilege Escalation (LPE).

## 3. Metodología Forense y Verificación

Cada acción exitosa debe ser probada irrefutablemente. Esto es crítico en pentesting profesional.

### Verificación Constante

Después de cada paso importante, valida el estado actual:

```bash
# Verificar usuario/privilegios
whoami          # Muestra usuario actual
id              # Muestra UID, GID y grupos
sudo -l         # Verifica permisos sudo

# Verificar conectividad
ping -c 4 [IP]  # Prueba conexión a red objetivo
ifconfig        # Muestra configuración de red
netstat -tuln   # Muestra puertos abiertos

# Verificar acceso a archivos
ls -la /root    # Verifica acceso a directorios críticos
cat /etc/passwd # Verifica lectura de archivos sensibles
```

### Evidencia de Compromiso

En ejercicios de explotación, crea archivos de prueba irrefutables:

```bash
# Después de escalar a root
echo "Root obtenido vía [técnica] - Equipo 4" > /root/evidencia_privesc_equipo4.txt
date >> /root/evidencia_privesc_equipo4.txt
id >> /root/evidencia_privesc_equipo4.txt

# Verificar la evidencia
cat /root/evidencia_privesc_equipo4.txt
```

**Importante:** La evidencia debe:

- Incluir timestamp (fecha/hora)
- Contener identificadores de equipo/grupo
- Usar archivos en ubicaciones sensibles (prueba de acceso real)
- No dañar el sistema (solo lectura/escritura controlada)

### Persistencia de Resultados

Nunca confíes solo en la salida de pantalla. Guarda todo en archivos para análisis posterior:

```bash
# Redirigir salida a archivos
nmap -sV -p- 192.168.100.20 > reporte_nmap_completo.txt
sqlmap -u "http://target/page?id=1" --dbs > sqlmap_bases_datos.txt
find / -perm -4000 -type f 2>/dev/null > suid_binaries.txt

# Combinar errores y salida correcta
command > salida_completa.txt 2>&1

# Redireccionar solo errores
command 2> solo_errores.txt
```

**Beneficios:**

- Facilita análisis detallado posterior
- Permite documentación exhaustiva
- Proporciona evidencia para el informe final
- Permite búsquedas/filtrado con `grep`

## 4. Calidad de la Documentación

### Capturas de Pantalla

Todas las capturas deben ser profesionales y bien documentadas:

- **Legibilidad:** Tamaño de fuente visible, contraste claro
- **Pie de foto descriptivo:** Explica qué se muestra y por qué es relevante
- **Contexto:** Incluye antes y después de acciones importantes
- **Anotaciones:** Resalta elementos críticos con flechas o rectángulos

*Ejemplo de buen pie de foto:*
> *Figura 5: Salida del comando `whoami` tras escalar privilegios. Se confirma acceso como usuario root (UID=0), demostrando escalada exitosa desde msfadmin.*

### Almacenamiento de Capturas (CDN / Repositorio / Git LFS)

Para conservar el repositorio ligero y mantener un historial limpio, recomendamos almacenar las capturas en un CDN o servicio de alojamiento de imágenes públicos/privados (por ejemplo: Imgur, Cloudinary, AWS S3, GitHub Releases) y enlazarlas en el informe en vez de subirlas directamente al árbol de Git.

- **Ventajas del CDN / hosting externo:**
  - Evita inflar el historial del repositorio
  - Permite referenciar imágenes mediante URLs públicas y compartibles
  - Facilita la gestión de permisos y acceso a imágenes grandes

- **Si debes guardar imágenes en el repositorio:**
  - Usa **Git LFS (Large File Storage)** para evitar dañar el historial:

```bash
# Instalar Git LFS
git lfs install

# Registrar extensión a trackear (ej. png/jpg)
git lfs track "*.png"
git lfs track "*.jpg"

# Agregar las reglas y las imágenes
git add .gitattributes
git add images/practica8_nmap_20251114.png
git commit -m "Agregar captura práctica 8 (via Git LFS)"
git push origin main
```

- **Buenas prácticas para nombres y versiones:**
  - Nombres claros y con fecha: `Practica8_Equipo4_nmap_20251114.png` (formato ISO `YYYYMMDD`) para facilitar búsqueda y trazabilidad.
  - Mantén una carpeta dedicada `images/` en el repo (o un bucket específico) con la estructura por práctica.

- **Privacidad / Seguridad:**
  - No subas imágenes que contengan credenciales, tokens o datos personales sensibles. Si es necesario, censura/blur o redacta esa información.
  - Si usas S3 u otro storage privado, controla los permisos de lectura y evita exponer datos sensibles en URLs públicas.

- **Referencias en el informe:**
  - Incluye la URL directa o la ruta relativa (si usas LFS) y un `alt`/pie de foto descriptivo.
  - Ejemplo Markdown con referencia externa:

```markdown
![Salida Nmap](https://i.imgur.com/ejemplo.png "Salida Nmap — Practica8")
*Figura X: Resultado del escaneo Nmap – resumen del puerto y versión detectada.*
```

De esta manera, mantendrás las evidencias accesibles y el repositorio en un estado óptimo para colaboradores.

### Tablas de Hallazgos

Usa tablas estructuradas para resumir vulnerabilidades encontradas:

| # | Vulnerabilidad | Impacto | Severidad | Solución Técnica | CVE |
|---|---|---|---|---|---|
| 1 | SUID en /usr/bin/nmap | Local Privilege Escalation | 🔴 Crítica | Remover bit SUID o eliminar binario innecesario | CVE-2008-1081 |
| 2 | SQL Injection en login.php | Bypass autenticación, acceso BD | 🔴 Crítica | Usar prepared statements, validar entrada | CWE-89 |
| 3 | Headers de seguridad faltantes | XSS, Clickjacking, MIME sniffing | 🟡 Alta | Configurar CSP, X-Frame-Options, HSTS | CWE-693 |

### Remediación - Soluciones Técnicas Específicas

No basta decir "corregir"; propón soluciones implementables:

**Remediación del SUID:**

```bash
# Opción 1: Remover bit SUID
sudo chmod u-s /usr/bin/nmap

# Opción 2: Eliminar binario si no es necesario
sudo rm /usr/bin/nmap

# Opción 3: Ejecutar solo con permiso explícito
sudo usermod -a -G nmap usuario_especifico
```

**Remediación de SQL Injection:**

```php
// ❌ VULNERABLE
$query = "SELECT * FROM users WHERE id = " . $_GET['id'];

// ✅ SEGURO (Prepared Statement)
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$_GET['id']]);
```

**Remediación de Headers de Seguridad (Apache):**

```apache
# Agregar a /etc/apache2/conf-available/security.conf
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set Content-Security-Policy "default-src 'self'"
```

### Estructura Recomendada de Informe

```markdown
# Título Descriptivo de la Práctica

## Datos de Identificación
[Tabla con autores, cédulas, grupo, fecha]

## Introducción
[Contexto empresarial/técnico]

## Objetivos
[Lista de objetivos a lograr]

## Requisitos Técnicos
[Herramientas, versiones, IPs]

## Procedimiento Paso a Paso
### Paso 1: [Descripción]
- Comando: `...`
- Explicación: [Desglose detallado]
- Captura: [Imagen con pie de foto]
- Verificación: `whoami`, `id`

## Resultados
[Tabla de hallazgos]

## Análisis de Vulnerabilidades
[Descripción de cada hallazgo con remediación]

## Conclusiones
[Resumen ejecutivo]

## Referencias
[CVEs, CWEs, documentación consultada]
```

---

> **Cita de Retroalimentación Docente (Práctica 8):**
> *"Nivel excepcional de documentación... Estructura impecable... Documentación a nivel profesional, adecuada para presentar hallazgos a clientes corporativos."*

---

## 5. Errores Comunes a Evitar

### ❌ Evita

- Mostrar solo comandos sin explicación
- Capturas borrosas o sin contexto
- Vulnerabilidades sin remediación técnica
- No verificar si los pasos funcionaron realmente
- Documentar solo los éxitos (incluye intentos fallidos)
- Olvidar guardar outputs para análisis posterior
- Usar herramientas sin entender qué hacen

### ✅ Haz siempre

- Explica cada comando y parámetro importante
- Incluye capturas claras con pies de foto descriptivos
- Propon soluciones técnicas específicas para cada hallazgo
- Verifica cada acción crítica con comandos de confirmación
- Documenta el proceso completo (intentos, ajustes, resultados)
- Redirige outputs a archivos para análisis exhaustivo
- Entiende completamente el funcionamiento de cada herramienta

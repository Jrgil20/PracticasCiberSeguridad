# Práctica Nro. 6: Cross-Site Scripting (XSS) y Cross-Site Request Forgery (CSRF)

## Datos de Identificación

| Apellido, Nombre | Cédula de Identidad | Nro. de Práctica | Fecha |
| :--- | :---: | :---: | :--- |
| Gil, Jesús | 30175126 | 7 | 07-11-2025|
| Guilarte, Andrés | 30246084 | 7 | 07-11-2025 |

**Nombre de la Práctica:** Password Attacks

**Grupo:** 4
_______________________________________
---

##  Direccionamiento IP/Máscara:   

 **Equipo origen/fuente:**   
 **Equipo Objetivo/Destino:**   
 **Otros Equipos involucrados:**   

---

## Preámbulo de la práctica

Al inicio de la práctica pasamos un repaso de criptografía: distinguimos criptografía simétrica (una misma clave para cifrar y descifrar, eficiente pero con el problema del intercambio seguro de la clave) y asimétrica (par de claves pública/privada, útil para intercambio seguro y firmas).

Se clarificó la diferencia entre cifrado y firma digital: el cifrado garantiza confidencialidad (que sólo el destinatario pueda leer el mensaje) mientras que la firma digital asegura autenticidad e integridad (que el mensaje proviene del remitente y no fue alterado).

Resumen de flujos con claves asimétricas:
- Cifrado (confidencialidad): el emisor cifra con la llave pública del receptor; el receptor descifra con su llave privada.
- Firma digital (autenticidad): el emisor firma (normalmente sobre un hash) con su llave privada; el receptor verifica la firma con la llave pública del emisor.

Combinación práctica: para lograr confidencialidad y autenticidad a la vez, el emisor firma el mensaje con su privada y luego cifra el mensaje firmado con la pública del receptor; el receptor descifra con su privada y verifica la firma con la pública del emisor.

Buenas prácticas breves: proteger claves privadas, usar algoritmos y tamaños actuales (p. ej. AES-256, RSA 3072+/ECC), y verificar certificados/cadena de confianza al usar llaves públicas.

### Software y herramientas necesarias
- CUPP (Common User Passwords Profiler) — descargar desde el repositorio Git oficial.  
- Hydra — herramienta de fuerza bruta (disponible en distribuciones de auditoría como Parrot).  
- Ncrack — herramienta de auditoría de servicios de red (disponible en repositorios).

### Infraestructura de máquinas virtuales
- Máquina Virtual A (Víctima): Kali Linux — servicio SSH habilitado.  
- Máquina Virtual B (Atacante): Parrot OS.  
- Conectividad: acceso a Internet y red entre VMs (configuración NAT o bridge según corresponda) para permitir comunicación entre ambas.

Nota breve para reejecución: conservar snapshots de las VMs, registrar direcciones IP y credenciales de prueba, y verificar que los servicios necesarios (p. ej. SSH) estén activos antes de iniciar la práctica.

---

##  Ejecución de la práctica

En esta sección se detallan los pasos prácticos para preparar y ejecutar la fase de generación de diccionarios con CUPP y su verificación. Todo lo siguiente debe ejecutarse en el Equipo B (Parrot OS) y únicamente contra objetivos de prueba autorizados.

### 1) Preparación del entorno

- Asegúrese de tener instalado git y Python 3 en Parrot OS.
- Trabaje desde el escritorio del usuario para seguir los ejemplos (ruta: `~/Desktop`).

### 2) Instalación de CUPP

Pasos básicos:

```bash
# Desde el directorio Desktop
cd ~/Desktop
git clone https://github.com/Mebus/cupp.git
cd cupp
chmod +x cupp.py
```

Explicación: el repositorio oficial de CUPP contiene el script `cupp.py` que genera diccionarios personalizados a partir de datos sociales del objetivo. El `chmod +x` permite ejecutarlo directamente.

### 3) Generación de un diccionario personalizado (ejemplo)

Objetivo del ejercicio: usar CUPP para generar un diccionario basado en información pública/recopilada del usuario objetivo. A continuación se muestra un perfil de ejemplo y el flujo interactivo simplificado.

Perfil de Usuario Objetivo (Ejemplo)

- Nombre completo: Pedro Pablo Pérez Uzcategui
- Puesto: Analista de administración en "Confianza y Seguridad C.A" (RIF: J-00205070-2)
- Familia: casado con María De La Concepción; hijos Eva y Adam
- Mascota: Punky
- Aficiones: tenis, pesca, lectura
- Película favorita: Troya
- Color preferido: azul
- Vehículo: Ford Focus, placas MOG-2020
- Fechas: Nacimiento 24/12/1948; fechas familiares 14/02/1954, 18/02/1976, 14/09/1987
- Residencia: Caracas, Parroquia El Recreo, Edif. Parque Monte Verde, Piso 7, Apt. 702

Extracción de datos clave (variables)

- Nombres: Pedro, Pablo, Pérez, Uzcategui, María, Concepción, Eva, Adam, Rosa
- Lugares: Caracas, Recreo, MonteVerde, SanPedro, Altos
- Fechas y fragmentos: 24, 12, 1948, 14, 02, 1954, 18, 76, 09, 87
- Otros términos: Punky, Troya, azul, Ford, Focus, MOG2020, seguros, Confianza

Proceso interactivo (ejemplo simplificado)

```bash
python3 cupp.py -i
```

Entrada de ejemplo en el asistente interactivo (respuestas mostradas después de cada prompt):

```
> Name: pedro
> Surname: perez
> Nickname:
> Birthdate (DDMMYYYY):
> Partners name:
> Partners nickname:
> Partners birthdate (DDMMYYYY):
> Child's name:
> Child's nickname:
> Child's birthdate (DDMMYYYY):
> Pet's name: Punky
> Company name:
> Do you want to add some key words about the victim? Y/[N]: y
> Please enter the words, separated by comma: Pedro,Perez,Punky
> Do you want to add special chars at the end of words? Y/[N]: N
> Do you want to add some random numbers at the end of words? Y/[N]: N
> Leet mode? (i.e. leet = 1337) Y/[N]: N
```

Salida esperada (resumen):

```
[+] Now making a dictionary...
[+] Sorting list and removing duplicates...
[+] Saving dictionary to pedro.txt, counting 240924 words.
[+] Now load your pistolero with pedro.txt and shoot! Good luck!
```

Notas importantes sobre la generación

- CUPP genera muchas combinaciones; el tamaño final depende de las palabras clave y las opciones seleccionadas.
- Para ejercicios académicos use siempre datos ficticios o cuentas/servicios de prueba.
- Si necesita reducir el tamaño del diccionario, limite palabras clave, desactive leet y no añada sufijos numéricos.

### 4) Verificación y uso del diccionario

Comando para inspeccionar el diccionario generado:

```bash
cat ~/Desktop/cupp/pedro.txt | wc -l
# o para listar las primeras líneas
head -n 30 ~/Desktop/cupp/pedro.txt
```

Análisis rápido:

- Total de contraseñas (líneas del fichero): aprox. 240,924 según el ejemplo.
- Contenido: combinaciones derivadas de nombres, apellidos, lugares y fechas; variaciones de mayúsculas/minúsculas según opciones.

Uso responsable (ejemplo): utilice `hydra` o `john` para pruebas autorizadas contra servicios de laboratorio. Ejemplo de sintaxis (solo en entorno controlado):

```bash
# Ejemplo ilustrativo (no ejecutar contra sistemas no autorizados)
# hydra -l usuario_prueba -P ~/Desktop/cupp/pedro.txt ssh://192.168.x.y
```

### Resultados obtenidos

El archivo generado por CUPP con las posibles contraseñas basadas en la información personal se encuentra en el siguiente enlace:

https://gist.github.com/Jrgil20/83b68690308a297dbfd43d8df08c8bdd

Resumen de resultados:

- Fichero: pedro.txt (contenido publicado en el gist).
- Total de entradas: ~9604 (según conteo de lineas en el gist).
- Observaciones: el fichero contiene muchas variaciones (nombres, apellidos, combinaciones con fechas y sufijos); CUPP elimina duplicados, pero es habitual que queden entradas muy sencillas o comunes que conviene filtrar antes de usar en ataques de pruebas.

Cómo descargar el archivo desde el Gist (opcional):

```bash
# Abra la URL en un navegador y use el botón "Raw" para descargar el archivo directamente, o clonelo con ssh git@gist.github.com:83b68690308a297dbfd43d8df08c8bdd.git
```

Nota: el enlace apunta al Gist público del repositorio del alumno; al descargar y usar el diccionario recuerde aplicar las medidas de seguridad y sólo emplearlo en entornos de laboratorio autorizados.

---

### 5) Recomendaciones finales y buenas prácticas

- Documente las opciones usadas para generar el diccionario (fecha, palabras clave, leet, sufijos) para reproducibilidad.
- Proteja los diccionarios generados; contienen información sensible y no deben compartirse fuera del laboratorio.
- Use control de acceso y registros cuando pruebe herramientas de fuerza bruta en entornos de práctica.

---

##  Conclusiones de la actividad desarrollada   



---

##  Contribución de esta actividad en su Proyecto:  

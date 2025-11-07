Al inicio de la práctica pasamos un repaso de criptografía: distinguimos criptografía simétrica (una misma clave para cifrar y descifrar, eficiente pero con el problema del intercambio seguro de la clave) y asimétrica (par de claves pública/privada, útil para intercambio seguro y firmas).

Se clarificó la diferencia entre cifrado y firma digital: el cifrado garantiza confidencialidad (que sólo el destinatario pueda leer el mensaje) mientras que la firma digital asegura autenticidad e integridad (que el mensaje proviene del remitente y no fue alterado).

Resumen de flujos con claves asimétricas:
- Cifrado (confidencialidad): el emisor cifra con la llave pública del receptor; el receptor descifra con su llave privada.
- Firma digital (autenticidad): el emisor firma (normalmente sobre un hash) con su llave privada; el receptor verifica la firma con la llave pública del emisor.

Combinación práctica: para lograr confidencialidad y autenticidad a la vez, el emisor firma el mensaje con su privada y luego cifra el mensaje firmado con la pública del receptor; el receptor descifra con su privada y verifica la firma con la pública del emisor.

Buenas prácticas breves: proteger claves privadas, usar algoritmos y tamaños actuales (p. ej. AES-256, RSA 3072+/ECC), y verificar certificados/cadena de confianza al usar llaves públicas.


**5.1 Verificación de Servicios Críticos**

┌──(kali㉿kali)-[~]
└─$ sudo systemctl status apache2
○ apache2.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/apache2.service; disabled; preset: disabled)
     Active: inactive (dead)
       Docs: https://httpd.apache.org/docs/2.4/
                                                                                               
┌──(kali㉿kali)-[~]
└─$ sudo systemctl status ssh
○ ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: disabled)
     Active: inactive (dead)
       Docs: man:sshd(8)
             man:sshd_config(5)
                                                                                               
┌──(kali㉿kali)-[~]
└─$ sudo service apache2 start
                                                                                               
┌──(kali㉿kali)-[~]
└─$ sudo service ssh start
                                                                                               
┌──(kali㉿kali)-[~]
└─$ 


┌──(kali㉿kali)-[~]
└─$ openssl version -a
OpenSSL 3.1.4 24 Oct 2023 (Library: OpenSSL 3.1.4 24 Oct 2023)
built on: Sat Nov 25 20:35:59 2023 UTC
platform: debian-amd64
options:  bn(64,64)
compiler: gcc -fPIC -pthread -m64 -Wa,--noexecstack -Wall -fzero-call-used-regs=used-gpr -DOPENSSL_TLS_SECURITY_LEVEL=2 -Wa,--noexecstack -g -O2 -ffile-prefix-map=/build/reproducible-path/openssl-3.1.4=. -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection -DOPENSSL_USE_NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_BUILDING_OPENSSL -DNDEBUG -Wdate-time -D_FORTIFY_SOURCE=2
OPENSSLDIR: "/usr/lib/ssl"
ENGINESDIR: "/usr/lib/x86_64-linux-gnu/engines-3"
MODULESDIR: "/usr/lib/x86_64-linux-gnu/ossl-modules"
Seeding source: os-specific
CPUINFO: OPENSSL_ia32cap=0xdefa220b478bffff:0x842421

                                                                                               
┌──(kali㉿kali)-[~]
└─$ openssl list -cipher-algorithms \| grep -i aes

openssl list -public-key-algorithms \| grep -i rsa
list: Use -help for summary.
list: Use -help for summary.


└─$ mkdir -p /home/kali/cybersecure-project/{

symmetric-encryption/{keys,data,encrypted,decrypted},

asymmetric-encryption/{private-keys,certificates,csr},

web-security/{config,logs},

documentation,

backup,

scripts,

logs,

config

}
zsh: parse error near `}'

┌──(kali㉿kali)-[~]
└─$ mkdir -p "/home/kali/cybersecure-project"/{symmetric-encryption/{keys,data,encrypted,decrypted},asymmetric-encryption/{private-keys,certificates,csr},web-security/{config,logs},documentation,backup,scripts,logs,config}

┌──(kali㉿kali)-[~]
└─$ chmod 700 /home/kali/cybersecure-project/symmetric-encryption/keys                         

chmod 700 /home/kali/cybersecure-project/asymmetric-encryption/private-keys

chmod 755 /home/kali/cybersecure-project/scripts


┌──(kali㉿kali)-[~]
└─$ chmod u+x /home/kali/cybersecure-project/scripts/*                                         

┌──(kali㉿kali)-[~]
└─$ chmod 700 /home/kali/cybersecure-project/scripts/*                                     

┌──(kali㉿kali)-[~]
└─$ ls -la /home/kali/cybersecure-project/scripts                                              
total 120
drwxr-xr-x  2 kali kali  4096 Nov 28 07:57  .
drwxr-xr-x 10 kali kali  4096 Nov 28 07:53  ..
-rwx------  1 kali kali  3391 Nov 28 07:26  01_verify_environment.sh
-rwx------  1 kali kali  4157 Nov 28 07:26  02_setup_structure.sh
-rwx------  1 kali kali  4634 Nov 28 07:26  03_generate_master_keys.sh
-rwx------  1 kali kali  5910 Nov 28 07:26  04_encrypt_data.sh
-rwx------  1 kali kali  5304 Nov 28 07:26  05_decrypt_data.sh
-rwx------  1 kali kali  7388 Nov 28 07:26  06_setup_pki.sh
-rwx------  1 kali kali  6207 Nov 28 07:26  07_secure_backup.sh
-rwx------  1 kali kali 14448 Nov 28 07:26  08_configure_apache_ssl.sh
-rwx------  1 kali kali 10292 Nov 28 07:26  09_crypto_management.sh
-rwx------  1 kali kali    76 Nov 28 07:26 'Agregar al etc_hosts.txt'
-rwx------  1 kali kali  6884 Nov 28 07:26  cleanup_project.sh
-rwx------  1 kali kali  4120 Nov 28 07:26 '(Revisar script 8)_cybersecure-ssl.conf'
-rwx------  1 kali kali  9222 Nov 28 07:26 '(Revisar script 8)_index.html'

┌──(kali㉿kali)-[~]
└─$ sudo cat /etc/apache2/sites-available/cybersecure-ssl.conf                                 
[sudo] password for kali: 
cat: /etc/apache2/sites-available/cybersecure-ssl.conf: No such file or directory

┌──(kali㉿kali)-[~]
└─$ sudo mv /home/kali/cybersecure-project/scripts/cybersecure-ssl.conf /etc/apache2/sites-available/cybersecure-ssl.conf

┌──(kali㉿kali)-[~]
└─$ sudo cat /etc/apache2/sites-available/cybersecure-ssl.conf# ============================================
# CONFIGURACIÓN HTTP (Puerto 80)
# Redirección automática a HTTPS
# ============================================
<VirtualHost *:80>
    ServerName secure.cybersecure.local
    ServerAlias www.secure.cybersecure.local
    DocumentRoot /var/www/cybersecure
    
    # Redirección automática a HTTPS
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
    
    # Logging
    ErrorLog ${APACHE_LOG_DIR}/cybersecure_http_error.log
    CustomLog ${APACHE_LOG_DIR}/cybersecure_http_access.log combined
</VirtualHost>

# ============================================
# CONFIGURACIÓN HTTPS (Puerto 443)
# Configuración Principal con SSL/TLS
# ============================================
<VirtualHost *:443>
    ServerName secure.cybersecure.local
    ServerAlias www.secure.cybersecure.local
    DocumentRoot /var/www/cybersecure
    
    # === CONFIGURACIÓN SSL CORE ===
    SSLEngine on
    
    # Rutas a certificados (AJUSTAR SEGÚN TU INSTALACIÓN)
    SSLCertificateFile /home/kali/cybersecure-project/asymmetric-encryption/certificates/server_certificate.pem
    SSLCertificateKeyFile /home/kali/cybersecure-project/asymmetric-encryption/private-keys/server_private_key.pem
    SSLCertificateChainFile /home/kali/cybersecure-project/asymmetric-encryption/certificates/ca_certificate.pem
    
    # === CONFIGURACIÓN DE SEGURIDAD SSL/TLS ===
    
    # Protocolos permitidos (solo versiones seguras)
    # Deshabilita SSLv2, SSLv3, TLS 1.0 y TLS 1.1 (vulnerables)
    SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
    
    # Cifrados permitidos (solo cifrados fuertes)
    # Prioriza ECDHE para Perfect Forward Secrecy
    SSLCipherSuite ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256
    
    # Preferir cifrados del servidor sobre los del cliente
    SSLHonorCipherOrder on
    
    # === HEADERS DE SEGURIDAD ===
    
    # HTTP Strict Transport Security (HSTS)
    # Fuerza HTTPS por 1 año, incluye subdominios
    Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
    
    # Prevenir ataques de clickjacking
    Header always set X-Frame-Options "SAMEORIGIN"
    
    # Prevenir MIME type sniffing
    Header always set X-Content-Type-Options "nosniff"
    
    # Protección XSS en navegadores antiguos
    Header always set X-XSS-Protection "1; mode=block"
    
    # Content Security Policy básica
    Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"
    
    # Referrer Policy
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    
    # === LOGGING ===
    
    # Logs de errores SSL
    ErrorLog ${APACHE_LOG_DIR}/cybersecure_ssl_error.log
    
    # Logs de acceso estándar
    CustomLog ${APACHE_LOG_DIR}/cybersecure_ssl_access.log combined
    
    # Log específico de SSL con información detallada
    CustomLog ${APACHE_LOG_DIR}/cybersecure_ssl_request.log \
              "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
    
    # === CONFIGURACIÓN DEL DIRECTORIO ===
    
    <Directory /var/www/cybersecure>
        # Deshabilitar listado de directorios
        Options -Indexes +FollowSymLinks
        
        # Permitir uso de .htaccess
        AllowOverride All
        
        # Permitir acceso a todos
        Require all granted
        
        # Protección adicional para archivos sensibles
        <Files ~ "\.(key|pem|crt|conf|log)$">
            Require all denied
        </Files>
    </Directory>
    
</VirtualHost>

# ============================================
# CONFIGURACIÓN GLOBAL SSL
# ============================================

# Cache de sesiones SSL para mejor rendimiento
SSLSessionCache "shmcb:${APACHE_RUN_DIR}/ssl_scache(512000)"
SSLSessionCacheTimeout 300

┌──(kali㉿kali)-[~]
└─$ sudo mv /home/kali/cybersecure-project/scripts/index.html /var/www/cybersecure/index.html  

┌──(kali㉿kali)-[~]
└─$ sudo chmod -R 755 /var/www/cybersecure  

┌──(kali㉿kali)-[~]
└─$                                                                                            

┌──(kali㉿kali)-[~]
└─$ ls -la /var/www/cybersecure                                               
total 20
drwxr-xr-x 2 www-data www-data 4096 Nov 28 08:33 .
drwxr-xr-x 4 root     root     4096 Nov 28 08:30 ..
-rwxr-xr-x 1 kali     kali     9222 Nov 28 07:26 index.html

┌──(kali㉿kali)-[~]
└─$ sudo cp /var/www/cybersecure/index.html /var/www/cybersecure/index.html.backup

┌──(kali㉿kali)-[~]
└─$ sudo mv /home/kali/cybersecure-project/scripts/hosts.txt /etc/hosts                        

┌──(kali㉿kali)-[~]
└─$ cat /etc/hosts                                                                             
127.0.0.1 secure.cybersecure.local
127.0.0.1 www.secure.cybersecure.local

┌──(kali㉿kali)-[~]
└─$ sudo cp /etc/hosts /etc/hosts.backup                                                       
sudo: unable to resolve host kali: Name or service not known

┌──(kali㉿kali)-[~]
└─$ ping -c 3 secure.cybersecure.local                                                         
PING secure.cybersecure.local (127.0.0.1) 56(84) bytes of data.
64 bytes from secure.cybersecure.local (127.0.0.1): icmp_seq=1 ttl=64 time=0.015 ms
64 bytes from secure.cybersecure.local (127.0.0.1): icmp_seq=2 ttl=64 time=0.053 ms
64 bytes from secure.cybersecure.local (127.0.0.1): icmp_seq=3 ttl=64 time=0.048 ms

--- secure.cybersecure.local ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2048ms
rtt min/avg/max/mdev = 0.015/0.038/0.053/0.016 ms

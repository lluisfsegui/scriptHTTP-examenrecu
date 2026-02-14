#!/bin/bash

apt update
apt install -y apache2

# Crear carpetes necessàries
mkdir -p /srv/erebor/www
mkdir -p /var/erebor/img
mkdir -p /var/log/www

# Crear VirtualHost per www.erebor.com
cat > /etc/apache2/sites-available/www.conf << 'EOF'
<VirtualHost *:80>
    ServerName www.erebor.com
    DocumentRoot /srv/erebor/www

    ErrorLog /var/log/www/error.log
    CustomLog /var/log/www/access.log combined

    <Directory /srv/erebor/www>
        AllowOverride None
        Require all granted
    </Directory>

    # Ruta /img → /var/erebor/img
    Alias /img /var/erebor/img

    <Directory /var/erebor/img>
        Require all granted
    </Directory>

</VirtualHost>
EOF

# Activar el lloc i reiniciar Apache
a2ensite www.conf
systemctl reload apache2

#!/bin/bash

echo "Instalando Apache2..."
apt update -y
apt install -y apache2 apache2-utils

echo "Creando directorios del sitio..."
mkdir -p /srv/erebor/www
mkdir -p /var/erebor/img
mkdir -p /var/log/www

echo "Asignando permisos..."
chmod -R 755 /srv/erebor/www
chmod -R 755 /var/erebor/img

echo "Creando página pública..."
cat <<EOF > /srv/erebor/www/index.html
<html>
<head><title>WWW Erebor</title></head>
<body>
<h1>Bienvenido a www.erebor.com</h1>
</body>
</html>
EOF

echo "Creando VirtualHost para www.erebor.com..."
cat <<EOF > /etc/apache2/sites-available/www.conf
<VirtualHost *:80>
    ServerName www.erebor.com
    DocumentRoot /srv/erebor/www

    ErrorLog /var/log/www/error.log
    CustomLog /var/log/www/access.log combined

    <Directory /srv/erebor/www>
        AllowOverride None
        Require all granted
    </Directory>

    Alias /img /var/erebor/img

    <Directory /var/erebor/img>
        AllowOverride None
        Require all granted
    </Directory>

</VirtualHost>
EOF

echo "Habilitando sitio www..."
a2ensite www.conf

echo "Reiniciando Apache..."
systemctl restart apache2

echo "Configuración de www.erebor.com COMPLETADA correctamente."

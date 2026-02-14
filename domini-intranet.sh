#!/bin/bash

echo "Instalando Apache2..."
apt update -y
apt install -y apache2 apache2-utils

echo "Creando directorios del sitio..."
mkdir -p /srv/erebor/intranet
mkdir -p /var/erebor/privat
mkdir -p /var/log/intranet

echo "Asignando permisos..."
chmod -R 755 /srv/erebor/intranet
chmod -R 750 /var/erebor/privat

echo "Creando página pública..."
cat <<EOF > /srv/erebor/intranet/index.html
<html>
<head><title>Intranet Erebor</title></head>
<body>
<h1>Bienvenido a la intranet de Erebor</h1>
</body>
</html>
EOF

echo "Creando usuarios para Apache (los 4)..."
htpasswd -bc /etc/apache2/web_privado.users gandalf 12345678
htpasswd -b  /etc/apache2/web_privado.users celeborn 12345678
htpasswd -b  /etc/apache2/web_privado.users radagast 12345678
htpasswd -b  /etc/apache2/web_privado.users peregrin 12345678

echo "Creando archivo de grupos..."
echo "web_privado: gandalf celeborn radagast peregrin" > /etc/apache2/web_privado.groups

echo "Activando módulo necesario para Require group..."
a2enmod authz_groupfile

echo "Creando VirtualHost intranet..."
cat <<EOF > /etc/apache2/sites-available/intranet.conf
<VirtualHost *:80>
    ServerName intranet.erebor.com
    DocumentRoot /srv/erebor/intranet

    ErrorLog /var/log/intranet/error.log
    CustomLog /var/log/intranet/access.log combined

    <Directory /srv/erebor/intranet>
        AllowOverride None
        Require all granted
    </Directory>

    Alias /private /var/erebor/privat

    <Directory /var/erebor/privat>
        AuthType Basic
        AuthName "Zona privada de Erebor"
        AuthUserFile /etc/apache2/web_privado.users
        AuthGroupFile /etc/apache2/web_privado.groups
        Require group web_privado
    </Directory>

</VirtualHost>
EOF

echo "Habilitando sitio intranet..."
a2ensite intranet.conf

echo "Reiniciando Apache..."
systemctl restart apache2

echo "Configuración de Apache COMPLETADA correctamente."

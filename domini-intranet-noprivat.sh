#!/bin/bash

echo "Instalando Apache2..."
apt update -y
apt install -y apache2 apache2-utils

echo "Creando directorios del sitio..."
mkdir -p /srv/erebor/intranet
mkdir -p /var/log/intranet

echo "Asignando permisos..."
chmod -R 755 /srv/erebor/intranet

echo "Creando página pública..."
cat <<EOF > /srv/erebor/intranet/index.html
<html>
<head><title>Intranet Erebor</title></head>
<body>
<h1>Bienvenido a la intranet de Erebor</h1>
</body>
</html>
EOF

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

</VirtualHost>
EOF

echo "Habilitando sitio intranet..."
a2ensite intranet.conf

echo "Reiniciando Apache..."
systemctl restart apache2

echo "Configuración de Apache COMPLETADA correctamente."

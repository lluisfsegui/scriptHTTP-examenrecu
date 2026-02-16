#!/bin/bash

echo "Instal·lant Apache2..."
apt update -y
apt install -y apache2

echo "Creant directoris del lloc..."
mkdir -p /var/www/bentley/www
mkdir -p /srv/bentley/dades
mkdir -p /var/log/bentley/www

echo "Assignant permisos..."
chmod -R 755 /var/www/bentley/www
chmod -R 755 /srv/bentley/dades

echo "Creant pàgina principal..."
cat <<EOF > /var/www/bentley/www/index.html
<html>
<head><title>Web Bentley</title></head>
<body>
<h1>Benvingut al lloc web www..com</h1>
<p>Això és la pàgina principal del lloc.</p>
</body>
</html>
EOF

echo "Creant pàgina DADES..."
cat <<EOF > /srv/bentley/dades/index.html
<html>
<head><title>Dades Bentley</title></head>
<body>
<h1>Directori de dades</h1>
<p>Aquí es troben els fitxers de dades.</p>
</body>
</html>
EOF

echo "Creant VirtualHost www..."
cat <<EOF > /etc/apache2/sites-available/www.conf
<VirtualHost *:80>
    ServerName www..com
    DocumentRoot /var/www/bentley/www

    ErrorLog /var/log/bentley/www/error.log
    CustomLog /var/log/bentley/www/access.log combined

    <Directory /var/www/bentley/www>
        AllowOverride None
        Require all granted
    </Directory>

    Alias /dades /srv/bentley/dades
    <Directory /srv/bentley/dades>
        AllowOverride None
        Require all granted
    </Directory>

</VirtualHost>
EOF

echo "Habilitant lloc www..."
a2ensite www.conf

echo "Reiniciant Apache..."
systemctl restart apache2

echo "Configuració del segon domini COMPLETADA correctament."

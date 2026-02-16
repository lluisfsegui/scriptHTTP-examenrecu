#!/bin/bash

echo "Instal·lant Apache2..."
apt update -y
apt install -y apache2 apache2-utils

echo "Creant directoris del lloc..."
mkdir -p /var/www/bentley/intranet
mkdir -p /srv/bentley/img
mkdir -p /srv/bentley/private
mkdir -p /var/log/bentley/intranet

echo "Assignant permisos..."
chmod -R 755 /var/www/bentley/intranet
chmod -R 755 /srv/bentley/img
chmod -R 750 /srv/bentley/private

echo "Creant pàgina principal..."
cat <<EOF > /var/www/bentley/intranet/index.html
<html>
<head><title>Intranet Bentley</title></head>
<body>
<h1>Benvingut a la intranet de Bentley</h1>
<p>Això és la pàgina principal.</p>
</body>
</html>
EOF

echo "Creant pàgina IMG..."
cat <<EOF > /srv/bentley/img/index.html
<html>
<head><title>Imatges Bentley</title></head>
<body>
<h1>Directori d'imatges</h1>
<p>Aquí es troben els recursos gràfics.</p>
</body>
</html>
EOF

echo "Creant pàgina PRIVATE..."
cat <<EOF > /srv/bentley/private/index.html
<html>
<head><title>Zona Privada Bentley</title></head>
<body>
<h1>Zona privada</h1>
<p>Només per usuaris autoritzats.</p>
</body>
</html>
EOF

echo "Creant usuaris per a la zona privada..."
htpasswd -bc /etc/apache2/web_privado.users laracroft 12345678
htpasswd -b  /etc/apache2/web_privado.users link 12345678
htpasswd -b  /etc/apache2/web_privado.users ashketchum 12345678
htpasswd -b  /etc/apache2/web_privado.users ratchel 12345678

echo "Creant fitxer de grups..."
echo "web_privado: laracroft link ashketchum ratchel" > /etc/apache2/web_privado.groups

echo "Activant mòdul authz_groupfile..."
a2enmod authz_groupfile

echo "Creant VirtualHost intranet..."
cat <<EOF > /etc/apache2/sites-available/intranet.conf
<VirtualHost *:80>
    ServerName intranet..com
    DocumentRoot /var/www/bentley/intranet

    ErrorLog /var/log/bentley/intranet/error.log
    CustomLog /var/log/bentley/intranet/access.log combined

    <Directory /var/www/bentley/intranet>
        AllowOverride None
        Require all granted
    </Directory>

    Alias /img /srv/bentley/img
    <Directory /srv/bentley/img>
        AllowOverride None
        Require all granted
    </Directory>

    Alias /private /srv/bentley/private
    <Directory /srv/bentley/private>
        AuthType Basic
        AuthName "Zona privada Bentley"
        AuthUserFile /etc/apache2/web_privado.users
        AuthGroupFile /etc/apache2/web_privado.groups
        Require group web_privado
    </Directory>

</VirtualHost>
EOF

echo "Habilitant lloc intranet..."
a2ensite intranet.conf

echo "Reiniciant Apache..."
systemctl restart apache2

echo "Configuració COMPLETADA correctament."

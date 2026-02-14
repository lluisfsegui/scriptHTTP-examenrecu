#!/bin/bash

apt update
apt install -y apache2

# Crear carpetas necesarias
mkdir -p /srv/erebor/intranet
mkdir -p /var/erebor/privat
mkdir -p /var/log/intranet

# Crear usuarios (si no existen ya) Si existex ho borram
useradd -m -s /bin/bash gandalf
useradd -m -s /bin/bash celeborn
useradd -m -s /bin/bash radagast
useradd -m -s /bin/bash peregrin

#Si ja existeixen els usuaris, borram aquesta part del script
echo "gandalf:12345678" | chpasswd
echo "celeborn:12345678" | chpasswd
echo "radagast:12345678" | chpasswd
echo "peregrin:12345678" | chpasswd

# Crear grupo para acceso privado
groupadd web_privado

# Añadir usuarios al grupo
usermod -aG web_privado gandalf
usermod -aG web_privado celeborn
usermod -aG web_privado radagast
usermod -aG web_privado peregrin

# Asignar permisos al directorio privado
chown :web_privado /var/erebor/privat
chmod 770 /var/erebor/privat

# Crear VirtualHost
cat > /etc/apache2/sites-available/intranet.conf << 'EOF'
<VirtualHost *:80>
    ServerName intranet.erebor.com
    DocumentRoot /srv/erebor/intranet

    ErrorLog /var/log/intranet/error.log
    CustomLog /var/log/intranet/access.log combined

    <Directory /srv/erebor/intranet>
        AllowOverride None
        Require all granted
    </Directory>

    # Zona privada
    Alias /private /var/erebor/privat

    <Directory /var/erebor/privat>
        Require group web_privado
    </Directory>

</VirtualHost>
EOF

# Activar el sitio y reiniciar Apache
a2ensite intranet.conf
systemctl reload apache2

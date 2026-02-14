#!/bin/bash

# IP del servidor origen (ServidorIntranet)
ORIGEN=192.168.1.50

# Carpeta de configuració i contingut a copiar
CONF_ORIGEN=/etc/apache2/sites-available/isengard.conf
WEB_ORIGEN=/srv/isengard/www

# Carpeta de destí al servidor actual
CONF_Desti=/etc/apache2/sites-available/
WEB_Desti=/srv/isengard/www

# Crear carpeta destí si no existeix
mkdir -p $WEB_Desti

# Copiar configuració del VirtualHost
scp root@$ORIGEN:$CONF_ORIGEN $CONF_Desti

# Copiar contingut web
scp -r root@$ORIGEN:$WEB_ORIGEN/* $WEB_Desti/

# Activar el lloc web
a2ensite isengard.conf

# Reiniciar Apache
systemctl restart apache2

#!/usr/bin/env bash
output=` dnf list --installed | grep "httpd" ` ;
if [ -n "$output" ]; then
    is_web_server_installed=true
else 
    is_web_server_installed=false
fi
if [ $is_web_server_installed != true ] ; then
    echo "Installation du serveur web..." ;
    dnf group install "Basic Web Server" -y ;
fi
unset output ;
unset is_web_server_installed ;
echo 'Installation du site web randominfo.fr...' ;
cp -R ../randominfo.fr/* /var/www/html/ &&
chown -R root:apache /var/www/html/ &&
chmod -R 750 /var/www/html/ &&
cp ./randominfo.fr.conf /etc/httpd/conf.d &&
echo 'Redémarrage du serveur apache...' ;
apachectl configtest &&
systemctl restart httpd &&
echo 'Installation du site web terminée!'
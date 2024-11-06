#!/bin/bash
expected_output="i web-server" ;
output=`tasksel --list-tasks | grep "$expected_output"` ;
is_web_server_installed=` if [[ $output == $expected_output* ]] then echo true ; else echo false ; fi ` ;
if [ $is_web_server_installed != true ] ; then
    echo "Installation du serveur web..." ;
    tasksel install web-server ;
fi
unset expected_output ;
unset output ;
unset is_web_server_installed ;
echo 'Installation du site web randominfo.fr...' ;
cp -R ./randominfo.fr/ /var/www/ &&
chown -R root:www-data /var/www/randominfo.fr/ &&
chmod -R 750 /var/www/randominfo.fr/ &&
cp ./randominfo.fr.conf /etc/apache2/sites-available/ &&
a2dissite '*' >> install.log &&
a2ensite randominfo.fr.conf >> install.log &&
echo 'Redémarrage du serveur apache...' ;
systemctl reload apache2 &&
echo 'Installation du site web terminée!' &&
rm install.log ;
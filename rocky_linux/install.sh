#!/usr/bin/env bash

# Vérifier si le serveur web de base est installé sur la machine
output=` dnf list --installed | grep "httpd" ` ;
if [ -n "$output" ]; then
    is_web_server_installed=true
else 
    is_web_server_installed=false
fi

# S'il n'est pas installé, lancer son installation
if [ $is_web_server_installed != true ] ; then
    echo "Installation du serveur web..." ;
    dnf group install "Basic Web Server" -y ;
fi

# Effacer les variables précedemment créées pour libérer de la mémoire
unset output ;
unset is_web_server_installed ;

# Affichage d'un message signalant le début de l'installation
echo 'Installation du site web randominfo.fr...' ;

# Copie des fichiers du site web vers le répertoire /var/www/html/
# Ce dossier est utilisé par apache (httpd) pour servir un site web
# Arrêt de l'exécution du script en cas d'erreur (&&)
cp -R ../randominfo.fr/* /var/www/html/ &&

# Le groupe apache est celui du serveur apache
# L'utilisateur root ainsi que le groupe apache
# seront considérés comme propriétaires des fichiers.
# Arrêt de l'exécution du script en cas d'erreur (&&)
chown -R root:apache /var/www/html/ &&

# Modifier les permissions sur les fichiers
# L'utilisateur root aura les droits de lecture, d'écriture et d'exécution
# Le groupe www-data aura les droits de lecture et d'exécution
# Les autres utilisateurs n'auront aucun droit afin d'éviter des modifications intempestives
# et de ne pas rendre visible le code source à n'importe qui
# Arrêt de l'exécution du script en cas d'erreur (&&)
chmod -R 750 /var/www/html/ &&

# Copier le fichier de configuration de l'hôte virtuel
# dans le répertoire de configuration des hôtes virtuels d'apache
# Arrêt de l'exécution du script en cas d'erreur (&&)
cp ./randominfo.fr.conf /etc/httpd/conf.d &&

# Test de la configuration d'apache
# Arrêt de l'exécution du script en cas d'erreur (&&)
apachectl configtest &&

# Redémarrer le serveur afin de prendre en compte tous les changements
# Arrêt de l'exécution du script en cas d'erreur (&&)
echo 'Redémarrage du serveur apache...' ;
systemctl restart httpd &&

# Affichage d'une confirmation d'installation terminée
echo 'Installation du site web terminée!'
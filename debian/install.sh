#!/bin/bash

# Vérifier si le serveur web de base est installé sur la machine
expected_output="i web-server" ;
output=`tasksel --list-tasks | grep "$expected_output"` ;
if [[ $output == "$expected_output"* ]] then 
    is_web_server_installed=true
else
    is_web_server_installed=false
fi

# S'il n'est pas installé, lancer son installation
if [ "$is_web_server_installed" != true ] ; then
    echo "Installation du serveur web..." ;
    tasksel install web-server ;
fi

# Effacer les variables précedemment créées pour libérer de la mémoire
unset expected_output ;
unset output ;
unset is_web_server_installed ;

# Affichage d'un message signalant le début de l'installation
echo 'Installation du site web randominfo.fr...' ;

# Copie des fichiers du site web vers le répertoire /var/www/
# Ce dossier est utilisé par apache pour servir un ou plusieurs sites web
# Arrêt de l'exécution du script en cas d'erreur (&&)
cp -R ./randominfo.fr/ /var/www/ &&

# Le groupe www-data est celui du serveur apache
# L'utilisateur root ainsi que le groupe www-data
# seront considérés comme propriétaires des fichiers.
# Arrêt de l'exécution du script en cas d'erreur (&&)
chown -R root:www-data /var/www/randominfo.fr/ &&

# Modifier les permissions sur les fichiers
# L'utilisateur root aura les droits de lecture, d'écriture et d'exécution
# Le groupe www-data aura les droits de lecture et d'exécution
# Les autres utilisateurs n'auront aucun droit afin d'éviter des modifications intempestives
# et de ne pas rendre visible le code source à n'importe qui
# Arrêt de l'exécution du script en cas d'erreur (&&)
chmod -R 750 /var/www/randominfo.fr/ &&

# Copier le fichier de configuration de l'hôte virtuel
# dans le répertoire de configuration des hôtes virtuels d'apache
# Arrêt de l'exécution du script en cas d'erreur (&&)
cp ./debian/randominfo.fr.conf /etc/apache2/sites-available/ &&

# Désactiver tous les autres sites actuellement sur la machine
# notamment la page par défaut d'apache
# puis rediriger la sortie standard vers install.log afin de ne pas polluer
# l'utilisateur avec des informations inutiles pour lui
# Arrêt de l'exécution du script en cas d'erreur (&&)
a2dissite '*' >> install.log &&

# Activer le site web nouvellement installé
# Arrêt de l'exécution du script en cas d'erreur (&&)
a2ensite randominfo.fr.conf >> install.log &&

# Redémarrer le serveur afin de prendre en compte tous les changements
# Arrêt de l'exécution du script en cas d'erreur (&&)
echo 'Redémarrage du serveur apache...' &&
systemctl reload apache2 &&

# Affichage d'une confirmation d'installation terminée
echo 'Installation du site web terminée!' &&

# Suppression du fichier de log
rm install.log ;
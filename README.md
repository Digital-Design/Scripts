# Scripts
[![Gitter Chat](http://img.shields.io/badge/chat-online-brightgreen.svg)](https://gitter.im/Digital-Design/Scripts)

## newUser.sh

Script permettant :
  - De créer un dossier dans ``` /home/{username}/www ```
  - Pull un dépôt Git (optionnel) sinon créer un fichier ``` index.html ``` par défaut
  - Créer son vhost

Utilisation :
  - lancer la commande ``` sudo ./newUser.sh {username} ``` et suivre les instructions
  - Le username ne doit pas éxister

## delUser.sh

Script permettant de :
  - Supprimer l'user
  - Supprimer le dossier ``` /home/{username} ```
  - Supprimer son vhost
  - Supprimer ses logs apache

Utilisation :
  - lancer la commande ``` sudo ./delUser.sh {username} ``` et suivre les instructions
  - Le username doit éxister

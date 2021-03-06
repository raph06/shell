# Fichiers:

- mouve + man 
- remouve + man
- bonjour + man
- bonsoir + man
- .syncrc
- readme

## Configuration système avant utilisation:

- Vérifier que la clée usb est bien montée sur /dev/sdb1 avec la commande fdisk -l
  Si ce n'est pas le cas remplacer alors sdb1 (plus bas) par l'emplacement de votre clé /dev/emplacement_usb.
  (L'utilisation du numéro UUID est possible à la place de /dev/usb, lire man blkid si vous utilisez toujours la même clée)
- Créer le dossier où sera montée la clée: mkdir /mnt/usbkey
- Ouvrir le fichier /etc/fstab avec les droits d'accés root et ajouter la ligne suivante en fin de fichier:
/dev/sdb1  /mnt/usbkey       vfat    user,rw,noauto      0      0
- Placer les fichiers mouve.1.gz et remouve.1.gz dans le répertoire /usr/shared/man/man1
  Utilisation: "man mouve"; "man remouve"
- Placer les fichier mouve, remouve, bonjour, bonsoir dans le répertoire /bin
 
## Commentaires: 

### Généraux:
- Projet intéressant car s'avère utile.
- Nous avons donc tenté de rendre le projet le plus accessible et d'étoffer la description pour 
 permettre son utilisation par tout types d'utilisateurs 
- Le mieux aurait été de créer un petit programme ‘opensource’ installable sur machine, qui aurait placé directement 
les differents scripts dans les répertoires adéquats pour une utilisation plus rapide des différentes fonctions des programmes.

### Manuels:
- La création du manuel est un aspect "découverte" du projet, instructif au regard de la syntaxe 
 particulière du fichier foo.1 et de la localisation et la spécification des dossiers mans dans la machine.
- Les man de mouve et remouve contiennent les informations sur les bugs rencontrés, leur provenance et la difficulté pour les corriger.
- Les fichiers ont été compressés pour gain d'espace mémoire.

### Mouve/Remouve:
- La fonction basename à été trouvée assez intuitivement. 
- La fonction swich à permis le remplacement de boucles 'for' probablement maladroites.
- Les options de mv et rm sont gérés avec la méthode arguments. On suppose qu'un bon utilisateur respectera l'ordre des 
 des options et des arguments et par le fichier .syncrc.
- La sortie en "|| exit 1" permet d'eviter la gestion d'arguments et laisse les fonctions mv/rm fonctionner en amont.
 Cependant pour la fonction remouve avec l'option -f il a fallut ajouter un if supplementaire (absence du fichier)
 car aucune erreur ne s'affiche et l'écriture du fichier non supprimé se fait tout de même.
- La gestion de l'options help et la gestion d'absence d'argument allourdit un peu le script mais rend le programme 
 plus robuste et "userfriendly"


### Bonjour/Bonsoir:

- La sortie en "|| exit 1" permet d'eviter d'éviter que le script se termine normallement si une erreur a été détectée et de la signaler.
- La fonction tar a été préférée au find indiqué dans le sujet dans un soucis de lisibilité, la méthode employée utilisant le find était longue qui ne prennait 
  pas en compte les fichiers exclus (elle a tout de même été indiqué en commentaire dans le script). Le find n'est donc pas nécessaire et cela retire quelques bugs 
  (par exemple on ignorait tous les dossiers avec le find mais ils sont créés grâce au path, mais si l'utilisateur créait un dossier vide, il n'aurait pas pu être synchronisé.)
- Emploi de la méthode touch en fin de fichir bonsoir et en début de bonjour afin de modifier la date de dernire modification.
- Liaison effectuées avec les fichiers déplacés/supprimés par mouve&remouve à l'aide de la fonction xargs qui passe en argument les path des fichiers affectés à RM (/bin/rm)

 

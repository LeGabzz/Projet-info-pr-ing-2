# Projet-info-pr-ing-

Contenu du projet :

- ReadMe.md = Ce fichier, qui contient les informations sur les options, la bonne façon d'executer ainsi que les limites connues.
- Planning.pdf = Un pdf composé d'un tableau où la distribution en fonction du temps est clairement exposé.
- projetG.sh = Le centre de notre projet, un fichier shell qui regroupe toutes les options décrites ci dessous.
- main.c = le fichier c utile pour l'execution des options S et T, contient un AVL et ses structures.

I/ Informations sur les options.

Notre programme CY Trucks contient les 5 options suivantes : 

D1 = Programmer uniquement à base de shell elle crée 2 fichiers temporaires “extracted_columns.csv” et “counted_unique_lines.csv” puis les supprime et renvoie les 10 conducteurs ayant effectué le plus de trajets. 

D2 = De la même manière que D1 elle est programmé en shell, crée et supprime 2 fichiers temporaires et renvoie ici les 10 conducteurs ayant parcouru la plus grande distance.

L = Cette fonction programmer en shell renvoie les 10 trajets les plus longs

T = Cette fois-ci, cette fonction est développée à partir d’un programme C qui construit des structures afin de stocker les informations concernant les villes, et des structures permettant de construire un AVL. Le programme C contient toutes les fonctions utiles et nécessaires pour avoir un AVL. Ainsi l’exécution de T nous renvoie les 10 villes les plus traversées.

S = En utilisant le même procédé que pour l’option T, l’option S se base sur un programme C afin de renvoyer les statistiques sur les étapes  : les distances minimales, les maximales et les moyennes pour chaque trajet.

II/ Execution

Il faut avant tout installer cMakelist, gcc et gnuplot pour pouvoir exécuter et afficher les graphiques.

Pour installer gcc : 

sudo apt-get update
sudo apt-get install gcc

Pour installer gnuplot :

sudo apt-get update
sudo apt-get install gnuplot

Pour executer le programme shell, il faudra d'abord donner les permissions, soit : 

  chmod +x projetG.sh 

Ensuite, il faut écrire : 

 ./projetG.sh [chemin data.csv] [traitement]
 
 Par exemple pour exécuter l’option s:
 ./projetG.sh/home/utilisateur/projet/data.csv -s

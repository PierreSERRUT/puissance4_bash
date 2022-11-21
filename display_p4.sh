#!/usr/bin/env bash

display_intro()
{
local version="Bash             |"

cat << EOF
|------------------------------------|
|   Bienvenue dans le puissance 4 !  |
|           Version $version
|------------------------------------|

EOF
}

display_grille()
{
	echo 
	for i in {6..1}; do eval echo \${lig$i[@]}; done
	echo "-------------"
}

display_win()
{
	if [ $1 -eq 3 ]; then echo "Pas de chance l'ordinateur a gagné ! "
	else if [ $1 -eq 0 ]; then echo "Egalité ! "
	else echo "Bravo le joueur $1 a gagné !!!" 
	fi
	fi

}

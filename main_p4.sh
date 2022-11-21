#!/usr/bin/env bash

source $(dirname "$0")/add_p4.sh
source $(dirname "$0")/display_p4.sh
#source $(dirname "$0")/ia_simple_p4.sh
#source $(dirname "$0")/ia_v2_p4.sh
source $(dirname "$0")/ia_propre_p4.sh
source $(dirname "$0")/init_p4.sh
source $(dirname "$0")/game_p4.sh
source $(dirname "$0")/validate_p4.sh

display_intro
options=("Jouer à 2 joueurs " "Jouer contre l'ordi facile " "Jouer contre l'ordi moyen " "Ordi contre Ordi(Facile) " "Ordi contre Ordi(Moyen) " "Quitter ")
options2=("Jouer en premier " "Jouer en deuxième ")
PS3="Que voulez vous faire ? "
while true ; do
        select opt in "${options[@]}"; do 
                case "$REPLY" in 
                        1) init; game;;
                        2) init
				while true ; do
					select opt in "${options2[@]}"; do
						case "$REPLY" in
				 			1) game_easy X;;
							2) game_easy O;;
							*) echo "Option inconnue. Reessayer."; continue;;
						esac
					break 2
					done
				done;;

                        3) init; 
				while true ; do
					select opt in "${options2[@]}"; do
						case "$REPLY" in
				 			1) game_hard X;;
							2) game_hard O;;
							*) echo "Option inconnue. Reessayer."; continue;;
						esac
					break 2
					done
				done;;
			4) init; game_e_vs_e;;
                        5) init; game_m_vs_m;;
                        6) echo ; echo "Au revoir !"; break 2 ;;
                        *) echo "Option inconnue. Reessayer."; continue;;
                esac
                read -p "Press [Enter] key to continue..."
                clear
                display_intro
                break
        done
done

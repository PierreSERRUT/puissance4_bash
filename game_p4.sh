#!/usr/bin/env bash

weighted_selection() {
    case $(( RANDOM % 20 )) in
        0|1) return 1 ;;      
        2|3) return 2 ;;    
        4|5|6) return 3 ;;  
        7|8|9) return 5 ;; 
        10|11) return 6 ;;     
        12|13) return 7 ;;     
        *) return 4 ;;  
    esac
}

game()
{
	local turn=1
	local return_add=0
	local winner=0
	local draw=0
	local col=0
	display_grille	
	while [ $winner -eq 0 ]
	do
		col=0
	 	until [[ $col =~ [1-7] ]]; do
			read -n1 -p "Au joueur $turn, choisissez une colonne (1 à 7): " col
			echo
		done
		if [ $turn -eq 1 ]; then add $col 'X'; return_add=$?
		else add $col 'O'; return_add=$?
		fi
		
		while [ $return_add -eq 1 ];do 
			echo "Colonne déjà pleine !"
			display_grille
			read -n1 -p "Au joueur $turn, choisissez une colonne (1 à 7): " col
			if [ $turn -eq 1 ]; then add $col 'X'; return_add=$?
			else add $col 'O'; return_add=$?
			fi
		done
		display_grille	
		validate_win
		winner=$?
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
		turn=$(($turn%2+1))
	done
	display_win $winner
}

game_easy()
{
	local symb=$1
	local return_add=0
	local winner=0
	local col=0
	display_grille	
	while [ $winner -eq 0 ]
	do
		if [ $symb == 'O' ]; then
			add_comp_easy 'X'
			display_grille	
			validate_win
			winner=$?
			if [ $winner -ne 0 ]; then break; fi
			check_draw
			draw=$?
			if [ $draw -eq 1 ]; then
				break
			fi
		fi
		col=0
	 	until [[ $col =~ [1-7] ]]; do
			read -n1 -p "Au joueur, choisissez une colonne (1 à 7): " col
			echo
		done
		add $col $symb
	       	return_add=$?
		while [ $return_add -eq 1 ]; do 
			echo "Colonne déjà pleine !"
			display_grille
			read -n1 -p "Au joueur, choisissez une colonne (1 à 7): " col
			add $col $symb
	       		return_add=$?
		done
		display_grille	
		validate_win
		winner=$?
		if [ $winner -ne 0 ]; then break; fi
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
		if [ $symb == 'X' ]; then
			add_comp_easy 'O'
		fi
		display_grille	
		validate_win
		winner=$?
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
	done
	if [ $symb == 'X' ]; then local symb_numb=1
	else local symb_numb=2
	fi

	if [ $winner -eq $symb_numb ]; then display_win 1
	else if [ $winner -eq $(($symb_numb%2+1)) ]; then display_win 3
	else display 0
	fi
	fi
}

game_hard()
{
	local symb=$1
	local return_add=0
	local winner=0
	local col=0
	display_grille	
	while [ $winner -eq 0 ]
	do
		if [ $symb == 'O' ]; then
			main_ia 'X'
			display_grille	
			validate_win
			winner=$?
			if [ $winner -ne 0 ]; then break; fi
			check_draw
			draw=$?
			if [ $draw -eq 1 ]; then
				break
			fi
		fi
		col=0
	 	until [[ $col =~ [1-7] ]]; do
			read -n1 -p "Au joueur, choisissez une colonne (1 à 7): " col
			echo
		done
		add $col $symb
	       	return_add=$?
		while [ $return_add -eq 1 ]; do 
			echo "Colonne déjà pleine !"
			display_grille
			read -n1 -p "Au joueur, choisissez une colonne (1 à 7): " col
			add $col $symb
	       		return_add=$?
		done
		display_grille	
		validate_win
		winner=$?
		if [ $winner -ne 0 ]; then break; fi
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
		if [ $symb == 'X' ]; then
			main_ia 'O'
			display_grille	
		fi
		validate_win
		winner=$?
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
	done
	if [ $symb == 'X' ]; then local symb_numb=1
	else local symb_numb=2
	fi

	if [ $winner -eq $symb_numb ]; then display_win 1
	else if [ $winner -eq $(($symb_numb%2+1)) ]; then display_win 3
	else display 0
	fi
	fi
}

game_e_vs_e()
{
	local winner=0
	display_grille	
	while [ $winner -eq 0 ]
	do
		add_comp_easy 'X'
		display_grille	
		validate_win
		winner=$?
		if [ $winner -ne 0 ]; then break; fi
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
		add_comp_easy 'O'
		display_grille	
		validate_win
		winner=$?
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
	done
	display_win $winner
}

game_m_vs_m()
{
	local winner=0
	display_grille	
	while [ $winner -eq 0 ]
	do
		main_ia 'X'
		display_grille	
		validate_win
		winner=$?
		if [ $winner -ne 0 ]; then break; fi
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
		main_ia 'O'
		display_grille	
		validate_win
		winner=$?
		check_draw
		draw=$?
		if [ $draw -eq 1 ]; then
			break
		fi
	done
	display_win $winner
}


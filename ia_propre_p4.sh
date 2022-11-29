#!/usr/bin/env bash

# initialisation des variables globales de l'ordinateur
init_var_ia()
{
	declare -a pos_X=()
	declare -a pos_O=()
	declare -a figure_X=()
	declare -a figure_O=()
	declare -a pos_ok_X=()
	declare -a pos_ok_O=()
	declare -a pos_forbit_X=()
	declare -a pos_forbit_O=()
}

#rempli les pos_X,O et figure_X,O
detect_3()
{
	pos_X=()
	pos_O=()
	figure_X=()
	figure_O=()
	for i in {1..6}; do
		for j in {1..7}; do
			local i1=$(($i+1))
			local i2=$(($i+2))
			local i3=$(($i+3))
			local j1=$(($j+1))
			local j2=$(($j+2))
			local j3=$(($j+3))
			eval local vxy=\${lig$i[\$j]}
			if [ $j -le 5 ]; then 
				eval local vxy1=\${lig$i[\$j1]}
                                eval local vxy2=\${lig$i[\$j2]}
				if [[ $vxy == $vxy1 && $vxy == $vxy2 && $vxy != '-' ]]
				then
					local pos="$i $j"
					if [ $vxy == 'X' ]; then
					       	pos_X+=($pos)
					       	figure_X+=("Lig")
				       	else
					       	pos_O+=($pos)
					       	figure_O+=("Lig")
				       	fi
				fi
			fi
			if [ $j -le 4 ]; then 
				eval local vxy1=\${lig$i[\$j1]}
                                eval local vxy2=\${lig$i[\$j2]}
                                eval local vxy3=\${lig$i[\$j3]}
				if [ $vxy == $vxy3 ] && [ $vxy != '-' ] 
				then
				       if [ $vxy == $vxy1 ] || [ $vxy == $vxy2 ]; then
						if [ $vxy1 == '-' ]; then 
							local pos="$i $j1"
							if [ $vxy == 'X' ]; then pos_X+=($pos); figure_X+=("LigMissing")
						       	else pos_O+=($pos); figure_O+=("LigMissing"); fi
						else if [ $vxy2 == '-' ]; then
						       	local pos="$i $j2"
							if [ $vxy == 'X' ]; then pos_X+=($pos); figure_X+=("LigMissing")
						       	else pos_O+=($pos); figure_O+=("LigMissing"); fi
						fi
					      	fi
				       fi
				fi
			fi
			if [ $i -le 4 ]; then
				eval local vx1y=\${lig$i1[\$j]}
				eval local vx2y=\${lig$i2[\$j]}
				if [[ $vxy == $vx1y && $vxy == $vx2y && $vxy != '-' ]]
				then
					local pos="$i $j"
					if [ $vxy == 'X' ]; then pos_X+=($pos); figure_X+=("Col")
				       	else pos_O+=($pos); figure_O+=("Col"); fi
				fi
			fi
			if [[ $i -le 4 && $j -le 5 ]]; then
				eval local vx1y1=\${lig$i1[\$j1]}
				eval local vx2y2=\${lig$i2[\$j2]}
				if [[ $vxy == $vx1y1 && $vxy == $vx2y2 && $vxy != '-' ]]
				then
					local pos="$i $j"
					if [ $vxy == 'X' ]; then pos_X+=($pos); figure_X+=("DiagoM")
					else pos_O+=($pos); figure_O+=("DiagoM"); fi
				fi
				if [[ $vx2y == $vx1y1 && $vx2y == $vxy2 && $vx2y != '-' ]]
				then
					local pos="$i $j"
					if [ $vx2y == 'X' ]; then pos_X+=($pos); figure_X+=("DiagoD")
					else pos_O+=($pos); figure_O+=("DiagoD"); fi
				fi
			fi
			if [[ $i -le 3 && $j -le 4 ]]; then
				eval local vx1y1=\${lig$i1[\$j1]}
                                eval local vx2y2=\${lig$i2[\$j2]}
                                eval local vx3y3=\${lig$i3[\$j3]}
				if [ $vxy == $vx3y3 ] && [ $vxy != '-' ] 
				then
				       if [ $vxy == $vx1y1 ] || [ $vxy == $vx2y2 ]; then
						if [ $vx1y1 == '-' ]; then 
							local pos="$i1 $j1"
							if [ $vxy == 'X' ]; then pos_X+=($pos); figure_X+=("DiagMoMissing")
							else pos_O+=($pos); figure_O+=("DiagMoMissing"); fi
						else if [ $vx2y2 == '-' ]; then
						       	local pos="$i2 $j2"
							if [ $vxy == 'X' ]; then pos_X+=($pos); figure_X+=("DiagMoMissing")
							else pos_O+=($pos); figure_O+=("DiagMoMissing"); fi
						fi
					      	fi
				       fi
				fi
				eval local vx3y=\${lig$i3[\$j]}
				eval local vx2y1=\${lig$i2[\$j1]}
                                eval local vx1y2=\${lig$i1[\$j2]}
                                eval local vxy3=\${lig$i[\$j3]}
				if [ $vx3y == $vxy3 ] && [ $vx3y != '-' ] 
				then
				       if [ $vx3y == $vx2y1 ] || [ $vx3y == $vx1y2 ]; then
						if [ $vx2y1 == '-' ]; then 
							local pos="$i2 $j1"
							if [ $vx3y == 'X' ]; then pos_X+=($pos); figure_X+=("DiagDeMissing")
							else pos_O+=($pos); figure_O+=("DiagDeMissing"); fi
						else if [ $vx1y2 == '-' ]; then
						       	local pos="$i1 $j2"
							if [ $vx3y == 'X' ]; then pos_X+=($pos); figure_X+=("DiagDeMissing")
							else pos_O+=($pos); figure_O+=("DiagDeMissing"); fi
						fi
					      	fi
				       fi
				fi
			fi
		done
	done
}

#rempli les positions ok et interdite pour 'X' et O
check_pos()
{

	pos_ok_X=()
	pos_ok_O=()
	pos_forbit_X=()
	pos_forbit_O=()

#	if ! (( ${#pos_forbit_O[@]} > 0)); then echo "pos_forbit_O is empty"; fi
#	if ! (( ${#pos_forbit_X[@]} > 0)); then echo "pos_forbit_X is empty"; fi

	local nb_pos_X=${#pos_X[@]}
	local nb_pos_O=${#pos_O[@]}
	for a in  'X' 'O'; do
		eval local fig$a=''
		eval local lig$a=''
		eval local col$a=''
		local i_hi=0
		local i_bot=0
		local i_bot2=0
		local j_left=0
		local j_right=0
		if eval [ \$nb_pos_$a -ne 0 ]; then 
			eval local temp2=\$nb_pos_$a
			temp2=$((temp2 / 2))
			for (( z=0; z<$temp2; z++ )); do
				if [ $a == 'X' ]; then
					figX=${figure_X[$z]}
					ligX=${pos_X[$((z*2))]}
					colX=${pos_X[$((z*2+1))]}
				else
					figO=${figure_O[$z]}
					ligO=${pos_O[$((z*2))]}
					colO=${pos_O[$((z*2+1))]}
				fi
				eval local text="\$fig$a" 
				case $text in
					"Lig")
						if eval [ \$col$a -ne 1 ]; then
							#check gauche de la ligne
							eval local temp=\$col$a
							j_left=$(($temp-1))
							eval local temp=\$lig$a
							eval local v_left=\${lig$temp[\$j_left]}
							if [ $v_left == '-' ];then 
								if eval [ \$lig$a -eq 1 ]; then
									if [ $a == 'X' ]; then
										pos_ok_X+=($j_left)
									else
										pos_ok_O+=($j_left)
									fi
								else
									eval local temp=\$lig$a
									i_bot=$(($temp-1))
									eval local v_left_bot=\${lig$i_bot[\$j_left]}
									if [ $v_left_bot != '-' ]; then 
										if [ $a == 'X' ]; then
											pos_ok_X+=($j_left)
										else
											pos_ok_O+=($j_left)
										fi
									else
										if [ $a == 'X' ]; then
											pos_forbit_O+=($j_left)
										else
											pos_forbit_X+=($j_left)
										fi
										
									fi
								fi
							fi	
						fi
						if eval [ \$col$a -lt 5 ]; then
							#check droite de la ligne
							eval local temp=\$col$a
							j_right=$(($temp+3))
							eval local temp=\$lig$a
							eval local v_right=\${lig$temp[\$j_right]}
							if [ $v_right == '-' ];then 
								if eval [ \$lig$a -eq 1 ]; then
									if [ $a == 'X' ]; then
										pos_ok_X+=($j_right)
									else
										pos_ok_O+=($j_right)
									fi
								else
									eval local temp=\$lig$a
									i_bot=$(($temp-1))
									eval local v_right_bot=\${lig$i_bot[\$j_right]}
									if [ $v_right_bot != '-' ]; then 
										if [ $a == 'X' ]; then
											pos_ok_X+=($j_right)
										else
											pos_ok_O+=($j_right)
										fi
									else
										if [ $a == 'X' ]; then
											pos_forbit_O+=($j_right)
										else
											pos_forbit_X+=($j_right)
										fi
									fi
								fi
							fi	
						fi;;
					"Col")
        	                                if eval [ \$lig$a -lt 4 ]; then
                        	                        eval local temp=\$lig$a
							i_hi=$(($temp+3))
							eval temp=\$col$a
	                                                eval local v_hi=\${lig$i_hi[\$temp]}
        	                                        if [ $v_hi == '-' ]; then
								if [ $a == 'X' ]; then
									pos_ok_X+=($temp)
								else
									pos_ok_O+=($temp)
								fi
          	                                      fi
                	                        fi;;
                        	        "DiagoM")
                                	        if eval [ \$lig$a -ne 1 ] && eval [ \$col$a -ne 1 ]; then
                                        	        #check gauche de la diago
                                                	eval local temp=\$col$a
	                                                j_left=$(($temp-1))
        	                                        eval temp=\$lig$a
                	                                i_bot=$(($temp-1))
                        	                        eval local v_left=\${lig$i_bot[\$j_left]}
                                	                if [ $v_left == '-' ];then
                                        	                if eval [ \$lig$a -eq 2 ]; then
									if [ $a == 'X' ]; then
										pos_ok_X+=($j_left)
									else
										pos_ok_O+=($j_left)
									fi
        	                                                else
                	                                		eval local temp=\$lig$a
                        	                                        i_bot2=$(($temp-2))
                                	                                eval local v_left_bot=\${lig$i_bot2[\$j_left]}
                                        	                        if [ $v_left_bot != '-' ]; then
										if [ $a == 'X' ]; then
											pos_ok_X+=($j_left)
										else
											pos_ok_O+=($j_left)
										fi
									else
										if [ $a == 'X' ]; then
											pos_forbit_O+=($j_left)
										else
											pos_forbit_X+=($j_left)
										fi
        	                                                        fi
                	                                        fi
                        	                        fi
                                	        fi
                                        	if eval [ \$lig$a -lt 4 ] && eval [ \$col$a -lt 5 ]; then
                                                	#check droite de la diago
	                                                eval local temp=\$col$a
        	                                        j_right=$(($temp+3))
                	                                eval temp=\$lig$a
                        	                        i_hi=$(($temp+3))
                                	                eval local v_right=\${lig$i_hi[\$j_right]}
                                        	        if [ $v_right == '-' ];then
                                                	        i_bot=$(($i_hi-1))
                                                        	eval local v_right_bot=\${lig$i_bot[\$j_right]}
								if [ $v_right_bot != '-' ]; then
									if [ $a == 'X' ]; then
										pos_ok_X+=($j_right)
									else
										pos_ok_O+=($j_right)
									fi
								else
									if [ $a == 'X' ]; then
										pos_forbit_O+=($j_right)
									else
										pos_forbit_X+=($j_right)
									fi
                                                	        fi
	                                                fi
        	                                fi;;
					"DiagoD")
                        	                if eval [ \$lig$a -lt 4 ] && eval [ \$col$a -ne 1 ]; then
                                	                #check gauche de la diago
                                        	        eval local temp=\$col$a
                                                	j_left=$(($temp-1))
	                                                eval temp=\$lig$a
        	                                        i_hi=$(($temp+3))
                	                                eval local v_left=\${lig$i_hi[\$j_left]}
                        	                        if [ $v_left == '-' ];then
                                	                        i_bot=$(($i_hi-1))
                                        	                eval local v_left_bot=\${lig$i_bot[\$j_left]}
                                                	        if [ $v_left_bot != '-' ]; then
									if [ $a == 'X' ]; then
										pos_ok_X+=($j_left)
									else
										pos_ok_O+=($j_left)
									fi
								else
									if [ $a == 'X' ]; then
										pos_forbit_O+=($j_left)
									else
										pos_forbit_X+=($j_left)
									fi
                                	                        fi
                                        	        fi
	                                        fi
        	                                if eval [ \$lig$a -ne 1 ] && eval [ \$col$a -lt 5 ]; then
                	                                #check droite de la diago
                        	                        eval local temp=\$col$a
                                	                j_right=$(($temp+3))
                                        	        eval temp=\$lig$a
                                                	i_bot=$(($temp-1))
	                                                eval local v_right=\${lig$i_bot[\$j_right]}
        	                                        if [ $v_right == '-' ];then
                	                                        if eval [ \$lig$a -eq 2 ]; then
									if [ $a == 'X' ]; then
										pos_ok_X+=($j_right)
									else
										pos_ok_O+=($j_right)
									fi
	                                                         else
        	                                                         i_bot2=$(($temp-2))
                	                                                 eval local v_right_bot=\${lig$i_bot2[\$j_right]} 
									 if [ $v_right_bot != '-' ]; then
									 	if [ $a == 'X' ]; then
											pos_ok_X+=($j_right)
										else
											pos_ok_O+=($j_right)
										fi
									else
										if [ $a == 'X' ]; then
											pos_forbit_O+=($j_right)
										else
											pos_forbit_X+=($j_right)
										fi
        	                                                         fi
                	                                        fi
                        	                        fi
                                	        fi;;
					"LigMissing"|"DiagMoMissing"|"DiagDeMissing")
        	                                if eval [ \$lig$a -eq 1 ]; then
							eval local temp=\$col$a
							if [ $a == 'X' ]; then
								pos_ok_X+=($temp)
							else
								pos_ok_O+=($temp)
							fi
        	                                else
                	                                eval local temp=\$lig$a
                        	                        i_bot=$(($temp-1))
							eval temp=\$col$a
                                        	        eval local v_bot=\${lig$i_bot[\$temp]}
                                                	if [ $v_bot != '-' ]; then
								if [ $a == 'X' ]; then
									pos_ok_X+=($temp)
								else
									pos_ok_O+=($temp)
								fi
							else
								if [ $a == 'X' ]; then
									pos_forbit_O+=($temp)
								else
									pos_forbit_X+=($temp)
								fi
                                        	        fi
	                                        fi;;
					
					*);;
				esac
			done
		fi
	done
}

main_ia()
{
	
	local symb=$1
	echo $symb
	init_var_ia
	detect_3
	check_pos
	local ret_add=0
	local ret_forb=0
	local ret_imp=0
	local random=0
	local placX=''
	local plac0=''
	local nb_pos_ok_X=${#pos_ok_X[@]}
	local nb_pos_ok_O=${#pos_ok_O[@]}

	if [ $nb_pos_ok_X -ne 0 ]; then
        	if [ $nb_pos_ok_X -ne 1 ]; then
			random=$(($RANDOM %$nb_pos_ok_X))
                        placX=${pos_ok_X[$random]}
		else
                        placX=${pos_ok_X[0]}
		fi
	fi	       
        if [ $nb_pos_ok_O -ne 0 ]; then
        	if [ $nb_pos_ok_O -ne 1 ]; then
			random=$(($RANDOM %$nb_pos_ok_O))
                        placO=${pos_ok_O[$random]}
		else
                        placO=${pos_ok_O[0]}
		fi
	fi	       

	if [ $symb == 'X' ] && [ $nb_pos_ok_X -ne 0 ]; then
		add $placX 'X'
	else
	       	if  [ $symb == 'X' ] && [ $nb_pos_ok_O -ne 0 ]; then
			add $placO 'X'
		else 
			if  [ $symb == 'O' ] && [ $nb_pos_ok_O -ne 0 ]; then
				add $placO 'O'
			else 
				if  [ $symb == 'O' ] && [ $nb_pos_ok_X -ne 0 ]; then
					add $placX 'O'
				else
					local cond1=true
					while $cond1 || [ $ret_add -eq 1 ]; do
						cond1=false
						local cond2=true
						while $cond2 || [ $ret_forb -eq 1 ] ; do
							cond2=false
							weighted_selection
							random=$?

							check_pos_forb $symb $random
							ret_forb=$?
							check_imp $symb $random
							ret_imp=$?
							if [ $ret_imp -eq 1 ]; then break; fi
						done
						add $random $symb
						ret_add=$?
					done
				fi
			fi
		fi
	fi
}

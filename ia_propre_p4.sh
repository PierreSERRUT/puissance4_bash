#!/usr/bin/env bash

ia_3()
{
	local symb=$1
	local posX=""
	local posO=""
	local figureX=""
	local figureO=""
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
					local pos="$i $j |"
					local fig="Lig |"

					eval pos$vxy+="\$pos"
					eval figure$vxy+="\$fig"
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
							local pos="$i $j1 |"
							local fig="LigMissing |"
							eval pos$vxy+="\$pos"
							eval figure$vxy+="\$fig"
						else if [ $vxy2 == '-' ]; then
						       	local pos="$i $j2 |"
							local fig="LigMissing |"
							eval pos$vxy+="\$pos"
							eval figure$vxy+="\$fig"
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
					local pos="$i $j |"
					local fig="Col |"

					eval pos$vxy+="\$pos"
					eval figure$vxy+="\$fig"
				fi
			fi
			if [[ $i -le 4 && $j -le 5 ]]; then
				eval local vx1y1=\${lig$i1[\$j1]}
				eval local vx2y2=\${lig$i2[\$j2]}
				if [[ $vxy == $vx1y1 && $vxy == $vx2y2 && $vxy != '-' ]]
				then
					local pos="$i $j |"
					local fig="DiagoM |"

					eval pos$vxy+="\$pos"
					eval figure$vxy+="\$fig"
				fi
				if [[ $vx2y == $vx1y1 && $vx2y == $vxy2 && $vx2y != '-' ]]
				then
					local pos="$i $j |"
					local fig="DiagoD |"

					eval pos$vx2y+="\$pos"
					eval figure$vx2y+="\$fig"
				fi
			fi
		done
	done


	#########################

	local nb_posX=$(echo $posX | grep -o '|' | wc -l)
	local nb_posO=$(echo $posO | grep -o '|' | wc -l)

	for a in  'X' 'O'; do

	

	eval local coord$a=''
	eval local fig$a=''
	eval local lig$a=''
	eval local col$a=''
	eval local pos_ok$a=''
	local i_hi=0
	local i_bot=0
	local i_bot2=0
	local j_left=0
	local j_right=0
	eval local temp=\nb_pos$a
	if eval [ \$nb_pos$a -ne 0 ]; then 
		eval local temp2=\$nb_pos$a
		for (( z=1; z<=$temp2; z++ )); do
			if [ $a == 'X' ]; then
				coordX=$(echo $posX | cut -d '|' -f $z)
			else
				coordO=$(echo $posO | cut -d '|' -f $z)
			fi
			eval temp=\$figure$a
			eval fig$a=$(echo "$temp" | cut -d '|' -f $z)
			eval temp=\$coord$a
			eval lig$a=$(echo "$temp" | cut -d ' ' -f 1)
			eval col$a=$(echo "$temp" | cut -d ' ' -f 2)
			
			eval local coord_ok$a=""
			eval local text="\$fig$a" 
			case $text in
				"Lig")
					if eval [ \$col$a -ne 1 ]; then
						#check gauche de la ligne
						eval local temp=\$col$a
						j_left=$(($temp-1))
						#if [ $a == 'X' ]; then
						eval local temp=\$lig$a
						eval local v_left=\${lig$temp[\$j_left]}
						#else 
						#	eval local v_left=\${lig$ligO[\$j_left]}
						#fi
						if [ $v_left == '-' ];then 
							if eval [ \$lig$a -eq 1 ]; then
								if [ $a == 'X' ]; then
									pos_okX+="$j_left |"
								else
									pos_okO+="$j_left |"
								fi
							else
								eval local temp=\$lig$a
								i_bot=$(($temp-1))
								eval local v_left_bot=\${lig$i_bot[\$j_left]}
								if [ $v_left_bot != '-' ]; then 
									if [ $a == 'X' ]; then
									       	pos_okX+="$j_left |"
									else
									       	pos_okO+="$j_left |"
									fi
								fi
							fi
						fi	
					fi
					if eval [ \$col$a -lt 5 ]; then
						#check droite de la ligne
						eval local temp=\$col$a
						j_right=$(($temp+3))
						#if [ $a == 'X' ]; then
						eval local temp=\$lig$a
						eval local v_right=\${lig$temp[\$j_right]}
						#else
						#	eval local v_right=\${lig$ligO[\$j_right]}
						#fi
						if [ $v_right == '-' ];then 
							if eval [ \$lig$a -eq 1 ]; then
								if [ $a == 'X' ]; then
									pos_okX+="$j_right |"
								else
									pos_okO+="$j_right |"
								fi
							else
								eval local temp=\$lig$a
								i_bot=$(($temp-1))
								eval local v_right_bot=\${lig$i_bot[\$j_right]}
								if [ $v_right_bot != '-' ]; then 
									if [ $a == 'X' ]; then
										pos_okX+="$j_right |"
									else
										pos_okO+="$j_right |"
									fi
								fi
							fi
						fi	
					fi;;
				"Col")
                                        if eval [ \$lig$a -lt 4 ]; then
                                                #check haut de la col
                                                eval local temp=\$lig$a
						i_hi=$(($temp+3))
						eval temp=\$col$a
                                                eval local v_hi=\${lig$i_hi[\$temp]}
                                                if [ $v_hi == '-' ]; then
							if [ $a == 'X' ]; then
                                                        	pos_okX+="$temp |"
							else
                                                        	pos_okO+="$temp |"
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
									pos_okX+="$j_left |"
								else
									pos_okO+="$j_left |"
								fi
                                                        else
                                                		eval local temp=\$lig$a
                                                                i_bot2=$(($temp-2))
                                                                eval local v_left_bot=\${lig$i_bot2[\$j_left]}
                                                                if [ $v_left_bot != '-' ]; then
									if [ $a == 'X' ]; then
										pos_okX+="$j_left |"
									else
										pos_okO+="$j_left |"
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
									pos_okX+="$j_right |"
								else
									pos_okO+="$j_right |"
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
								eval pos_ok$a+=
								if [ $a == 'X' ]; then
									pos_okX+="$j_left |"
								else
									pos_okO+="$j_left |"
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
									pos_okX+="$j_right |"
								else
									pos_okO+="$j_right |"
								fi
                                                         else
                                                                 i_bot2=$(($temp-2))
                                                                 eval local v_right_bot=\${lig$i_bot2[\$j_right]}
                                                                 if [ $v_right_bot != '-' ]; then
									if [ $a == 'X' ]; then
										pos_okX+="$j_right |"
									else
										pos_okO+="$j_right |"
									fi
                                                                 fi
                                                        fi
                                                fi
                                        fi;;
				"LigMissing")
                                        if eval [ \$lig$a -eq 1 ]; then
						eval local temp=\$col$a
						if [ $a == 'X' ]; then
							pos_okX+="$temp |"
						else
							pos_okO+="$temp |"
						fi
                                        else
                                                eval local temp=\$lig$a
                                                i_bot=$(($lig-1))
						eval temp=\$col$a
                                                eval local v_bot=\${lig$i_bot[\$temp]}
                                                if [ $v_bot != '-' ]; then
							if [ $a == 'X' ]; then
								pos_okX+="$temp |"
							else
								pos_okO+="$temp |"
							fi
                                                fi
                                        fi
                                        ;;
				*);;
			esac
		done
	fi

	done

	local ret=0
	local placX=''
	local plac0=''
	local random=0
	local nb_posX_ok=$(echo $pos_okX | grep -o '|' | wc -l)
	local nb_posO_ok=$(echo $pos_okO | grep -o '|' | wc -l)


        if [ $nb_posX_ok -ne 0 ]; then
        	if [ $nb_posX_ok -ne 1 ]; then
			random=$((1 + $RANDOM %$nb_posX_ok))
                        placX=$(echo $pos_okX | cut -d '|' -f $random)
		else
                        placX=$(echo $pos_okX | cut -d '|' -f 1)
		fi
	fi	       
        if [ $nb_posO_ok -ne 0 ]; then
        	if [ $nb_posO_ok -ne 1 ]; then
			random=$((1 + $RANDOM %$nb_posO_ok))
                        placO=$(echo $pos_okO | cut -d '|' -f $random)
		else
                        placO=$(echo $pos_okO | cut -d '|' -f 1)
		fi
	fi	       


	if [ $symb == 'X' ] && [ $nb_posX_ok -ne 0 ]; then
		add $placX 'X'
	else
	       	if  [ $symb == 'X' ] && [ $nb_posO_ok -ne 0 ]; then
			add $placO 'X'
		else 
			if  [ $symb == 'O' ] && [ $nb_posO_ok -ne 0 ]; then
				add $placO 'O'
			else 
				if  [ $symb == 'O' ] && [ $nb_posX_ok -ne 0 ]; then
					add $placX 'O'
				else
					#random=$((1 + $RANDOM %7))
					weighted_selection
					random=$?
					add $random $symb
					ret=$?
					while [ $ret -eq 1 ]; do
						#random=$((1 + $RANDOM %7))
						weighted_selection
						random=$?
						add $random $symb
						ret=$?
					done
				fi
			fi
		fi
	fi
}

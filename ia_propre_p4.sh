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
					#echo "Ligne possible en [$i;$j]"
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
					echo if1 vxy: $vxy vxy1: $vxy1 vxy2: $vxy2
				       if [ $vxy == $vxy1 ] || [ $vxy == $vxy2 ]; then
					       echo if2
					       	echo "Ligne possible en [$i;$j]"
						if [ $vxy1 == '-' ]; then 
							local pos="$i $j1 |"
							local fig="Lig Missing |"
							eval pos$vxy+="\$pos"
							eval figure$vxy+="\$fig"
						else if [ $vxy2 == '-' ]; then
						       	local pos="$i $j2 |"
							local fig="Lig Missing |"
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
					#echo "Colonne possible en [$i;$j]"
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
					#echo "Diago montante possible en [$i;$j]"
					local pos="$i $j |"
					local fig="DiagoM |"

					eval pos$vxy+="\$pos"
					eval figure$vxy+="\$fig"
				fi
				if [[ $vx2y == $vx1y1 && $vx2y == $vxy2 && $vx2y != '-' ]]
				then
					#echo "Diago descendante possible en [$i2;$j]"
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
		echo $a

	eval echo "pos$a \$pos$a"
	
	eval echo "nb_pos$a : \$nb_pos$a"

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
			eval fig$a=$(echo $temp | cut -d '|' -f $z)
			eval temp=\$coord$a
			eval lig$a=$(echo $temp | cut -d ' ' -f 1)
			eval col$a=$(echo $temp | cut -d ' ' -f 2)
			
			eval local coord_ok$a=""
			eval local text=\$fig$a 
			echo text: $text
			case $text in
				"Lig ")
					if eval [ \$col$a -ne 1 ]; then
						#check gauche de la ligne
						eval local temp=\$col$a
						j_left=$(($temp-1))
						if [ $a == 'X' ]; then
							eval local v_left=\${lig$ligX[\$j_left]}
						else 
							eval local v_left=\${lig$ligO[\$j_left]}
						fi
						if [ $v_left == '-' ];then 
							if eval [ $lig$a -eq 1 ]; then
								 eval pos_ok$a+="$j_left |"
							else
								eval local temp=\$lig$a
								i_bot=$(($temp-1))
								eval local v_left_bot=\${lig$i_bot[\$j_left]}
								if [ $v_left_bot != '-' ]; then 
								       	eval pos_ok$a+="$j_left |"
								fi
							fi
						fi	
					fi
					if eval [ \$col$a -lt 5 ]; then
						#check droite de la ligne
						eval local temp=\$col$a
						eval j_right=$(($temp+3))
						if [ $a == 'X' ]; then
							eval local v_right=\${lig$ligX[\$j_right]}
						else
							eval local v_right=\${lig$ligO[\$j_right]}
						fi
						if [ $v_right == '-' ];then 
							if eval [ \$lig$a -eq 1 ]; then
								eval pos_ok$a+="$j_right |"
							else
								eval local temp=\$lig$a
								eval i_bot=$((temp-1))
								eval local v_right_bot=\${lig$i_bot[\$j_right]}
								if [ $v_right_bot != '-' ]; then 
								       	eval pos_ok$a+="$j_right |"
								fi
							fi
						fi	
					fi;;
				*);;
			esac
		done
	fi

	done
        echo posO: $pos_okO posX: $pos_okX

	local ret=0
	local placX=''
	local plac0=''
	local random=0
	local nb_posX_ok=$(echo $posX_ok | grep -o '|' | wc -l)
	local nb_posO_ok=$(echo $posO_ok | grep -o '|' | wc -l)

#	echo nb_pos  X: $nb_posX_ok O:  $nb_posO_ok 

        if [ $nb_posX_ok -ne 0 ]; then
        	if [ $nb_posX_ok -ne 1 ]; then
			random=$((1 + $RANDOM %$nb_posX_ok))
                        placX=$(echo $posX_ok | cut -d '|' -f $random)
		else
                        placX=$(echo $posX_ok | cut -d '|' -f 1)
		fi
	fi	       
        if [ $nb_posO_ok -ne 0 ]; then
        	if [ $nb_posO_ok -ne 1 ]; then
			random=$((1 + $RANDOM %$nb_posO_ok))
                        placO=$(echo $posO_ok | cut -d '|' -f $random)
		else
                        placO=$(echo $posO_ok | cut -d '|' -f 1)
		fi
	fi	       

#	echo placX $placX

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
					random=$((1 + $RANDOM %7))
					add $random $symb
					ret=$?
					while [ $ret -eq 1 ]; do
						random=$((1 + $RANDOM %7))
						add $random $symb
						ret=$?
					done
				fi
			fi
		fi
	fi
}

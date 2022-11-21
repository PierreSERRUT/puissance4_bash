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
			local j1=$(($j+1))
			local j2=$(($j+2))

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
	local nb_posX=$(echo $posX | grep -o '|' | wc -l)

	local coordX=''
	local figX=''
	local ligX=''
	local colX=''
	local posX_ok=''
	local i_hi=0
	local i_bot=0
	local i_bot2=0
	local j_left=0
	local j_right=0
	if [ $nb_posX -ne 0 ]; then 
		for (( z=1; z<=$nb_posX; z++ )); do
			coordX=$(echo $posX | cut -d '|' -f $z)
			figX=$(echo $figureX | cut -d '|' -f $z)
			ligX=$(echo $coordX | cut -d ' ' -f 1)
			colX=$(echo $coordX | cut -d ' ' -f 2)
			
			local coordX_ok=""
			case $figX in
				"Lig ")
					if [ $colX -ne 1 ]; then
						#check gauche de la ligne
						j_left=$(($colX-1))
						eval local v_left=\${lig$ligX[\$j_left]}
						if [ $v_left == '-' ];then 
							if [ $ligX -eq 1 ]; then
								 posX_ok+="$j_left |"
							else
								i_bot=$(($ligX-1))
								eval local v_left_bot=\${lig$i_bot[\$j_left]}
								if [ $v_left_bot != '-' ]; then 
								       	posX_ok+="$j_left |"
								fi
							fi
						fi	
					fi
					if [ $colX -lt 5 ]; then
						#check droite de la ligne
						j_right=$(($colX+3))
						eval local v_right=\${lig$ligX[\$j_right]}
						if [ $v_right == '-' ];then 
							if [ $ligX -eq 1 ]; then
								posX_ok+="$j_right |"
							else
								i_bot=$(($ligX-1))
								eval local v_right_bot=\${lig$i_bot[\$j_right]}
								if [ $v_right_bot != '-' ]; then 
								       	posX_ok+="$j_right |"
								fi
							fi
						fi	
					fi;;
				"Col ")
					if [ $ligX -lt 4 ]; then
						#check haut de la col
						i_hi=$(($ligX+3))
						eval local v_hi=\${lig$i_hi[\$colX]}
						if [ $v_hi == '-' ];then 
							 posX_ok+="$colX |"
						fi	
					fi;;
				"DiagoM ")
					if [ $ligX -ne 1 ] && [ $colX -ne 1 ]; then 
						#check gauche de la diago
						j_left=$(($colX-1))
						i_bot=$(($ligX-1))
						eval local v_left=\${lig$i_bot[\$j_left]}
						if [ $v_left == '-' ];then 
							if [ $ligX -eq 2 ]; then
								 posX_ok+="$j_left |"
							else
								i_bot2=$(($ligX-2))
								eval local v_left_bot=\${lig$i_bot2[\$j_left]}
								if [ $v_left_bot != '-' ]; then 
								       	posX_ok+="$j_left |"
								fi
							fi
						fi	
					fi
					if [ $ligX -lt 4 ] && [ $colX -lt 5 ]; then 
						#check droite de la diago
						j_right=$(($colX+3))
						i_hi=$(($ligX+3))
						eval local v_right=\${lig$i_hi[\$j_right]}
						if [ $v_right == '-' ];then 
							i_bot=$(($i_hi-1))
							eval local v_right_bot=\${lig$i_bot[\$j_right]}
							if [ $v_right_bot != '-' ]; then 
							       	posX_ok+="$j_right |"
							fi
						fi	
					fi;;
				"DiagoD ")
					if [ $ligX -lt 4 ] && [ $colX -ne 1 ]; then 
						#check gauche de la diago
						j_left=$(($colX-1))
						i_hi=$(($ligX+3))
						eval local v_left=\${lig$i_hi[\$j_left]}
						if [ $v_left == '-' ];then 
							i_bot=$(($i_hi-1))
							eval local v_left_bot=\${lig$i_bot[\$j_left]}
							if [ $v_left_bot != '-' ]; then 
							       	posX_ok+="$j_left |"
							fi
						fi	
					fi
					if [ $ligX -ne 1 ] && [ $colX -lt 5 ]; then 
						#check droite de la diago
						j_right=$(($colX+3))
						i_bot=$(($ligX-1))
						eval local v_right=\${lig$i_bot[\$j_right]}
						if [ $v_right == '-' ];then 
							if [ $ligX -eq 2 ]; then
								 posX_ok+="$j_right |"
							 else
								 i_bot2=$(($ligX-2))
								 eval local v_right_bot=\${lig$i_bot2[\$j_right]}
								 if [ $v_right_bot != '-' ]; then 
	 								 posX_ok+="$j_right |" 
								 fi
							fi
						fi
					fi;;	
				*)
					;;
			esac
		done
	fi
	local nb_posO=$(echo $posO | grep -o '|' | wc -l)

        local coordO=''
        local figO=''
        local ligO=''
        local colO=''
        local posO_ok=''
        if [ $nb_posO -ne 0 ]; then 
                for (( z=1; z<=$nb_posO; z++ )); do
                        coordO=$(echo $posO | cut -d '|' -f $z)
                        figO=$(echo $figureO | cut -d '|' -f $z)
                        ligO=$(echo $coordO | cut -d ' ' -f 1)
                        colO=$(echo $coordO | cut -d ' ' -f 2)

                        local coordO_ok=""
                        case $figO in
                                "Lig ")
                                        if [ $colO -ne 1 ]; then
                                                #check gauche de la ligne
                                                j_left=$(($colO-1))
                                                eval local v_left=\${lig$ligO[\$j_left]}
                                                if [ $v_left == '-' ];then 
                                                	if [ $ligO -eq 1 ]; then
                                                   		posO_ok+="$j_left |"
                                                  	else
                                                  		i_bot=$(($ligO-1))
                                                  		eval local v_left_bot=\${lig$i_bot[\$j_left]}
                                                  		if [ $v_left_bot != '-' ]; then 
                                                           		posO_ok+="$j_left |"
                                                  		fi
                                                  	fi
                                                fi
                                        fi
                                        if [ $colO -lt 5 ]; then
                                                #check droite de la ligne
                                                j_right=$(($colO+3))
                                                eval local v_right=\${lig$ligO[\$j_right]}
                                                if [ $v_right == '-' ];then 
                                                	if [ $ligO -eq 1 ]; then
                                                  		posO_ok+="$j_right |"
                                                  	else
                                                  		i_bot=$(($ligO-1))
                                                  		eval local v_right_bot=\${lig$i_bot[\$j_right]}
                                                  		if [ $v_right_bot != '-' ]; then 
                                                           		posO_ok+="$j_right |"
                                                  		fi
                                                  	fi
                                                fi
                                        fi;;
                                "Col ")
                                        if [ $ligO -lt 4 ]; then
                                                #check haut de la col
                                                i_hi=$(($ligO+3))
                                                eval local v_hi=\${lig$i_hi[\$colO]}
                                                if [ $v_hi == '-' ];then 
                                                	posO_ok+="$colO |"
                                                fi
                                        fi;;
                                "DiagoM ")
                                        if [ $ligO -ne 1 ] && [ $colO -ne 1 ]; then 
                                                #check gauche de la diago
                                                j_left=$(($colO-1))
                                                i_bot=$(($ligO-1))
                                                eval local v_left=\${lig$i_bot[\$j_left]}
                                                if [ $v_left == '-' ];then 
                                                  	if [ $ligO -eq 2 ]; then
                                                   		posO_ok+="$j_left |"
                                                  	else
                                                  		i_bot2=$(($ligO-2))
                                                  		eval local v_left_bot=\${lig$i_bot2[\$j_left]}
                                                  		if [ $v_left_bot != '-' ]; then 
                                                           		posO_ok+="$j_left |"
                                                  		fi
                                                  	fi
                                                fi
                                        fi
                                        if [ $ligO -lt 4 ] && [ $colO -lt 5 ]; then 
                                                #check droite de la diago
                                                j_right=$(($colO+3))
                                                i_hi=$(($ligO+3))
                                                eval local v_right=\${lig$i_hi[\$j_right]}
                                                if [ $v_right == '-' ];then 
                                                  	i_bot=$(($i_hi-1))
                                                  	eval local v_right_bot=\${lig$i_bot[\$j_right]}
                                                  	if [ $v_right_bot != '-' ]; then 
                                                        	posO_ok+="$j_right |"
                                                  	fi
                                                fi
                                        fi;;
                                "DiagoD ")
                                        if [ $ligO -lt 4 ] && [ $colO -ne 1 ]; then 
                                                #check gauche de la diago
                                                j_left=$(($colO-1))
                                                i_hi=$(($ligO+3))
                                                eval local v_left=\${lig$i_hi[\$j_left]}
                                                if [ $v_left == '-' ];then 
                                                  	i_bot=$(($i_hi-1))
                                                  	eval local v_left_bot=\${lig$i_bot[\$j_left]}
                                                  	if [ $v_left_bot != '-' ]; then 
                                                        	posO_ok+="$j_left |"
                                                  	fi
                                                fi
                                        fi
                                        if [ $ligO -ne 1 ] && [ $colO -lt 5 ]; then 
                                                #check droite de la diago
                                                j_right=$(($colO+3))
                                                i_bot=$(($ligO-1))
                                                eval local v_right=\${lig$i_bot[\$j_right]}
                                                if [ $v_right == '-' ];then 
                                                  	if [ $ligO -eq 2 ]; then
                                                   		posO_ok+="$j_right |"
                                                   	else
                                                   		i_bot2=$(($ligO-2))
                                                   		eval local v_right_bot=\${lig$i_bot2[\$j_right]}
                                                   		if [ $v_right_bot != '-' ]; then 
                                                   			posO_ok+="$j_right |"
                                                  		fi
                                                  	fi
                                                fi
                                        fi;;
                                *)
                                        ;;
                        esac
                done
        fi
#        echo posO: $posO_ok posX: $posX_ok

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

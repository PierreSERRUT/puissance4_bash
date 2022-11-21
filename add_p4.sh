#!/usr/bin/env bash

#renvoi 1 si la colonne est déjà rempli
add()
{
	i=1
	local place=0
	if [ $1 -gt 7 ]; then return 1; fi
	until [[ $i -eq 7  ||  $place -eq 1 ]]; do
		eval var=\${lig$i[\$1]}
		if [ $var == '-' ]; then	
			eval lig$i[\$1]=$2
			place=1
		fi
		((i+=1))
	done
	if [ $place -eq 1 ];then return 0; 
	else return 1; fi
}

add_comp_easy()
{
	
	local rand=$((1 + $RANDOM %7))
	local ret=0
	add $rand $1
        ret=$?
        while [ $ret -eq 1 ]; do 
	 	rand=$((1 + $RANDOM %7))
		add $rand $1
                ret=$?
	done
	echo "Colonne sélectionné par l'ordianteur: $rand"
}

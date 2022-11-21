#!/usr/bin/env bash

#renvoi le numéro de joueur s'il a gagné; 0 autrement
validate_win()
{
	local win=0
	for i in {1..6}; do
		for j in {1..7}; do
			local i1=$(($i+1))
			local i2=$(($i+2))
			local i3=$(($i+3))
			local j1=$(($j+1))
			local j2=$(($j+2))
			local j3=$(($j+3))

			eval local vxy=\${lig$i[\$j]}
			if [ $j -le 4 ]; then 
				eval local vxy1=\${lig$i[\$j1]}
				eval local vxy2=\${lig$i[\$j2]}
				eval local vxy3=\${lig$i[\$j3]}
				if [[ $vxy == $vxy1 && $vxy == $vxy2 && $vxy == $vxy3 && $vxy != '-' ]]
				then
					echo "Ligne en [$i;$j]"
					win=$vxy
				fi
			fi
			if [ $i -le 3 ]; then
				eval local vx1y=\${lig$i1[\$j]}
				eval local vx2y=\${lig$i2[\$j]}
				eval local vx3y=\${lig$i3[\$j]}
				if [[ $vxy == $vx1y && $vxy == $vx2y && $vxy == $vx3y && $vxy != '-' ]]
				then
					echo "Colonne en [$i;$j]"
					win=$vxy
				fi
			fi
			if [[ $i -le 3 && $j -le 4 ]]; then
				eval local vx1y1=\${lig$i1[\$j1]}
				eval local vx2y2=\${lig$i2[\$j2]}
				eval local vx3y3=\${lig$i3[\$j3]}
				if [[ $vxy == $vx1y1 && $vxy == $vx2y2 && $vxy == $vx3y3 && $vxy != '-' ]]
				then
					echo "Diago montante en [$i;$j]"
					win=$vxy
				fi
				eval local vx2y1=\${lig$i2[\$j1]}
				eval local vx1y2=\${lig$i1[\$j2]}
				if [[ $vx3y == $vx2y1 && $vx3y == $vx1y2 && $vx3y == $vxy3 && $vx3y != '-' ]]
				then
					echo "Diago descendante en [$i3;$j]"
					win=$vxy
				fi
			fi
		done
	done
if [ $win == 'X' ]; then return 1
else if [ $win == 'O' ]; then return 2
fi
fi
}

check_draw()
{
	win=0
	for j in {1..7}; do
		eval local v6y=\${lig6[\j]}
		if [ $v6y == '-' ]; then return 0
		fi
	done
	return 1
}

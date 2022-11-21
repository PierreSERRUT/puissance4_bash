#!/usr/bin/env bash

init()
{
	for i in {1..6}; do
		for j in {1..7}; do
			eval lig$i[\$j]='-'
		done
	done
}

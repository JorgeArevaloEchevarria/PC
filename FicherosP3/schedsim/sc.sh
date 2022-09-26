#!/bin/bash
make clean
make
clear
echo "------Simulacion practica 3-------"

	if test -d resultados; then
		rm -rf ./resultados
	fi

mkdir resultados

echo "Nombre del fichero:"
read fichero
	
	while ! [ -e "examples/$fichero" ]; do
		echo "No existe el fichero"
		read fichero
	done

echo "Numero de CPUs"
read nCPU

while [ $nCPU -gt 8 ] || [ $nCPU -lt 1 ]; do
	echo "No puede ser mayor que 8 ni menor que 1"
	read nCPU
done

read -p "¿Quieres empezar la simulacion? (RR)"

mkdir resultados/RR
cd resultados/RR
../../schedsim -i ../../examples/$ficheros -n $nCPU -p

cd ../../../gantt-gplot

cont=0
while [ $cont -lt $nCPU ]; do
	./generate_gantt_chart ../schedsim/resultados/RR/CPU_$cont.log
	let cont++
done
cd ../schedsim
read -p "¿Pasar a la siguiente simulacion? (SJF)"

#########################################################################

mkdir resultados/SJF
cd resultados/SJF
../../schedsim -i ../../examples/$fichero -n $nCPU -p

cd ../../../gantt-gplot

cont=0
while [ $cont -lt $nCPU ]; do
	./generate_gantt_chart ../schedsim/resultados/SJF/CPU_$cont.log
      let cont++
    done
cd ../schedsim
read -p "¿Pasar a la siguiente simulacion (FCFS)?"

#######################################################################

mkdir resultados/FCFS
cd resultados/FCFS
../../schedsim -i ../../examples/$fichero -n $nCPU -p

cd ../../../gantt-gplot

cont=0
while [ $cont -lt $nCPU ]; do
	./generate_gantt_chart ../schedsim/resultados/FCFS/CPU_$cont.log
      let cont++
    done
cd ../schedsim
read -p "¿Pasar a la siguiente simulacion? (PRIO)"

#####################################################################

mkdir resultados/PRIO
 cd resultados/PRIO
../../schedsim -i ../../examples/$fichero -n $nCPU -p

cd ../../../gantt-gplot

cont=0
while [ $cont -lt $nCPU ]; do
    ./generate_gantt_chart ../schedsim/resultados/PRIO/CPU_$cont.log
   let cont++
  done
cd ../schedsim
read -p "Simulacion Terminada"
clear







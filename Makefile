.SUFFIXES: .f90 .o
.SECONDARY: $(OBJU)

.PHONY: all

STM = helloWorld
SRC = ${STM:=.cpp}
OBJ = ${STM:=.o}
EXE = ${STM}
MKR  = g++

RPT = -fopt-info-vec-missed
OPT = -g -O3 -fopenmp -ftree-vectorize  -ffast-math -march=native -fopenmp-simd

.cpp.o:
	${MKR} ${OPT} ${RPT} -c $< -o $@

all: ${EXE}  

${EXE}: ${OBJ}
	${MKR} ${OPT} ${RPT} -o $@ ${OBJ}

run-cycles: ${EXE} 
	time hpcrun -e cycles -o ${EXE}-cycles ./${EXE}
	hpcstruct ${EXE}
	hpcprof -S ${EXE}.hpcstruct -o ${EXE}-cycles-database ${EXE}-cycles

run-time: ${EXE} 
	time hpcrun -e REALTIME -o ${EXE}-REALTIME ./${EXE}
	hpcstruct helloWorld
	hpcprof -S ${EXE}.hpcstruct -o ${EXE}-REALTIME-database ${EXE}-REALTIME
	hpcviewer ${EXE}-REALTIME-database

clean:
	/bin/rm -rf helloWorld helloWorld-* helloWorld.hpcstruct

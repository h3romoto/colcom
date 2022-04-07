#!/bin/bash
# test fire on cluster and cleanup after cluster-set test
# to execute:  hd-cluster should execute
# git clone https://github.com/HVKHCM/CURI2021-Raspberry-Pi.git ctest; ctest/firec.sh

# test fire with cluster
echo "Testing fire example with cluster"
cd ~/CSinParallel/Exemplars/mpi4py-examples/fire/
mpirun -np 4 -hostfile ~/hostfile python fire_mpi_simulate.py 10 0.1 20

cd ~
rm -rf CSinParallel/Patternlets/MPI/00.spmd/spmd hostfile .openmpi/mca-params.conf ctest stest


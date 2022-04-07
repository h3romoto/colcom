#!/bin/bash
# fix some head node files - pi should execute
# git clone https://github.com/HVKHCM/CURI2021-Raspberry-Pi.git ctest; ctest/fix.sh

# remove cluster_nodes files
sudo find CSinParallel /hd-cluster/CSinParallel /etc/skel/CSinParallel -name cluster_nodes -exec rm {} \;

# update fire cluster example
cp ~/ctest/fire_mpi_simulate.py ~/CSinParallel/Exemplars/mpi4py-examples/fire/
sudo -u hd-cluster cp ~/ctest/fire_mpi_simulate.py /hd-cluster/CSinParallel/Exemplars/mpi4py-examples/fire/
sudo cp ~/ctest/fire_mpi_simulate.py /etc/skel/CSinParallel/Exemplars/mpi4py-examples/fire/

rm -rf ctest

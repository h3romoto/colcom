#!/bin/bash

cd ~/stest
(cd .. ; tar cf - CSinParallel) | sudo tar xf - || {
    echo "ERROR! couldn't duplicate CSinParallel, aborting" ; exit 1 ; }

#Create a log for output of testing
source test.sh > log.txt 2>&1

#Checking the manifest
#If nothing show up, it means it fit the manifest
diff -b log.txt manifest.txt || {
    echo "ERROR! - log.txt isn't right, exiting early" ; exit 1; }
rm log.txt
rm manifest.txt

#Checking the patternlets
source patterntest.sh

#Check fire with graphics
cd ~/stest/CSinParallel/Exemplars/mpi4py-examples/fire
python fire_sequential_once.py 24 0.4   # should show graph

#checking wifi
ping -c 5 8.8.8.8 || { echo "ERROR!  wifi test failed, aborting" ; exit 1; }

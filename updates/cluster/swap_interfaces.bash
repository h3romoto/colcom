#!/bin/bash

# By Tanaka Khondowe
# This script changes the networking for the eth0 and eth1 interfaces
# such that eth0 is assigned the 172.27.1.0/24, the cluster-facing interface
# and eth1 is assigned the 172.27.0.0/24 network, the laptop-connection interface.

source /usr/HD/soc-state

PROG=`basename $0`

USAGE=$(echo -e "Usage:  $PROG -n [head | worker] -c [eth0 | eth1] \n\
Example:   $PROG -n head -c eth0")

function Help () {
echo -e "\nThis program sets up this cluster node to use specified cluster and laptop-facing interfaces.\n\
User also has to define what kind of node they are running the script on.\n\
Cluster interface can either be 'eth0' or 'eth1' and nodes can only be 'head' or 'worker'"

      echo " "
      echo "options:"
      echo "-n       specify this node's type - head or worker"
      echo "-c       specify the cluster-facing interface"
      echo  " "
      echo -e "Usage:  $PROG -n [head | worker] -c [eth0 | eth1] \n\
Example:   sudo ./$PROG -n head -c eth0"
echo " "

}


# Get arguments
while getopts n:c:h flag
do
        case "${flag}" in
                n) node_type=${OPTARG}
                        ;;
                c) cluster_interface=${OPTARG}
                         ;;
                h) Help
                        ;;
                *) Help
                        ;;
        esac
done


function do_the_swapping() {
        #Remove the interfaces
        sed -i '/interface eth*/d' /etc/dhcpcd.conf


        echo "SETTING UP YOUR INTERFACES"

        #Add them in the right places
        sed -i '/^metric 301/i interface eth0' /etc/dhcpcd.conf
        sed -i '/^metric 302/i interface eth1' /etc/dhcpcd.conf
        echo "APPLYING CHANGES..."


        # For the worker nodes only. Tell dhcp server to serve requests on eth1 instead of eth0
        if [ $node_type=="worker" ]
        then
                sed -i 's/INTERFACESv4="eth0"/INTERFACESv4="eth1"/g' /etc/default/isc-dhcp-server
        fi

        # Only accept dhcp packets from the head-node (172.27.1.2/24)
        dhcpcd --whitelist 172.27.1.2/24

        dhcpcd --rebind eth0
        dhcpcd --rebind eth1

        # For changes made to the dhcp service
        systemctl daemon-reload

        echo "DONE!"

}


function check_args() {
        if [[( -z $node_type || -z $cluster_interface)]]
        then
                Help
        else
                echo -e "\nDefault interface settings:\n\
                        LAPTOP=eth0\n\
                        CLUSTER=eth1\n"

                echo -e "You indicated that this node is a ${node_type} node\n"

                if [ "$cluster_interface" == "eth0" ]
                then
                        echo -e "Here is the new network configuration:\nCLUSTER=$cluster_interface\nLAPTOP=eth1"
                        echo -e "CLUSTER=$cluster_interface\nLAPTOP=eth1" > /usr/HD/soc-state
                elif [ "$cluster_interface" == "eth1" ]
                then
                        echo -e "CLUSTER=$cluster_interface\nLAPTOP=eth0" > /usr/HD/soc-state
                        echo -e "You have restored the default network configuration.\n"
                else
                        Help
                fi
        fi
}


if [ "$EUID" -ne 0 ]
then
        echo -e "Please run as sudo\n"
        exit 1
else
        check_args
        do_the_swapping
        exit
fi

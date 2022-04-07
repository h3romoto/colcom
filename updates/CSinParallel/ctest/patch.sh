# patch for virtual 21 image

sudo head-node

# upgrade numpy
pip install --upgrade numpy
sudo su - hd-cluster <<EOF 
pip install --upgrade numpy
EOF

# fix /usr/HD, add xhost +
echo Issuing xhost +
cd /usr/HD
sudo bash <<EOF
chmod 755 .
cp head-node.bash head-node.bash.bu
awk 'NR==123 {print "    xhost +"} {print}' head-node.bash.bu > head-node.bash
chmod +x head-node.bash
EOF

#!/usr/bin/env bash

# This downloads ruby from source, installs rails, installs ngnix, and configures everything to work together.
echo "+----------------------------------------------------+"
echo "|     Sets up a P2P mining node for you locally!     |"
echo "|                                                    |"
echo "|                                                    |"
echo "| Sit back, grab a cup of tea, and relax as I take   |"
echo "| care of everything for you while you are watch in  |"
echo "| awe at the minutes of setting up and confusion are |"
echo "| shortened to mere minutes!                         |"
echo "|                                                    |"
echo "+----------------------------------------------------+"

rpc_username=cooluser
rpc_password=superduperpassword12

# When the script gets provisioned on a vagrant box, the current home directory is root,
# which is not what we want. So, if the vagrant option is put in from the vagrantfile then
# this will be installed into /home/vagrant instead of /vagrant/root.
if [[ $1 == "vagrant" ]]; then
    working_directory="/home/vagrant"
    log_location="$working_directory/dogecoin_p2p_node.log"
else
    working_directory="$HOME"
    log_location="$working_directory/dogecoin_p2p_node.log"
fi

# Make the logging file
    echo "  [1/6] Making log file"
	mkdir -p $working_directory
	touch $log_location &>>/dev/null

# Install all the required requisists
    echo "  [2/6] Installing dependencies"
    echo "----FROM SCRIPT ECHO---- Installing dependencies" &>>$log_location

	    echo "    |- [1/4] Adding bitcoin PPA"
	    echo "----FROM SCRIPT ECHO---- Adding bitcoin PPA" &>>$log_location
		sudo add-apt-repository ppa:bitcoin/bitcoin &>>$log_location

		echo "    |- [2/4] Updating and upgrading Ubuntu"
		echo "----FROM SCRIPT ECHO---- Updating and upgrading Ubuntu" &>>$log_location
		sudo apt-get update &>>$log_location
		sudo apt-get upgrade &>>$log_location

		echo "    |- [3/4] Tools to build dogecoin"
		echo "----FROM SCRIPT ECHO---- Installing tools to build dogecoin" &>>$log_location
		sudo apt-get -y install git build-essential libssl-dev libdb4.8-dev libdb4.8++-dev libboost1.49-all-dev &>>$log_location

		echo "    \- [4/4] Python for the web interface and p2p pool"
		echo "----FROM SCRIPT ECHO---- Installing Python for the web interface and p2p pool" &>>$log_location
		sudo apt-get -y install python-software-properties &>>$log_location
		sudo apt-get -y install python-zope.interface python-twisted python-twisted-web &>>$log_location

# Get the dogecoin client from github.
    echo "  [3/6] Installing the dogecoin client"
    echo "----FROM SCRIPT ECHO---- Installing the dogecoin client" &>>$log_location

		echo "    |- [1/4] Cloning dogecoin repo"
	    echo "----FROM SCRIPT ECHO---- Cloning dogecoin repo" &>>$log_location
	    cd $working_directory
	    git clone https://github.com/dogecoin/dogecoin $working_directory/dogecoin &>>$log_location

		# Changes the swapfile from the standard 512MB to 1GB for dogecoin installation if less than
		# 1GB of ram is found. If there is less than 1 GB of ram on the system then you get the
		# following error.            make: *** [obj/alert.o] Error 4
	    memory_size_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}'  )
	    if [ $memory_size_KB -lt 1048576 ]; then
	        echo "    |- [2/5] Changing swap file size to 1 GB"
	        echo "----FROM SCRIPT ECHO---- Changing swap file size to 1 GB" &>>$log_location
	        dd if=/dev/zero of=/swap bs=1M count=1024 &>>$log_location
	        mkswap /swap &>>$log_location
	        swapon /swap &>>$log_location
	    else
	        echo "    |- [2/5] Not changing swap file size to 1 GB"
	        echo "----FROM SCRIPT ECHO---- Not changing swap file size to 1 GB" &>>$log_location
	    fi

	    Processor_Count=`grep -c ^processor /proc/cpuinfo`
	    echo "    |- [3/6] Running make on $Processor_Count core(s). (This takes a while)"
	    echo "----FROM SCRIPT ECHO---- Running make on $Processor_Count core(s). (This takes a while)" &>>$log_location
	    cd $working_directory/dogecoin/src &>>$log_location
	    make -j $Processor_Count -f makefile.unix USE_UPNP=- &>>$log_location

	    echo "    \- [4/5] Moving dogecoin"
	    echo "----FROM SCRIPT ECHO---- Moving dogecoin" &>>$log_location
	    mv $working_directory/dogecoin/src/dogecoind  $working_directory/dogecoind &>>$log_location

	    echo "    \- [5/5] Cleaning up after myself"
	    echo "----FROM SCRIPT ECHO---- Cleaning up after myself" &>>$log_location
	    rm -r -f $working_directory/dogecoin &>>$log_location

# Configuring dogecoin client
    echo "  [4/6] Configuring dogecoin client"
    echo "----FROM SCRIPT ECHO---- Configuring dogecoin client" &>>$log_location
    mkdir $working_directory/.dogecoin &>>$log_location
	touch $working_directory/.dogecoin/dogecoin.conf &>>$log_location

	cat <<- _EOF_ >$working_directory/.dogecoin/dogecoin.conf
		rpcuser=$rpc_username
		rpcpassword=$rpc_password
		rpcallowip=127.0.0.1
		addnode=67.205.20.10
		addnode=146.185.181.114
		addnode=95.85.29.144
		addnode=78.46.57.132
		addnode=188.165.19.28
		addnode=162.243.113.110
		rpcport=22555
		port=22556
		server=1
		daemon=1
_EOF_

# Starting dogecoin client
    echo "  [5/6] Running dogecoin client"
    echo "----FROM SCRIPT ECHO---- Running dogecoin client" &>>$log_location

    cd $working_directory
    sudo ./dogecoind

# Installing p2p pool
    echo "  [6/6] Installing P2P pool"
    echo "----FROM SCRIPT ECHO---- Installing P2P pool" &>>$log_location

		echo "    |- [1/2] Cloning P2P pool repo"
	    echo "----FROM SCRIPT ECHO---- Cloning dogecoin repo" &>>$log_location
	    cd $working_directory
	    git clone --recursive https://github.com/blixnood/p2pool &>>$log_location

	    echo "    \- [2/2] Setting up P2P pool"
	    echo "----FROM SCRIPT ECHO---- Setting up P2P pool" &>>$log_location
	    cd $working_directory/p2pool/litecoin_scrypt &>>$log_location
		sudo python setup.py install &>>$log_location

echo "+--------------------  ALL DONE  --------------------+"
echo ""
echo "----FROM SCRIPT ECHO---- ALL DONE!!!!" &>>$log_location

# Done for the most part, now just need to wait for the dogecoin client to sync.
echo "Below is the current amount of the blocks your client has synced up to."
echo "You need to wait till this gets to the same number as blocks in chain on"
echo "dogechain.info"
cd $working_directory
./dogecoind getinfo | grep "blocks"
echo ""

echo "Run to see what you are up to: ./dogecoind getinfo | grep blocks"
echo "This make take a few solid hours, so ... yeah. Go browse"
echo "/r/dogecoin in the meantime!"
echo ""

echo "Once this finishes, run the following: "
echo "screen -d -m -S myp2pool sudo ~/p2pool/run_p2pool.py --give-author 0 --net dogecoin $rpc_username $rpc_password"
echo "And the following to see what is up: screen -x myp2pool"
echo ""

echo "Your HW error rate will be massive for the first few minutes"
echo "since the pool is adjusting its difficulty. Do not fret, for"
echo "all you need to do is restart your miner after a few minutes"
echo "and all will be splendid!"
echo ""

echo "To find out when you will start getting paid out, use this"
echo "tool: http://www.nckpnny.com/sharecalc/"

Current_IP=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
miner_target=$Current_IP
miner_target+=":22550"
echo "Point your miner at: $miner_target"
echo "Node web GUI: $miner_target"

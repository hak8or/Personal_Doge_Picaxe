#!/usr/bin/env bash
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
rpc_password=$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo)

# Where the majority of this script will be run.
working_directory="$HOME"
log_location="$working_directory/dogecoin_p2p_node.log"

# Make the logging file
    echo "  [1/8] Making log file"
	mkdir -p $working_directory
	touch $log_location &>>/dev/null

# Install all the required requisists
    echo "  [2/8] Installing dependencies"
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
    echo "  [3/8] Installing the dogecoin client"
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
	        sudo dd if=/dev/zero of=/swap bs=1M count=1024 &>>$log_location
	        sudo mkswap /swap &>>$log_location
	        sudo swapon /swap &>>$log_location
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
    echo "  [4/8] Configuring dogecoin client"
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

# Download bootstrap.dat to speed up initial blockchain sync.
    echo "  [5/8] Downloading bootstrap.dat (1GB ish)"
    echo "----FROM SCRIPT ECHO---- Downloading bootstrap.dat" &>>$log_location
	
	cd $working_directory
    wget http://smibacdn.nl/smiba/doge/bootstrap.dat &>>/dev/null
    mv bootstrap.dat $working_directory/.dogecoin/

# Starting dogecoin client
    echo "  [6/8] Running dogecoin client"
    echo "----FROM SCRIPT ECHO---- Running dogecoin client" &>>$log_location

    cd $working_directory
    sudo ./dogecoind

# Installing p2p pool
    echo "  [7/8] Installing P2P pool"
    echo "----FROM SCRIPT ECHO---- Installing P2P pool" &>>$log_location

		echo "    |- [1/2] Cloning P2P pool repo"
	    echo "----FROM SCRIPT ECHO---- Cloning dogecoin repo" &>>$log_location
	    cd $working_directory
	    git clone --recursive https://github.com/blixnood/p2pool &>>$log_location

	    echo "    \- [2/2] Setting up P2P pool"
	    echo "----FROM SCRIPT ECHO---- Setting up P2P pool" &>>$log_location
	    cd $working_directory/p2pool/litecoin_scrypt &>>$log_location
		sudo python setup.py install &>>$log_location

# Generate a startup script for when user wants to easily start everything up.
# Mainly to get around the super long p2p pool setup command.
	echo "  [8/8] Generate startup script"
    echo "----FROM SCRIPT ECHO---- Generate startup script" &>>$log_location

    cd $working_directory &>>$log_location
	touch $working_directory/startup.sh &>>$log_location

	cat <<- _EOF_ >$working_directory/startup.sh
		#!/usr/bin/env bash
		cd $working_directory
    	sudo ./dogecoind

		screen -d -m -S myp2pool sudo ~/p2pool/run_p2pool.py --give-author 0 --net dogecoin --bitcoind-address 127.0.0.1 --bitcoind-p2p-port 22556 --bitcoind-rpc-port 22555 --worker-port 22550 $rpc_username $rpc_password

		echo "RPC Username: $rpc_username"
		echo "RPC Password: $rpc_password"

		echo "To view p2p pool output, use the following:"
		echo "  screen -x myp2pool"
_EOF_

	sudo chmod 777 startup.sh

# Set up starting conditions for the later loop of polling block size.
	client_block_count=0
	dogechain_info_block_count=1

# Done for the most part, now just need to wait for the dogecoin client to sync.
echo "----FROM SCRIPT ECHO---- Waiting for blockchain to finish syncing." &>>$log_location
echo "+----------------------------------------------------+"
echo "|                                                    |"
echo "|  And now we wait, since the Dogecoin client must   |"
echo "|  sync with the blockchain. This make take a few    |"
echo "|  solid hours, so ... yeah. Go browse /r/dogecoin   |"
echo "|  in the meantime!                                  |"
echo "|                                                    |"
	
# Keep refreshing this display and check every two minutes so we can know
# the blockchain is fully synced. Greater or equal to is because the dogechain
# wallet is not always fully up to date.
until [[ $client_block_count -ge $dogechain_info_block_count ]]; do
	cd $working_directory

	# Get a new block count.
	wget -O dogechain_block.txt -P $working_directory http://dogechain.info/chain/Dogecoin/q/getblockcount &>>$log_location

	# Throw that block count into a bash variable for comparing.
	dogechain_info_block_count=$(cat $working_directory/dogechain_block.txt)

	# Delete the old block count file from dogechain.info
	rm $working_directory/dogechain_block.txt

	# Get the current block count we are synced up to and clean up the output
	# so we only get the number.
	cd $working_directory
	client_block_count=$(./dogecoind getinfo | grep "blocks")
	client_block_count=${client_block_count:15:-1}

	# Overwrite the previous line in the terminal so user can see how far 
	# the syncing process is so far.
	echo -en "|  Your current block progress: $client_block_count of $dogechain_info_block_count \r"

	# Delay two minutes so we do not pummel the dogechain.info API.
	sleep 2m
done

# Show that blockchain finished syncing.
echo "|  Done syncing blockchain!                          |"

# Start the P2P pool so users can connect their miners.
screen -d -m -S myp2pool sudo ~/p2pool/run_p2pool.py --give-author 0 --net dogecoin --bitcoind-address 127.0.0.1 --bitcoind-p2p-port 22556 --bitcoind-rpc-port 22555 --worker-port 22550 $rpc_username $rpc_password

miner_target=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
miner_target+=":22550"

echo "+--------------------  ALL DONE  --------------------+"
echo "|                                                    |"
echo "|  RPC Username: $rpc_username                            |"
echo "|  RPC Password: $rpc_password      |"
echo "|  Status of p2p pool: screen -x myp2pool            |"
echo "|                                                    |"
echo "|  Point your miner at: $miner_target              |"
echo "|  Node web GUI: $miner_target                     |"
echo "+----------------------------------------------------+"

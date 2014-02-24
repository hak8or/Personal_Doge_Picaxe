#!/usr/bin/env bash

# This script checks to see if both P2P pool is still running correctly and the dogecoin client.
# Based on user reports, it seems that the issue is on the p2p end, with the most prominant symptom
# being that the web page is not responsive.

# First checks to see if the p2p pool node's web service is giving us an HTTP 200 code.
node_frontend_code=$(curl -sL -w "%{http_code}\\n" "127.0.0.1:22550" -o /dev/null)

# If the front end is down, restart both the dogecoin client and the node.
if [[ $node_frontend_code -ne 200 ]]; then
	echo "---- Node front end failure detected!" >> /var/log/p2p_health.log
	echo "Time: $(date)" >> /var/log/p2p_health.log

	# pkill shouldn't implode if dogecoind process does not exist.
	echo "Shutting down dogecoin client." >> /var/log/p2p_health.log
	sudo pkill -KILL dogecoind &>> /var/log/p2p_health.log

	# Same as above, but for the node.
	# This kills all running python processes, not ideal in the least, but assuming this is a vagrant box
	# setup by me, all should be fine.
	echo "Shutting down P2P Pool node." >> /var/log/p2p_health.log
	sudo pkill -KILL python &>> /var/log/p2p_health.log

	echo "Restarting dogecoind and p2p pool now!" >> /var/log/p2p_health.log
	./startup.sh &>> /var/log/p2p_health.log

	# Put in an extra line into the log file.
	echo "" >> /var/log/p2p_health.log
fi
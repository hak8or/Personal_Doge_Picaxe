#!/usr/bin/env bash

# This script checks to see if both P2P pool is still running correctly and the dogecoin client.
# Based on user reports, it seems that the issue is on the p2p end, with the most prominant symptom
# being that the web page is not responsive.

# First checks to see if the p2p pool node's web service is giving us an HTTP 200 code.
$node_frontend_code = curl -sL -w "%{http_code}\\n" "127.0.0.1:22550" -o /dev/null

# If the front end is down, restart both the dogecoin client and the node.
if [[ $node_frontend_code -ne 200 ]]; then
	echo "Node front end failure detected!"

	# pkill shouldn't implode if dogecoind process does not exist.
	echo "Shutting down dogecoin client."
	sudo pkill -KILL dogecoind

	# Same as above, but for the node.
	# This kills all running python processes, not ideal in the least, but assuming this is a vagrant box
	# setup by me, all should be fine.
	echo "Shutting down P2P Pool node."
	sudo pkill -KILL python

	echo "Restarting dogecoind and p2p pool now!"
	sudo ./startup.sh
fi
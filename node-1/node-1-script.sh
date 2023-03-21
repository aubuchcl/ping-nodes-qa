#!/bin/bash
trap "exit" SIGINT SIGTERM
echo "pid is $$"
# The address to ping
ADDRESS="_env-discovery"

# The number of times to try pinging the address
MAX_TRIES=5

# Keep track of the number of failed pings
failed_pings=0


# Loop until we reach the maximum number of tries or until we succeed
while [ "$failed_pings" -lt "$MAX_TRIES" ]
do
  echo "PRINTING RESOLV.CONF CONTENTS" 
  cat /etc/resolv.conf
  echo "### end resolv.conf ###"
  # Ping the address and capture the output
  ping_output=$(ping -c 1 "$ADDRESS")

  # Check if the ping was successful
  if [ $? -eq 0 ]
  then
    # The ping was successful, so we can exit the loop
    break
  fi

  # The ping failed, so increment the failed pings count
  failed_pings=$((failed_pings + 1))

  # Wait for a second before trying again
  sleep 1
done

# Check if the loop was exited because we succeeded or because we reached the maximum number of tries
if [ "$failed_pings" -ge "$MAX_TRIES" ]
then
  # The maximum number of tries was reached, so exit with an error code
  exit 1
else
  # The ping was successful, so exit with a success code
  echo "discovery was pingable, quick pause then moving on" 
  sleep 10
fi

# Keep track of attempts to hit node 1
connect_to_node_2=0

MAX_NODE_2_TRIES=5

N2_ADDRESS="_nodetwo"

while [ "$connect_to_node_2" -lt "$MAX_NODE_2_TRIES"]
do 
  echo "Attempting to connect to node 1" 
  ping_n1_output=$(ping -c 1 "$N2_ADDRESS")
  
  # Check if the ping was successful
  if [ $? -eq 0 ]
  then
    # The ping was successful, so we can exit the loop
    break
  fi
  
  # The ping failed, so increment the failed pings count
  connect_to_node_2=$((connect_to_node_2 + 1))

  sleep 1
done

if [ "$failed_pings" -ge "$MAX_TRIES" ]
then
  # The maximum number of tries was reached, so exit with an error code
  echo "Failed to reach node 1 exiting"
  exit 1
else
  # The ping was successful, so exit with a success code
  echo "Node 1 is reachable moving on to see if the other instances are reachable" 
fi

while :
do
	ping6 -c 2  "$N2_ADDRESS"
  sleep 3
done






























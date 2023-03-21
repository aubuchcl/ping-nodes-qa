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
  continue
fi


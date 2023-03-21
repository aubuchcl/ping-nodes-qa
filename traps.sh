#!/bin/bash

trap "exit" SIGINT SIGTERM
echo "pid is $$"

while :
do
	ping6 -c 3  _env-discovery
done

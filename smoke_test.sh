#!/usr/bin/env bash

set -e
IMAGE=${IMAGE:-mongooseim}

echo "Start MongooseIM container"
docker rm -f mongooseim-smoke
docker run --name=mongooseim-smoke -e JOIN_CLUSTER=false -e BOOTSTRAP_ENABLED=true -d mongooseim

CTL="docker exec mongooseim-smoke mongooseimctl"

echo "Wait for Mongooseim to get started"
$CTL started

echo "Checking status via 'mongooseimctl status'"
$CTL status

echo "Trying to register a user"
$CTL account registerUser --domain localhost --password a_password

echo "Check if bootstap script works"
docker logs mongooseim-smoke | grep "Hello from"

echo "Stop and remove mongooseim-smoke container"
docker rm -f mongooseim-smoke


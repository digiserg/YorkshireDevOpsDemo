#!/bin/bash

export K3S_VERSION=v1.26.13-rc2-k3s1
#export K3S_TOKEN=${RANDOM}${RANDOM}${RANDOM}
export K3S_TOKEN=265941111626893

docker-compose up

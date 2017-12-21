#!/bin/bash

CMD="appium"
if [ ! -z "$CONNECT_TO_GRID" ]; then
  NODE_CONFIG_JSON="/root/src/nodeconfig.json"
  /root/generate_config.sh $NODE_CONFIG_JSON
  CMD+=" --nodeconfig $NODE_CONFIG_JSON"
fi
$CMD


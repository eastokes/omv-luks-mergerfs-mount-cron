#!/bin/bash

declare -a arrMounts

for file in /etc/systemd/system/*.mount
do
  arrMounts=(${arrMounts[*]} "$file")
done

for item in "${arrMounts[@]}"
do
  if [ -n "$(systemctl status ${item#"/etc/systemd/system/"} | grep inactive)" ]; then
    systemctl start ${item#"/etc/systemd/system/"}
    DOCKER_RESTART="${DOCKER_RESTART:-true}"
  fi
done

if [ "$DOCKER_RESTART" = true ]; then
  docker restart $(docker ps -a -q)
fi

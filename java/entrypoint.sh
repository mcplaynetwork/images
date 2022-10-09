#!/bin/bash

TZ=${TZ:-JST}
export TZ

INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

cd /home/container || exit 1

printf "\033[1m\033[33mcontainer@mcplaynetwork~ \033[0mjava -version\n"
java -version

if [ -d .git ]; then
git config user.email "${GIT_EMAIL}"
git config user.name "${GIT_NAME}"
printf "\033[1m\033[33mcontainer@mcplaynetwork~ \033[0m.git directory exists\n"
printf "\033[1m\033[33mcontainer@mcplaynetwork~ \033[0mUpdate git upstream\n"
git add .
git commit -m "Upstream update" -m "`git diff --name-only --staged`" -m "Generated on `date +'%Y-%m-%d %H:%M:%S'`"
git push
fi

PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")
printf "\033[1m\033[33mcontainer@mcplaynetwork~ \033[0m%s\n" "$PARSED"
exec env ${PARSED}
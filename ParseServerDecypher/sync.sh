#!/bin/sh
SERVER_IP="52.67.119.16"
rsync -ravzup -e "ssh -i $HOME/parseserver.pem" --exclude "logs" --exclude "node_modules" ParseServer/ ubuntu@$SERVER_IP:/usr/src/apps/ParseServer/
ssh -i ~/parseserver.pem ubuntu@$SERVER_IP "pm2 restart ParseServer"

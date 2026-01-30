#!/bin/bash
cd /home/ec2-user/nodejs-app
nohup npm start > app.log 2>&1 &

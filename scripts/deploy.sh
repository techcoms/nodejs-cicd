#!/bin/bash

EC2_USER=ec2-user
EC2_IP=<EC2_PUBLIC_IP>
APP_DIR=/home/ec2-user/nodejs-app
KEY_PATH=/root/.ssh/ec2-key.pem

echo "Copying files to EC2..."
scp -o StrictHostKeyChecking=no -i $KEY_PATH -r . $EC2_USER@$EC2_IP:$APP_DIR

echo "Restarting Node app..."
ssh -o StrictHostKeyChecking=no -i $KEY_PATH $EC2_USER@$EC2_IP << EOF
  pkill node || true
  cd $APP_DIR
  npm install
  nohup npm start > app.log 2>&1 &
EOF

#!/bin/bash
set -e

APP_DIR=/home/ec2-user/nodejs-app
KEY_PATH=/root/.ssh/ec2-key.pem

echo "Using EC2 IP: $EC2_IP"
echo "Using EC2 User: $EC2_USER"

echo "Copying files to EC2..."
ssh -o StrictHostKeyChecking=no -i $KEY_PATH $EC2_USER@$EC2_IP "mkdir -p $APP_DIR"

scp -o StrictHostKeyChecking=no -i $KEY_PATH -r . \
  $EC2_USER@$EC2_IP:$APP_DIR

echo "Restarting Node.js app..."
ssh -o StrictHostKeyChecking=no -i $KEY_PATH $EC2_USER@$EC2_IP << EOF
  pkill node || true
  cd $APP_DIR
  npm install
  nohup npm start > app.log 2>&1 &
EOF

echo "Deployment completed successfully"

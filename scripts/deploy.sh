#!/bin/bash
set -e

APP_DIR=/home/ec2-user/nodejs-app
KEY_PATH=/root/.ssh/ec2-key.pem

echo "Using EC2 IP: $EC2_IP"
echo "Using EC2 User: $EC2_USER"

# 1️⃣ Create app directory
echo "Creating app directory on EC2..."
ssh -o StrictHostKeyChecking=no -i $KEY_PATH $EC2_USER@$EC2_IP "mkdir -p $APP_DIR"

# 2️⃣ Copy files (EXCLUDE .git)
echo "Copying application files to EC2 (excluding .git)..."
rsync -avz --delete \
  --exclude '.git' \
  --exclude '.gitignore' \
  -e "ssh -o StrictHostKeyChecking=no -i $KEY_PATH" \
  ./ $EC2_USER@$EC2_IP:$APP_DIR/

# 3️⃣ Install Node.js & start app
echo "Deploying application on EC2..."
ssh -o StrictHostKeyChecking=no -i $KEY_PATH $EC2_USER@$EC2_IP << 'EOF'
set -e

APP_DIR=/home/ec2-user/nodejs-app

# Install Node.js if missing
if ! command -v node >/dev/null 2>&1; then
  echo "Node.js not found. Installing Node.js 18..."
  curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
  sudo yum install -y nodejs
else
  echo "Node.js already installed: $(node -v)"
fi

cd $APP_DIR

echo "Installing dependencies..."
npm install

echo "Stopping old Node.js process..."
pkill node || true

echo "Starting Node.js app..."
nohup node app.js > app.log 2>&1 &

sleep 3

echo "Verifying Node process..."
ps -ef | grep node | grep app.js || {
  echo "ERROR: Node app failed to start"
  cat app.log
  exit 1
}

echo "Application started successfully"
EOF

echo "Deployment completed successfully"

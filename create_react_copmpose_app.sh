#!/bin/bash

# Prompt for app name
read -p "Enter the name for your React app (leave blank to use current directory name): " app_name

if [[ -z "${app_name// }" ]]; then
  app_name=${PWD##*/}
fi

# Create React app
npx create-react-app "$app_name"


# Create Dockerfile
cat > Dockerfile << EOL
# Используем базовый образ на основе Alpine Linux 3.17
FROM node:alpine3.17

# install
RUN apk add --no-cache

RUN mkdir /$app_name


WORKDIR /$app_name

EXPOSE 3000

COPY start.sh /start.sh

RUN chmod +x /start.sh


CMD ["/start.sh"]


EOL

# Create docker-compose.yml
cat > docker-compose.yml << EOL
version: "3"
services:
  react:
    build: .
    ports:
      - "3000:3000"
    volumes: # React
      - ./$app_name:/$app_name
EOL

# Create start.sh script
cat > start.sh << EOL
#!/bin/ash

npm install
npm run build
npm start
EOL

chmod +x start.sh

echo "React app '$app_name' created successfully!"
echo "To start the app, run 'docker-compose up -it'

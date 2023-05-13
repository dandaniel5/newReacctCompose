#!/bin/bash

# Prompt for app name
read -p "Enter the name for your React app (leave blank to use current directory name): " app_name

if [[ -z "${app_name// }" ]]; then
  app_name=${PWD##*/}
fi

# Prompt for package manager
read -p "Enter the package manager you want to use (npm/yarn): " package_manager

while [[ "$package_manager" != "npm" && "$package_manager" != "yarn" ]]; do
  read -p "Invalid input. Enter the package manager you want to use (npm/yarn): " package_manager
done

# Prompt for language
read -p "Enter the language you want to use (ts/js): " language

while [[ "$language" != "ts" && "$language" != "js" ]]; do
  read -p "Invalid input. Enter the language you want to use (ts/js): " language
done

# Create React app
if [ "$language" == "ts" ]; then
  if [ "$package_manager" == "npm" ]; then
    npx create-react-app "$app_name" --template typescript
  else
    yarn create react-app "$app_name" --template typescript
  fi
else
  if [ "$package_manager" == "npm" ]; then
    npx create-react-app "$app_name"
  else
    yarn create react-app "$app_name"
  fi
fi


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

if [ "$package_manager" == "npm" ]; then
  npm install
  npm run build
  npm start
else
  yarn install
  yarn build
  yarn start
fi
EOL

chmod +x start.sh

echo "React app '$app_name' created successfully with $package_manager and $language!"
echo "To start the app, run 'docker-compose up'"

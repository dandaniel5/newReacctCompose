#!/bin/bash

# Function to check if a string is web-friendly
is_web_friendly() {
  # Regular expression to match web-friendly names (lowercase letters, numbers, and hyphens)
  local pattern="^[a-z0-9-]+$"
  if [[ $1 =~ $pattern ]]; then
    return 0
  else
    return 1
  fi
}

# Function to convert a string to web-friendly format
to_web_friendly() {
  local input=$1
  local web_friendly=$(echo "$input" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9]/-/g' -e 's/--/-/g')
  echo "$web_friendly"
}

# Prompt for app name
read -p "Enter the name for your React app (leave blank to use current directory name): " app_name

if [[ -z "${app_name// }" ]]; then
  app_name=${PWD##*/}
fi

# Check if app name is web-friendly
while ! is_web_friendly "$app_name"; do
  echo "Invalid app name. App name should only contain lowercase letters, numbers, and hyphens."
  web_friendly_name=$(to_web_friendly "$app_name")
  echo "Web-friendly alternative: $web_friendly_name"
  read -p "Enter a web-friendly name for your React app (or press Enter to use the web-friendly alternative): " new_app_name
  if [[ -z "${new_app_name// }" ]]; then
    app_name=$web_friendly_name
  else
    app_name=$new_app_name
  fi
done

# Prompt for package manager
read -p "Enter the package manager you want to use (npm/yarn) [default: npm]: " package_manager

package_manager=${package_manager:-npm}  # Set default value if input is empty

while [[ "$package_manager" != "npm" && "$package_manager" != "yarn" ]]; do
  read -p "Invalid input. Enter the package manager you want to use (npm/yarn) [default: npm]: " package_manager
  package_manager=${package_manager:-npm}  # Set default value if input is empty
done

# Prompt for language
read -p "Enter the language you want to use (ts/js) [default: js]: " language

language=${language:-js}  # Set default value if input is empty

while [[ "$language" != "ts" && "$language" != "js" ]]; do
  read -p "Invalid input. Enter the language you want to use (ts/js) [default: js]: " language
  language=${language:-js}  # Set default value if input is empty
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

COPY reactStart.sh /reactStart.sh

RUN chmod +x /reactStart.sh


CMD ["/reactStart.sh"]


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

# Create reactStart.sh script
cat > reactStart.sh << EOL
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

chmod +x reactStart.sh

echo "React app '$app_name' created successfully with $package_manager and $language!"
echo "To start the app, run 'docker-compose up'"

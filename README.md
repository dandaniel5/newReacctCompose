# newReacctCompose
sh script, which will create a new npm project with 2 environments

how to use :
To use this script, follow these steps:

Download the create_react_compose_app.sh script.
Open a terminal and navigate to the directory where the script is saved.
Run the following command: chmod +x create_react_compose_app.sh to make the script executable.
Run the script using the following command: ./create_react_compose_app.sh.
When prompted, enter the name of your npm project. If you want to use the current working directory name, press enter.
The script will create a new React project using create-react-app.
It will then create a Dockerfile with the node:alpine3.17 image.
It will create a docker-compose.yml file with volumes that will map your local project files to the container and expose port 3000.
Finally, it will create a start.sh file that will start the container and install all the necessary dependencies.

To start the application in the container, you can use the following command:

Copy code
docker-compose up -it
This will start the container and run the start.sh script, which will install all the necessary dependencies and start the development server.

If you want to run the application locally, navigate to the project directory in a terminal and run the following command:

sql
Copy code
npm start
This will start the development server locally on port 3000. Note that you will need to have Node.js installed on your system in order to run the application locally.
<img width="469" alt="image" src="https://github.com/dandaniel5/newReacctCompose/assets/88844682/317e0282-30fc-4e2a-af10-5db2f5208262">

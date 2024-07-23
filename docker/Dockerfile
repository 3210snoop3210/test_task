# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Build the application with the environment variable, default to 'dev'
ARG ENV=dev
RUN npm run build:$ENV

# Remove unnecessary files from the image
RUN rm -rf docker

# Set the environment variable for the serving directory
ENV ENV=${ENV}

# Install a simple static file server
RUN npm install -g serve

# Expose port 5000
EXPOSE 5000

# Serve the static files

CMD ["npm", "start"]

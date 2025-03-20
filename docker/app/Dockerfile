# Use the official Node.js image as base image
FROM node:lts

# Install pnpm globally
RUN npm install -g pnpm

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy package.json and pnpm-lock.yaml to the working directory
COPY package.json pnpm-lock.yaml ./

RUN git init

# Install app dependencies
RUN npm install --unsafe-perm

# Copy the rest of the application code to the working directory
COPY . .

#Generate key
RUN npm run generatePrivateKey
RUN npm run generateAES
RUN npm run generatePublicKey

# Command to run the application
CMD ["sh", "-c", "pnpm run build && pnpm run copyKeys && pnpm run start"]
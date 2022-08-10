FROM java
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} foodbox.jar
EXPOSE 8082
ENTRYPOINT ["java","-jar","/foodbox.jar"]

# Stage 1

FROM node:10-alpine as build-step

RUN mkdir -p /app

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

RUN npm run build --prod

# Stage 2

FROM nginx:alpine

COPY --from=build-step /app/docs /usr/share/nginx/html

EXPOSE 80
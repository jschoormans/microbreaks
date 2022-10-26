# create a Dockerfile for a web application
FROM nginx
COPY . /usr/share/nginx/html

# Base image: Lightweight web server
FROM nginx:alpine

# Copy app files to Nginx serve dir
COPY . /usr/share/nginx/html

# Port for web access
EXPOSE 80

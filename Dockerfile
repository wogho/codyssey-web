FROM nginx:alpine

# Serve the static site from the app directory.
COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80

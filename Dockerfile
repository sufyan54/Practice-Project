FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
# OR copy everything
# COPY . /usr/share/nginx/html
EXPOSE 80

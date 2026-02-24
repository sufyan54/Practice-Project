FROM nginx:alpine
COPY Practice.html /usr/share/nginx/html/index.html
# OR copy everything
# COPY . /usr/share/nginx/html
EXPOSE 80

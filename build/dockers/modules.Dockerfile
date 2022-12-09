FROM nginx:latest

EXPOSE 80

COPY modules-nginx.conf /etc/nginx/nginx.conf



CMD ["nginx"]

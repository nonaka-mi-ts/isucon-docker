FROM nginx:alpine

ARG APP_HOST=app

# Configure default vhost
COPY app.conf /etc/nginx/conf.d/default.conf
RUN sed -i -e "s/{{APP_HOST}}/${APP_HOST}/g" /etc/nginx/conf.d/default.conf


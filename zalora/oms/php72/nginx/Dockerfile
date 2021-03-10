FROM nginx:latest

RUN mkdir -pv /etc/nginx/sites-enabled
RUN mkdir -pv /etc/nginx/sites-available

# Replace nginx config files
COPY config/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -pv /var/log/nginx/oms

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/oms/app.access.log
RUN ln -sf /dev/stderr /var/log/nginx/oms/app.error.log

# Export ports
EXPOSE 80 443

# Define default command.
CMD ["nginx"]
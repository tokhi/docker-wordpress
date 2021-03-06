FROM php:5.6-fpm
MAINTAINER CenturyLink

# Install packages
RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
 DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen && \
 apt-get -y install mysql-client

# Download Wordpress into /app
RUN rm -fr /app && mkdir /app && \
 curl -L -O https://wordpress.org/wordpress-3.8.3.tar.gz && \
 tar -xzvf wordpress-3.8.3.tar.gz -C /app --strip-components=1 && \
 rm wordpress-3.8.3.tar.gz

# Add wp-config with info for Wordpress to connect to DB
ADD wp-config.php /app/wp-config.php
RUN chmod 644 /app/wp-config.php

# Fix permissions for apache
RUN chown -R www-data:www-data /app

# Add script to create 'wordpress' DB
ADD run.sh run.sh
RUN chmod 755 *.sh

EXPOSE 80
CMD ["/run.sh"]

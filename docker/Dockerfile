FROM php:7.4-apache
WORKDIR /var/www/html
RUN docker-php-ext-install mysqli

COPY ./docker/docker-compose/my-apache-site.conf /etc/apache2/sites-available/my-apache-site.conf

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf &&\
    a2enmod rewrite &&\
    a2dissite 000-default &&\
    a2ensite my-apache-site &&\
    service apache2 restart
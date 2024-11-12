FROM debian:latest 

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get install -y perl && \
    apt-get install -y libcgi-pm-perl

RUN mkdir -p /home/pweb
RUN useradd pweb -m && echo "pweb:12345678" | chpasswd
RUN echo "root:12345678" | chpasswd
RUN chown pweb:www-data /usr/lib/cgi-bin/
RUN chown pweb:www-data /var/www/html/
RUN chmod 750 /usr/lib/cgi-bin/
RUN chmod 750 /var/www/html/

RUN ln -s /usr/lib/cgi-bin /home/pweb/cgi-bin
RUN ln -s /var/www/html/ /home/pweb/html

RUN ln -s /home/pweb /usr/lib/cgi-bin/toHome
RUN ln -s /home/pweb /var/www/html/toHome

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod cgid
RUN service apache2 restart

COPY ./cgi-bin/consulta.pl /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin/consulta.pl

COPY ./html/index.html /var/www/html

COPY ./css/ /var/www/html/css

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]


FROM ubuntu:18.04
RUN apt-get update && apt-get -y install apache2
RUN mkdir -p /var/www/html/sorry
ADD ./index.html /var/www/html/sorry/index.html
RUN echo '. /etc/apache2/envvars' > /root/run-apache.sh && \
 echo 'mkdir -p /var/run/apache2' >> /root/run-apache.sh && \
 echo 'mkdir -p /var/lock/apache2' >> /root/run-apache.sh && \
 echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run-apache.sh && \
 chmod a+x /root/run-apache.sh
EXPOSE 80
CMD /root/run-apache.sh

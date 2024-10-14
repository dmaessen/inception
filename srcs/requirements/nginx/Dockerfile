# pulls the base image, the penultimate stable now is bullseye - debian 11
FROM debian:bullseye

#EXPOSE 3000

RUN apt-get update && apt-get upgrade -y

# the package manager to install all required packages
# openssl is a toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols 
# - to create/amanage SSL certificates
RUN apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl 

# generate SSL certificate (https://www.openssl.org/docs/man3.0/man1/openssl-req.html)
#   req = required; 
#   -x509 = the format of the public key and that should be self signed;
#   -nodes = skips the encryption and leaves public key as plain text;
RUN openssl req -x509 -nodes \
    -subj "/C=NL/ST=Noord Holland/L=Amsterdam/O=42/OU=42/CN=dmaessen.42.fr/UID=dmaessen" \ 
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key

# change owner for wordpress dir to www-data
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN chmod 777 /etc/nginx/ssl/ 
RUN chown -R www-data:www-data /etc/nginx/ssl/

# COPY ./conf/nginx.conf /etc/nginx/nginx.d
COPY ./conf/nginx.conf /etc/nginx/sites-enabled/nginx.conf

WORKDIR /var/www/html

# when the container starts for Nginx web server
#   -g to apply additional configuration globaly
#   daemon off;: will make Nginx run in the foreground, which ensures that the container remains active as long as Nginx runs
CMD ["nginx", "-g", "daemon off;"]

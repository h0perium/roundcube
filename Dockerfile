FROM roundcube/roundcubemail

MAINTAINER "Saeid Salehi" <hostage.scape2010@gmail.com>

EXPOSE 80

COPY defaults.inc.php /var/roundcube/config/smtp.php


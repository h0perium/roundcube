## Roundcube Panel

if you need a graphical user interface to send and receive emails , we have also prepared a roundcube image to connect it to postfix-dovecot service. roundcube needs database which we use mysql here so you can run both services in a docker-compose file.

docker-compose.yml:
```sh
version: '3'

services:
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: 1
      MYSQL_DATABASE: admin
      MYSQL_USER: admin
      MYSQL_PASSWORD: admin

  mailserver:
    image: h0perium/postfix-dovecot-dkim
    restart: always
    ports:
      - 25:25
      - 587:587
      - 993:993
      - 995:995
      - 143:143
      - 110:110
    volumes:
      - mailserver-storage:/var/mail

    environment:
      MTP_HOST: example.com
      INIT_EMAIL: info@example.com
      INIT_EMAIL_PASS: qwerty
      MTP_DESTINATION: '6a6a6586e71d, localhost.localdomain, localhost'



  roundcube:
    depends_on:
      - db
    image: h0perium/roundcube
  

    environment:
      ROUNDCUBEMAIL_DEFAULT_HOST: "mailserver"
      ROUNDCUBEMAIL_SMTP_SERVER:  "mailserver"
      ROUNDCUBEMAIL_SMTP_PORT: 25
      ROUNDCUBEMAIL_DB_TYPE: mysql
      ROUNDCUBEMAIL_DB_HOST: db
      ROUNDCUBEMAIL_DB_USER: admin
      ROUNDCUBEMAIL_DB_PASSWORD: admin
      ROUNDCUBEMAIL_DB_NAME: admin

    ports:
      - 6565:80
    restart: always

volumes:
   mailserver-storage:
```
you just need to replace the MTP_HOST  with your hostname and an initial email address and its password in INIT_EMAIL and INIT_EMAIL_PASS evn variables.
now you can access roundcube on port 6565 or any port you asigned in docker-compose file
and run it with command:

```sh
docker-compose up -d
```
it takes couple of minutes till roundcube get fully loaded.

you can add this microservice to your exisintg docker network like this:
```sh
version: '3'

services:
  db:
    image: mysql:5.7
    restart: always
    networks:
      - mynetwork

    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: 1
      MYSQL_DATABASE: admin
      MYSQL_USER: admin
      MYSQL_PASSWORD: admin

  mailserver:
    image: h0perium/postfix-dovecot-dkim
    restart: always
    ports:
      - 25:25
      - 587:587
      - 993:993
      - 995:995
      - 143:143
      - 110:110
    volumes:
      - mailserver-storage:/var/mail
    networks:
      - mynetwork

    environment:
      MTP_HOST: example.com
      INIT_EMAIL: info@example.com
      INIT_EMAIL_PASS: qwerty
      MTP_DESTINATION: '6a6a6586e71d, localhost.localdomain, localhost'



  roundcube:
    depends_on:
      - db
    image: h0perium/roundcube
    networks:
      - mynetwork
    environment:
      ROUNDCUBEMAIL_DEFAULT_HOST: "mailserver"
      ROUNDCUBEMAIL_SMTP_SERVER:  "mailserver"
      ROUNDCUBEMAIL_SMTP_PORT: 25
      ROUNDCUBEMAIL_DB_TYPE: mysql
      ROUNDCUBEMAIL_DB_HOST: db
      ROUNDCUBEMAIL_DB_USER: admin
      ROUNDCUBEMAIL_DB_PASSWORD: admin
      ROUNDCUBEMAIL_DB_NAME: admin

    ports:
      - 6565:80
    restart: always

networks:
  mynetwork:
    external: true

volumes:
   mailserver-storage:

```


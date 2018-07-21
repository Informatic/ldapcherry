FROM python:2-alpine

WORKDIR /usr/src/app
ADD . /usr/src/app

ENV DATAROOTDIR /usr/share
ENV SYSCONFDIR /etc

RUN apk add --no-cache libldap && \
    apk add --no-cache --virtual build-dependencies build-base yaml-dev openldap-dev && \
    python setup.py install && \
    apk del build-dependencies && \
    cp -v conf/* /etc/ldapcherry && \
    sed -i 's/syslog/none/; s/127.0.0.1/0.0.0.0/' /etc/ldapcherry/ldapcherry.ini && \
    adduser -S ldapcherry && \
    rm -rf /usr/src/app

USER ldapcherry

CMD [ "ldapcherryd", "-c", "/etc/ldapcherry/ldapcherry.ini", "-D" ]

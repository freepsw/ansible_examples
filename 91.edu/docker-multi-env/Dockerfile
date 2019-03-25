FROM nginx
RUN apt-get update
RUN apt-get install -y  python-pip python-setuptools

#RUN easy_install pip
RUN pip install j2cli

COPY nginx.conf.j2 /templates/
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

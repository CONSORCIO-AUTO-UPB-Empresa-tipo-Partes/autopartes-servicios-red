FROM postgres:latest

# Variables de entorno
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=admin123
ENV POSTGRES_DB=autopartes

# Copiamos nuestro script SQL directamente a /docker-entrypoint-initdb.d/
COPY init.sql /docker-entrypoint-initdb.d/

# Por defecto, la imagen oficial de Postgres ya tiene:
# ENTRYPOINT ["docker-entrypoint.sh"]
# CMD ["postgres"]

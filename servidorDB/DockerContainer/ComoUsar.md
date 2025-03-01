# 📌 Guía para Configurar y Usar el Contenedor de PostgreSQL

## 📝 **Requisitos Previos**

Antes de comenzar, asegúrate de tener instalado:

- [Docker](https://docs.docker.com/get-docker/)

## 📥 **Descargar la Imagen de PostgreSQL**

Para obtener el contenedor de PostgreSQL configurado, ejecuta el siguiente comando:

```bash
docker pull raloz/db_autopartes
```

## 🚀 **Ejecutar el Contenedor**

Para iniciar el contenedor con PostgreSQL:

```bash
docker run --name db_container -d -p 5432:5432 raloz/db_autopartes
```

🔹 **Explicación de los parámetros:**

- `--name db_container` → Nombre asignado al contenedor.
- `-d` → Ejecuta el contenedor en segundo plano (*detached mode*).
- `-p 5432:5432` → Expone el puerto 5432 del contenedor en el host.
- `raloz/db_autopartes` → Imagen descargada desde Docker Hub.

## 🔄 **Verificar que PostgreSQL Está Corriendo**

Para confirmar que el contenedor se está ejecutando correctamente:

```bash
docker ps
```

Si el contenedor aparece en la lista, significa que está activo. También puedes ver los logs con:

```bash
docker logs db_container
```

## 🔗 **Conectarse a PostgreSQL desde el Contenedor**

Para acceder a PostgreSQL dentro del contenedor, usa:

```bash
docker exec -it db_container psql -U admin -d autopartes
```

📌 **Credenciales de Acceso:**

- **Usuario:** `admin`
- **Contraseña:** `admin123`
- **Base de datos:** `autopartes`

## 🛠 **Verificar la Base de Datos y las Tablas**

Una vez dentro de `psql`, puedes verificar que todo está correctamente configurado:

- **Listar esquemas:**
  ```sql
  \dn
  ```
- **Ver las tablas dentro del esquema ************`autopartes`************:**
  ```sql
  \dt autopartes.*
  ```
- **Ver la estructura de una tabla (ejemplo: ************`Person`************)**
  ```sql
  \d autopartes.person
  ```
- **Ver algunos registros de una tabla (ejemplo: ************`Users`************)**
  ```sql
  SELECT * FROM autopartes.users LIMIT 5;
  ```

## 📡 **Conectarse desde una Aplicación Externa**

Para conectarte desde una aplicación como **DBeaver, pgAdmin o una API**, usa estos datos de conexión:

🔹 **Configuración de conexión:**

- **Host:** `localhost`
- **Puerto:** `5432`
- **Base de datos:** `autopartes`
- **Usuario:** `admin`
- **Contraseña:** `admin123`

Si estás en un entorno de red diferente, usa el siguiente comando para obtener la IP del contenedor:

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db_container
```

## 🛑 **Detener y Eliminar el Contenedor**

Si necesitas detener el contenedor:

```bash
docker stop db_container
```

Para eliminarlo completamente:

```bash
docker rm db_container
```

## 🔄 **Reiniciar el Contenedor**

Si quieres reiniciarlo:

```bash
docker restart db_container
```

## 🎯 **Notas Adicionales**

- Si el contenedor ya está creado y quieres levantarlo nuevamente sin perder los datos:
  ```bash
  docker start db_container
  ```
- Si necesitas recrearlo desde cero (perdiendo los datos):
  ```bash
  docker rm -f db_container
  docker run --name db_container -d -p 5432:5432 tu_usuario/db_autopartes
  ```

---


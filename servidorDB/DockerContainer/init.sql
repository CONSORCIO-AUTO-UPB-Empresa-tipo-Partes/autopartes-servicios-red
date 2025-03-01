-- Crear usuarios globales
DO
$do$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'admin') THEN
      CREATE ROLE admin WITH LOGIN PASSWORD 'admin123';
      ALTER ROLE admin CREATEDB CREATEROLE;
   END IF;

   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'develop') THEN
      CREATE ROLE develop WITH LOGIN PASSWORD '123perrito';
   END IF;
END
$do$;

-- Crear base de datos si no existe
DO
$do$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'autopartes') THEN
      CREATE DATABASE autopartes OWNER admin;
   END IF;
END
$do$;

-- Conectarse a la base de datos
\c autopartes;

-- Crear esquema
DROP SCHEMA IF EXISTS AutoPartes CASCADE;
CREATE SCHEMA AutoPartes AUTHORIZATION admin;
SET search_path TO AutoPartes;


-- Crear tablas
CREATE TABLE Person (
  idDocument CHAR(15) PRIMARY KEY,
  personName VARCHAR(100) NOT NULL,
  phoneNumber VARCHAR(20) NOT NULL UNIQUE,
  typeDocument CHAR(3) NOT NULL,
  personAddress VARCHAR(100) NOT NULL,
  personType VARCHAR(45) NOT NULL
);

CREATE TABLE UserType (
  idTypeUser SERIAL PRIMARY KEY,
  description VARCHAR(150),
  userTypeName VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE UserTokens (
  idTokens SERIAL PRIMARY KEY,
  token VARCHAR(500) NOT NULL UNIQUE,
  expiresAt TIMESTAMP,
  createdAt TIMESTAMP,
  UserTokensCol BOOLEAN
);

CREATE TABLE Users (
  email VARCHAR(100) PRIMARY KEY,
  password VARCHAR(255) NOT NULL,
  UserType_idTypeUser INT NOT NULL,
  Person_idDocument CHAR(15) NOT NULL,
  UserTokens_idTokens INT NOT NULL,
  FOREIGN KEY (UserType_idTypeUser) REFERENCES UserType(idTypeUser) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Person_idDocument) REFERENCES Person(idDocument) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (UserTokens_idTokens) REFERENCES UserTokens(idTokens) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ItemType (
  idItem SERIAL PRIMARY KEY,
  ItemName VARCHAR(45)
);

CREATE TABLE Provider (
  idProvider SERIAL PRIMARY KEY,
  Name VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE Batch (
  idBatch SERIAL PRIMARY KEY,
  dateArrival TIMESTAMP NOT NULL,
  quantity INT NOT NULL,
  purchasePrice DECIMAL(10,2) NOT NULL,
  unitPurchasePrice DECIMAL(10,2) NOT NULL,
  unitSalePrice DECIMAL(10,2) NOT NULL,
  monthsOfWarranty INT,
  itemDescription VARCHAR(250),
  Item_idItem INT NOT NULL,
  Provider_idProvider INT NOT NULL,
  warrantyInDays VARCHAR(45),
  haveWarranty BOOLEAN,
  FOREIGN KEY (Item_idItem) REFERENCES ItemType(idItem) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Provider_idProvider) REFERENCES Provider(idProvider) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Bill (
  idBill SERIAL PRIMARY KEY,
  billDate TIMESTAMP NOT NULL,
  totalPrice DECIMAL(10,2) NOT NULL,
  tax DECIMAL(10,2),
  totalPriceWithoutTax DECIMAL(10,2) NOT NULL,
  haveDiscount BOOLEAN,
  discountRate DECIMAL(5,2),
  Person_idDocument CHAR(15) NOT NULL,
  FOREIGN KEY (Person_idDocument) REFERENCES Person(idDocument) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE BillHasBatch (
  Bill_idBill INT NOT NULL,
  Batch_idBatch INT NOT NULL,
  amountSold INT,
  PRIMARY KEY (Bill_idBill, Batch_idBatch),
  FOREIGN KEY (Bill_idBill) REFERENCES Bill(idBill) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Batch_idBatch) REFERENCES Batch(idBatch) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Permissions (
  idPermissions SERIAL PRIMARY KEY,
  name_permissions VARCHAR(45),
  permissionDescription VARCHAR(250)
);

CREATE TABLE UserTypeHasPermissions (
  UserType_idTypeUser INT NOT NULL,
  Permissions_idPermissions INT NOT NULL,
  PRIMARY KEY (UserType_idTypeUser, Permissions_idPermissions),
  FOREIGN KEY (UserType_idTypeUser) REFERENCES UserType(idTypeUser) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Permissions_idPermissions) REFERENCES Permissions(idPermissions) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Asignar permisos
GRANT CONNECT ON DATABASE autopartes TO develop;
GRANT USAGE ON SCHEMA AutoPartes TO develop;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA AutoPartes TO develop;
ALTER DEFAULT PRIVILEGES IN SCHEMA AutoPartes GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO develop;

-- Evitar que develop pueda modificar estructura de tablas
REVOKE CREATE ON SCHEMA AutoPartes FROM develop;

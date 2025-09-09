-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS paradise_experience_db;
USE paradise_experience_db;

-- Crear la tabla paisos
CREATE TABLE paisos (
  idPais INT NOT NULL AUTO_INCREMENT,
  pais VARCHAR(50) NOT NULL,
  pais_original VARCHAR(50) NOT NULL,
  PRIMARY KEY (idPais)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla provincies
CREATE TABLE provincies (
  idProvincia INT NOT NULL AUTO_INCREMENT,
  idPais INT NOT NULL,
  provincia VARCHAR(100) NOT NULL,
  PRIMARY KEY (idProvincia),
  UNIQUE KEY uk_provincia_pais (idPais, idProvincia),
  KEY idx_idPais (idPais),
  CONSTRAINT provincies_ibfk_1 FOREIGN KEY (idPais) REFERENCES paisos (idPais) 
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla hotels
CREATE TABLE hotels (
  idHotel INT NOT NULL AUTO_INCREMENT,
  nomHotel VARCHAR(45) DEFAULT NULL,
  estrelles INT DEFAULT NULL,
  idPais INT DEFAULT NULL,
  idProvincia INT DEFAULT NULL,
  ciutat VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (idHotel),
  KEY fk2_idx (idPais, idProvincia),
  CONSTRAINT fk2 FOREIGN KEY (idPais, idProvincia) REFERENCES provincies (idPais, idProvincia) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla clients
CREATE TABLE clients (
  idClient INT NOT NULL AUTO_INCREMENT,  
  -- Datos personales
  nom VARCHAR(50) NOT NULL,
  cognoms VARCHAR(100) NOT NULL,
  data_naixement DATE,
  dni VARCHAR(15),
  email VARCHAR(254) NOT NULL,
  telefon VARCHAR(20),  
  -- Dirección separada
  carrer VARCHAR(100),
  numero VARCHAR(10),
  pis VARCHAR(10),
  ciutat VARCHAR(100),  
  -- Relación con tablas paisos/provincies
  idPais INT DEFAULT NULL,
  idProvincia INT DEFAULT NULL,
  codi_postal VARCHAR(10),  
  -- Timestamps
  data_actualitzacio TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
  -- PRIMARY KEY
  PRIMARY KEY (idClient),  
  -- Constraints para referenciar paisos y provincies
  CONSTRAINT fk_clients_paisos FOREIGN KEY (idPais) REFERENCES paisos (idPais) ON DELETE SET NULL ON UPDATE CASCADE,  
  CONSTRAINT fk_clients_provincies FOREIGN KEY (idPais, idProvincia) REFERENCES provincies (idPais, idProvincia) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla habitacions
CREATE TABLE habitacions (
  idHotel INT NOT NULL,
  numeroHabitacio INT NOT NULL,
  nomHabitacio VARCHAR(100) DEFAULT NULL,
  capacitat INT DEFAULT NULL,
  PRIMARY KEY (idHotel, numeroHabitacio),
  CONSTRAINT habitacions_ibfk_1 FOREIGN KEY (idHotel) REFERENCES hotels (idHotel) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla serveis
CREATE TABLE serveis (
  idServei INT NOT NULL AUTO_INCREMENT,
  nomServei VARCHAR(100) NOT NULL,
  descripcio TEXT,
  disponible TINYINT(1) DEFAULT '1',
  PRIMARY KEY (idServei)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla serveishotels
CREATE TABLE serveishotels (
  idHotel INT NOT NULL,
  idServei INT NOT NULL,
  preu DECIMAL(10,2) DEFAULT '0.00',
  disponible TINYINT(1) DEFAULT '1',
  PRIMARY KEY (idHotel, idServei),
  KEY fk_s_2_idx (idServei),
  CONSTRAINT fk_s_1 FOREIGN KEY (idHotel) REFERENCES hotels (idHotel) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_s_2 FOREIGN KEY (idServei) REFERENCES serveis (idServei) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla temporades
CREATE TABLE temporades (
  idTemporada INT NOT NULL AUTO_INCREMENT,
  nom ENUM('baja', 'media', 'alta') NOT NULL,
  dataInici DATE NOT NULL,
  dataFi DATE NOT NULL,
  PRIMARY KEY (idTemporada)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insertar datos en temporades
INSERT INTO temporades (idTemporada, nom, dataInici, dataFi) VALUES
(1, 'baja', '2024-01-10', '2024-03-31'),
(2, 'media', '2024-04-01', '2024-06-30'),
(3, 'alta', '2024-07-01', '2024-09-30'),
(4, 'media', '2024-10-01', '2024-12-20'),
(5, 'alta', '2024-12-21', '2024-12-31');

-- Crear la tabla categories
CREATE TABLE categories (
  idCategoria INT NOT NULL AUTO_INCREMENT,
  nomCategoria VARCHAR(100) NOT NULL,
  descripcio TEXT,
  PRIMARY KEY (idCategoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insertar datos en categories
INSERT INTO categories (idcategoria, nomCategoria, descripcio) VALUES
(1, 'Standard', 'Habitacions estàndard amb comoditats bàsiques'),
(2, 'Superior', 'Habitacions superiors amb millores en espai i comoditats'),
(3, 'Suite', 'Suites luxoses amb espai ampli i serveis addicionals');

-- Crear la tabla tarifes
CREATE TABLE tarifes (
  idHotel INT NOT NULL,
  idCategoria INT NOT NULL,
  idTemporada INT NOT NULL,
  preu DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (idHotel, idCategoria, idTemporada),
  KEY idCategoria (idCategoria),
  KEY idTemporada (idTemporada),
  CONSTRAINT tarifes_ibfk_1 FOREIGN KEY (idHotel) REFERENCES hotels (idHotel) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT tarifes_ibfk_2 FOREIGN KEY (idCategoria) REFERENCES categories (idCategoria) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT tarifes_ibfk_3 FOREIGN KEY (idTemporada) REFERENCES temporades (idTemporada) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla reserves
CREATE TABLE reserves (
  idHotel INT NOT NULL,
  numReserva INT NOT NULL, /*consultar autoincrement combinado con el año*/
  idClient INT DEFAULT NULL,
  dataInici DATE DEFAULT NULL,
  dataFi DATE DEFAULT NULL,
  PRIMARY KEY (idHotel, numReserva),
  KEY fk_Reserva_2_idx (idClient),
  CONSTRAINT fk_Reserva_2 FOREIGN KEY (idClient) REFERENCES clients (idClient) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_Reserva_1 FOREIGN KEY (idHotel) REFERENCES hotels (idHotel) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla reserveshab
CREATE TABLE reserveshab (
  idHotel INT NOT NULL,
  numReserva INT NOT NULL,
  numHabitacio INT NOT NULL,
  persones INT DEFAULT NULL,
  PRIMARY KEY (idHotel, numReserva, numHabitacio),
  KEY fk_detall_1_idx (idHotel, numHabitacio),
  CONSTRAINT fk_detall_1 FOREIGN KEY (idHotel, numHabitacio) REFERENCES habitacions (idHotel, numeroHabitacio) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_detall_2 FOREIGN KEY (idHotel, numReserva) REFERENCES reserves (idHotel, numReserva) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla: reservesserveis
CREATE TABLE reservesserveis (
  idReservaServei INT NOT NULL AUTO_INCREMENT,
  idHotel INT NOT NULL,
  numReserva INT NOT NULL,
  idServei INT NOT NULL,
  dia DATE NOT NULL,
  quantitat INT DEFAULT '1',
  observacions VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (idReservaServei),
  KEY idx_hotel_numReserva (idHotel, numReserva),
  KEY idx_hotel_servei (idHotel, idServei),
  CONSTRAINT fk_reserserv_1 FOREIGN KEY (idHotel, idServei) REFERENCES serveishotels (idHotel, idServei) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reserserv_2 FOREIGN KEY (idHotel, numReserva) REFERENCES reserves (idHotel, numReserva) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE usuaris (
  idUsuari INT NOT NULL AUTO_INCREMENT,
  idClient INT DEFAULT NULL,  -- Relación opcional para usuarios que son clientes
  username VARCHAR(50) NOT NULL,
  password VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  email VARCHAR(100) NOT NULL,
  rol ENUM('usuari', 'administrador') NOT NULL DEFAULT 'usuari',
  actiu TINYINT(1) DEFAULT 1,         -- Indicador de activación (soft delete)
  deleted_at DATETIME DEFAULT NULL,    -- Fecha de desactivación, si aplica
  data_creacio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idUsuari),
  UNIQUE KEY uk_username (username),
  CONSTRAINT fk_usuaris_client FOREIGN KEY (idClient) 
  REFERENCES clients (idClient) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


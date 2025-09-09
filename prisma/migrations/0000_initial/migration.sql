-- CreateTable
CREATE TABLE `categories` (
    `idCategoria` INTEGER NOT NULL AUTO_INCREMENT,
    `nomCategoria` VARCHAR(100) NOT NULL,
    `descripcio` TEXT NULL,

    PRIMARY KEY (`idCategoria`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `clients` (
    `idClient` INTEGER NOT NULL AUTO_INCREMENT,
    `nom` VARCHAR(50) NOT NULL,
    `cognoms` VARCHAR(100) NOT NULL,
    `data_naixement` DATE NULL,
    `dni` VARCHAR(15) NULL,
    `email` VARCHAR(254) NOT NULL,
    `telefon` VARCHAR(20) NULL,
    `carrer` VARCHAR(100) NULL,
    `numero` VARCHAR(10) NULL,
    `pis` VARCHAR(10) NULL,
    `ciutat` VARCHAR(100) NULL,
    `idPais` INTEGER NULL,
    `idProvincia` INTEGER NULL,
    `codi_postal` VARCHAR(10) NULL,
    `data_actualitzacio` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `clients_dni_key`(`dni`),
    INDEX `fk_clients_provincies`(`idPais`, `idProvincia`),
    PRIMARY KEY (`idClient`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `habitacions` (
    `idHotel` INTEGER NOT NULL,
    `numeroHabitacio` INTEGER NOT NULL,
    `nomHabitacio` VARCHAR(100) NULL,
    `capacitat` INTEGER NULL,

    PRIMARY KEY (`idHotel`, `numeroHabitacio`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `hotels` (
    `idHotel` INTEGER NOT NULL AUTO_INCREMENT,
    `nomHotel` VARCHAR(45) NULL,
    `estrelles` INTEGER NULL,
    `idPais` INTEGER NULL,
    `idProvincia` INTEGER NULL,
    `ciutat` VARCHAR(100) NULL,

    INDEX `fk2_idx`(`idPais`, `idProvincia`),
    PRIMARY KEY (`idHotel`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `paisos` (
    `idPais` INTEGER NOT NULL AUTO_INCREMENT,
    `pais` VARCHAR(50) NOT NULL,
    `pais_original` VARCHAR(50) NOT NULL,

    PRIMARY KEY (`idPais`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `provincies` (
    `idProvincia` INTEGER NOT NULL AUTO_INCREMENT,
    `idPais` INTEGER NOT NULL,
    `provincia` VARCHAR(100) NOT NULL,

    INDEX `idx_idPais`(`idPais`),
    UNIQUE INDEX `uk_provincia_pais`(`idPais`, `idProvincia`),
    PRIMARY KEY (`idProvincia`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `reserves` (
    `idHotel` INTEGER NOT NULL,
    `numReserva` INTEGER NOT NULL,
    `idClient` INTEGER NULL,
    `dataInici` DATE NULL,
    `dataFi` DATE NULL,

    INDEX `fk_Reserva_2_idx`(`idClient`),
    PRIMARY KEY (`idHotel`, `numReserva`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `reserveshab` (
    `idHotel` INTEGER NOT NULL,
    `numReserva` INTEGER NOT NULL,
    `numHabitacio` INTEGER NOT NULL,
    `persones` INTEGER NULL,

    INDEX `fk_detall_1_idx`(`idHotel`, `numHabitacio`),
    PRIMARY KEY (`idHotel`, `numReserva`, `numHabitacio`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `reservesserveis` (
    `idReservaServei` INTEGER NOT NULL AUTO_INCREMENT,
    `idHotel` INTEGER NOT NULL,
    `numReserva` INTEGER NOT NULL,
    `idServei` INTEGER NOT NULL,
    `dia` DATE NOT NULL,
    `quantitat` INTEGER NULL DEFAULT 1,
    `observacions` VARCHAR(100) NULL,

    INDEX `idx_hotel_numReserva`(`idHotel`, `numReserva`),
    INDEX `idx_hotel_servei`(`idHotel`, `idServei`),
    PRIMARY KEY (`idReservaServei`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `serveis` (
    `idServei` INTEGER NOT NULL AUTO_INCREMENT,
    `nomServei` VARCHAR(100) NOT NULL,
    `descripcio` TEXT NULL,
    `disponible` BOOLEAN NULL DEFAULT true,

    PRIMARY KEY (`idServei`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `serveishotels` (
    `idHotel` INTEGER NOT NULL,
    `idServei` INTEGER NOT NULL,
    `preu` DECIMAL(10, 2) NULL DEFAULT 0.00,
    `disponible` BOOLEAN NULL DEFAULT true,

    INDEX `fk_s_2_idx`(`idServei`),
    PRIMARY KEY (`idHotel`, `idServei`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tarifes` (
    `idHotel` INTEGER NOT NULL,
    `idCategoria` INTEGER NOT NULL,
    `idTemporada` INTEGER NOT NULL,
    `preu` DECIMAL(10, 2) NOT NULL,

    INDEX `idCategoria`(`idCategoria`),
    INDEX `idTemporada`(`idTemporada`),
    PRIMARY KEY (`idHotel`, `idCategoria`, `idTemporada`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `temporades` (
    `idTemporada` INTEGER NOT NULL AUTO_INCREMENT,
    `nom` ENUM('baja', 'media', 'alta') NOT NULL,
    `dataInici` DATE NOT NULL,
    `dataFi` DATE NOT NULL,

    PRIMARY KEY (`idTemporada`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `usuaris` (
    `idUsuari` INTEGER NOT NULL AUTO_INCREMENT,
    `idClient` INTEGER NULL,
    `username` VARCHAR(50) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `rol` ENUM('usuari', 'administrador') NOT NULL DEFAULT 'usuari',
    `actiu` BOOLEAN NULL DEFAULT true,
    `deleted_at` DATETIME(0) NULL,
    `data_creacio` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `uk_username`(`username`),
    INDEX `fk_usuaris_client`(`idClient`),
    PRIMARY KEY (`idUsuari`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `clients` ADD CONSTRAINT `fk_clients_paisos` FOREIGN KEY (`idPais`) REFERENCES `paisos`(`idPais`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `clients` ADD CONSTRAINT `fk_clients_provincies` FOREIGN KEY (`idPais`, `idProvincia`) REFERENCES `provincies`(`idPais`, `idProvincia`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `habitacions` ADD CONSTRAINT `habitacions_ibfk_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels`(`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `hotels` ADD CONSTRAINT `fk2` FOREIGN KEY (`idPais`, `idProvincia`) REFERENCES `provincies`(`idPais`, `idProvincia`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `provincies` ADD CONSTRAINT `provincies_ibfk_1` FOREIGN KEY (`idPais`) REFERENCES `paisos`(`idPais`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reserves` ADD CONSTRAINT `fk_Reserva_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels`(`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reserves` ADD CONSTRAINT `fk_Reserva_2` FOREIGN KEY (`idClient`) REFERENCES `clients`(`idClient`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reserveshab` ADD CONSTRAINT `fk_detall_1` FOREIGN KEY (`idHotel`, `numHabitacio`) REFERENCES `habitacions`(`idHotel`, `numeroHabitacio`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reserveshab` ADD CONSTRAINT `fk_detall_2` FOREIGN KEY (`idHotel`, `numReserva`) REFERENCES `reserves`(`idHotel`, `numReserva`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reservesserveis` ADD CONSTRAINT `fk_reserserv_1` FOREIGN KEY (`idHotel`, `idServei`) REFERENCES `serveishotels`(`idHotel`, `idServei`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `reservesserveis` ADD CONSTRAINT `fk_reserserv_2` FOREIGN KEY (`idHotel`, `numReserva`) REFERENCES `reserves`(`idHotel`, `numReserva`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `serveishotels` ADD CONSTRAINT `fk_s_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels`(`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `serveishotels` ADD CONSTRAINT `fk_s_2` FOREIGN KEY (`idServei`) REFERENCES `serveis`(`idServei`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tarifes` ADD CONSTRAINT `tarifes_ibfk_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels`(`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tarifes` ADD CONSTRAINT `tarifes_ibfk_2` FOREIGN KEY (`idCategoria`) REFERENCES `categories`(`idCategoria`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tarifes` ADD CONSTRAINT `tarifes_ibfk_3` FOREIGN KEY (`idTemporada`) REFERENCES `temporades`(`idTemporada`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `usuaris` ADD CONSTRAINT `fk_usuaris_client` FOREIGN KEY (`idClient`) REFERENCES `clients`(`idClient`) ON DELETE SET NULL ON UPDATE CASCADE;


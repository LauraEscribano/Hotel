CREATE DATABASE  IF NOT EXISTS `paradise_experience_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `paradise_experience_db`;
-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: paradise_experience_db
-- ------------------------------------------------------
-- Server version	8.0.35-0ubuntu0.23.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_prisma_migrations`
--

LOCK TABLES `_prisma_migrations` WRITE;
/*!40000 ALTER TABLE `_prisma_migrations` DISABLE KEYS */;
INSERT INTO `_prisma_migrations` VALUES ('2c5e1af2-763f-4096-acbd-b18ee47c1708','9a5dc931019a5b245bf9004c45da179a3498e383211e4298026e9b2461e89aaa','2025-03-21 19:38:27.444','0000_initial','',NULL,'2025-03-21 19:38:27.444',0);
/*!40000 ALTER TABLE `_prisma_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `idCategoria` int NOT NULL AUTO_INCREMENT,
  `nomCategoria` varchar(100) NOT NULL,
  `descripcio` text,
  PRIMARY KEY (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Standard','Habitacions estàndard amb comoditats bàsiques'),(2,'Superior','Habitacions superiors amb millores en espai i comoditats'),(3,'Suite','Suites luxoses amb espai ampli i serveis addicionals');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `idClient` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  `cognoms` varchar(100) NOT NULL,
  `data_naixement` date DEFAULT NULL,
  `dni` varchar(15) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `telefon` varchar(20) DEFAULT NULL,
  `carrer` varchar(100) DEFAULT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `pis` varchar(10) DEFAULT NULL,
  `ciutat` varchar(100) DEFAULT NULL,
  `idPais` int DEFAULT NULL,
  `idProvincia` int DEFAULT NULL,
  `codi_postal` varchar(10) DEFAULT NULL,
  `data_actualitzacio` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `actiu` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`idClient`),
  UNIQUE KEY `uk_dni` (`dni`),
  KEY `fk_clients_provincies` (`idPais`,`idProvincia`),
  CONSTRAINT `fk_clients_paisos` FOREIGN KEY (`idPais`) REFERENCES `paisos` (`idPais`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_clients_provincies` FOREIGN KEY (`idPais`, `idProvincia`) REFERENCES `provincies` (`idPais`, `idProvincia`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (1,'Marcos','Padilla Arroyo','1982-10-10','44332211M','marcos@marcos.com','666554433','calle inventada','1','2 4','Martorell',1,1,'08760','2025-05-06 05:55:44',1),(2,'Michael','Knight','1982-10-10','11223344P','michael@knight.kidd','777665544','calle inventada','1','2 4','Martorell',1,1,'08760','2025-05-03 14:12:41',1),(3,'Laura','Escribano Domínguez','1999-05-15','77751457A','laura@gmail.com','661785262','calle inventada 3','2','2 4','Olesa de Montserrat',10,NULL,'08761','2025-05-08 12:26:47',1),(4,'MK','MK','1990-04-01','99887766M',NULL,'666554433','','','','',NULL,NULL,'','2025-05-06 05:55:42',1),(5,'Marcos','Padilla Arroyo','1999-12-12','33221100A','','666554433','','','','',6,NULL,'','2025-05-06 12:06:16',1);
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `habitacions`
--

DROP TABLE IF EXISTS `habitacions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `habitacions` (
  `idHotel` int NOT NULL,
  `numeroHabitacio` int NOT NULL,
  `nomHabitacio` varchar(100) DEFAULT NULL,
  `capacitat` int DEFAULT NULL,
  `idCategoria` int NOT NULL,
  PRIMARY KEY (`idHotel`,`numeroHabitacio`),
  KEY `fk_habitacions_2_idx` (`idCategoria`),
  CONSTRAINT `fk_habitacions_2` FOREIGN KEY (`idCategoria`) REFERENCES `categories` (`idCategoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `habitacions_ibfk_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels` (`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `habitacions`
--

LOCK TABLES `habitacions` WRITE;
/*!40000 ALTER TABLE `habitacions` DISABLE KEYS */;
INSERT INTO `habitacions` VALUES (1,101,'prova1',4,1),(1,102,'prova2',4,1),(1,103,'prova3',4,2),(1,104,'prova4',4,2),(1,105,'prova5',4,3),(1,106,'prova6',4,3),(2,201,'prova1',2,1),(2,202,'prova2',2,1),(2,203,'prova3',2,2),(2,204,'prova4',2,2);
/*!40000 ALTER TABLE `habitacions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotels` (
  `idHotel` int NOT NULL AUTO_INCREMENT,
  `nomHotel` varchar(45) DEFAULT NULL,
  `estrelles` int DEFAULT NULL,
  `idPais` int DEFAULT NULL,
  `idProvincia` int DEFAULT NULL,
  `ciutat` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idHotel`),
  KEY `fk2_idx` (`idPais`,`idProvincia`),
  CONSTRAINT `fk2` FOREIGN KEY (`idPais`, `idProvincia`) REFERENCES `provincies` (`idPais`, `idProvincia`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_hotels_paisos` FOREIGN KEY (`idPais`) REFERENCES `paisos` (`idPais`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotels`
--

LOCK TABLES `hotels` WRITE;
/*!40000 ALTER TABLE `hotels` DISABLE KEYS */;
INSERT INTO `hotels` VALUES (1,'Barcelona',5,1,1,'Barcelona'),(2,'Barcelona - 2',4,1,1,'Barcelona'),(3,'Madrid',2,1,1,'Madrid'),(4,'Madrid - 1',2,1,1,'Madrid'),(5,'Andorra',5,10,NULL,'Andorra');
/*!40000 ALTER TABLE `hotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imatgesCategoria`
--

DROP TABLE IF EXISTS `imatgesCategoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `imatgesCategoria` (
  `idImatge` int NOT NULL AUTO_INCREMENT,
  `idHotel` int NOT NULL,
  `idCategoria` int NOT NULL,
  `rutaImatge` varchar(255) NOT NULL,
  `descripcio` varchar(255) DEFAULT NULL,
  `ordreImatge` int DEFAULT NULL,
  PRIMARY KEY (`idImatge`),
  KEY `idCategoria` (`idCategoria`),
  KEY `idx_hotel_categoria` (`idHotel`,`idCategoria`),
  CONSTRAINT `imatgesCategoria_ibfk_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels` (`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `imatgesCategoria_ibfk_2` FOREIGN KEY (`idCategoria`) REFERENCES `categories` (`idCategoria`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imatgesCategoria`
--

LOCK TABLES `imatgesCategoria` WRITE;
/*!40000 ALTER TABLE `imatgesCategoria` DISABLE KEYS */;
INSERT INTO `imatgesCategoria` VALUES (1,1,1,'images/hoteles/hotel_1/categoria_1/imagen1.png',NULL,1),(2,1,1,'images/hoteles/hotel_1/categoria_1/imagen2.png',NULL,2),(3,1,1,'images/hoteles/hotel_1/categoria_1/imagen3.png',NULL,3),(4,1,2,'images/hoteles/hotel_1/categoria_2/imagen1.png',NULL,1),(5,1,2,'images/hoteles/hotel_1/categoria_2/imagen2.png',NULL,2),(6,1,2,'images/hoteles/hotel_1/categoria_2/imagen3.png',NULL,3),(7,1,3,'images/hoteles/hotel_1/categoria_3/imagen1.png',NULL,1),(8,1,3,'images/hoteles/hotel_1/categoria_3/imagen2.png',NULL,2),(9,1,3,'images/hoteles/hotel_1/categoria_3/imagen3.png',NULL,3);
/*!40000 ALTER TABLE `imatgesCategoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paisos`
--

DROP TABLE IF EXISTS `paisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paisos` (
  `idPais` int NOT NULL AUTO_INCREMENT,
  `pais` varchar(50) NOT NULL,
  `pais_original` varchar(50) NOT NULL,
  PRIMARY KEY (`idPais`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paisos`
--

LOCK TABLES `paisos` WRITE;
/*!40000 ALTER TABLE `paisos` DISABLE KEYS */;
INSERT INTO `paisos` VALUES (1,'España','España'),(2,'Estados Unidos','United States'),(3,'Francia','France'),(4,'Italia','Italia'),(5,'Alemania','Deutschland'),(6,'Afganistán','Afghanistan'),(7,'Islas Aland','Aland Islands'),(8,'Albania','Shqipëri'),(9,'Argelia','Algeria'),(10,'Andorra','Andorra'),(11,'Angola','Angola'),(12,'Antártida','Antarctica'),(13,'Argentina','Argentina'),(14,'Armenia','Armenia'),(15,'Australia','Australia'),(16,'Austria','Osterreich'),(17,'Azerbaiyán','Azerbaijan'),(18,'Bahamas','The Bahamas'),(19,'Baréin','Bahrain'),(20,'Bangladesh','Bangladesh'),(21,'Barbados','Barbados'),(22,'Bielorrusia','Belarus'),(23,'Bélgica','Belgium'),(24,'Belice','Belize'),(25,'Benín','Benin'),(26,'Bután','Bhutan'),(27,'Bolivia','Bolivia'),(28,'Bosnia y Herzegovina','Bosnia and Herzegovina'),(29,'Botsuana','Botswana'),(30,'Brasil','Brazil'),(31,'Brunéi','Brunei'),(32,'Bulgaria','Bulgaria'),(33,'Burkina Faso','Burkina Faso'),(34,'Burundi','Burundi'),(35,'Camboya','Cambodia'),(36,'Camerún','Cameroon'),(37,'Canadá','Canada'),(38,'Cabo Verde','Cape Verde'),(39,'República Centroafricana','Central African Republic'),(40,'Chad','Chad'),(41,'Chile','Chile'),(42,'China','China'),(43,'Colombia','Colombia'),(44,'Comoras','Comoros'),(45,'Congo (Brazzaville)','Congo-Brazzaville'),(46,'Congo (Kinshasa)','Congo-Kinshasa'),(47,'Costa Rica','Costa Rica'),(48,'Croacia','Croatia'),(49,'Cuba','Cuba'),(50,'Chipre','Cyprus'),(51,'República Checa','Czech Republic'),(52,'Dinamarca','Denmark'),(53,'Yibuti','Djibouti'),(54,'Dominica','Dominica'),(55,'República Dominicana','Dominican Republic'),(56,'Ecuador','Ecuador'),(57,'Egipto','Egypt'),(58,'El Salvador','El Salvador'),(59,'Guinea Ecuatorial','Equatorial Guinea'),(60,'Eritrea','Eritrea'),(61,'Estonia','Estonia'),(62,'Etiopía','Ethiopia'),(63,'Fiyi','Fiji'),(64,'Finlandia','Finland'),(65,'Gabón','Gabon'),(66,'Gambia','Gambia'),(67,'Georgia','Georgia'),(68,'Ghana','Ghana'),(69,'Grecia','Greece'),(70,'Granada','Grenada'),(71,'Guatemala','Guatemala'),(72,'Guinea','Guinea'),(73,'Guinea-Bissau','Guinea-Bissau'),(74,'Guyana','Guyana'),(75,'Haití','Haiti'),(76,'Honduras','Honduras'),(77,'Hungría','Hungary'),(78,'Islandia','Iceland'),(79,'India','India'),(80,'Indonesia','Indonesia'),(81,'Irán','Iran'),(82,'Irak','Iraq'),(83,'Irlanda','Ireland'),(84,'Israel','Israel'),(85,'Jamaica','Jamaica'),(86,'Japón','Japan'),(87,'Jordania','Jordan'),(88,'Kazajistán','Kazakhstan'),(89,'Kenia','Kenya'),(90,'Kiribati','Kiribati'),(91,'Corea del Norte','North Korea'),(92,'Corea del Sur','South Korea'),(93,'Kuwait','Kuwait'),(94,'Kirguistán','Kyrgyzstan'),(95,'Laos','Laos'),(96,'Letonia','Latvia'),(97,'Libia','Libya'),(98,'Liechtenstein','Liechtenstein'),(99,'Luxemburgo','Luxembourg'),(100,'Madagascar','Madagascar'),(101,'Malasia','Malaysia'),(102,'Malawi','Malawi'),(103,'Maldivas','Maldives'),(104,'Malí','Mali'),(105,'Malta','Malta'),(106,'Islas Marshall','Marshall Islands'),(107,'Mauritania','Mauritania'),(108,'Mauricio','Mauritius'),(109,'México','Mexico'),(110,'Micronesia','Micronesia'),(111,'Moldavia','Moldova'),(112,'Mónaco','Monaco'),(113,'Mongolia','Mongolia'),(114,'Montenegro','Montenegro'),(115,'Marruecos','Morocco'),(116,'Mozambique','Mozambique'),(117,'Myanmar','Myanmar'),(118,'Namibia','Namibia'),(119,'Nauru','Nauru'),(120,'Nepal','Nepal'),(121,'Países Bajos','Netherlands'),(122,'Nueva Zelanda','New Zealand'),(123,'Nicaragua','Nicaragua'),(124,'Níger','Niger'),(125,'Nigeria','Nigeria'),(126,'Noruega','Norway'),(127,'Omán','Oman'),(128,'Pakistán','Pakistan'),(129,'Palau','Palau'),(130,'Panamá','Panama'),(131,'Papúa Nueva Guinea','Papua New Guinea'),(132,'Paraguay','Paraguay'),(133,'Perú','Peru'),(134,'Filipinas','Philippines'),(135,'Polonia','Poland'),(136,'Portugal','Portugal'),(137,'Qatar','Qatar'),(138,'Rumania','Romania'),(139,'Rusia','Russia'),(140,'Ruanda','Rwanda'),(141,'San Cristóbal y Nieves','Saint Kitts and Nevis'),(142,'Santa Lucía','Saint Lucia'),(143,'San Vicente y las Granadinas','Saint Vincent and the Grenadines'),(144,'Samoa','Samoa'),(145,'San Marino','San Marino'),(146,'Santo Tomé y Príncipe','Sao Tomé and Príncipe'),(147,'Arabia Saudita','Saudi Arabia'),(148,'Senegal','Senegal'),(149,'Serbia','Serbia'),(150,'Seychelles','Seychelles'),(151,'Sierra Leona','Sierra Leone'),(152,'Singapur','Singapore'),(153,'Eslovaquia','Slovakia'),(154,'Eslovenia','Slovenia'),(155,'Islas Salomón','Solomon Islands'),(156,'Somalia','Somalia'),(157,'Sudáfrica','South Africa'),(158,'Sudán','Sudan');
/*!40000 ALTER TABLE `paisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provincies`
--

DROP TABLE IF EXISTS `provincies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provincies` (
  `idProvincia` int NOT NULL AUTO_INCREMENT,
  `idPais` int NOT NULL,
  `provincia` varchar(100) NOT NULL,
  PRIMARY KEY (`idProvincia`),
  UNIQUE KEY `uk_provincia_pais` (`idPais`,`idProvincia`),
  KEY `idx_idPais` (`idPais`),
  CONSTRAINT `provincies_ibfk_1` FOREIGN KEY (`idPais`) REFERENCES `paisos` (`idPais`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provincies`
--

LOCK TABLES `provincies` WRITE;
/*!40000 ALTER TABLE `provincies` DISABLE KEYS */;
INSERT INTO `provincies` VALUES (1,1,'ESPAÑA'),(2,2,'ESTADOS UNIDOS'),(3,3,'FRANCIA'),(4,4,'ITALIA'),(5,5,'ALEMANIA'),(6,6,'AFGANISTÁN'),(7,7,'ISLAS ALAND'),(8,8,'ALBANIA'),(9,9,'ARGELIA'),(10,10,'ANDORRA'),(11,11,'ANGOLA'),(12,12,'ANTÁRTIDA'),(13,13,'ARGENTINA'),(14,14,'ARMENIA'),(15,15,'AUSTRALIA'),(16,16,'AUSTRIA'),(17,17,'AZERBAIYÁN'),(18,18,'BAHAMAS'),(19,19,'BARÉIN'),(20,20,'BANGLADESH'),(21,21,'BARBADOS'),(22,22,'BIELORRUSIA'),(23,23,'BÉLGICA'),(24,24,'BELICE'),(25,25,'BENÍN'),(26,26,'BUTÁN'),(27,27,'BOLIVIA'),(28,28,'BOSNIA Y HERZEGOVINA'),(29,29,'BOTSUANA'),(30,30,'BRASIL'),(31,31,'BRUNÉI'),(32,32,'BULGARIA'),(33,33,'BURKINA FASO'),(34,34,'BURUNDI'),(35,35,'CAMBOYA'),(36,36,'CAMERÚN'),(37,37,'CANADÁ'),(38,38,'CABO VERDE'),(39,39,'REPÚBLICA CENTROAFRICANA'),(40,40,'CHAD'),(41,41,'CHILE'),(42,42,'CHINA'),(43,43,'COLOMBIA'),(44,44,'COMORAS'),(45,45,'CONGO (BRAZZAVILLE)'),(46,46,'CONGO (KINSHASA)'),(47,47,'COSTA RICA'),(48,48,'CROACIA'),(49,49,'CUBA'),(50,50,'CHIPRE'),(51,51,'REPÚBLICA CHECA'),(52,52,'DINAMARCA'),(53,53,'YIBUTI'),(54,54,'DOMINICA'),(55,55,'REPÚBLICA DOMINICANA'),(56,56,'ECUADOR'),(57,57,'EGIPTO'),(58,58,'EL SALVADOR'),(59,59,'GUINEA ECUATORIAL'),(60,60,'ERITREA'),(61,61,'ESTONIA'),(62,62,'ETIOPÍA'),(63,63,'FIYI'),(64,64,'FINLANDIA'),(65,65,'GABÓN'),(66,66,'GAMBIA'),(67,67,'GEORGIA'),(68,68,'GHANA'),(69,69,'GRECIA'),(70,70,'GRANADA'),(71,71,'GUATEMALA'),(72,72,'GUINEA'),(73,73,'GUINEA-BISSAU'),(74,74,'GUYANA'),(75,75,'HAITÍ'),(76,76,'HONDURAS'),(77,77,'HUNGRÍA'),(78,78,'ISLANDIA'),(79,79,'INDIA'),(80,80,'INDONESIA'),(81,81,'IRÁN'),(82,82,'IRAK'),(83,83,'IRLANDA'),(84,84,'ISRAEL'),(85,85,'JAMAICA'),(86,86,'JAPÓN'),(87,87,'JORDANIA'),(88,88,'KAZAJISTÁN'),(89,89,'KENIA'),(90,90,'KIRIBATI'),(91,91,'COREA DEL NORTE'),(92,92,'COREA DEL SUR'),(93,93,'KUWAIT'),(94,94,'KIRGUISTÁN'),(95,95,'LAOS'),(96,96,'LETONIA'),(97,97,'LIBIA'),(98,98,'LIECHTENSTEIN'),(99,99,'LUXEMBURGO'),(100,100,'MADAGASCAR'),(101,101,'MALASIA'),(102,102,'MALAWI'),(103,103,'MALDIVAS'),(104,104,'MALÍ'),(105,105,'MALTA'),(106,106,'ISLAS MARSHALL'),(107,107,'MAURITANIA'),(108,108,'MAURICIO'),(109,109,'MÉXICO'),(110,110,'MICRONESIA'),(111,111,'MOLDAVIA'),(112,112,'MÓNACO'),(113,113,'MONGOLIA'),(114,114,'MONTENEGRO'),(115,115,'MARRUECOS'),(116,116,'MOZAMBIQUE'),(117,117,'MYANMAR'),(118,118,'NAMIBIA'),(119,119,'NAURU'),(120,120,'NEPAL'),(121,121,'PAÍSES BAJOS'),(122,122,'NUEVA ZELANDA'),(123,123,'NICARAGUA'),(124,124,'NÍGER'),(125,125,'NIGERIA'),(126,126,'NORUEGA'),(127,127,'OMÁN'),(128,128,'PAKISTÁN'),(129,129,'PALAU'),(130,130,'PANAMÁ'),(131,131,'PAPÚA NUEVA GUINEA'),(132,132,'PARAGUAY'),(133,133,'PERÚ'),(134,134,'FILIPINAS'),(135,135,'POLONIA'),(136,136,'PORTUGAL'),(137,137,'QATAR'),(138,138,'RUMANIA'),(139,139,'RUSIA'),(140,140,'RUANDA'),(141,141,'SAN CRISTÓBAL Y NIEVES'),(142,142,'SANTA LUCÍA'),(143,143,'SAN VICENTE Y LAS GRANADINAS'),(144,144,'SAMOA'),(145,145,'SAN MARINO'),(146,146,'SANTO TOMÉ Y PRÍNCIPE'),(147,147,'ARABIA SAUDITA'),(148,148,'SENEGAL'),(149,149,'SERBIA'),(150,150,'SEYCHELLES'),(151,151,'SIERRA LEONA'),(152,152,'SINGAPUR'),(153,153,'ESLOVAQUIA'),(154,154,'ESLOVENIA'),(155,155,'ISLAS SALOMÓN'),(156,156,'SOMALIA'),(157,157,'SUDÁFRICA'),(158,158,'SUDÁN');
/*!40000 ALTER TABLE `provincies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserves`
--

DROP TABLE IF EXISTS `reserves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserves` (
  `idHotel` int NOT NULL,
  `numReserva` int NOT NULL,
  `idClient` int DEFAULT NULL,
  `dataInici` date DEFAULT NULL,
  `dataFi` date DEFAULT NULL,
  `codiReserva` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`idHotel`,`numReserva`),
  UNIQUE KEY `codiReserva` (`codiReserva`),
  KEY `fk_Reserva_2_idx` (`idClient`),
  CONSTRAINT `fk_Reserva_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels` (`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Reserva_2` FOREIGN KEY (`idClient`) REFERENCES `clients` (`idClient`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserves`
--

LOCK TABLES `reserves` WRITE;
/*!40000 ALTER TABLE `reserves` DISABLE KEYS */;
/*!40000 ALTER TABLE `reserves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserveshab`
--

DROP TABLE IF EXISTS `reserveshab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserveshab` (
  `idHotel` int NOT NULL,
  `numReserva` int NOT NULL,
  `numHabitacio` int NOT NULL,
  `persones` int DEFAULT NULL,
  PRIMARY KEY (`idHotel`,`numReserva`,`numHabitacio`),
  KEY `fk_detall_1_idx` (`idHotel`,`numHabitacio`),
  CONSTRAINT `fk_detall_1` FOREIGN KEY (`idHotel`, `numHabitacio`) REFERENCES `habitacions` (`idHotel`, `numeroHabitacio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detall_2` FOREIGN KEY (`idHotel`, `numReserva`) REFERENCES `reserves` (`idHotel`, `numReserva`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserveshab`
--

LOCK TABLES `reserveshab` WRITE;
/*!40000 ALTER TABLE `reserveshab` DISABLE KEYS */;
/*!40000 ALTER TABLE `reserveshab` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservesserveis`
--

DROP TABLE IF EXISTS `reservesserveis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservesserveis` (
  `idReservaServei` int NOT NULL AUTO_INCREMENT,
  `idHotel` int NOT NULL,
  `numReserva` int NOT NULL,
  `idServei` int NOT NULL,
  `dia` date DEFAULT NULL,
  `quantitat` int DEFAULT '1',
  `observacions` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idReservaServei`),
  KEY `idx_hotel_numReserva` (`idHotel`,`numReserva`),
  KEY `idx_hotel_servei` (`idHotel`,`idServei`),
  CONSTRAINT `fk_reserserv_1` FOREIGN KEY (`idHotel`, `idServei`) REFERENCES `serveishotels` (`idHotel`, `idServei`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reserserv_2` FOREIGN KEY (`idHotel`, `numReserva`) REFERENCES `reserves` (`idHotel`, `numReserva`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservesserveis`
--

LOCK TABLES `reservesserveis` WRITE;
/*!40000 ALTER TABLE `reservesserveis` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservesserveis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serveis`
--

DROP TABLE IF EXISTS `serveis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `serveis` (
  `idServei` int NOT NULL AUTO_INCREMENT,
  `nomServei` varchar(100) NOT NULL,
  `descripcio` text,
  `disponible` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`idServei`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serveis`
--

LOCK TABLES `serveis` WRITE;
/*!40000 ALTER TABLE `serveis` DISABLE KEYS */;
INSERT INTO `serveis` VALUES (1,'Sólo Alojamiento',NULL,1),(2,'Alojamiento y desayuno',NULL,1),(3,'Media pesión',NULL,1),(4,'Pensión completa',NULL,1);
/*!40000 ALTER TABLE `serveis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serveishotels`
--

DROP TABLE IF EXISTS `serveishotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `serveishotels` (
  `idHotel` int NOT NULL,
  `idServei` int NOT NULL,
  `preu` decimal(10,2) DEFAULT '0.00',
  `disponible` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`idHotel`,`idServei`),
  KEY `fk_s_2_idx` (`idServei`),
  CONSTRAINT `fk_s_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels` (`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_s_2` FOREIGN KEY (`idServei`) REFERENCES `serveis` (`idServei`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serveishotels`
--

LOCK TABLES `serveishotels` WRITE;
/*!40000 ALTER TABLE `serveishotels` DISABLE KEYS */;
INSERT INTO `serveishotels` VALUES (1,1,0.00,1),(1,2,6.00,1),(1,3,15.00,1),(1,4,30.00,1),(2,1,0.00,1);
/*!40000 ALTER TABLE `serveishotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifes`
--

DROP TABLE IF EXISTS `tarifes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifes` (
  `idHotel` int NOT NULL,
  `idCategoria` int NOT NULL,
  `idTemporada` int NOT NULL,
  `preu` decimal(10,2) NOT NULL,
  PRIMARY KEY (`idHotel`,`idCategoria`,`idTemporada`),
  KEY `idCategoria` (`idCategoria`),
  KEY `idTemporada` (`idTemporada`),
  CONSTRAINT `tarifes_ibfk_1` FOREIGN KEY (`idHotel`) REFERENCES `hotels` (`idHotel`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tarifes_ibfk_2` FOREIGN KEY (`idCategoria`) REFERENCES `categories` (`idCategoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tarifes_ibfk_3` FOREIGN KEY (`idTemporada`) REFERENCES `temporades` (`idTemporada`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifes`
--

LOCK TABLES `tarifes` WRITE;
/*!40000 ALTER TABLE `tarifes` DISABLE KEYS */;
INSERT INTO `tarifes` VALUES (1,1,2,80.00),(1,2,2,100.00),(1,3,2,120.00),(2,1,2,60.00),(2,2,2,75.00),(2,3,2,90.00);
/*!40000 ALTER TABLE `tarifes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temporades`
--

DROP TABLE IF EXISTS `temporades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temporades` (
  `idTemporada` int NOT NULL AUTO_INCREMENT,
  `nom` enum('baja','media','alta') NOT NULL,
  `dataInici` date NOT NULL,
  `dataFi` date NOT NULL,
  PRIMARY KEY (`idTemporada`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporades`
--

LOCK TABLES `temporades` WRITE;
/*!40000 ALTER TABLE `temporades` DISABLE KEYS */;
INSERT INTO `temporades` VALUES (1,'baja','2024-01-10','2024-03-31'),(2,'media','2025-04-01','2025-06-30'),(3,'alta','2024-07-01','2024-09-30'),(4,'media','2024-10-01','2024-12-20'),(5,'alta','2024-12-21','2024-12-31');
/*!40000 ALTER TABLE `temporades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuaris`
--

DROP TABLE IF EXISTS `usuaris`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuaris` (
  `idUsuari` int NOT NULL AUTO_INCREMENT,
  `idClient` int DEFAULT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  `email` varchar(100) NOT NULL,
  `rol` enum('usuari','administrador') NOT NULL DEFAULT 'usuari',
  `actiu` tinyint(1) DEFAULT '1',
  `deleted_at` datetime DEFAULT NULL,
  `data_creacio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idUsuari`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  KEY `fk_usuaris_client` (`idClient`),
  CONSTRAINT `fk_usuaris_client` FOREIGN KEY (`idClient`) REFERENCES `clients` (`idClient`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuaris`
--

LOCK TABLES `usuaris` WRITE;
/*!40000 ALTER TABLE `usuaris` DISABLE KEYS */;
INSERT INTO `usuaris` VALUES (1,NULL,'prova','$2b$10$BU6QLGLZeNR/kXWp3.BgfuWfmz2r9Z/pnHX7F5ysSgVtw8TqVYT7e','usuario@example.com','usuari',1,NULL,'2025-02-21 16:28:56'),(2,NULL,'admin','$2b$10$CGXPRqj5cOEo7y.iJfBDKOOqWVAthbq2fXkfZHHplgjZ6KsO7rnqS','admin@admin.com','administrador',1,NULL,'2025-03-07 15:38:15'),(3,1,'Marcos','$2b$10$esuvOWo6f32HMTkeE2q41.J2axn0DC/Gy7RIJYZtuWOodCw.Z6r7u','marcos@marcos.com','usuari',1,NULL,'2025-03-21 20:00:30'),(4,2,'m','$2b$10$/T1fUAq.71ySn0M5c7rXKu8aD8L7karVZe./CZNiAY0u/e7863PN2','michael@knight.kidd','usuari',1,NULL,'2025-03-25 10:34:45'),(5,3,'Laura','$2b$10$Ca7xfqH8ukdSSetgEWkjjullkl.L9uC6WQqks3H2WFPRLEO1aSMeu','laura@gmail.com','usuari',1,NULL,'2025-03-25 15:00:14'),(6,4,NULL,'$2b$10$FbIDqzabEup9zDQu/azlpOqbZQs.PtF72i7ZzGaSZUsFF6lrk8Ji6','mk@mk.com','usuari',1,NULL,'2025-04-20 20:11:35'),(7,5,NULL,'$2b$10$a9iTHg/yVJwE2118dhSKzOmLUfnDEbsaalBtNLVScL9kyTk0ytENi','roni@coleman.us','usuari',1,NULL,'2025-04-21 20:09:09');
/*!40000 ALTER TABLE `usuaris` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-08 19:15:41

CREATE DATABASE  IF NOT EXISTS `db_almoco_missionario` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_almoco_missionario`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: db_almoco_missionario
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add pessoa',8,'add_pessoa'),(26,'Can change pessoa',8,'change_pessoa'),(27,'Can delete pessoa',8,'delete_pessoa'),(28,'Can view pessoa',8,'view_pessoa'),(29,'Can add dia almoco',7,'add_diaalmoco'),(30,'Can change dia almoco',7,'change_diaalmoco'),(31,'Can delete dia almoco',7,'delete_diaalmoco'),(32,'Can view dia almoco',7,'view_diaalmoco');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1200000$7W86sIWvYNkQGih7GdY7Ku$RRxpjOKKHl/UOiGHBN+qUaQHV1+tP4fETLAJyBo49dA=',NULL,1,'fernando','','','',1,1,'2026-01-27 05:16:33.254588');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dia_almoco`
--

DROP TABLE IF EXISTS `dia_almoco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dia_almoco` (
  `id_dia_almoco` int NOT NULL AUTO_INCREMENT,
  `dia` date NOT NULL,
  `pessoa_id_pessoa` int NOT NULL,
  PRIMARY KEY (`id_dia_almoco`),
  KEY `fk_dia_almoço_pessoa_idx` (`pessoa_id_pessoa`),
  CONSTRAINT `fk_dia_almoço_pessoa` FOREIGN KEY (`pessoa_id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dia_almoco`
--

LOCK TABLES `dia_almoco` WRITE;
/*!40000 ALTER TABLE `dia_almoco` DISABLE KEYS */;
/*!40000 ALTER TABLE `dia_almoco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(7,'app_almoco','diaalmoco'),(8,'app_almoco','pessoa'),(2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-01-27 04:37:55.562429'),(2,'auth','0001_initial','2026-01-27 04:37:57.231973'),(3,'admin','0001_initial','2026-01-27 04:37:57.572830'),(4,'admin','0002_logentry_remove_auto_add','2026-01-27 04:37:57.594830'),(5,'admin','0003_logentry_add_action_flag_choices','2026-01-27 04:37:57.604830'),(6,'app_almoco','0001_initial','2026-01-27 04:37:57.896306'),(7,'contenttypes','0002_remove_content_type_name','2026-01-27 04:37:58.106330'),(8,'auth','0002_alter_permission_name_max_length','2026-01-27 04:37:58.254742'),(9,'auth','0003_alter_user_email_max_length','2026-01-27 04:37:58.400844'),(10,'auth','0004_alter_user_username_opts','2026-01-27 04:37:58.409841'),(11,'auth','0005_alter_user_last_login_null','2026-01-27 04:37:58.522187'),(12,'auth','0006_require_contenttypes_0002','2026-01-27 04:37:58.530572'),(13,'auth','0007_alter_validators_add_error_messages','2026-01-27 04:37:58.539979'),(14,'auth','0008_alter_user_username_max_length','2026-01-27 04:37:58.683858'),(15,'auth','0009_alter_user_last_name_max_length','2026-01-27 04:37:58.824861'),(16,'auth','0010_alter_group_name_max_length','2026-01-27 04:37:58.975312'),(17,'auth','0011_update_proxy_permissions','2026-01-27 04:37:58.985865'),(18,'auth','0012_alter_user_first_name_max_length','2026-01-27 04:37:59.120635'),(19,'sessions','0001_initial','2026-01-27 04:37:59.208533');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('34lvnsk4y2bd2wd41cd2fqq5qbe32u7h','eyJwZXNzb2FfaWQiOjEsInBlc3NvYV9uYW1lIjoiRmVybmFuZG8gRnJlaXRhcyJ9:1vkcGW:SOPrPvYK78rs_VtE3lrBq9idxbexQDoCZFuWA2y04pA','2026-02-10 06:09:28.428780');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa`
--

DROP TABLE IF EXISTS `pessoa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa` (
  `id_pessoa` int NOT NULL AUTO_INCREMENT,
  `nome_completo` varchar(45) NOT NULL,
  `telefone` varchar(45) NOT NULL,
  PRIMARY KEY (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa`
--

LOCK TABLES `pessoa` WRITE;
/*!40000 ALTER TABLE `pessoa` DISABLE KEYS */;
INSERT INTO `pessoa` VALUES (1,'Fernando Freitas','(91) 98471-1434');
/*!40000 ALTER TABLE `pessoa` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-27  3:13:08


-- ------------------------------------------------------
-- PARA POSTGRESQL / SUPABASE
-- ------------------------------------------------------



-- Configurações iniciais de schema (Opcional no Supabase, que usa 'public' por padrão)
-- DROP SCHEMA IF EXISTS public CASCADE;
-- CREATE SCHEMA public;

-- -- ------------------------------------------------------
-- -- Table structure for table django_content_type
-- -- ------------------------------------------------------
-- CREATE TABLE django_content_type (
--   id SERIAL PRIMARY KEY,
--   app_label varchar(100) NOT NULL,
--   model varchar(100) NOT NULL,
--   CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model)
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table auth_permission
-- -- ------------------------------------------------------
-- CREATE TABLE auth_permission (
--   id SERIAL PRIMARY KEY,
--   name varchar(255) NOT NULL,
--   content_type_id int NOT NULL,
--   codename varchar(100) NOT NULL,
--   CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename),
--   CONSTRAINT auth_permission_content_type_id_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type (id)
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table auth_group
-- -- ------------------------------------------------------
-- CREATE TABLE auth_group (
--   id SERIAL PRIMARY KEY,
--   name varchar(150) NOT NULL UNIQUE
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table auth_group_permissions
-- -- ------------------------------------------------------
-- CREATE TABLE auth_group_permissions (
--   id BIGSERIAL PRIMARY KEY,
--   group_id int NOT NULL,
--   permission_id int NOT NULL,
--   CONSTRAINT auth_group_permissions_group_id_permission_id_uniq UNIQUE (group_id, permission_id),
--   CONSTRAINT auth_group_permissions_group_id_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group (id),
--   CONSTRAINT auth_group_permissio_permission_id_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES auth_permission (id)
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table auth_user
-- -- ------------------------------------------------------
-- CREATE TABLE auth_user (
--   id SERIAL PRIMARY KEY,
--   password varchar(128) NOT NULL,
--   last_login timestamptz DEFAULT NULL,
--   is_superuser boolean NOT NULL,
--   username varchar(150) NOT NULL UNIQUE,
--   first_name varchar(150) NOT NULL,
--   last_name varchar(150) NOT NULL,
--   email varchar(254) NOT NULL,
--   is_staff boolean NOT NULL,
--   is_active boolean NOT NULL,
--   date_joined timestamptz NOT NULL
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table auth_user_groups
-- -- ------------------------------------------------------
-- CREATE TABLE auth_user_groups (
--   id BIGSERIAL PRIMARY KEY,
--   user_id int NOT NULL,
--   group_id int NOT NULL,
--   CONSTRAINT auth_user_groups_user_id_group_id_uniq UNIQUE (user_id, group_id),
--   CONSTRAINT auth_user_groups_user_id_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user (id),
--   CONSTRAINT auth_user_groups_group_id_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group (id)
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table auth_user_user_permissions
-- -- ------------------------------------------------------
-- CREATE TABLE auth_user_user_permissions (
--   id BIGSERIAL PRIMARY KEY,
--   user_id int NOT NULL,
--   permission_id int NOT NULL,
--   CONSTRAINT auth_user_user_permissions_user_id_permission_id_uniq UNIQUE (user_id, permission_id),
--   CONSTRAINT auth_user_user_permissions_user_id_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user (id),
--   CONSTRAINT auth_user_user_permi_permission_id_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES auth_permission (id)
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table pessoa
-- -- ------------------------------------------------------
-- CREATE TABLE pessoa (
--   id_pessoa SERIAL PRIMARY KEY,
--   nome_completo varchar(45) NOT NULL,
--   telefone varchar(45) NOT NULL
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table dia_almoco
-- -- ------------------------------------------------------
-- CREATE TABLE dia_almoco (
--   id_dia_almoco SERIAL PRIMARY KEY,
--   dia date NOT NULL,
--   pessoa_id_pessoa int NOT NULL,
--   CONSTRAINT fk_dia_almoco_pessoa FOREIGN KEY (pessoa_id_pessoa) REFERENCES pessoa (id_pessoa)
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table django_admin_log
-- -- ------------------------------------------------------
-- CREATE TABLE django_admin_log (
--   id SERIAL PRIMARY KEY,
--   action_time timestamptz NOT NULL,
--   object_id text,
--   object_repr varchar(200) NOT NULL,
--   action_flag smallint NOT NULL CHECK (action_flag >= 0),
--   change_message text NOT NULL,
--   content_type_id int DEFAULT NULL,
--   user_id int NOT NULL,
--   CONSTRAINT django_admin_log_content_type_id_fk_django_co FOREIGN KEY (content_type_id) REFERENCES django_content_type (id),
--   CONSTRAINT django_admin_log_user_id_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user (id)
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table django_migrations
-- -- ------------------------------------------------------
-- CREATE TABLE django_migrations (
--   id BIGSERIAL PRIMARY KEY,
--   app varchar(255) NOT NULL,
--   name varchar(255) NOT NULL,
--   applied timestamptz NOT NULL
-- );

-- -- ------------------------------------------------------
-- -- Table structure for table django_session
-- -- ------------------------------------------------------
-- CREATE TABLE django_session (
--   session_key varchar(40) PRIMARY KEY,
--   session_data text NOT NULL,
--   expire_date timestamptz NOT NULL
-- );
-- CREATE INDEX django_session_expire_date_idx ON django_session (expire_date);

-- -- ------------------------------------------------------
-- -- DADOS INICIAIS (INSERTs)
-- -- ------------------------------------------------------

-- INSERT INTO django_content_type (id, app_label, model) VALUES 
-- (1,'admin','logentry'),(7,'app_almoco','diaalmoco'),(8,'app_almoco','pessoa'),
-- (2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),
-- (5,'contenttypes','contenttype'),(6,'sessions','session');

-- INSERT INTO auth_permission (id, name, content_type_id, codename) VALUES 
-- (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),
-- (3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),
-- (5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),
-- (7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),
-- (9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),
-- (11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),
-- (13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),
-- (15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),
-- (17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),
-- (19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),
-- (21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),
-- (23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),
-- (25,'Can add pessoa',8,'add_pessoa'),(26,'Can change pessoa',8,'change_pessoa'),
-- (27,'Can delete pessoa',8,'delete_pessoa'),(28,'Can view pessoa',8,'view_pessoa'),
-- (29,'Can add dia almoco',7,'add_diaalmoco'),(30,'Can change dia almoco',7,'change_diaalmoco'),
-- (31,'Can delete dia almoco',7,'delete_diaalmoco'),(32,'Can view dia almoco',7,'view_diaalmoco');

-- INSERT INTO auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) VALUES 
-- (1,'pbkdf2_sha256$1200000$7W86sIWvYNkQGih7GdY7Ku$RRxpjOKKHl/UOiGHBN+qUaQHV1+tP4fETLAJyBo49dA=', NULL, TRUE, 'fernando', '', '', '', TRUE, TRUE, '2026-01-27 05:16:33.254588+00');

-- INSERT INTO pessoa (id_pessoa, nome_completo, telefone) VALUES 
-- (1,'Fernando Freitas','(91) 98471-1434');

-- -- Ajuste das sequências (Necessário no Postgres após inserts manuais com ID)
-- SELECT setval('django_content_type_id_seq', (SELECT MAX(id) FROM django_content_type));
-- SELECT setval('auth_permission_id_seq', (SELECT MAX(id) FROM auth_permission));
-- SELECT setval('auth_user_id_seq', (SELECT MAX(id) FROM auth_user));
-- SELECT setval('pessoa_id_pessoa_seq', (SELECT MAX(id_pessoa) FROM pessoa));
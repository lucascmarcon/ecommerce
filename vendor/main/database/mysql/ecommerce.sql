
USE ecommerce;

SET FOREIGN_KEY_CHECKS = 0;

/*´
                                            ------ persons
                                            |        |
                                            |        |
                                        addresses    |
                                            |        | ------------ userslogs
                                            |        | |
                                 ------------        | |
                                 |                   | |
                               carts -------------- users -------------- userspasswordsrecoveries
                                | |                   |
                                | ---------- ----------
                                |          | |
                                |          | |
                                |        orders ------------ ordersstatus
                                |
                                |
                          cartsproducts ------------ products
                                                         |
                                                         |
                                                 productscategories
                                                         |
                                                         |
                                                     categories
*/

DROP TABLE IF EXISTS `persons`;
CREATE TABLE `persons` (
`idperson`                  INT(11) NOT NULL AUTO_INCREMENT,
`name`                      VARCHAR(64) NOT NULL,
`email`                     VARCHAR(128) DEFAULT NULL,
`phone`                     BIGINT(20) DEFAULT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_persons_idperson` PRIMARY KEY (`idperson`))
ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `persons` VALUES (1,'Lucas','admin@email',2147483647,'2017-03-01 03:00:00'),(7,'Suporte','suporte@hcode.com.br',1112345678,'2017-03-15 16:10:27');




DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
`iduser`                    INT(11) NOT NULL AUTO_INCREMENT,
`idperson`                  INT(11) NOT NULL,
`login`                     VARCHAR(64) NOT NULL,
`password`                  VARCHAR(256) NOT NULL,
`isadmin`                   TINYINT(4) NOT NULL DEFAULT '0',
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_users_iduser` PRIMARY KEY (`iduser`),
KEY `k_users_idperson_index` (`idperson`),
CONSTRAINT `fk_users_idperson` FOREIGN KEY (`idperson`) REFERENCES `persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION )
ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `userslogs`;
CREATE TABLE `userslogs` (
`iduserlog`                 INT(11) NOT NULL AUTO_INCREMENT,
`iduser`                    INT(11) NOT NULL,
`log`                       VARCHAR(256) NOT NULL,
`ip`                        VARCHAR(64) NOT NULL,
`useragent`                 VARCHAR(128) NOT NULL,
`sessionid`                 VARCHAR(128) NOT NULL,
`url`                       VARCHAR(512) NOT NULL,
`register`                  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_userslogs_iduserlog` PRIMARY KEY (`iduserlog`),
KEY `k_userslogs_iduser_index` (`iduser`),
CONSTRAINT `fk_userslogs_iduser` FOREIGN KEY (`iduser`) REFERENCES `users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION )
ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `userspasswordsrecoveries`;
CREATE TABLE `userspasswordsrecoveries` (
`iduserpasswordrecovery`    INT(11) NOT NULL AUTO_INCREMENT,
`iduser`                    INT(11) NOT NULL,
`ip`                        VARCHAR(64) NOT NULL,
`daterecovery`              DATETIME DEFAULT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_userspasswordsrecoveries_iduserpasswordrecovery` PRIMARY KEY (`iduserpasswordrecovery`),
KEY `k_userspasswordsrecoveries_iduser_index` (`iduser`),
CONSTRAINT `fk_userspasswordsrecoveries_iduser` FOREIGN KEY (`iduser`) REFERENCES `users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION )
ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
`idaddress`                 INT(11) NOT NULL AUTO_INCREMENT,
`idperson`                  INT(11) NOT NULL,
`address`                   VARCHAR(128) NOT NULL,
`complement`                VARCHAR(32) DEFAULT NULL,
`city`                      VARCHAR(32) NOT NULL,
`estate`                    VARCHAR(32) NOT NULL,
`country`                   VARCHAR(32) NOT NULL,
`zipcode`                   INT(11) NOT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_addresses_idaddress` PRIMARY KEY (`idaddress`),
KEY `k_addresses_idperson_index` (`idperson`),
CONSTRAINT `fk_addresses_idperson` FOREIGN KEY (`idperson`) REFERENCES `persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION )
ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts` (
`idcart`                    INT(11) NOT NULL,
`iduser`                    INT(11) DEFAULT NULL,
`idaddress`                 INT(11) DEFAULT NULL,
`sessionid`                 VARCHAR(128) NOT NULL,
`valuefreight`              DECIMAL(10, 2) NOT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_carts_idcart` PRIMARY KEY (`idcart`),
KEY `k_carts_iduser_index` (`iduser`),
KEY `k_carts_idaddress_index` (`idaddress`),
CONSTRAINT `fk_carts_iduser` FOREIGN KEY (`iduser`) REFERENCES `users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT `fk_carts_idaddress` FOREIGN KEY (`idaddress`) REFERENCES `addresses` (`idaddress`) ON DELETE NO ACTION ON UPDATE NO ACTION )
ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ordersstatus`;
CREATE TABLE `ordersstatus` (
`idorderstatus`             INT(11) NOT NULL AUTO_INCREMENT,
`status`                    VARCHAR(32) NOT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_orderstatus_idorderstatus` PRIMARY KEY (`idorderstatus`))
ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
`idorder`                   INT(11) NOT NULL AUTO_INCREMENT,
`idcart`                    INT(11) NOT NULL,
`iduser`                    INT(11) NOT NULL,
`idorderstatus`             INT(11) NOT NULL,
`totalvalue`                DECIMAL(10, 2) NOT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_orders_idorder` PRIMARY KEY (`idorder`),
KEY `k_orders_idcart_index` (`idcart`),
KEY `k_orders_iduser_index` (`iduser`),
KEY `k_orders_idorderstatus_index` (`idorderstatus`),
CONSTRAINT `fk_order_idcart` FOREIGN KEY (`idcart`) REFERENCES `carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT `fk_order_iduser` FOREIGN KEY (`iduser`) REFERENCES `users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT `fk_order_idorderstatus` FOREIGN KEY (`idorderstatus`) REFERENCES `ordersstatus` (`idorderstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION )
ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
`idproduct`                 INT(11) NOT NULL AUTO_INCREMENT,
`description`               VARCHAR(258) NOT NULL,
`price`                     DECIMAL(10, 2) NOT NULL,
`width`                     DECIMAL(10, 2) NOT NULL,
`height`                    DECIMAL(10, 2) NOT NULL,
`length`                    DECIMAL(10, 2) NOT NULL,
`weight`                    DECIMAL(10, 2) NOT NULL,
`url`                       VARCHAR(258) NOT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_products_idproduct` PRIMARY KEY (`idproduct`))
ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cartsproducts`;
CREATE TABLE `cartsproducts` (
`idcartproduct`             INT(11) NOT NULL AUTO_INCREMENT,
`idcart`                    INT(11) NOT NULL,
`idproduct`                 INT(11) NOT NULL,
`dateremoved`               DATETIME NOT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_cartsproducts_idcartproduct` PRIMARY KEY (`idcartproduct`),
KEY `k_cartsproducts_idcart_index` (`idcart`),
KEY `k_cartsproducts_idproduct_index` (`idproduct`),
CONSTRAINT `fk_cartsproducts_idcart` FOREIGN KEY (`idcart`) REFERENCES `carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT `fk_cartsproducts_idproduct` FOREIGN KEY (`idproduct`) REFERENCES `products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION )
ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
`idcategory`                INT(11) NOT NULL AUTO_INCREMENT,
`description`               VARCHAR(258) NOT NULL,
`dateregister`              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT `pk_categories_idcategory` PRIMARY KEY (`idcategory`))
ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `productscategories`;
CREATE TABLE `productscategories` (
`idcategory`                INT(11) NOT NULL,
`idproduct`                 INT(11) NOT NULL,
CONSTRAINT `pk_productscategories_idcategory_idproduct` PRIMARY KEY (`idcategory`, `idproduct`),
KEY `k_productscategories_idcategory_index` (`idcategory`),
KEY `k_productscategories_idproduct_index` (`idproduct`),
CONSTRAINT `fk_productscategories_idcategory` FOREIGN KEY (`idcategory`) REFERENCES `categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT `fk_productscategories_idproduct` FOREIGN KEY (`idproduct`) REFERENCES `products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION )
ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
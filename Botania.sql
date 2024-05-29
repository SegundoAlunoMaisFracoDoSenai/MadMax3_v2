-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema botania
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `botania` DEFAULT CHARACTER SET utf8 ;
USE `botania` ;

-- -----------------------------------------------------
-- Table `botania`.`plantas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `botania`.`plantas` (
  `id_Plantas` INT(11) NOT NULL AUTO_INCREMENT,
  `Valor_Planta` DECIMAL(10,0) NOT NULL,
  `Quantia_Planta` INT NOT NULL,
  `Tipo_Planta` VARCHAR(45) NOT NULL,
  `Porte_Planta` VARCHAR(45) NOT NULL,
  `Especime_Planta` VARCHAR(200) NOT NULL,
  `Cor_Planta` VARCHAR(45) NOT NULL,
  `Desc_Planta` TEXT NOT NULL,
  `Foto1_Planta` BLOB NOT NULL,
  `Foto2_Planta` BLOB NULL,
  `Foto3_Planta` BLOB NULL,
  `Banner1_Planta` BLOB NOT NULL,   
  `Banner2_Planta` BLOB NULL,
  PRIMARY KEY (`id_Plantas`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `botania`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `botania`.`users` (
  `id_Users` INT(11) NOT NULL AUTO_INCREMENT,
  `Nome_User` VARCHAR(50) NOT NULL,
  `Sobrenome_User` VARCHAR(100) NOT NULL,
  `Email_User` VARCHAR(200) NOT NULL UNIQUE,
  `Senha_User` VARCHAR(200) NOT NULL,
  `ADM_User` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id_Users`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `botania`.`vendas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `botania`.`vendas` (
  `id_Vendas` INT(11) NOT NULL AUTO_INCREMENT,
  `Hora_Venda` TIME NOT NULL,
  `Dia_Venda` DATETIME NOT NULL,
  `Valor_Venda` DECIMAL(10,0) NOT NULL,
  `Quantia_Venda` INT NOT NULL,
  `Users_id_Users` INT(11) NOT NULL,
  PRIMARY KEY (`id_Vendas`),
  INDEX `fk_Vendas_Users_idx` (`Users_id_Users` ASC),
  CONSTRAINT `fk_Vendas_Users`
    FOREIGN KEY (`Users_id_Users`)
    REFERENCES `botania`.`users` (`id_Users`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `botania`.`plantas_has_vendas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `botania`.`plantas_has_vendas` (
  `Vendas_id_Vendas` INT(11) NOT NULL,
  `Plantas_id_Plantas` INT(11) NOT NULL,
  PRIMARY KEY (`Vendas_id_Vendas`, `Plantas_id_Plantas`),
  INDEX `fk_Plantas_Plantas1_idx` (`Plantas_id_Plantas` ASC),
  CONSTRAINT `fk_Plantas_Plantas1`
    FOREIGN KEY (`Plantas_id_Plantas`)
    REFERENCES `botania`.`plantas` (`id_Plantas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Plantas_Vendas1`
    FOREIGN KEY (`Vendas_id_Vendas`)
    REFERENCES `botania`.`vendas` (`id_Vendas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- View `botania`.`vw_vendas_com_plantas`
-- -----------------------------------------------------
CREATE OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `botania`.`vw_vendas_com_plantas` AS 
SELECT 
  `v`.`id_Vendas` AS `id_Vendas`,
  `v`.`Hora_Venda` AS `Hora_Venda`,
  `v`.`Dia_Venda` AS `Dia_Venda`,
  `v`.`Valor_Venda` AS `Valor_Venda`,
  `v`.`Quantia_Venda` AS `Quantia_Venda`,
  `u`.`Nome_User` AS `Nome_Vendedor`,
  `p`.`id_Plantas` AS `id_Plantas`,
  `p`.`Tipo_Planta` AS `Tipo_Planta`,
  `p`.`Especime_Planta` AS `Especime_Planta`,
  `p`.`Cor_Planta` AS `Cor_Planta`
FROM 
  `botania`.`vendas` `v`
  JOIN `botania`.`users` `u` ON (`v`.`Users_id_Users` = `u`.`id_Users`)
  JOIN `botania`.`plantas_has_vendas` `phv` ON (`v`.`id_Vendas` = `phv`.`Vendas_id_Vendas`)
  JOIN `botania`.`plantas` `p` ON (`phv`.`Plantas_id_Plantas` = `p`.`id_Plantas`);


DELIMITER $$

USE `botania`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `botania`.`atualizar_estoque`
AFTER INSERT ON `botania`.`vendas`
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE planta_id INT;
    DECLARE quantidade_vendida INT;
    DECLARE cur CURSOR FOR
    SELECT `Plantas_id_Plantas`, `Quantia_Venda`
    FROM `botania`.`plantas_has_vendas`
    WHERE `Vendas_id_Vendas` = NEW.`id_Vendas`;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO planta_id, quantidade_vendida;
        IF done THEN
            LEAVE read_loop;
        END IF;
        UPDATE `botania`.`plantas`
        SET `Quantia_Planta` = `Quantia_Planta` - quantidade_vendida
        WHERE `id_Plantas` = planta_id;
    END LOOP;
    
    CLOSE cur;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

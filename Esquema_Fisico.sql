-- MySQL Script generated by MySQL Workbench
-- Sun Dec 15 19:10:17 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BD_VOOSOLO
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema BD_VOOSOLO
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BD_VOOSOLO` DEFAULT CHARACTER SET utf8 ;
USE `BD_VOOSOLO` ;

-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`regiao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`regiao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`fuso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`fuso` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `epsg` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`estado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`estado` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `uf` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`cidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`cidade` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NULL,
  `estado_id` INT NOT NULL,
  PRIMARY KEY (`id`, `estado_id`),
  INDEX `fk_cidade_estado1_idx` (`estado_id` ASC) VISIBLE,
  CONSTRAINT `fk_cidade_estado1`
    FOREIGN KEY (`estado_id`)
    REFERENCES `BD_VOOSOLO`.`estado` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`local_levantamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`local_levantamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NULL,
  `data_adesao` DATETIME NULL,
  `cidade_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `cidade_id`),
  INDEX `fk_local_levantamento_cidade1_idx` (`cidade_id` ASC) VISIBLE,
  CONSTRAINT `fk_local_levantamento_cidade1`
    FOREIGN KEY (`cidade_id`)
    REFERENCES `BD_VOOSOLO`.`cidade` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`vetor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`vetor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tipo_geometria` GEOMETRY NOT NULL,
  `data_inclusao` DATETIME NOT NULL,
  `local_levantamento_id` INT NOT NULL,
  `local_levantamento_cidade_id` INT UNSIGNED NOT NULL,
  `faixa_duto_vetor_id` INT NOT NULL,
  PRIMARY KEY (`id`, `local_levantamento_id`, `local_levantamento_cidade_id`, `faixa_duto_vetor_id`),
  INDEX `fk_vetor_local_levantamento1_idx` (`local_levantamento_id` ASC, `local_levantamento_cidade_id` ASC) VISIBLE,
  CONSTRAINT `fk_vetor_local_levantamento1`
    FOREIGN KEY (`local_levantamento_id` , `local_levantamento_cidade_id`)
    REFERENCES `BD_VOOSOLO`.`local_levantamento` (`id` , `cidade_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`raster`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`raster` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `extensao` VARCHAR(45) NOT NULL,
  `data_inclusao` DATETIME NOT NULL,
  `local_levantamento_id` INT NOT NULL,
  `local_levantamento_cidade_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `local_levantamento_id`, `local_levantamento_cidade_id`),
  INDEX `fk_raster_local_levantamento1_idx` (`local_levantamento_id` ASC, `local_levantamento_cidade_id` ASC) VISIBLE,
  CONSTRAINT `fk_raster_local_levantamento1`
    FOREIGN KEY (`local_levantamento_id` , `local_levantamento_cidade_id`)
    REFERENCES `BD_VOOSOLO`.`local_levantamento` (`id` , `cidade_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`edificacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`edificacao` (
  `area` DECIMAL NOT NULL,
  `tipo` VARCHAR(45) NULL,
  `num_pavimentos` VARCHAR(45) NULL,
  `vetor_id` INT NOT NULL,
  `vetor_local_levantamento_id` INT NOT NULL,
  `vetor_local_levantamento_cidade_id` INT UNSIGNED NOT NULL,
  `vetor_faixa_duto_vetor_id` INT NOT NULL,
  PRIMARY KEY (`vetor_id`, `vetor_local_levantamento_id`, `vetor_local_levantamento_cidade_id`, `vetor_faixa_duto_vetor_id`),
  CONSTRAINT `fk_edificacao_vetor1`
    FOREIGN KEY (`vetor_id` , `vetor_local_levantamento_id` , `vetor_local_levantamento_cidade_id` , `vetor_faixa_duto_vetor_id`)
    REFERENCES `BD_VOOSOLO`.`vetor` (`id` , `local_levantamento_id` , `local_levantamento_cidade_id` , `faixa_duto_vetor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`gasoduto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`gasoduto` (
  `km` VARCHAR(10) NULL,
  `tipo` VARCHAR(50) NULL,
  `comprimento` DECIMAL NULL,
  `vetor_id` INT NOT NULL,
  `vetor_local_levantamento_id` INT NOT NULL,
  `vetor_local_levantamento_cidade_id` INT UNSIGNED NOT NULL,
  `vetor_faixa_duto_vetor_id` INT NOT NULL,
  PRIMARY KEY (`vetor_id`, `vetor_local_levantamento_id`, `vetor_local_levantamento_cidade_id`, `vetor_faixa_duto_vetor_id`),
  CONSTRAINT `fk_gasoduto_vetor1`
    FOREIGN KEY (`vetor_id` , `vetor_local_levantamento_id` , `vetor_local_levantamento_cidade_id` , `vetor_faixa_duto_vetor_id`)
    REFERENCES `BD_VOOSOLO`.`vetor` (`id` , `local_levantamento_id` , `local_levantamento_cidade_id` , `faixa_duto_vetor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`faixa_duto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`faixa_duto` (
  `code` VARCHAR(50) NULL,
  `offset` INT NULL,
  `vetor_id` INT NOT NULL,
  `vetor_local_levantamento_id` INT NOT NULL,
  `vetor_local_levantamento_cidade_id` INT UNSIGNED NOT NULL,
  `vetor_faixa_duto_vetor_id` INT NOT NULL,
  PRIMARY KEY (`vetor_id`, `vetor_local_levantamento_id`, `vetor_local_levantamento_cidade_id`, `vetor_faixa_duto_vetor_id`),
  INDEX `fk_faixa_duto_vetor1_idx` (`vetor_id` ASC, `vetor_local_levantamento_id` ASC, `vetor_local_levantamento_cidade_id` ASC, `vetor_faixa_duto_vetor_id` ASC) VISIBLE,
  CONSTRAINT `fk_faixa_duto_vetor1`
    FOREIGN KEY (`vetor_id` , `vetor_local_levantamento_id` , `vetor_local_levantamento_cidade_id` , `vetor_faixa_duto_vetor_id`)
    REFERENCES `BD_VOOSOLO`.`vetor` (`id` , `local_levantamento_id` , `local_levantamento_cidade_id` , `faixa_duto_vetor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`ortomosaico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`ortomosaico` (
  `gsd` VARCHAR(15) NULL,
  `raster_id` INT NOT NULL,
  PRIMARY KEY (`raster_id`),
  CONSTRAINT `fk_ortomosaico_raster1`
    FOREIGN KEY (`raster_id`)
    REFERENCES `BD_VOOSOLO`.`raster` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`modelo_digital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`modelo_digital` (
  `mdt` VARCHAR(250) NULL,
  `mds` VARCHAR(250) NULL,
  `raster_id` INT NOT NULL,
  PRIMARY KEY (`raster_id`),
  CONSTRAINT `fk_modelo_digital_raster1`
    FOREIGN KEY (`raster_id`)
    REFERENCES `BD_VOOSOLO`.`raster` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`fuso_has_regiao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`fuso_has_regiao` (
  `fuso_id` INT NOT NULL,
  `regioes_id` INT NOT NULL,
  INDEX `fk_fuso_has_regioes_regioes1_idx` (`regioes_id` ASC) VISIBLE,
  INDEX `fk_fuso_has_regioes_fuso1_idx` (`fuso_id` ASC) VISIBLE,
  PRIMARY KEY (`fuso_id`, `regioes_id`),
  CONSTRAINT `fk_fuso_has_regioes_fuso1`
    FOREIGN KEY (`fuso_id`)
    REFERENCES `BD_VOOSOLO`.`fuso` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fuso_has_regioes_regioes1`
    FOREIGN KEY (`regioes_id`)
    REFERENCES `BD_VOOSOLO`.`regiao` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD_VOOSOLO`.`estado_has_fuso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD_VOOSOLO`.`estado_has_fuso` (
  `estado_id` INT NOT NULL,
  `fuso_id` INT NOT NULL,
  PRIMARY KEY (`estado_id`, `fuso_id`),
  INDEX `fk_estado_has_fuso_fuso1_idx` (`fuso_id` ASC) VISIBLE,
  INDEX `fk_estado_has_fuso_estado1_idx` (`estado_id` ASC) VISIBLE,
  CONSTRAINT `fk_estado_has_fuso_estado1`
    FOREIGN KEY (`estado_id`)
    REFERENCES `BD_VOOSOLO`.`estado` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estado_has_fuso_fuso1`
    FOREIGN KEY (`fuso_id`)
    REFERENCES `BD_VOOSOLO`.`fuso` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

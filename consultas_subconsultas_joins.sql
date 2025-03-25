CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`perfil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`perfil` (
  `ID_PERFIL` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico del perfil en la base de datos de perfiles',
  `NOMBRE` VARCHAR(45) NOT NULL COMMENT 'Nombre del perfil',
  `CORREO` VARCHAR(45) NOT NULL COMMENT 'Corre del perfil',
  `FOTO` VARCHAR(45) NOT NULL COMMENT 'Url de la foto del perfil',
  `CONTRASENA` VARCHAR(45) NOT NULL COMMENT 'Contrasena del perfil',
  PRIMARY KEY (`ID_PERFIL`));


-- -----------------------------------------------------
-- Table `mydb`.`administrador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`administrador` (
  `ID_ADMINISTRADOR` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id del administrador, brinda una diferencia entre el perfil general, y el perfil de administrador',
  `ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_ADMINISTRADOR`, `ID_PERFIL`),
  INDEX `fk_administrador_perfil1_idx` (`ID_PERFIL` ASC),
  CONSTRAINT `fk_administrador_perfil1`
    FOREIGN KEY (`ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));


-- -----------------------------------------------------
-- Table `mydb`.`gerente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`gerente` (
  `ID_GERENTE` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico de los perfiles de gerente',
  `ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_GERENTE`, `ID_PERFIL`),
  INDEX `fk_gerente_perfil1_idx` (`ID_PERFIL` ASC) ,
  CONSTRAINT `fk_gerente_perfil1`
    FOREIGN KEY (`ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));


-- -----------------------------------------------------
-- Table `mydb`.`mesa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`mesa` (
  `ID_MESA` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificadror unico de la mesa',
  `NUMERO` VARCHAR(10) NOT NULL COMMENT 'Numero con el que se identifica la mesa',
  `SILLAS` VARCHAR(10) NOT NULL COMMENT 'Numero de sillas que posee la mesa',
  `ADMINISTRADOR_ID_ADMINISTRADOR` INT(11) NOT NULL COMMENT 'Llave foranea que conecta al administrador con las multiples reseravas',
  PRIMARY KEY (`ID_MESA`, `ADMINISTRADOR_ID_ADMINISTRADOR`),
  INDEX `fk_MESA_ADMINISTRADOR1_idx` (`ADMINISTRADOR_ID_ADMINISTRADOR` ASC) ,
  CONSTRAINT `fk_MESA_ADMINISTRADOR1`
    FOREIGN KEY (`ADMINISTRADOR_ID_ADMINISTRADOR`)
    REFERENCES `mydb`.`administrador` (`ID_ADMINISTRADOR`));



-- -----------------------------------------------------
-- Table `mydb`.`recepcionista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`recepcionista` (
  `ID_RECEPCIONISTA` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id que diferencia a los tipos de perfil de recepcionistas',
  `ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_RECEPCIONISTA`, `ID_PERFIL`),
  INDEX `fk_recepcionista_perfil1_idx` (`ID_PERFIL` ASC) ,
  CONSTRAINT `fk_recepcionista_perfil1`
    FOREIGN KEY (`ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));
-- -----------------------------------------------------
-- Table `mydb`.`reporte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`reporte` (
  `ID_REPORTE` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico del reporte',
  `FECHA` DATETIME NOT NULL COMMENT 'Fecha en la que se genero el reporte, tiene un limite de uno por mes por cuestiones de almacenamiento',
  `URL` VARCHAR(45) NOT NULL COMMENT 'Url de donde se almaceno el reporte',
  `ID_GERENTE` INT(11) NOT NULL COMMENT 'Id del gerente que genero el reporte',
  PRIMARY KEY (`ID_REPORTE`, `ID_GERENTE`),
  INDEX `fk_REPORTE_GERENTE1_idx` (`ID_GERENTE` ASC) ,
  CONSTRAINT `fk_REPORTE_GERENTE1`
    FOREIGN KEY (`ID_GERENTE`)
    REFERENCES `mydb`.`gerente` (`ID_GERENTE`));

-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `ID_USUARIO` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Id del usuario , separa a todos los periles de tipo usuario',
  `ID_PERFIL` INT(11) NOT NULL,
  PRIMARY KEY (`ID_USUARIO`, `ID_PERFIL`),
  UNIQUE INDEX `idtable1_UNIQUE` (`ID_USUARIO` ASC) ,
  INDEX `fk_usuario_perfil1_idx` (`ID_PERFIL` ASC) ,
  CONSTRAINT `fk_usuario_perfil1`
    FOREIGN KEY (`ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));

-- -----------------------------------------------------
-- Table `mydb`.`reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`reserva` (
  `ID_RESERVA` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador unico de la reserva',
  `ID_USUARIO` INT(11) NOT NULL COMMENT 'Id del usuario que realiza la reserva',
  `ID_MESA` INT(11) NOT NULL COMMENT 'Identificador unico de la mesa',
  `FECHA` DATETIME NOT NULL COMMENT 'Fecha en la que se llevara a cabo la reserva',
  `HORA_INICIO` DATETIME NOT NULL COMMENT 'Hora en la que inicia la reserva, despues de trancuridos 15 minutos se libera para el uso libre',
  `HORA_FINAL` DATETIME NOT NULL COMMENT 'La hora en la que termina la reserva, se tiene planes a futuro de  implementar una notificacion  para que avise al usuario para que se prepare con quince minutos de antelacion',
  `ID_RECEPCIONISTA` INT(11) NOT NULL COMMENT 'Id del recepcioista que confirma el uso de la reserva',
  PRIMARY KEY (`ID_RESERVA`, `ID_USUARIO`, `ID_MESA`, `ID_RECEPCIONISTA`),
  INDEX `fk_USUARIO_has_MESA_MESA1_idx` (`ID_MESA` ASC) ,
  INDEX `fk_USUARIO_has_MESA_USUARIO_idx` (`ID_USUARIO` ASC) ,
  INDEX `fk_RESERVA_RECEPCIONISTA1_idx` (`ID_RECEPCIONISTA` ASC),
  CONSTRAINT `fk_RESERVA_RECEPCIONISTA1`
    FOREIGN KEY (`ID_RECEPCIONISTA`)
    REFERENCES `mydb`.`recepcionista` (`ID_RECEPCIONISTA`),
  CONSTRAINT `fk_USUARIO_has_MESA_MESA1`
    FOREIGN KEY (`ID_MESA`)
    REFERENCES `mydb`.`mesa` (`ID_MESA`),
  CONSTRAINT `fk_USUARIO_has_MESA_USUARIO`
    FOREIGN KEY (`ID_USUARIO`)
    REFERENCES `mydb`.`usuario` (`ID_USUARIO`));
    
    
    
-- -----------------------------------------------------
-- Table `mydb`.`Actualiza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Actualiza` (
  `ID_ADMINISTRADOR` INT(11) NOT NULL COMMENT 'Identificador del administardor que realizo la actualizacion',
  `ID_PERFIL` INT(11) NOT NULL COMMENT 'Identificador del perfil del administrador que actualizo el perfil externo al mismo',
  `perfil_ID_PERFIL` INT(11) NOT NULL COMMENT 'Identificador del perfil que se actualizo',
  PRIMARY KEY (`ID_ADMINISTRADOR`, `ID_PERFIL`, `perfil_ID_PERFIL`) COMMENT 'Llaves primarias de la actualizacion',
  INDEX `fk_administrador_has_perfil_perfil1_idx` (`perfil_ID_PERFIL` ASC) ,
  INDEX `fk_administrador_has_perfil_administrador1_idx` (`ID_ADMINISTRADOR` ASC, `ID_PERFIL` ASC) ,
  -- Construyendo las llaves foraneas de adminn e id_perfil del perfil del administrador
  CONSTRAINT `fk_administrador_has_perfil_administrador1` FOREIGN KEY (`ID_ADMINISTRADOR` , `ID_PERFIL`) 
  REFERENCES `mydb`.`administrador` (`ID_ADMINISTRADOR` , `ID_PERFIL`),
  -- Llaves foraneas del perfil que se edita
  CONSTRAINT `fk_administrador_has_perfil_perfil1`FOREIGN KEY (`perfil_ID_PERFIL`)
    REFERENCES `mydb`.`perfil` (`ID_PERFIL`));
    
# Inserciones de datos
# Orden de cracion -> primero se crea el perfil en la tabla perfil, luego se le asigna una llave en su tabla de
# (usuario,admin,recepcionista o gerente)
# perfilprimer ejemplo de incersion
INSERT INTO perfil(ID_PERFIL,NOMBRE,CORREO,FOTO,CONTRASENA) VALUES (null,"Banjo Kazooie","Banjo_hawai@gmail.com",
"banjo-kazooie.com/photo","Crazy_red_feathers.1998");
INSERT INTO perfil(ID_PERFIL, NOMBRE, CORREO, FOTO, CONTRASENA) VALUES
(null, "Mario", "mario_bros@gmail.com", "mario.com/photo", "ItsaMeMario.1981"),
(null, "Luigi", "luigi_green@gmail.com", "luigi.com/photo", "GhostBuster.1983"),
(null, "Donkey Kong", "dk_barrels@gmail.com", "donkeykong.com/photo", "BananaSlamma.1981"),
(null, "Zelda", "princess_zelda@gmail.com", "zelda.com/photo", "Triforce.Wisdom.1986"),
(null, "Link", "hero_of_time@gmail.com", "link.com/photo", "MasterSword.1986"),
(null, "Samus Aran", "samus_mission@gmail.com", "samus.com/photo", "MetroidHunter.1986"),
(null, "Yoshi", "yoshi_dino@gmail.com", "yoshi.com/photo", "EggThrower.1990"),
(null, "Kirby", "kirby_puff@gmail.com", "kirby.com/photo", "SuperInhale.1992"),
(null, "Fox McCloud", "fox_starfox@gmail.com", "starfox.com/photo", "DoABarrelRoll.1993");

select * from perfil;

# Ahora asignaremos los perfiles:
INSERT INTO usuario(ID_USUARIO,ID_PERFIL) VALUES (NULL,1);
INSERT INTO usuario(ID_USUARIO,ID_PERFIL) VALUES (NULL,2);
INSERT INTO usuario(ID_USUARIO,ID_PERFIL) VALUES (NULL,3);
INSERT INTO usuario(ID_USUARIO,ID_PERFIL) VALUES (NULL,4);
INSERT INTO usuario(ID_USUARIO,ID_PERFIL) VALUES (NULL,5);

# Asignamos los recepcionistas
INSERT INTO recepcionista(ID_RECEPCIONISTA,ID_PERFIL) VALUES (NULL,6);
INSERT INTO recepcionista(ID_RECEPCIONISTA,ID_PERFIL) VALUES (NULL,7);

# Asignamos un gerente y un administrador
INSERT INTO gerente(ID_GERENTE,ID_PERFIL) VALUES (NULL,8);
INSERT INTO gerente(ID_GERENTE,ID_PERFIL) VALUES (NULL,9);
# Asignamos un admin
INSERT INTO administrador(ID_ADMINISTRADOR,ID_PERFIL) VALUES (NULL,10);
select * from usuario;
select * from recepcionista;
select * from gerente;
select * from administrador;


#10 subconsultas a lastablas de perfil

SELECT * FROM usuario where usuario.id = 1;
SELECT * FROM usuario where usuario.id = 2;
SELECT * FROM usuario where usuario.id = 3;
SELECT * FROM usuario where usuario.id = 4;
SELECT * FROM usuario where usuario.id = 5;
SELECT * FROM usuario INNER JOIN perfil ON usuario.id_perfil = perfil.id_perfil;
SELECT * FROM administrador INNER JOIN perfil ON administrador.id_perfil = perfil.id_perfil;
SELECT * FROM gerente INNER JOIN perfil ON gerente.id_perfil = perfil.id_perfil;
SELECT * FROM recepcionista INNER JOIN perfil ON recepcionista.id_perfil = perfil.id_perfil;


#10 consulats sencillas
SELECT * FROM perfil WHERE NOMBRE = 'Mario';
SELECT * FROM perfil;
SELECT * FROM perfil WHERE NOMBRE = 'Mario';
SELECT NOMBRE, CORREO FROM perfil ORDER BY NOMBRE ASC;
SELECT COUNT(*) AS total_usuarios FROM perfil;
SELECT DISTINCT NOMBRE FROM perfil;
SELECT * FROM perfil WHERE NOMBRE LIKE 'L%';
SELECT * FROM perfil LIMIT 5;
SELECT SUM(ID_PERFIL) AS suma_ids FROM perfil;
SELECT NOMBRE, COUNT(*) AS cantidad FROM perfil GROUP BY NOMBRE;

# joins

SELECT usuario.ID_USUARIO, perfil.NOMBRE, perfil.CORREO
FROM usuario
INNER JOIN perfil ON usuario.ID_PERFIL = perfil.ID_PERFIL;

SELECT recepcionista.ID_RECEPCIONISTA, perfil.NOMBRE, perfil.CORREO
FROM recepcionista
INNER JOIN perfil ON recepcionista.ID_PERFIL = perfil.ID_PERFIL;

SELECT gerente.ID_GERENTE, perfil.NOMBRE, perfil.FOTO
FROM gerente
INNER JOIN perfil ON gerente.ID_PERFIL = perfil.ID_PERFIL;

SELECT perfil.NOMBRE, usuario.ID_USUARIO
FROM perfil
LEFT JOIN usuario ON perfil.ID_PERFIL = usuario.ID_PERFIL;

SELECT perfil.NOMBRE, recepcionista.ID_RECEPCIONISTA
FROM perfil
LEFT JOIN recepcionista ON perfil.ID_PERFIL = recepcionista.ID_PERFIL;

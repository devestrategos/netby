CREATE DATABASE FinancialDb

USE FinancialDb;
GO

DROP TABLE IF EXISTS estadistica;
GO
DROP TABLE IF EXISTS transacciones;
GO
DROP TABLE IF EXISTS cuentas;
GO
DROP TABLE IF EXISTS comerciante;
GO
DROP TABLE IF EXISTS tipos;
GO
DROP TABLE IF EXISTS banco;
GO
DROP TABLE IF EXISTS categoria;
GO

CREATE TABLE categoria(
     categoria_id INTEGER IDENTITY(1,1)
    ,categoria_name VARCHAR(35) CONSTRAINT categoria_name_nn NOT NULL
    ,icon VARCHAR(35)
    ,time_stamp DATETIME
    ,color VARCHAR(35)
    ,CONSTRAINT categoria_id_pk PRIMARY KEY(categoria_id)
);

CREATE TABLE banco(
      banco_id INTEGER IDENTITY(1,1)
    ,banco_name VARCHAR(35) CONSTRAINT banco_name_nn NOT NULL
    ,banco_description VARCHAR(50)
    ,image varbinary(50)
    ,time_stamp DATETIME
    ,CONSTRAINT banco_id_pk PRIMARY KEY(banco_id)
);
CREATE TABLE tipos(
     tipos_id INTEGER IDENTITY(1,1)
    ,tipos_name VARCHAR(35) CONSTRAINT tipos_name_nn NOT NULL
    ,table_name VARCHAR(35)
    ,icon VARCHAR(35)
    ,CONSTRAINT tipos_id_pk PRIMARY KEY(tipos_id)
);

CREATE TABLE comerciante(
    comerciante_id INTEGER IDENTITY(1,1)
    ,comerciante_name VARCHAR(35) CONSTRAINT comerciante_name_nn NOT NULL
    ,categoria_id INTEGER
    ,comerciante_description VARCHAR(50)
    ,time_stamp DATETIME
    ,CONSTRAINT comerciante_id_pk PRIMARY KEY(comerciante_id)
    ,CONSTRAINT categoria_id_fk FOREIGN KEY(categoria_id) REFERENCES categoria(categoria_id)
);

CREATE TABLE cuentas(
      cuentas_id INTEGER IDENTITY(1,1)
    ,cuentas_name VARCHAR(35) CONSTRAINT cuentas_name_nn NOT NULL
    ,tipos_id INTEGER 
    ,banco_id INTEGER
    ,cuentas_balance float
    ,cuentas_IBAN VARCHAR(50)
    ,time_stamp DATETIME
    ,cuentas_holder VARCHAR(50)
    ,CONSTRAINT acc_iban_uk   UNIQUE(cuentas_IBAN)
    ,CONSTRAINT acc_name_uk   UNIQUE(cuentas_name)
    ,CONSTRAINT cuentas_id_pk PRIMARY KEY(cuentas_id)
    ,CONSTRAINT banco_id_fk FOREIGN KEY(banco_id) REFERENCES banco(banco_id)
    ,CONSTRAINT tipos_id_fk FOREIGN KEY(tipos_id) REFERENCES tipos(tipos_id)
);

CREATE TABLE transacciones(
     transacciones_id INTEGER IDENTITY(1,1)
    ,transacciones_name VARCHAR(35) CONSTRAINT transacciones_name_nn NOT NULL
    ,tipos_id INTEGER
    ,comerciante_id INTEGER
    ,cuentas_id INTEGER
    ,categoria_id INTEGER
    ,transacciones_price float CONSTRAINT transacciones_price_nn NOT NULL
    ,transacciones_Date DATE CONSTRAINT transacciones_Date_nn NOT NULL
    ,image varbinary(50)
    ,transacciones_description VARCHAR(50)
    ,time_stamp DATETIME CONSTRAINT transacciones_time_stamp_nn NOT NULL
    ,CONSTRAINT transacciones_id_pk PRIMARY KEY(transacciones_id)
    ,CONSTRAINT tipos_id_trans_fk FOREIGN KEY(tipos_id) REFERENCES tipos(tipos_id)
    ,CONSTRAINT comerciante_id_fk FOREIGN KEY(comerciante_id) REFERENCES comerciante(comerciante_id)
    ,CONSTRAINT cuentas_id_trans_fk FOREIGN KEY(cuentas_id) REFERENCES cuentas(cuentas_id) ON DELETE CASCADE
    ,CONSTRAINT categoria_id_trans_fk FOREIGN KEY(categoria_id) REFERENCES categoria(categoria_id)
);

CREATE TABLE estadistica(
     estadistica_id INTEGER IDENTITY(1,1)
    ,estadistica_date DATE CONSTRAINT estadistica_date_nn NOT NULL
    ,tipos_id INTEGER 
    ,cuentas_id INTEGER
    ,incomes float
    ,expences float
    ,time_stamp DATETIME
    ,CONSTRAINT estadistica_id_pk PRIMARY KEY(estadistica_id)
    ,CONSTRAINT cuentas_id_fk FOREIGN KEY(cuentas_id) REFERENCES cuentas(cuentas_id) ON DELETE CASCADE
    ,CONSTRAINT tipos_id_stat_fk FOREIGN KEY(tipos_id) REFERENCES tipos(tipos_id)
);
GO

INSERT INTO tipos VALUES( 'Ingreso','transacciones','arrow-up');
INSERT INTO tipos VALUES( 'Gastos','transacciones','arrow-down');
INSERT INTO tipos VALUES( 'Credito','cuentas','credit-card');
INSERT INTO tipos VALUES( 'Debito','cuentas','credit-card');
INSERT INTO tipos VALUES( 'Efectivo','cuentas','money-bill-alt');
INSERT INTO tipos VALUES( 'Mes','estadistica','M');
INSERT INTO tipos VALUES( 'Dia','estadistica','D');
INSERT INTO tipos VALUES( 'Año','estadistica','Y');
GO

INSERT INTO categoria VALUES('Comida','utensils',CONVERT(DATETIME, '2022-11-04'),'#28A32E');
INSERT INTO categoria VALUES('Gastos sc','question-circle',CONVERT(DATETIME, '2022-11-04'),'#C4C4C4');
INSERT INTO categoria VALUES('Vacaciones/Viajes/Tiempo libre','plane-arrival',CONVERT(DATETIME, '2022-11-04'),'#FFD4C6');
INSERT INTO categoria VALUES('Comunicaciones y Medios','desktop',CONVERT(DATETIME, '2022-11-04'),'#CE1E07');
INSERT INTO categoria VALUES('Ingresos recurrentese','undo',CONVERT(DATETIME, '2022-11-04'),'#84E721' );
INSERT INTO categoria VALUES('Depositos','shopping-basket',CONVERT(DATETIME, '2022-11-04'),'#C1FFF2');
INSERT INTO categoria VALUES('Transporte','subway',CONVERT(DATETIME, '2022-11-04'),'#F2CB00');
INSERT INTO categoria VALUES('Vestimenta','tshirt',CONVERT(DATETIME, '2022-11-04'),'#62C7CE');
INSERT INTO categoria VALUES('Retiros','money-bill-alt',CONVERT(DATETIME, '2022-11-04'),'#FFFE73');
GO

INSERT INTO banco VALUES('BCR',null,null,CONVERT(DATETIME, '2022-11-04'));
INSERT INTO banco VALUES('Revolut',null,null,CONVERT(DATETIME, '2022-11-04'));
INSERT INTO banco VALUES('BRD',null,null,CONVERT(DATETIME, '2022-11-04'));
INSERT INTO banco VALUES('BT',null,null,CONVERT(DATETIME, '2022-11-04'));
INSERT INTO banco VALUES('CEC',null,null,CONVERT(DATETIME, '2022-11-04'));
INSERT INTO banco VALUES('Raiffeisen',null,null,CONVERT(DATETIME, '2022-11-04'));
INSERT INTO banco VALUES('UniCredit',null,null,CONVERT(DATETIME, '2022-11-04'));
INSERT INTO banco VALUES('Cash',null,null,CONVERT(DATETIME, '2022-11-04'));
GO

INSERT INTO cuentas VALUES('BCR User1',4,1,2000,'RO79 RNCB 0205 1519 1020 0001',CONVERT(DATETIME, '2022-11-04'),'Cristian');
INSERT INTO cuentas VALUES('Revolut User1',4,2,2000,'RO79 RNCB 0205 1519 1020 0002',CONVERT(DATETIME, '2022-11-04'),'Cristian');
INSERT INTO cuentas VALUES('BRD User1',4,3,2000,'RO79 RNCB 0205 1519 1020 0003',CONVERT(DATETIME, '2022-11-04'),'Cristian');
INSERT INTO cuentas VALUES('BT User1',4,4,2000,'RO79 RNCB 0205 1519 1020 0004',CONVERT(DATETIME, '2022-11-04'),'Cristian');
INSERT INTO cuentas VALUES('CEC User1',4,5,2000,'RO79 RNCB 0205 1519 1020 0005',CONVERT(DATETIME, '2022-11-04'),'Cristian');
INSERT INTO cuentas VALUES('Raiffeisen User1',4,6,2000,'RO79 RNCB 0205 1519 1020 0006',CONVERT(DATETIME, '2022-11-04'),'Cristian');
INSERT INTO cuentas VALUES('UniCredit User1',4,7,2000,'RO79 RNCB 0205 1519 1020 0007',CONVERT(DATETIME, '2022-11-04'),'Cristian');
INSERT INTO cuentas VALUES('Cash User1',5,8,2000,null,CONVERT(DATETIME, '2022-11-04'),'Cristian');
GO

INSERT INTO comerciante VALUES('KFC',1,'m. ',CONVERT(DATETIME, '2022-11-04'));
INSERT INTO comerciante VALUES('Enel',2,'m',CONVERT(DATETIME, '2022-11-04'));
INSERT INTO comerciante VALUES('Cinema City',3,'m ',CONVERT(DATETIME, '2022-11-04'));
INSERT INTO comerciante VALUES('Digi',4,'m',CONVERT(DATETIME, '2022-11-04'));
INSERT INTO comerciante VALUES('UPB',5,'m',CONVERT(DATETIME, '2022-11-04'));
INSERT INTO comerciante VALUES('Lidl',6,'m',CONVERT(DATETIME, '2022-11-04'));
INSERT INTO comerciante VALUES('Metrorex',7,'m',CONVERT(DATETIME, '2022-11-04'));
INSERT INTO comerciante VALUES('NewYorker',8,'m',CONVERT(DATETIME, '2022-11-04'));
INSERT INTO comerciante VALUES('ATM Big',9,'m',CONVERT(DATETIME, '2022-11-04'));
GO

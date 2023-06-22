DROP TABLE GOLEADORES;
DROP TABLE PARTIDOS;
DROP TABLE ESTADIOS;
DROP TABLE JUGADORES_EQUIPOS;
DROP TABLE JUGADORES;
DROP TABLE EQUIPOS;

CREATE TABLE EQUIPOS(
CODEQUIPO INTEGER PRIMARY KEY,
NOMBRE VARCHAR2(50) NOT NULL UNIQUE,
FECHA_FUNDACION DATE, 
NUM_SOCIOS INTEGER,
VALOR_MERCADO NUMBER(10,2));


CREATE TABLE JUGADORES(
CODJUGADOR    INTEGER PRIMARY KEY,
NOMBRE    VARCHAR2(50) NOT NULL,
FECNAC    DATE,
DORSAL    INTEGER NOT NULL);


CREATE TABLE JUGADORES_EQUIPOS(
 CODTEMPORADA VARCHAR2(10),
 CODJUGADOR INTEGER,
 CODEQUIPO INTEGER);

CREATE TABLE ESTADIOS 
(CODESTADIO    INTEGER PRIMARY KEY,
 NOMBRE    VARCHAR2(50) NOT NULL,
 CAPACIDAD    INTEGER,
 CIUDAD    VARCHAR2(30),
 CODEQUIPO INTEGER);
 

CREATE TABLE PARTIDOS(
CODPARTIDO INTEGER PRIMARY KEY,
CODTEMPORADA VARCHAR2(10), 
CODEQUIPO_LOCAL INTEGER,
CODEQUIPO_VISITANTE    INTEGER,
GOLES_EQUIPO_LOCAL    INTEGER DEFAULT 0,
GOLES_EQUIPO_VISITANTE INTEGER DEFAULT 0,
CODESTADIO INTEGER);


CREATE TABLE GOLEADORES(
CODPARTIDO    INTEGER,
CODJUGADOR    INTEGER,
MIN_GOL INTEGER, 
OBSERVACION VARCHAR2(100));


/*** ALTER ****/
ALTER TABLE JUGADORES_EQUIPOS ADD CONSTRAINT PK_JUG_EQ PRIMARY KEY (CODTEMPORADA, CODEQUIPO, CODJUGADOR);
ALTER TABLE JUGADORES_EQUIPOS ADD CONSTRAINT FK_JUG_EQ_JUG FOREIGN KEY (CODJUGADOR) REFERENCES JUGADORES(CODJUGADOR);
ALTER TABLE JUGADORES_EQUIPOS ADD CONSTRAINT FK_JUG_EQ_EQ FOREIGN KEY (CODEQUIPO) REFERENCES EQUIPOS(CODEQUIPO);

ALTER TABLE ESTADIOS ADD CONSTRAINT FK_EST_EQ FOREIGN KEY (CODEQUIPO) REFERENCES EQUIPOS(CODEQUIPO);



ALTER TABLE PARTIDOS ADD CONSTRAINT FK_EQ_PART1 FOREIGN KEY (CODEQUIPO_LOCAL) REFERENCES EQUIPOS(CODEQUIPO);
ALTER TABLE PARTIDOS ADD CONSTRAINT FK_EQ_PART2 FOREIGN KEY (CODEQUIPO_VISITANTE) REFERENCES EQUIPOS(CODEQUIPO);
ALTER TABLE PARTIDOS ADD CONSTRAINT FK_EST_PART FOREIGN KEY (CODESTADIO) REFERENCES ESTADIOS(CODESTADIO);

ALTER TABLE GOLEADORES ADD CONSTRAINT PK_GOLEADORES PRIMARY KEY (CODPARTIDO,CODJUGADOR, MIN_GOL);
ALTER TABLE GOLEADORES ADD CONSTRAINT FK_GOL_PART FOREIGN KEY (CODPARTIDO) REFERENCES PARTIDOS(CODPARTIDO);
ALTER TABLE GOLEADORES ADD CONSTRAINT FK_GOL_JUG FOREIGN KEY (CODJUGADOR) REFERENCES JUGADORES(CODJUGADOR);



/*********
INSERT INTO EQUIPOS(CODEQUIPO, NOMBRE,FECHA_FUNDACION, NUM_SOCIOS,VALOR_MERCADO)
VALUES
(6, 'REAL BETIS BALOMPIE', TO_DATE('12/09/1907','DD/MM/YYYY'),50373,270.20);
*/
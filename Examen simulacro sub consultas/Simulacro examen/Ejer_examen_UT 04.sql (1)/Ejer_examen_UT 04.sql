CREATE TABLE cliente (
  id integer PRIMARY KEY,
  nombre VARCHAR2(100) NOT NULL,
  apellido1 VARCHAR2(100) NOT NULL,
  apellido2 VARCHAR2(100),
  ciudad VARCHAR2(100),
  categoría integer
);

CREATE TABLE comercial (
  id integer PRIMARY KEY,
  nombre VARCHAR2(100) NOT NULL,
  apellido1 VARCHAR2(100) NOT NULL,
  apellido2 VARCHAR2(100),
  comisión number(3,2)
);

CREATE TABLE pedido (
  id integer PRIMARY KEY,
  total number(6,2) NOT NULL,
  fecha DATE,
  id_cliente integer NOT NULL,
  id_comercial integer NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id),
  FOREIGN KEY (id_comercial) REFERENCES comercial(id)
);

INSERT INTO cliente VALUES(1, 'Aarón', 'Rivero', 'Gómez', 'Almería', 100);
INSERT INTO cliente VALUES(2, 'Adela', 'Salas', 'Díaz', 'Granada', 200);
INSERT INTO cliente VALUES(3, 'Adolfo', 'Rubio', 'Flores', 'Sevilla', NULL);
INSERT INTO cliente VALUES(4, 'Adrián', 'Suárez', NULL, 'Jaén', 300);
INSERT INTO cliente VALUES(5, 'Marcos', 'Loyola', 'Méndez', 'Almería', 200);
INSERT INTO cliente VALUES(6, 'María', 'Santana', 'Moreno', 'Cádiz', 100);
INSERT INTO cliente VALUES(7, 'Pilar', 'Ruiz', NULL, 'Sevilla', 300);
INSERT INTO cliente VALUES(8, 'Pepe', 'Ruiz', 'Santana', 'Huelva', 200);
INSERT INTO cliente VALUES(9, 'Guillermo', 'López', 'Gómez', 'Granada', 225);
INSERT INTO cliente VALUES(10, 'Daniel', 'Santana', 'Loyola', 'Sevilla', 125);

INSERT INTO comercial VALUES(1, 'Daniel', 'Sáez', 'Vega', 0.15);
INSERT INTO comercial VALUES(2, 'Juan', 'Gómez', 'López', 0.13);
INSERT INTO comercial VALUES(3, 'Diego','Flores', 'Salas', 0.11);
INSERT INTO comercial VALUES(4, 'Marta','Herrera', 'Gil', 0.14);
INSERT INTO comercial VALUES(5, 'Antonio','Carretero', 'Ortega', 0.12);
INSERT INTO comercial VALUES(6, 'Manuel','Domínguez', 'Hernández', 0.13);
INSERT INTO comercial VALUES(7, 'Antonio','Vega', 'Hernández', 0.11);
INSERT INTO comercial VALUES(8, 'Alfredo','Ruiz', 'Flores', 0.05);

INSERT INTO pedido VALUES(1, 150.5, '05/10/2017', 5, 2);
INSERT INTO pedido VALUES(2, 270.65, '10/09/2016', 1, 5);
INSERT INTO pedido VALUES(3, 65.26, '05/10/2017', 2, 1);
INSERT INTO pedido VALUES(4, 110.5, '17/07/2016', 8, 3);
INSERT INTO pedido VALUES(5, 948.5, '10/09/2017', 5, 2);
INSERT INTO pedido VALUES(6, 2400.6, '27/07/2016', 7, 1);
INSERT INTO pedido VALUES(7, 5760, '10/09/2015', 2, 1);
INSERT INTO pedido VALUES(8, 1983.43, '10/10/2017', 4, 6);
INSERT INTO pedido VALUES(9, 2480.4, '10/10/2016', 8, 3);
INSERT INTO pedido VALUES(10, 250.45, '27/06/2015', 8, 2);
INSERT INTO pedido VALUES(11, 75.29, '17/08/2016', 3, 7);
INSERT INTO pedido VALUES(12, 3045.6, '25/04/2017', 2, 1);
INSERT INTO pedido VALUES(13, 545.75, '25/01/2019', 6, 1);
INSERT INTO pedido VALUES(14, 145.82, '02/02/2017', 6, 1);
INSERT INTO pedido VALUES(15, 370.85, '11/03/2019', 1, 5);
INSERT INTO pedido VALUES(16, 2389.23, '11/03/2019', 1, 5);

commit;
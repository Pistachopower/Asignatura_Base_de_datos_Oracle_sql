--1. Mostrar el nombre de todos los jugadores ordenados alfab)camente.
SELECT NOMBRE
FROM JUGADORES
ORDER BY NOMBRE;

--2. Mostrar el nombre de los jugadores que sean pivots con mas de 200 libras
SELECT NOMBRE
FROM JUGADORES
WHERE UPPER(POSICION) LIKE '%C%'
AND PESO>200
ORDER BY NOMBRE;

--3. Mostrar el nombre de todos los equipos ordenados alfabeticamente.
SELECT NOMBRE
FROM EQUIPOS
ORDER BY NOMBRE;

--4. Mostrar el nombre de los equipos del este.
SELECT NOMBRE
FROM EQUIPOS
WHERE UPPER(CONFERENCIA)='EAST'
ORDER BY NOMBRE;

--5. Mostrar los equipos donde su ciudad empieza por c.
SELECT NOMBRE
FROM EQUIPOS
WHERE UPPER(CIUDAD) LIKE 'C%'
ORDER BY NOMBRE;

--6. Mostrar todos los jugadores y su equipo ordenado por nombre del equipo.
SELECT J.NOMBRE AS JUGADOR, E.NOMBRE AS EQUIPO
FROM JUGADORES J, EQUIPOS E
WHERE J.NOMBRE_EQUIPO=E.NOMBRE
ORDER BY E.NOMBRE, J.NOMBRE;

--7. Mostrar todos los jugadores del equipo ¡ptors
SELECT J.NOMBRE AS JUGADOR
FROM JUGADORES J, EQUIPOS E
WHERE J.NOMBRE_EQUIPO=E.NOMBRE
AND UPPER(E.NOMBRE)='RAPTORS'
ORDER BY J.NOMBRE;

--8. Mostrar los puntos por partido de !u Gasol
SELECT ES.PUNTOS_POR_PARTIDO
FROM ESTADISTICAS ES, JUGADORES J
WHERE J.CODIGO= ES.JUGADOR
AND UPPER(J.NOMBRE)='PAU GASOL';

--9. Mostrar los puntos por partido de !u Gasol%n la temporada 4/05?.
SELECT ES.PUNTOS_POR_PARTIDO
FROM ESTADISTICAS ES, JUGADORES J
WHERE J.CODIGO= ES.JUGADOR
AND UPPER(J.NOMBRE)='PAU GASOL'
AND TO_CHAR(ES.TEMPORADA)= '04/05';

--10. Mostrar el numero de puntos de cada jugador en toda su carrera.
SELECT J.NOMBRE, SUM(ES.PUNTOS_POR_PARTIDO) AS PUNTOS_CARRERA
FROM ESTADISTICAS ES, JUGADORES J
WHERE J.CODIGO= ES.JUGADOR
GROUP BY J.NOMBRE;

--11. Mostrar el nvro de jugadores de cada equipo.
SELECT E.NOMBRE AS EQUIPO, COUNT(J.NOMBRE) AS TOTAL_JUGADORES
FROM JUGADORES J, EQUIPOS E
WHERE J.NOMBRE_EQUIPO=E.NOMBRE
GROUP BY E.NOMBRE
ORDER BY E.NOMBRE;

--12. Mostrar el jugador que mas puntos ha realizado en toda su carrera.
SELECT J.NOMBRE, SUM(ES.PUNTOS_POR_PARTIDO) AS PUNTOS_CARRERA
FROM ESTADISTICAS ES, JUGADORES J
WHERE J.CODIGO= ES.JUGADOR
GROUP BY J.NOMBRE
HAVING SUM(ES.PUNTOS_POR_PARTIDO)= (SELECT MAX(SUM(ES.PUNTOS_POR_PARTIDO))
                                    FROM ESTADISTICAS ES, JUGADORES J
                                    WHERE J.CODIGO= ES.JUGADOR
                                    GROUP BY J.NOMBRE);
                                    
--13. Mostrar el nombre del equipo, conferencia y division del jugador mas alto de la NBA.
SELECT J.NOMBRE AS JUGADOR, E.NOMBRE AS EQUIPO, E.CONFERENCIA, E.DIVISION, MAX(J.ALTURA)
FROM JUGADORES J, EQUIPOS E
WHERE J.NOMBRE_EQUIPO=E.NOMBRE
GROUP BY J.NOMBRE, E.NOMBRE, E.CONFERENCIA, E.DIVISION
HAVING MAX(J.ALTURA)= (SELECT MAX(MAX(J.ALTURA))
                        FROM JUGADORES J, EQUIPOS E
                        WHERE J.NOMBRE_EQUIPO=E.NOMBRE
                        GROUP BY E.NOMBRE);

--14. Mostrar la suma de los puntos por partido de todos los jugadores espa~%s donde el equipo donde juegan este en /s Angeles
SELECT SUM(ES.PUNTOS_POR_PARTIDO) AS PUNTOS
FROM ESTADISTICAS ES, JUGADORES J, EQUIPOS E
WHERE J.CODIGO= ES.JUGADOR
AND J.NOMBRE_EQUIPO=E.NOMBRE
AND UPPER(J.PROCEDENCIA)='SPAIN'
AND UPPER(E.CIUDAD)='LOS ANGELES';

--15. Mostrar la media de puntos en partidos de los equipos de la division Pacific.
SELECT TRUNC(AVG(NVL(ES.PUNTOS_POR_PARTIDO, 0))) AS MEDIA_PUNTOS_POR_PARTIDO
FROM ESTADISTICAS ES, JUGADORES J, EQUIPOS E
WHERE J.CODIGO= ES.JUGADOR
AND J.NOMBRE_EQUIPO=E.NOMBRE
AND UPPER(E.DIVISION)='PACIFIC';

select avg(puntos)
from (select sum(puntos_local) as puntos
      from PARTIDOS
      where equipo_local in (select nombre
                              from equipos
                              where lower(DIVISION) = 'pacific')
      union
      select sum(puntos_visitante) as puntos
      from PARTIDOS
      where equipo_visitante in (select nombre
                              from equipos
                              where lower(DIVISION) = 'pacific')) t;
SELECT AVG(SUM(PUNTOS))
FROM(
            SELECT E.NOMBRE, (P.PUNTOS_LOCAL) AS PUNTOS
            FROM PARTIDOS P, EQUIPOS E
            WHERE E.NOMBRE=P.EQUIPO_LOCAL
            AND UPPER(E.DIVISION)='PACIFIC'
            UNION ALL
            SELECT E.NOMBRE,(P.PUNTOS_VISITANTE)
            FROM PARTIDOS P, EQUIPOS E
            WHERE E.NOMBRE=P.EQUIPO_VISITANTE
            AND UPPER(E.DIVISION)='PACIFIC')
GROUP BY NOMBRE;

--16. Mostrar el partido o partidos (equipo_local, equipo_visitante y diferencia) con mayor diferencia de puntos.
SELECT DISTINCT P.EQUIPO_LOCAL,P.EQUIPO_VISITANTE ,ABS(SUM(P.PUNTOS_LOCAL)-SUM(P.PUNTOS_VISITANTE)) AS DIFERENCIA
FROM PARTIDOS P
GROUP BY P.EQUIPO_LOCAL,P.EQUIPO_VISITANTE
HAVING ABS(SUM(P.PUNTOS_LOCAL)-SUM(P.PUNTOS_VISITANTE))= (SELECT DISTINCT MAX(ABS(SUM(P.PUNTOS_LOCAL)-SUM(P.PUNTOS_VISITANTE)))
                                                            FROM PARTIDOS P
                                                            GROUP BY P.EQUIPO_LOCAL,P.EQUIPO_VISITANTE);
/************la real soluciz%s la de abajo, lo anterior es la diferencia mayor de suma de puntos por partidos entre equipos***********/
SELECT DISTINCT P.EQUIPO_LOCAL,P.EQUIPO_VISITANTE, ABS(P.PUNTOS_LOCAL-P.PUNTOS_VISITANTE)
FROM PARTIDOS P
WHERE ABS(P.PUNTOS_LOCAL-P.PUNTOS_VISITANTE) = (SELECT MAX(ABS(P.PUNTOS_LOCAL - P.PUNTOS_VISITANTE))
                                                FROM PARTIDOS P);


--17. Mostrar la media de puntos en partidos de los equipos de la divisizacific.
--EST`REPE, MUESTRO LA UNION DE TOOOODAS LAS TABLAS:
SELECT *
FROM PARTIDOS P, EQUIPOS E, JUGADORES J, ESTADISTICAS ES
WHERE E.NOMBRE=P.EQUIPO_LOCAL
AND J.CODIGO= ES.JUGADOR
AND J.NOMBRE_EQUIPO=E.NOMBRE;
--18. Mostrar los puntos de cada equipo en los partidos, tanto de local como de visitante. Usa una vista
CREATE VIEW V_PUNTOS_EQUIPOS(EQUIPO, TOTAL_PUNTOS) 
 AS 
SELECT J.NOMBRE_EQUIPO, SUM(ES.PUNTOS_POR_PARTIDO)
FROM JUGADORES J, ESTADISTICAS ES
WHERE J.CODIGO= ES.JUGADOR
GROUP BY  J.NOMBRE_EQUIPO;

SELECT *
FROM V_PUNTOS_EQUIPOS;

--19. Mostrar quien gana en cada partido (codigo, equipo_local, equipo_visitante, equipo_ganador), en caso de empate sera null.
SELECT DISTINCT P.CODIGO, p.equipo_local, p.equipo_visitante,
        CASE
            WHEN P.PUNTOS_LOCAL > P.PUNTOS_VISITANTE THEN 'LOCAL'
            WHEN P.PUNTOS_LOCAL < P.PUNTOS_VISITANTE THEN 'VISITANTE'
            ELSE 'EMPATE'
         END AS EQUIPO_GANADOR
FROM PARTIDOS P, EQUIPOS E
WHERE E.NOMBRE=P.EQUIPO_LOCAL;

--MOSTRAR la informaciz$e los equipos que tienen màcantidad de puntos anotados como local o visitante
SELECT P.EQUIPO_LOCAL AS NOMBRE_EQUIPO, SUM(P.PUNTOS_LOCAL) AS TOTAL_PUNTOS
FROM PARTIDOS P, EQUIPOS E
WHERE E.NOMBRE=P.EQUIPO_LOCAL
GROUP BY P.EQUIPO_LOCAL
HAVING SUM(P.PUNTOS_LOCAL)=(SELECT MAX(SUM(P.PUNTOS_LOCAL))
                            FROM PARTIDOS P, EQUIPOS E
                            WHERE E.NOMBRE=P.EQUIPO_LOCAL
                            GROUP BY P.EQUIPO_LOCAL)
UNION ALL

SELECT P.EQUIPO_VISITANTE, SUM(P.PUNTOS_VISITANTE)
FROM PARTIDOS P, EQUIPOS E
WHERE E.NOMBRE=P.EQUIPO_VISITANTE
GROUP BY P.EQUIPO_VISITANTE
HAVING SUM(P.PUNTOS_VISITANTE)=(SELECT MAX(SUM(P.PUNTOS_VISITANTE))
                            FROM PARTIDOS P, EQUIPOS E
                            WHERE E.NOMBRE=P.EQUIPO_VISITANTE
                            GROUP BY P.EQUIPO_VISITANTE);

/*Haz un procedimiento que, dada una temporada y un equipo (ambos pasados como
paretros de entrada) diga:
Cu´os partidos en total ha ganado ese equipo como local
Para cada partido: Decir cu´os puntos anotz¯

SELECT P.EQUIPO_LOCAL, P.PUNTOS_LOCAL, P.PUNTOS_VISITANTE, P.EQUIPO_VISITANTE
            FROM PARTIDOS P
            WHERE P.TEMPORADA='98/99'
            AND UPPER(P.EQUIPO_LOCAL)= 'MAGIC';
SET SERVEROUTPUT ON
/
CREATE OR REPLACE PROCEDURE spPuntosPartido(P_TEMPORADA PARTIDOS.TEMPORADA%TYPE, P_EQUIPO EQUIPOS.NOMBRE%TYPE)
IS
       CURSOR C_PARTIDOS_GANADOS IS 
            SELECT P.EQUIPO_LOCAL, P.PUNTOS_LOCAL, P.PUNTOS_VISITANTE, P.EQUIPO_VISITANTE
            FROM PARTIDOS P
            WHERE P.TEMPORADA=P_TEMPORADA
            AND UPPER(P.EQUIPO_LOCAL)= P_EQUIPO;
        
            V_LOCAL PARTIDOS.EQUIPO_LOCAL%TYPE;
            V_PTOS_LOCAL PARTIDOS.PUNTOS_LOCAL%TYPE;
            V_PTOS_VISITA PARTIDOS.PUNTOS_VISITANTE%TYPE;
            V_VISITA PARTIDOS.EQUIPO_VISITANTE%TYPE;
            V_CONTADOR_LOCAL NUMBER:=0;
           
BEGIN
     OPEN C_PARTIDOS_GANADOS;
            LOOP
                FETCH C_PARTIDOS_GANADOS INTO V_LOCAL, V_PTOS_LOCAL, V_PTOS_VISITA,V_VISITA;
                EXIT WHEN C_PARTIDOS_GANADOS%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(V_LOCAL || ' HA ANOTADO ' || V_PTOS_LOCAL || ' PUNTOS CONTRA ' || V_VISITA);
                IF V_PTOS_LOCAL> V_PTOS_VISITA THEN
                    V_CONTADOR_LOCAL:=V_CONTADOR_LOCAL+1;
                    
                END IF;
                
            END LOOP;
            
    CLOSE C_PARTIDOS_GANADOS;
    DBMS_OUTPUT.PUT_LINE(V_LOCAL || ' HA GANADO ' || V_CONTADOR_LOCAL || ' PARTIDOS');
    
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);
END;
/
BEGIN 
    spPuntosPartido('98/99', 'MAGIC');
END; 
/
--otra manera de hacerlo, usando un cursor expléto y otro impléto:
CREATE OR REPLACE PROCEDURE spEquipoGanador(pTemp partidos.temporada%type, pEquipo equipos.nombre%type)
is
    v_partidos_ganados number;
    
    cursor c_part is
        select pa.codigo, pa.puntos_local
        from partidos pa
        where upper(pa.equipo_local) = upper(pEquipo)
        and pa.temporada = pTemp;
    
    v_cod partidos.codigo%type;
    v_puntos_local partidos.puntos_local%type;
        
begin

    open c_part;
    loop
        fetch c_part into v_cod, v_puntos_local;
        exit when c_part%notfound;
        
        DBMS_OUTPUT.PUT_LINE('El equipo '|| pEquipo || ' en el partido '||v_cod||' metio '|| v_puntos_local);
        
    end loop;
    close c_part;

    --- y cuantos partidos ha ganado
    select count(*) into v_partidos_ganados
    from partidos pa
    where pa.puntos_visitante < pa.puntos_local
    and upper(pa.equipo_local) = upper(pEquipo)
    and pa.temporada = pTemp;
    
    DBMS_OUTPUT.PUT_LINE('El equipo '|| pEquipo || ' ganBü|v_partidos_ganados||' partidos ');

    EXCEPTION
        WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);
end;
/
BEGIN 
    spEquipoGanador('98/99', 'BULLS');
END; 
/
/*** REALIZAR EN LA BASE DE DATOS LAS MODIFICICACIONES NECESARIAS PARA QUE LOS BULLS DE CHICAGO NO
     PUEDAN PERDER UN PARTIDO **/
CREATE OR REPLACE TRIGGER T_BullsSiempreGanan
BEFORE
INSERT OR UPDATE OF EQUIPO_LOCAL OR UPDATE OF EQUIPO_VISITANTE OR UPDATE OF PUNTOS_LOCAL OR UPDATE OF PUNTOS_VISITANTE
ON PARTIDOS
FOR EACH ROW 
DECLARE

BEGIN
        IF :NEW.PUNTOS_LOCAL< :NEW.PUNTOS_VISITANTE AND UPPER(:NEW.EQUIPO_LOCAL) = 'BULLS' THEN
            raise_application_error(-20600,'LOS BULLS NO PUEDEN TENER MENOS PUNTOS QUE EL EQUIPO CONTRARIO');
        END IF;
        
        IF :NEW.PUNTOS_LOCAL> :NEW.PUNTOS_VISITANTE AND UPPER(:NEW.EQUIPO_VISITANTE) = 'BULLS' THEN
            raise_application_error(-20600,'LOS BULLS NO PUEDEN TENER MENOS PUNTOS QUE EL EQUIPO CONTRARIO');
        END IF;

END;
/


/*** CREAR UNA FUNCIÎ QUE DADA UNA DIVISIÎ  Y UNA TEMPORADA
DEVUELVA LOS 3 EQUIPOS (NOMBRES CONCATENADOS) QUE MS PUNTOS HAN METIDO EN ESA DIVISION Y TEMPORADA*/
SELECT E.NOMBRE, SUM(ES.PUNTOS_POR_PARTIDO)
FROM PARTIDOS P, EQUIPOS E, JUGADORES J, ESTADISTICAS ES
WHERE E.NOMBRE=P.EQUIPO_LOCAL
AND J.CODIGO= ES.JUGADOR
AND J.NOMBRE_EQUIPO=E.NOMBRE
AND UPPER(E.DIVISION)='CENTRAL'
AND UPPER(P.TEMPORADA)='98/99'
GROUP BY E.NOMBRE
ORDER BY 2 DESC;

SELECT *
FROM(
            SELECT NOMBRE, SUM(TOTAL_PUNTOS)
            FROM(
                    SELECT E.NOMBRE, SUM(P.PUNTOS_LOCAL) AS TOTAL_PUNTOS
                    FROM PARTIDOS P, EQUIPOS E
                    WHERE E.NOMBRE=P.EQUIPO_LOCAL
                    AND UPPER(E.DIVISION)='CENTRAL'
                    AND UPPER(P.TEMPORADA)='98/99'
                    GROUP BY E.NOMBRE
                    UNION ALL
                    SELECT E.NOMBRE, SUM(P.PUNTOS_VISITANTE)
                    FROM PARTIDOS P, EQUIPOS E
                    WHERE E.NOMBRE=P.EQUIPO_VISITANTE
                    AND UPPER(E.DIVISION)='CENTRAL'
                    AND UPPER(P.TEMPORADA)='98/99'
                    GROUP BY E.NOMBRE)
            GROUP BY NOMBRE
            ORDER BY 2 DESC)
WHERE ROWNUM <=3;
/
CREATE OR REPLACE FUNCTION fLos3MejoresEQUIPOS (p_DIVISION  EQUIPOS.DIVISION%TYPE, P_TEMPORADA PARTIDOS.TEMPORADA%TYPE)
RETURN VARCHAR2
IS
v_lista varchar2(200);
  CURSOR C_MAS_PUNTOS IS 
            
        SELECT NOMBRE, SUM(TOTAL_PUNTOS)
        FROM(
                    SELECT E.NOMBRE, SUM(P.PUNTOS_LOCAL) AS TOTAL_PUNTOS
                    FROM PARTIDOS P, EQUIPOS E
                    WHERE E.NOMBRE=P.EQUIPO_LOCAL
                    AND UPPER(E.DIVISION)=UPPER(p_DIVISION)
                    AND UPPER(P.TEMPORADA)=UPPER(P_TEMPORADA)
                    GROUP BY E.NOMBRE
                    UNION ALL
                    SELECT E.NOMBRE, SUM(P.PUNTOS_VISITANTE)
                    FROM PARTIDOS P, EQUIPOS E
                    WHERE E.NOMBRE=P.EQUIPO_VISITANTE
                    AND UPPER(E.DIVISION)=UPPER(p_DIVISION)
                    AND UPPER(P.TEMPORADA)=UPPER(P_TEMPORADA)
                    GROUP BY E.NOMBRE)
        GROUP BY NOMBRE
        ORDER BY 2 DESC;
            
            V_EQUIPO EQUIPOS.NOMBRE%TYPE;
            V_TOTAL_PUNTOS NUMBER;
BEGIN
     OPEN C_MAS_PUNTOS;
            for x in 1..3 LOOP
                FETCH C_MAS_PUNTOS INTO V_EQUIPO, V_TOTAL_PUNTOS;
                EXIT WHEN C_MAS_PUNTOS%NOTFOUND;
                v_lista:=v_lista||'--> '||v_equipo;
                DBMS_OUTPUT.PUT_LINE(V_equipo || ' HA OBTENIDO ' || V_TOTAL_PUNTOS|| ' PUNTOS'); 
            END LOOP;
                  
    CLOSE C_MAS_PUNTOS;
    
    RETURN v_lista;
   
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);
          return SQLERRM;
END;

/
begin

    dbms_output.put_line('LOS MEJORES EQUIPOS SON ' || fLos3MejoresEQUIPOS('CENTRAL', '98/99'));
end;
/

--Crea una funciz1ue devuelva, pasandole una TEMPORADA, el JUGADOR que màPUNTOS HAYA ANOTADO.

------------ejercicios chatGPT-----------
SET SERVEROUTPUT ON
--1. Crea un procedimiento almacenado que inserte un nuevo equipo en la tabla "equipos", SEGŽ LOS PARAMETROS PASADOS:
CREATE OR REPLACE PROCEDURE spINSERTAR_EQUIPO(V_NOMBRE EQUIPOS.NOMBRE%TYPE, V_CIUDAD EQUIPOS.CIUDAD%TYPE, V_CONFERENCIA EQUIPOS.CONFERENCIA%TYPE,V_DIVISION EQUIPOS.DIVISION%TYPE)
IS
BEGIN
    INSERT INTO equipos (nombre, ciudad, conferencia, division)
    VALUES (V_NOMBRE, V_CIUDAD, V_CONFERENCIA, V_DIVISION);
    DBMS_OUTPUT.PUT_LINE('Equipo insertado correctamente.');
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);
END;
/
BEGIN 
    spINSERTAR_EQUIPO ('REAL BETIS', 'SEVILLA', 'LIGA', 'PRIMERA');
END; 
/
SELECT * FROM EQUIPOS WHERE UPPER(NOMBRE)= 'REAL BETIS';
/
--2. Crea una funciz!lmacenada que devuelva el nvro total de jugadores en un equipo dado:
CREATE OR REPLACE FUNCTION f_TOTAL_JUGADORES_EQUIPO (p_EQUIPO  EQUIPOS.NOMBRE%TYPE)
RETURN NUMBER
IS
V_TOTAL_JUGADORES integer;

BEGIN
    SELECT COUNT(J.CODIGO) INTO V_TOTAL_JUGADORES
    FROM EQUIPOS E, JUGADORES J
    WHERE J.NOMBRE_EQUIPO=E.NOMBRE
    AND UPPER(E.NOMBRE) = p_EQUIPO;
    
    return V_TOTAL_JUGADORES;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);    
        RETURN SQLERRM;
END;
/
begin
 dbms_output.put_line('EL TOTAL DE JUGADORES DEL EQUIPO ES ' || f_TOTAL_JUGADORES_EQUIPO('BULLS'));
end;
/
SELECT COUNT(J.CODIGO) AS V_TOTAL_JUGADORES
    FROM EQUIPOS E, JUGADORES J
    WHERE J.NOMBRE_EQUIPO=E.NOMBRE
    AND UPPER(E.NOMBRE) = 'BULLS';
/
--3. Obt todos los jugadores y sus estadôicas de la temporada actual:
SELECT *
FROM JUGADORES J, ESTADISTICAS ES
WHERE  J.CODIGO= ES.JUGADOR
AND TEMPORADA= '06/07';
--4. Obt los equipos que pertenecen a una determinada conferencia:
SELECT *
FROM EQUIPOS E
WHERE UPPER(CONFERENCIA) = 'EAST';
--5. Actualiza el peso de un jugador espec©co:
UPDATE JUGADORES
SET PESO = PESO +10
WHERE UPPER(NOMBRE) = 'LEANDRO BARBOSA';
SELECT * FROM JUGADORES WHERE UPPER(NOMBRE) = 'LEANDRO BARBOSA';
--6. Elimina un equipo y todos sus jugadores asociados:
DELETE
FROM EQUIPOS E
WHERE UPPER(E.NOMBRE) = 'REAL BETIS';

--8. Trigger para evitar la eliminaciz$e un equipo si tiene jugadores asociados:
CREATE OR REPLACE TRIGGER TR_EVITAR_ELIMINAR_EQUIPOS
BEFORE
DELETE OR UPDATE
ON EQUIPOS
FOR EACH ROW 

DECLARE
    PRAGMA autonomous_transaction;
    V_CANT_JUGADORES NUMBER;

BEGIN

    SELECT COUNT(J.CODIGO) INTO V_CANT_JUGADORES
    FROM EQUIPOS E, JUGADORES J
    WHERE J.NOMBRE_EQUIPO=E.NOMBRE
    AND E.NOMBRE= :OLD.NOMBRE;
    
    IF V_CANT_JUGADORES <=1 THEN
        raise_application_error(-20600,'UN EQUIPO NO PUEDE QUEDARSE SIN JUGADORES');
    END IF;
END;
/
--9. Funciz0ara calcular el PESO EN KILOGRAMOS de un jugador, teniendo en cuenta que est%n libras:
SELECT (PESO * 0.45359237) AS KILOS
    FROM JUGADORES
    WHERE CODIGO = 584;
/
CREATE OR REPLACE FUNCTION f_KILOS_jugador (p_JUGADOR  JUGADORES.CODIGO%TYPE)
RETURN NUMBER
IS
V_KILOS NUMBER;

BEGIN
    SELECT (PESO* 0.45359237) INTO V_KILOS
    FROM JUGADORES
    WHERE CODIGO = p_JUGADOR;
    
    return V_KILOS;
    
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);    
        RETURN SQLERRM;
END;
/
begin
 dbms_output.put_line('EL PESO EN KILOGRAMOS DEL JUGADOR ES ' || f_KILOS_jugador(584) || ' kg');
end;
/
--10. Funciz0ara obtener el equipo de un jugador basado en su cRgo:
/
CREATE OR REPLACE FUNCTION f_equipo_jugador (p_JUGADOR  JUGADORES.CODIGO%TYPE)
RETURN VARCHAR2
IS
V_EQUIPO VARCHAR2(100);

BEGIN
    SELECT E.NOMBRE INTO V_EQUIPO
    FROM EQUIPOS E, JUGADORES J
    WHERE J.NOMBRE_EQUIPO=E.NOMBRE
    AND J.CODIGO= p_JUGADOR;
    
    return V_EQUIPO;
    
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);    
        RETURN SQLERRM;
END;
/
begin
    dbms_output.put_line('EL EQUIPO DONDE JUEGA ESE JUGADOR ES ' || f_equipo_jugador(584));
end;
/
--11. Funciz0ara obtener el nvro total de jugadores en un equipo:
/
CREATE OR REPLACE FUNCTION f_equipo_TOTALjugadores (p_EQUIPO  EQUIPOS.NOMBRE%TYPE)
RETURN NUMBER
IS
V_TOTAL_JUGADORES_EQUIPO NUMBER;

BEGIN
    SELECT COUNT(NVL(J.CODIGO,0)) INTO V_TOTAL_JUGADORES_EQUIPO
    FROM EQUIPOS E, JUGADORES J
    WHERE J.NOMBRE_EQUIPO=E.NOMBRE
    AND UPPER(E.NOMBRE)= p_EQUIPO;
    
    return V_TOTAL_JUGADORES_EQUIPO;
    
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);    
        RETURN SQLERRM;
END;
/
begin
    dbms_output.put_line('EL NE JUGADORES DE ESE EQUIPO ES: ' || f_equipo_totaljugadores('SUNS'));
end;
/
--12. Procedimiento para insertar un nuevo jugador en la tabla "jugadores":
CREATE OR REPLACE PROCEDURE spINSERTAR_JUGADOR(V_CODIGO JUGADORES.CODIGO%TYPE,V_NOMBRE JUGADORES.NOMBRE%TYPE, V_CIUDAD JUGADORES.PROCEDENCIA%TYPE, V_ALTURA JUGADORES.ALTURA%TYPE, V_PESO JUGADORES.PESO%TYPE, V_POSICION JUGADORES.POSICION%TYPE, V_EQUIPO EQUIPOS.NOMBRE%TYPE)
IS
BEGIN
    INSERT INTO JUGADORES (CODIGO, NOMBRE, PROCEDENCIA, ALTURA, PESO, POSICION, NOMBRE_EQUIPO)
    VALUES (V_CODIGO, V_NOMBRE, V_CIUDAD, V_ALTURA, V_PESO, V_POSICION, V_EQUIPO);
    DBMS_OUTPUT.PUT_LINE('Jugador insertado correctamente.');
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);
END;
/
BEGIN 
    spINSERTAR_JUGADOR (171717,NULL, NULL, NULL,NULL, NULL, NULL);
END; 
/
SELECT * FROM EQUIPOS WHERE UPPER(NOMBRE)= 'REAL BETIS';
/
--13. Procedimiento para actualizar la ciudad de un equipo espec©co:
CREATE OR REPLACE PROCEDURE spACTUALIZA_CIUDADEQUIPO(P_CIUDAD EQUIPOS.CIUDAD%TYPE, P_EQUIPO EQUIPOS.NOMBRE%TYPE)
IS
BEGIN
    UPDATE EQUIPOS
    SET CIUDAD = P_CIUDAD
    WHERE NOMBRE= P_EQUIPO;
    
    DBMS_OUTPUT.PUT_LINE('Ciudad actualizada correctamente.');
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);
END;
/
BEGIN 
    spACTUALIZA_CIUDADEQUIPO ('SEVILLA', 'BULLS');
END; 
/
-- 14. Procedimiento para eliminar todas las estadôicas de un jugador:
CREATE OR REPLACE PROCEDURE sp_BORRA_ESTADISTICAS(P_CODIGO JUGADORES.CODIGO%TYPE)
IS
BEGIN
    DELETE
    FROM ESTADISTICAS
    WHERE JUGADOR= P_CODIGO;
    
    DBMS_OUTPUT.PUT_LINE('ESTADISTICAS ELIMINADAS correctamente.');
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);
END;
/
BEGIN 
    sp_BORRA_ESTADISTICAS (584);
END; 
/
/*Aqu4ienes una serie de ejercicios màdesafiantes que abarcan consultas, PL/SQL con funciones y procedimientos, y triggers:

1. Consultas:
a) Obt el nombre y la posiciz$e todos los jugadores que han promediado màde 20 puntos por partido en una temporada espec©ca.
b) Encuentra el nombre y la ciudad de los equipos que tienen màde 3 jugadores con una altura DE 7-0.
c) Obt el nombre y el promedio de rebotes por partido de los jugadores de un equipo en particular, 
ordenados de mayor a menor promedio de rebotes.
d) Encuentra el nombre del jugador que ha registrado la mayor cantidad de tapones en una temporada determinada.*/
--A)
SELECT J.NOMBRE, J.POSICION
FROM JUGADORES J, ESTADISTICAS ES
WHERE J.CODIGO= ES.JUGADOR
AND ES.PUNTOS_POR_PARTIDO>20;

--B)
SELECT E.NOMBRE, E.CIUDAD
FROM EQUIPOS E, JUGADORES J
WHERE J.NOMBRE_EQUIPO=E.NOMBRE
AND J.ALTURA= '7-0';

--C)
SELECT DISTINCT J.NOMBRE, SUM(ES.REBOTES_POR_PARTIDO) AS TOTAL_REBOTES
FROM JUGADORES J, ESTADISTICAS ES, EQUIPOS E
WHERE J.CODIGO= ES.JUGADOR
AND J.NOMBRE_EQUIPO=E.NOMBRE
AND UPPER(E.NOMBRE)='SUNS'
GROUP BY J.NOMBRE
ORDER BY 2 DESC;

--D)
SELECT J.NOMBRE, SUM(ES.TAPONES_POR_PARTIDO) AS TOTAL_TAPONES
FROM JUGADORES J, ESTADISTICAS ES
WHERE J.CODIGO= ES.JUGADOR
GROUP BY J.NOMBRE
HAVING SUM(ES.TAPONES_POR_PARTIDO) = (SELECT MAX(SUM(ES.TAPONES_POR_PARTIDO)) AS TOTAL_TAPONES
                                        FROM JUGADORES J, ESTADISTICAS ES
                                        WHERE J.CODIGO= ES.JUGADOR
                                        GROUP BY J.NOMBRE);

/*2. PL/SQL con funciones y procedimientos:
a) Crea una funciz1ue calcule la edad de un jugador en aì dada su fecha de nacimiento.
b) Crea un procedimiento que actualice el peso de todos los jugadores de un equipo en un valor espec©co.
c) Crea una funciz1ue devuelva el nombre del equipo con la mayor cantidad de victorias en una temporada determinada.
d) Crea un procedimiento que elimine todos los jugadores que no hayan registrado ninguna estadôica en una temporada espec©ca.*/

--A)
/
CREATE OR REPLACE FUNCTION f_EDAD_JUGADOR (p_fecnac  DATE, P_CODIGO JUGADORES.CODIGO%TYPE)
RETURN NUMBER
IS
V_NOMBRE JUGADORES.NOMBRE%TYPE;
V_EDAD NUMBER;

BEGIN
    SELECT J.NOMBRE,  TRUNC(MONTHS_BETWEEN(SYSDATE, P_FECNAC)/12) INTO V_NOMBRE, V_EDAD
    FROM JUGADORES J
    WHERE J.CODIGO= P_CODIGO;
    
    return V_EDAD;
    
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);    
        RETURN SQLERRM;
END;
/
begin
    dbms_output.put_line('LA EDAD DE ESE JUGADOR ES: ' || f_EDAD_JUGADOR((TO_DATE('27/04/1992', 'DD/MM/YYYY')), 584);
end;
/
--B)Crea un procedimiento que actualice el peso de todos los jugadores de un equipo en un valor espec©co.
CREATE OR REPLACE PROCEDURE spACTUALIZA_PESO(P_PESO NUMBER, P_EQUIPO EQUIPOS.NOMBRE%TYPE)
IS
BEGIN
    UPDATE JUGADORES
    SET PESO = P_PESO
    WHERE UPPER(NOMBRE_EQUIPO)= P_EQUIPO;
    
    DBMS_OUTPUT.PUT_LINE('PESO DEL EQUIPO ACTUALIZADO correctamente.');
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OcurriBl error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);
END;
/
BEGIN 
    spACTUALIZA_PESO (90, 'BULLS');
END; 
/
SELECT * FROM JUGADORES WHERE UPPER(NOMBRE_EQUIPO)= 'BULLS';
--C)Crea una funciz1ue devuelva el nombre del equipo con la mayor cantidad de victorias en una temporada determinada.

--D)Crea un procedimiento que elimine todos los jugadores que no hayan registrado ninguna estadôica en una temporada espec©ca


/*3. Triggers:
a) Crea un trigger que registre en una tabla de auditor`cada vez que se inserte, actualice o elimine un jugador de la tabla "jugadores".
b) Crea un trigger que bloquee la inserciz$e un nuevo equipo si el nvro total de equipos existentes en la tabla "equipos" 
excede un valor determinado.
c) Crea un trigger que actualice autom)camente el nvro total de partidos jugados por un equipo cada vez que se inserte un 
nuevo partido en la tabla "partidos".

Recuerda que estos ejercicios son desafiantes y requerir un buen conocimiento de SQL y PL/SQL. Te sugiero que los resuelvas por tu cuenta y 
luego los revises para obtener la soluciz#orrecta. µena suerte en tu examen!*/

--A)

--B)

--C)

--D)

/
-----------------------------------------12/06/23--------------------------------------
-- 1. REALIZA UN TRIGGER QUE LOGRE ASEGURARSE QUE LOS EQUIPOS NO PUEDEN CAMBIAR DE CONFERENCIA
CREATE OR REPLACE TRIGGER TR_PROHIBIDO_CAMBIAR_CONFERENCIA
BEFORE
UPDATE OF CONFERENCIA
ON EQUIPOS
FOR EACH ROW
--DECLARE
BEGIN
    
    IF :NEW.CONFERENCIA <> :OLD.CONFERENCIA THEN
        raise_application_error(-20600,'NO SE PUEDE CAMBIAR LA CONFERENCIA DE UN EQUIPO');
    END IF;
END;
/
UPDATE EQUIPOS
    SET CONFERENCIA = 'SUR'
WHERE UPPER(NOMBRE) = 'BULLS';

-- 2. EN UN MISMO TRIGGER, IMPEDIR QUE UN EQUIPO JUEGUE CONTRA SI MISMO Y QUE EN UN PARTIDO NO EMPATEN EN PUNTOS

CREATE OR REPLACE TRIGGER TR_PARTIDOS_LEGALES
BEFORE
INSERT OR UPDATE OF EQUIPO_LOCAL OR UPDATE OF EQUIPO_VISITANTE OR UPDATE OF PUNTOS_LOCAL OR UPDATE OF PUNTOS_VISITANTE
ON PARTIDOS
FOR EACH ROW
--DECLARE
BEGIN
    
    IF :NEW.EQUIPO_LOCAL = :NEW.EQUIPO_VISITANTE THEN
        raise_application_error(-20600,'UN EQUIPO NO PUEDE JUGAR CONTRA SI MISMO');
    END IF;
    IF :NEW.PUNTOS_LOCAL = :NEW.PUNTOS_VISITANTE THEN
        raise_application_error(-20600,'NO SE PUEDE EMPATAR EL PARTIDO');
    END IF;
END;
/

-------------------13/06/23--------------------------

--3. Trigger para rellenar autom)camente el promedio de puntos por partido 
--   de un jugador cuando se inserta en la tabla estadôicas, suponiendo que los puntos del partido se reparten
--   equitativamente entre todos los jugadores.
SELECT SUM(PUNTOS), SUM(TOTAL_PARTIDOS)
FROM(
        SELECT SUM(PUNTOS_LOCAL)AS PUNTOS, NVL(COUNT(P.CODIGO),0) AS TOTAL_PARTIDOS
        FROM PARTIDOS P, EQUIPOS E, JUGADORES J
        WHERE E.NOMBRE=P.EQUIPO_LOCAL
        AND J.NOMBRE_EQUIPO=E.NOMBRE
        --AND J.CODIGO=:NEW.JUGADOR
        --AND P.TEMPORADA = :NEW.TEMPORADA
        UNION ALL
        SELECT SUM(PUNTOS_VISITANTE), NVL(COUNT(P.CODIGO),0)
        FROM PARTIDOS P, EQUIPOS E, JUGADORES J
        WHERE E.NOMBRE=P.EQUIPO_VISITANTE
        AND J.NOMBRE_EQUIPO=E.NOMBRE
        --AND J.CODIGO=:NEW.JUGADOR
        --AND P.TEMPORADA = :NEW.TEMPORADA
        );
/
CREATE OR REPLACE TRIGGER TR_MEDIAPTOS_JUGADOR_EQUIPO
BEFORE
INSERT
ON ESTADISTICAS
FOR EACH ROW
DECLARE
    V_TOTAL_PUNTOS NUMBER;
    V_TOTAL_PARTIDOS NUMBER;
    V_TOTAL_JUDAGORES NUMBER;
    V_MEDIA NUMBER;
BEGIN
    SELECT SUM(PUNTOS), SUM(TOTAL_PARTIDOS) INTO V_TOTAL_PUNTOS, V_TOTAL_PARTIDOS
    FROM(
            SELECT SUM(PUNTOS_LOCAL)AS PUNTOS, NVL(COUNT(P.CODIGO),0) AS TOTAL_PARTIDOS
            FROM PARTIDOS P, EQUIPOS E, JUGADORES J
            WHERE E.NOMBRE=P.EQUIPO_LOCAL
            AND J.NOMBRE_EQUIPO=E.NOMBRE
            AND J.CODIGO=:NEW.JUGADOR
            AND P.TEMPORADA = :NEW.TEMPORADA
            UNION ALL
            SELECT SUM(PUNTOS_VISITANTE), NVL(COUNT(P.CODIGO),0)
            FROM PARTIDOS P, EQUIPOS E, JUGADORES J
            WHERE E.NOMBRE=P.EQUIPO_VISITANTE
            AND J.NOMBRE_EQUIPO=E.NOMBRE
            AND J.CODIGO=:NEW.JUGADOR
            AND P.TEMPORADA = :NEW.TEMPORADA
            );
            
    SELECT NVL(COUNT(J.CODIGO),0) INTO V_TOTAL_JUDAGORES
    FROM JUGADORES J
    WHERE J.NOMBRE_EQUIPO =(SELECT NOMBRE_EQUIPO
                            FROM JUGADORES
                            WHERE CODIGO= :NEW.JUGADOR);
       
        IF V_TOTAL_PUNTOS=0 THEN
        :NEW.PUNTOS_POR_PARTIDO := 0;
        
        ELSE
        V_MEDIA:= ((V_TOTAL_PUNTOS/V_TOTAL_PARTIDOS)/ V_TOTAL_JUDAGORES);
        :NEW.PUNTOS_POR_PARTIDO := V_MEDIA;
        END IF;
         
END;
/
------OTRA FORMA DE HACERLO ES CREANDO UNA FUNCIÎ, 
------Y DESPUS CREAR EL TRIGGER PARA LLAMAR A ESA FUNCIÎ:

CREATE OR REPLACE FUNCTION F_PROMEDIO_JUGADOR (pJug jugadores.codigo%type, pTemp estadisticas.temporada%type)
return number
is
    V_PUNTOS_TOTAL_EQ_JUGADOR NUMBER;
    V_PARTIDOS_JUGADOS NUMBER;
    V_JUG_EQ NUMBER;
    V_MEDIA_JUG NUMBER;

begin

     -- CALCULAMOS LOS PUNTOS TOTALES DEL EQUIPO DEL JUGADOR POR TEMPORADA Y
     -- CALCULAMOS LOS NUMEROS DE PARTIDOS JUGADOS
     SELECT SUM(PUNTOS),SUM(NUMPARTIDOS) INTO V_PUNTOS_TOTAL_EQ_JUGADOR,V_PARTIDOS_JUGADOS
     FROM (
        SELECT SUM(PA.PUNTOS_VISITANTE) AS PUNTOS,NVL(COUNT(PA.CODIGO),0) AS NUMPARTIDOS
        FROM PARTIDOS PA, EQUIPOS E, JUGADORES J
        WHERE E.NOMBRE = PA.EQUIPO_VISITANTE
        AND E.NOMBRE = J.NOMBRE_EQUIPO
        AND J.CODIGO = pJug
        AND PA.TEMPORADA = pTemp
        UNION ALL
        SELECT SUM(PA.PUNTOS_LOCAL),NVL(COUNT(PA.CODIGO),0)
        FROM PARTIDOS PA, EQUIPOS E, JUGADORES J
        WHERE E.NOMBRE = PA.EQUIPO_LOCAL
        AND E.NOMBRE = J.NOMBRE_EQUIPO
        AND J.CODIGO = pJug
        AND PA.TEMPORADA = pTemp
        );
        
        -- SI NO HAY PUNTOS, PUES DIRECTAMENTE PONGO UN CERO
        IF (V_PUNTOS_TOTAL_EQ_JUGADOR = 0) THEN
           return 0;
        ELSE
           -- NECESITO SABER CUANTOS JUGADORES TIENE EL EQUIPO
           SELECT COUNT(CODIGO) INTO V_JUG_EQ
           FROM JUGADORES
           WHERE NOMBRE_EQUIPO = (SELECT NOMBRE_EQUIPO FROM JUGADORES WHERE CODIGO = pJug);
           
           -- CALCULAMOS LA MEDIA DE PUNTOS POR JUGADORES
           V_MEDIA_JUG := ((V_PUNTOS_TOTAL_EQ_JUGADOR/V_PARTIDOS_JUGADOS)/V_JUG_EQ);
          
           return V_MEDIA_JUG;
        END IF;

end;

CREATE OR REPLACE TRIGGER TR_RELLENA_PROMEDIO_CON_FUNCION
BEFORE INSERT
ON ESTADISTICAS
FOR EACH ROW 
BEGIN
   :NEW.PUNTOS_POR_PARTIDO := F_PROMEDIO_JUGADOR(:new.jugador, :new.temporada);
END;
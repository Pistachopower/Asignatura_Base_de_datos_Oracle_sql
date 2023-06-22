SET SERVEROUTPUT ON;

--1- ESCRIBIR UN BLOQUE PL/SQL QUE ESCRIBA EL TEXTO 'Hola'
DECLARE 
    SALUDO VARCHAR2(7):= 'Hola';
BEGIN 
    DBMS_OUTPUT.PUT_LINE(SALUDO );
END;

--2- mediante un bloque pl-sql cuenta el numero de filas que hay
--en la tabla productos, deposita el resultado en una variable
--y visualiza su contenido
DECLARE 
    TOTAL_FILAS PRODUCTOS.CODIGOPRODUCTO%TYPE;
BEGIN 
    SELECT COUNT(CODIGOPRODUCTO) INTO TOTAL_FILAS 
    FROM PRODUCTOS;
    DBMS_OUTPUT.PUT_LINE('TOTAL DE FILAS TABLA PRODUCTOS ' || total_filas);
END;


--3 ENCONTRAR ERROR
DECLARE 
    num1 NUMBER(8,2):=0.00;
    num2 NUMBER(8,2) not null DEFAULT 0;
    --num3 NUMBER(8,2) not null; si está not null debe tener un valor
    num3 NUMBER(8,2) not null:= 0; 
    cantidad integer(3);
    -- se debe declarar por separado con el tipo de dato precio, descuento number(6);
    precio number(6);
    descuento number(6);
    -- numb4 num1%rowtype; rowtype es usada para tipos de datos de tabla
    numb4 num1%type;
    -- dto CONSTANT INTEGER; debe tener un valor definido en la constante
    dto CONSTANT INTEGER:= 0;
BEGIN 
    DBMS_OUTPUT.PUT_LINE(num1 || ' ' || num2 || ' ' || num3);
END;

/*
--4- escribir un procedimiento que reciba dos números y visualice su suma 
*/
CREATE OR REPLACE PROCEDURE p_suma_numeros (num1 integer, num2 integer)
is 
    resultado integer;
begin 
    resultado:= num1 + num2;
    DBMS_OUTPUT.put_line(resultado);
end;

begin 
    p_suma_numeros (5,5);
end;

/*
5. Codificar un procedimiento que reciba una cadena 
y la visualice al revés.
*/

create or replace procedure p_cadena_al_reves (cadena varchar2)
is 
    cadena_al_reves varchar2(100);
    cadena_final  varchar2(100);
begin 
    cadena_al_reves := cadena;
    for i in reverse 1..length(cadena_al_reves) loop
        cadena_final := cadena_final || SUBSTR(cadena_al_reves,i , 1);
    end loop;
    DBMS_OUTPUT.PUT_LINE(cadena_final);
end;

begin 
    p_cadena_al_reves('nelson');
end;


DROP PROCEDURE p_cadena_al_reves


/*
6. Escribir una función que reciba una fecha y devuelva el año, 
en número, correspondiente a esa fecha.
*/
CREATE OR REPLACE FUNCTION f_Fecha(fecha date)
RETURN NUMBER
IS 
    v_anio NUMBER;
BEGIN 
    v_anio := to_number(to_char(fecha, 'YYYY'));
    DBMS_OUTPUT.PUT('La fecha es ' );
    RETURN v_anio;
END;

--forma 1 
BEGIN 
    DBMS_OUTPUT.PUT_LINE(f_Fecha('01/01/1993'));
END;

7. Escribir un bloque PL/SQL que haga uso de la función anterior.
BEGIN 
DBMS_OUTPUT.PUT_LINE(F_RECIBE_FECHA(TO_DATE('27/12/1998', 'DD/MM/YYYY')));
END;


8. Codificar un procedimiento que reciba una lista de hasta 5 números y visualice su
suma.
CREATE OR REPLACE PROCEDURE spsuma_numeros (
    num1   NUMBER,
    num2   NUMBER,
    num3   NUMBER,
    num4   NUMBER,
    num5   NUMBER
) IS
    v_suma NUMBER := 0;
BEGIN
    v_suma := num1 + num2 + num3 + num4 + num5;
    dbms_output.put_line('SUMA: ' || v_suma);
END;
 
BEGIN 
   spsuma_numeros (1,2,3,4,5);
END;

/*
9. Implementar un procedimiento que reciba un importe y visualice el 
desglose del cambio en unidades monetarias de 0.01, 0.02, 0.05, 0.10, 
0.20, 0.50, 1, 2, 5, 10, 20, 50, 100,
200, 500 y 1000 € en orden inverso al que aparecen aquí enumeradas.
*/
create or replace PROCEDURE spMostrarCambio
(P_importe number)
IS

    v_cambio number:= p_importe;
    v_moneda number;
    v_cantidad number;
    
BEGIN
    dbms_output.put_line('Desglose de: ' || p_importe || ' euros.');
    while v_cambio > 0 loop
        IF v_cambio >= 1000 THEN
            v_moneda:=1000;
        ELSIF v_cambio >= 500 THEN
            v_moneda:=500;
        ELSIF v_cambio >= 200 THEN
            v_moneda:=200;
        ELSIF v_cambio >= 100 THEN
            v_moneda:=100;
        ELSIF v_cambio >= 50 THEN
            v_moneda:=50;
        ELSIF v_cambio >= 20 THEN
            v_moneda:=20;
        ELSIF v_cambio >= 10 THEN
            v_moneda:=10;
        ELSIF v_cambio >= 5 THEN
            v_moneda:=5;
        ELSIF v_cambio >= 2 THEN
            v_moneda:=2;
        ELSIF v_cambio >= 1 THEN
            v_moneda:=1;
        ELSIF v_cambio >= 0.5 THEN
            v_moneda:=0.5;
        ELSIF v_cambio >= 0.2 THEN
            v_moneda:=0.2;
        ELSIF v_cambio >= 0.1 THEN
            v_moneda:=0.1;
        ELSIF v_cambio >= 0.05 THEN
            v_moneda:=0.05;
        ELSIF v_cambio >= 0.02 THEN
            v_moneda:=0.02;
        ELSE
            v_moneda:=0.01;
        END IF;
        
        v_cantidad:=TRUNC(v_cambio/v_moneda);
        v_cambio:=MOD(v_cambio,v_moneda);
        dbms_output.put_line('Billetes/monedas de ' || v_moneda || ': ' || v_cantidad);
    END LOOP;
    
END;



begin 
spMostrarCambio(150);
end;

/*
10. Realizar un programa que nos muestre la tabla de multiplicar de 
un número entero pasado por parámetro.
*/
CREATE OR REPLACE PROCEDURE P_MOSTRAR_TABLA_M
(P_NUM INTEGER)
IS 
BEGIN
    FOR i in 1..10 loop
        dbms_output.put_line(P_NUM || ' * ' || i || ' = ' || p_num * i);
    END LOOP;
END;

BEGIN 
    P_MOSTRAR_TABLA_M(5);
END;


/*
10. Realizar un programa que nos muestre la tabla de multiplicar de 
un número entero pasado por parámetro.
*/
CREATE OR REPLACE PROCEDURE P_MOSTRAR_TABLA_M
(P_NUM INTEGER)
IS 
BEGIN
    FOR i in 1..10 loop
        dbms_output.put_line(P_NUM || ' * ' || i || ' = ' || p_num * i);
    END LOOP;
END;

BEGIN 
    P_MOSTRAR_TABLA_M(5);
END;

/*
11. Escribe un algoritmo que reciba tres números y los muestre ordenados.
*/
CREATE OR REPLACE FUNCTION F_ALGORITMO_BURBUJA
(A NUMBER, B NUMBER, C NUMBER) 
RETURN VARCHAR2 
IS
    X NUMBER := A;
    Y NUMBER:= B;
    Z NUMBER:= C;
    TEMPORAL NUMBER;
BEGIN 
    IF X > Y THEN
        TEMPORAL:= X;
        X:= Y;
        Y:= TEMPORAL;
    END IF;
    
    IF X > Z THEN
        TEMPORAL:= X;
        X:= Z;
        Z:= TEMPORAL;
    END IF;
    
    IF Y > Z THEN 
        TEMPORAL:= Y;
        Y:= Z;
        Z:= TEMPORAL;
    END IF;
    
    RETURN 'Los numeros ordenados son '
            || X || ', ' || Y || ', ' || Z;
END;

DECLARE 
A NUMBER := 3;
B NUMBER := 10;
C NUMBER := 1;
RESULTADO VARCHAR2(100);

BEGIN 
RESULTADO:= F_ALGORITMO_BURBUJA(A,B, C);
dbms_output.put_line(resultado);
END;


/*
12- Escribe un algoritmo que reciba cinco números y muestre 
los que sean mayores que la media
*/
DECLARE
    -- Declaración y asignacion de variables
    num1 NUMBER:= &Ingrese_primer_numero;
    num2 NUMBER := &Ingrese_segundo_numero;
    num3 NUMBER := &Ingrese_tercer_numero;
    num4 NUMBER := &Ingrese_cuarto_numero;
    num5 NUMBER:= &Ingrese_quinto_numero;
    media NUMBER;
BEGIN

    -- Cálculo de la media
    media := (num1 + num2 + num3 + num4 + num5) / 5;

    -- Comprobación de cuáles números son mayores que la media
    IF num1 > media THEN
        DBMS_OUTPUT.PUT_LINE('El número ' || num1 || 
        ' es mayor que la media');
    END IF;

    IF num2 > media THEN
        DBMS_OUTPUT.PUT_LINE('El número ' || num2 || 
        ' es mayor que la media');
    END IF;

    IF num3 > media THEN
        DBMS_OUTPUT.PUT_LINE('El número ' || num3 || 
        ' es mayor que la media');
    END IF;

    IF num4 > media THEN
        DBMS_OUTPUT.PUT_LINE('El número ' || num4 || 
        ' es mayor que la media');
    END IF;

    IF num5 > media THEN
        DBMS_OUTPUT.PUT_LINE('El número ' || num5 || 
        ' es mayor que la media');
    END IF;
END;

/*
13. Escribe un programa que reciba dos números 'nota' y 'edad' y 
un carácter 'sexo' y muestre el mensaje 'ACEPTADA' si la nota 
es mayor o igual a cinco, la edad es mayor o igual a dieciocho 
y el sexo es 'M'. En caso de que se cumpla lo mismo, pero el sexo
sea 'V', debe imprimir 'POSIBLE'.
*/
DECLARE
    nota   NUMBER := 5;
    edad   INTEGER := 18;
    sexo   CHAR(2) := 'v';
BEGIN
    IF nota >= 5 AND edad >= 18 AND sexo = 'm' THEN
        dbms_output.put_line('ACEPTADO');
    ELSE
        IF nota >= 5 AND edad >= 18 AND sexo = 'v' THEN
            dbms_output.put_line('POSIBLE');
        END IF;
    END IF;
END;

/*
14. Procedimiento que reciba un número entero entre uno 
y doce e imprima el número de
días que tiene el mes correspondiente.
*/
CREATE OR REPLACE PROCEDURE P_NUM_DIAS_MESES
(P_MES INTEGER)
IS 

BEGIN
    IF p_mes > 12 THEN
        DBMS_OUTPUT.PUT_LINE('EL MES ES INCORRECTO');
    ELSE 
        IF p_mes = 1 OR p_mes = 3 OR p_mes = 4 OR p_mes = 5 
        OR p_mes = 6 OR p_mes = 7 OR p_mes = 8 OR p_mes = 9
        OR p_mes = 10 OR p_mes = 11 OR p_mes = 12 THEN
            DBMS_OUTPUT.PUT_LINE('EL MES ESTA ENTRE 30 Y 31 DIAS');
            
        ELSE
            IF p_mes = 2 THEN
                DBMS_OUTPUT.PUT_LINE('EL MES 28 DIAS');
            END IF;
        END IF;
    END IF;
END;


BEGIN 
 P_NUM_DIAS_MESES(100);
END;

/*
15. Algoritmo que reciba una letra e imprima 
si es vocal o consonante.
*/
DECLARE
    letra CHAR(2) := 'A';
BEGIN
    CASE
        WHEN letra IN (
            'A',
            'E',
            'I',
            'O',
            'U'
        ) THEN
            dbms_output.put_line('vocal');
        WHEN letra IN (
            'B',
            'C',
            'D',
            'F',
            'G',
            'H',
            'J',
            'K',
            'L',
            'M',
            'Ñ',
            'P',
            'Q',
            'R',
            'S',
            'T',
            'V',
            'W',
            'X',
            'Y',
            'Z'
        ) THEN
            dbms_output.put_line('consonante');
    END CASE;
END;

/*
16. Algoritmo que reciba dos números, a y b, y cuente 
desde el menor hasta el mayor.
*/

declare 
    num1 integer:= 5;
    num2 integer:= 8;
begin 
    case 
        when (num1 > num2) then 
            for i in num2..num1 loop
                DBMS_OUTPUT.PUT_LINE(i);
            end loop;
        when (num2 > num1) then
            for i in num1..num2 loop
                DBMS_OUTPUT.PUT_LINE(i);
            end loop;
    end case;
end;

/*
17. Algoritmo que multiplique dos números pasados por 
parámetros usando sumas
sucesivas.
*/
CREATE OR REPLACE FUNCTION F_SUMAS_SUCESIVAS
(P_NUMERO INTEGER, P_VECES INTEGER)
RETURN INTEGER
IS
   V_SUMA_SUCESIVA INTEGER:= 0;
BEGIN
    FOR I IN 1..P_VECES LOOP
        V_SUMA_SUCESIVA:= V_SUMA_SUCESIVA + P_NUMERO; 
    END LOOP;
    
    RETURN V_SUMA_SUCESIVA; 
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ocurrió el error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);    
    RETURN SQLERRM;
END;


SELECT F_SUMAS_SUCESIVAS(3,4) FROM DUAL;

/*
18. Algoritmo que muestre los números entre a y b 
(ambos valores enteros dados por el usuario).
*/
declare 
num1 integer:= &INTRODUCE_NUM1;
num2 integer:= &INTRODUCE_NUM2;
begin
    case 
        when (num1 > num2) then 
            for i in num2..num1 loop
                DBMS_OUTPUT.PUT_LINE(i);
            end loop;
        when (num2 > num1) then
            for i in num1..num2 loop
                DBMS_OUTPUT.PUT_LINE(i);
            end loop;
            
        else 
            if (num1 = num2) then
                DBMS_OUTPUT.PUT_LINE('LOS VALORES SON IGUALES');
            end if;
    end case;
end;

/*
19. Crea una función en PL/SQL que reciba como parámetro 
un número entero y devuelva el como resultado su factorial.
*/
CREATE OR REPLACE FUNCTION F_FACTORIAL
(P_NUMERO INTEGER)
RETURN INTEGER
IS
   V_FACTORIAL INTEGER:= 1;
BEGIN
    FOR I IN 1..P_NUMERO LOOP
        V_FACTORIAL:= V_FACTORIAL * I; 
    END LOOP;
    
    RETURN V_FACTORIAL; 
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ocurrió el error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);    
    RETURN SQLERRM;
END;

SELECT F_FACTORIAL (5) FROM DUAL;


/*
20. Utilizando la función anterior, hacer un procedimiento 
que escriba los primeros 8 factoriales, mostrando en pantalla 
lo siguiente:
El factorial de 1 es 1
El factorial de 2 es 2
El factorial de 3 es 6
El factorial de 4 es 24
El factorial de 5 es 120
El factorial de 6 es 720
El factorial de 7 es 5040
El factorial de 8 es 40320
*/

CREATE OR REPLACE FUNCTION F_FACTORIAL
(P_NUMERO INTEGER)
RETURN INTEGER
IS
   V_FACTORIAL INTEGER:= 1;
BEGIN
    FOR I IN 1..P_NUMERO LOOP
        V_FACTORIAL:= V_FACTORIAL * I; 
        DBMS_OUTPUT.PUT_LINE('El factorial de ' || I || ' es ' || V_FACTORIAL);
    END LOOP;
    
    RETURN V_FACTORIAL; 
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ocurrió el error ' ||SQLCODE ||' ---mensaje: ' || SQLERRM);    
    RETURN SQLERRM;
END;

SELECT F_FACTORIAL (8) FROM DUAL;

/*
Codificar un procedimiento que permita borrar un empleado cuyo
número se pasará en
la llamada.
*/
CREATE OR REPLACE PROCEDURE borrar_empleado (
v_emp_no emp.empno%TYPE
)
IS
BEGIN
DELETE FROM emp
WHERE empno = v_emp_no;
    DBMS_OUTPUT.PUT_LINE('Empleado borrado exitosamente.');
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontró ningún empleado con el número especificado.');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al borrar el empleado: ' || SQLERRM);
END borrar_empleado;


begin
borrar_empleado(7434);
end;


/*
Escribir un procedimiento que modifique la localidad de un departamento. El
procedimiento recibirá como parámetros el número del departamento y la localidad
nueva.
*/
CREATE OR REPLACE PROCEDURE actualizar_cod_depart (
v_deptno dept.deptno%TYPE,
v_loc dept.loc%TYPE
)
IS
BEGIN
UPDATE dept
SET loc = v_loc
WHERE deptno = v_deptno;
DBMS_OUTPUT.PUT_LINE('La localidad del departamento ' || v_deptno || ' ha sido actualizada exitosamente.');
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No se encontró ningún empleado con el número especificado.');
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error al borrar el empleado: ' || SQLERRM);
END actualizar_cod_depart;


begin
actualizar_cod_depart(10, 'sevilla');
end;




/*
Visualizar todos los procedimientos y funciones de los usuarios almacenados en la
base de datos y su situación (valid o invalid).
*/

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PROCEDURE', 'FUNCTION');
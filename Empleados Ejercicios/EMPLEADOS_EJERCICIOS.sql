--1. Nif_Empleado y salario de los empleados que pertenezcan departamento 52
SELECT NIFEMP, DEPART,SALARIO
FROM EMPLEADOS
WHERE DEPART= 52;


--2. Nombre, Departamento y salario de los empleados que ganen menos de 200 €
SELECT NOMBRE, DEPART, SALARIO
FROM EMPLEADOS
WHERE SALARIO < 200;

--3. Empleados cuya fecha de contratación sea posterior al año 80.
--Todos los campos
SELECT *
FROM EMPLEADOS
WHERE FECCON > (TO_DATE('01/01/1980', 'DD/MM/YYYY'));

--4. Empleados cuyo apellido empiece por P y ganen entre 200 y 300 €
SELECT NOMBRE, SALARIO
FROM EMPLEADOS
WHERE NOMBRE LIKE 'P%'
AND SALARIO BETWEEN 200 AND 300;

--5. Numero de hijos de los empleados cuyo nombre contenga una letra n
SELECT NOMBRE, HIJOS
FROM EMPLEADOS 
WHERE NOMBRE LIKE '%N%';



--6. Empleados que pertenezcan al departamento 40 o 52 y que tengan 
--un sueldo inferior a 200
SELECT NOMBRE, DEPART, SALARIO
FROM EMPLEADOS 
WHERE DEPART IN ('40','52')
AND SALARIO< 200;

--7. Empleados cuyo nombre empiece por P, que no tengan hijos y que 
--hayan realizado horas extras.
SELECT NOMBRE, HIJOS, EXTRAS 
FROM EMPLEADOS 
WHERE NOMBRE LIKE 'P%'
AND HIJOS LIKE '%0%';

--8. Empleados que tengan mas de 5 extras, con un hijo y que pertenezcan 
--al departamento 51 o 52.
--Ordenados por nombre
SELECT *
FROM EMPLEADOS;
SELECT NOMBRE, EXTRAS, HIJOS, DEPART
FROM EMPLEADOS
WHERE EXTRAS > 5
AND HIJOS = 1
AND DEPART IN (51,52)
ORDER BY NOMBRE;


--9. Empleados que tengan entre 2 y 4 hijos y que no sean del 
--departamento 52 ni del 40 ni del 32
SELECT NOMBRE, HIJOS, DEPART
FROM EMPLEADOS
WHERE HIJOS BETWEEN 2 AND 4
AND DEPART NOT IN (32,40,52);

--10. Obtener una lista con el nombre, el salario y el número de horas
--extraordinarias trabajadas de aquellos empleados que tienen algún hijo.
SELECT NOMBRE, SALARIO, EXTRAS, HIJOS
FROM EMPLEADOS
WHERE HIJOS <> 0
AND EXTRAS IS NOT NULL; 

--11. Obtener un listado alfabético de los empleados cuyo salario sea 
--igual o superior a 200 € y sea igual o inferior a las 300€.
SELECT NOMBRE, SALARIO
FROM EMPLEADOS
WHERE SALARIO >= 200
AND SALARIO <=300
ORDER BY NOMBRE ASC;


--12. Obtener un listado con los nombres de los empleados que no cobran
--horas extra.
SELECT NOMBRE, EXTRAS 
FROM EMPLEADOS 
WHERE EXTRAS IS NULL;

--13. Idem con los empleados que sí las cobran ordenados de más horas 
--extras a menos.
SELECT NOMBRE, EXTRAS 
FROM EMPLEADOS
WHERE EXTRAS IS NOT NULL
ORDER BY EXTRAS DESC;

--14. Obtener los nombres de los empleados cuyo número de horas 
--extra trabajadas sea 4 o 6.
SELECT NOMBRE, EXTRAS
FROM EMPLEADOS
WHERE EXTRAS IN (4,6);

--15. Obtener los nombres y salarios de los empleados que pertenezcan 
--a los departamentos 51 o 52 y que tengan algún hijo.
SELECT NOMBRE, SALARIO, DEPART, HIJOS
FROM EMPLEADOS
WHERE DEPART IN (51,52)
AND HIJOS !=0;

--16. Obtener un listado con los empleados que tengan un salario igual
--o superior a 200€ y con 2 o 3 hijos.
SELECT NOMBRE, SALARIO, HIJOS 
FROM EMPLEADOS
WHERE SALARIO >= 200
AND HIJOS IN (2,3);

--17. Obtener un listado de los empleados que hayan ingresado en la 
--empresa entre los años 1975 y 1987, ambos inclusive
--DEBES CORREGIR FALTA EL RANGO ENTRE 1975 y 1987
SELECT * FROM EMPLEADOS;

SELECT NOMBRE, FECCON
FROM EMPLEADOS 
WHERE FECCON>= TO_DATE('1975', 'YYYY')
AND FECCON<TO_DATE('1988', 'YYYY')
ORDER BY FECCON;


SELECT TO_CHAR(SYSDATE, 'YYYY')
FROM DUAL;

--18. Obtener los empleados que no tienen familia numerosa 
--(menos de 3 hijos) y que ingresaron en la empresa antes del 1 
--de enero de 1987
SELECT NOMBRE, HIJOS, FECCON
FROM EMPLEADOS
WHERE HIJOS <3 
AND HIJOS <>0
AND FECCON< TO_DATE('01/01/1987', 'DD/MM/YYYY');



SELECT *
FROM EMPLEADOS;


----------------------------------------------------------------------------
--EJERCICIO EXTRAS
--OBTENER LOS EMPLEADOS QUE COBRE MAS DE LOS EMPLEADOS
--QUE SE LLAMEN ANDRADE DE PRIMER APELLIDO QUE ESTEN
--EN EL MISMO DEPARTAMENTO QUE PANADERO DURAN, JOSEFA
--Y QUE NO TENGAN HIJOS
SELECT * FROM EMPLEADOS
WHERE SALARIO > (SELECT SALARIO FROM EMPLEADOS WHERE upper(NOMBRE) like 'ANDRADE%')
AND DEPART = (SELECT DEPART FROM EMPLEADOS WHERE upper(NOMBRE) = 'PANADERO DURAN,
JOSEFA')
AND HIJOS = 0;



SELECT *
FROM EMPLEADOS;

SELECT NOMBRE, TO_CHAR(FECNAC, 'YYYY') AS ANIO 
FROM EMPLEADOS;



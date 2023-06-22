--1. Obtener el nombre completo (nombre y apellido) del empleado que no tiene jefe.

SELECT * FROM EMPLEADOS;

SELECT NOMBRE ||' '|| APELLIDO1
FROM EMPLEADOS
WHERE CODIGOJEFE IS NULL;


--2.Cuánto dinero se hubiera gastado cada cliente si hubiera vendido 
--los productos al precio de venta registrado en productos.

SELECT * FROM PRODUCTOS;

SELECT DISTINCT C.CODIGOCLIENTE, (DP.CANTIDAD*PR.PRECIOVENTA) AS PRECIO_INVENTADO
FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP, PRODUCTOS PR
WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
AND DP.CODIGOPRODUCTO = PR.CODIGOPRODUCTO;


--3. Si la diferencia entre el precio de venta y el precio del proveedor 
--es el margen. Que margen hubiera tenido cada pedido.

SELECT DP.CODIGOPEDIDO, DP.CANTIDAD*(PR.PRECIOVENTA - PR.PRECIOPROVEEDOR) AS MARGEN
FROM PRODUCTOS PR, DETALLEPEDIDOS DP
WHERE DP.CODIGOPRODUCTO = PR.CODIGOPRODUCTO;


--4. Obtener el país donde han invertido más dinero en compras.


SELECT O.PAIS 
FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP, OFICINAS O, EMPLEADOS E
WHERE O.CODIGOOFICINA = E.CODIGOOFICINA
AND E.CODIGOEMPLEADO = C.CODIGOEMPLEADOREPVENTAS
AND C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
GROUP BY O.PAIS
HAVING SUM(DP.CANTIDAD*DP.PRECIOUNIDAD) = (SELECT MAX(SUM(DP.CANTIDAD*DP.PRECIOUNIDAD))
                                            FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP, PRODUCTOS PR, OFICINAS O, EMPLEADOS E
                                            WHERE O.CODIGOOFICINA = E.CODIGOOFICINA
                                            AND E.CODIGOEMPLEADO = C.CODIGOEMPLEADOREPVENTAS 
                                            AND C.CODIGOCLIENTE = P.CODIGOCLIENTE
                                            AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
                                            AND DP.CODIGOPRODUCTO = PR.CODIGOPRODUCTO
                                            GROUP BY O.PAIS);


--5. Obtener el cliente que ha hecho el pedido con el comentario más largo 
--(número de letras del comentario).

SELECT C.NOMBRECLIENTE
FROM CLIENTES C, PEDIDOS P
WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND LENGTH(P.COMENTARIOS) = (   SELECT MAX(LENGTH(P.COMENTARIOS))
                                FROM CLIENTES C, PEDIDOS P
                                WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE);




--6. Teniendo presente que el dinero de los pedidos rechazados es devuelto 
--al cliente, obtener cuanto se ha gastado cada cliente en 'Plantas aromáticas'.


SELECT C.NOMBRECLIENTE,SUM(DP.CANTIDAD*DP.PRECIOUNIDAD) AS GASTADO
FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP, PRODUCTOS PR
WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
AND DP.CODIGOPRODUCTO = PR.CODIGOPRODUCTO
AND UPPER(ESTADO)='RECHAZADO'
AND UPPER(PR.GAMA) = 'AROMÁTICAS'
GROUP BY C.NOMBRECLIENTE;

--7. Obtener el número de clientes distintos que han comprado en cada gama.

SELECT DISTINCT C.NOMBRECLIENTE, PR.GAMA
FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP,PRODUCTOS PR, GAMASPRODUCTOS G
WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
AND DP.CODIGOPRODUCTO = PR.CODIGOPRODUCTO
AND PR.GAMA = G.GAMA;


--8. Obtener los empleados que están en oficinas españolas y que no tienen 
--ningún cliente a su cargo.

SELECT E.NOMBRE ||' '|| E.APELLIDO1 ||' '|| E.APELLIDO2 AS EMPLEADO
FROM OFICINAS O, EMPLEADOS E
WHERE O.CODIGOOFICINA = E.CODIGOOFICINA
AND UPPER(O.PAIS)='ESPAÑA'
AND E.CODIGOEMPLEADO NOT IN (SELECT CODIGOEMPLEADOREPVENTAS FROM CLIENTES);


--9. Obtener el nombre de los clientes y el nombre de los empleados donde 
--los empleados trabajan en el mismo país que los clientes.

SELECT C.NOMBRECLIENTE AS CLIENTE, E.NOMBRE AS EMPLEADO
FROM OFICINAS O, EMPLEADOS E, CLIENTES C
WHERE O.CODIGOOFICINA = E.CODIGOOFICINA
AND E.CODIGOEMPLEADO = C.CODIGOEMPLEADOREPVENTAS
AND O.PAIS = C.PAIS;



--10. Obtener el país donde se ha gastado más dinero en comprar productos.

SELECT C.PAIS 
FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP
WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
GROUP BY C.PAIS
HAVING SUM(DP.CANTIDAD*DP.PRECIOUNIDAD) = (SELECT MAX(SUM(DP.CANTIDAD*DP.PRECIOUNIDAD))
                                            FROM CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP, PRODUCTOS PR
                                            WHERE C.CODIGOCLIENTE = P.CODIGOCLIENTE
                                            AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
                                            AND DP.CODIGOPRODUCTO = PR.CODIGOPRODUCTO
                                            GROUP BY C.PAIS);

--11. EMMANUEL tienes problemas con su jefe y quieres quejarse al jefe de su jefe, pero no sabe
--ni quien se, ni en qué oficina trabaja (ciudad). ¿Podrías ayudarle, necesita saber el nombre
--completo, el email, y la ciudad donde está su oficina?

SELECT JEFEDEJEFE.NOMBRE, JEFEDEJEFE.APELLIDO1, JEFEDEJEFE.APELLIDO2, JEFEDEJEFE.EMAIL, O.CIUDAD
FROM OFICINAS O, EMPLEADOS E, EMPLEADOS JEFE, EMPLEADOS JEFEDEJEFE
WHERE O.CODIGOOFICINA = E.CODIGOOFICINA
AND E.CODIGOJEFE = JEFE.CODIGOEMPLEADO
AND JEFE.CODIGOJEFE = JEFEDEJEFE.CODIGOEMPLEADO
AND UPPER(E.NOMBRE) = 'EMMANUEL';


--12. Si por cada letra del comentario se le resta un día a la fecha de pedido, 
--obtener el cliente(nombre) del pedido que se pidió el primero, en base a la fecha de pedido.

SELECT C.NOMBRECLIENTE
FROM CLIENTES C, PEDIDOS P
WHERE (ROUND(SYSDATE - P.FECHAPEDIDO,0) - LENGTH(P.COMENTARIOS)) = (    SELECT MAX(ROUND(SYSDATE - P.FECHAPEDIDO,0) - LENGTH(P.COMENTARIOS))
                                                                        FROM CLIENTES C, PEDIDOS P
                                                                        WHERE C.CODIGOCLIENTE=P.CODIGOCLIENTE);


--13. Si de lo gastado (pedidos) por los clientes, los directores de oficina tienen una comisión del
--20%, y los representantes de ventas un 15%, obtén cuanta comisión tiene cada uno de los
--empleados de estos tipos, mostrando el nombre del empleado.


SELECT DISTINCT E.NOMBRE, E.PUESTO, DECODE(UPPER(PUESTO), 'REPRESENTANTE VENTAS', SUM((DP.PRECIOUNIDAD*DP.CANTIDAD)*0.15),
    'DIRECTOR OFICINA',SUM(DP.PRECIOUNIDAD*DP.CANTIDAD)*0.2) AS COMISION
FROM OFICINAS O, EMPLEADOS E, CLIENTES C, PEDIDOS P, DETALLEPEDIDOS DP
WHERE O.CODIGOOFICINA = E.CODIGOOFICINA
AND E.CODIGOEMPLEADO = C.CODIGOEMPLEADOREPVENTAS
AND C.CODIGOCLIENTE = P.CODIGOCLIENTE
AND P.CODIGOPEDIDO = DP.CODIGOPEDIDO
GROUP BY E.NOMBRE, E.PUESTO;

--14. Obtener en una sola consulta el nombre, ciudad y país de los empleados y el nombre ciudad
--y país de su jefe.

SELECT E.NOMBRE, O.CIUDAD, O.PAIS, JEFE.NOMBRE AS NOMBRE_JEFE, O.CIUDAD, O.PAIS
FROM EMPLEADOS E, EMPLEADOS JEFE, OFICINAS O
WHERE  O.CODIGOOFICINA=E.CODIGOOFICINA
AND O.CODIGOOFICINA = JEFE.CODIGOOFICINA
AND E.CODIGOJEFE = JEFE.CODIGOEMPLEADO;


--15. Borrar los productos que no se han vendido nunca. Hacer posteriormente Rollback

SELECT *
FROM PRODUCTOS
WHERE CODIGOPRODUCTO NOT IN (SELECT CODIGOPRODUCTO FROM DETALLEPEDIDOS);

DELETE
FROM PRODUCTOS
WHERE CODIGOPRODUCTO NOT IN (SELECT CODIGOPRODUCTO FROM DETALLEPEDIDOS);








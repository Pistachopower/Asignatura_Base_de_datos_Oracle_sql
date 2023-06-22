https://www.discoduroderoer.es/ejercicios-propuestos-y-resueltos-consultas-sql-jardineria/

/*
1. Muestra la ciudad y el codigo postal de las oficinas de España.
*/
--solucion ejercicio
select ciudad, codigopostal 
from OFICINAS 
where lower(pais) = 'españa';

/*
2-obtener el nombre, apellidos del jefe de la empresa 
*/
select nombre, apellido1, apellido2
from empleados  
where codigojefe is null;


/*
3-mostrar el nombre y cargo de los empleados que no
sean directores de oficina 
*/
select * from empleados;

select nombre, puesto
from empleados
where puesto in (select puesto 
                from empleados 
                where lower(puesto) <> 'director oficina');
                

select nombre, puesto 
from empleados 
where lower(puesto) <> 'director oficina';

/*
4-muestra el numero de empleados que hay en la empresa 
*/
select COUNT(codigoempleado) total_empleados
from empleados;

/*
5-muestra el numero de clientes norteamericanos 
*/
select * from clientes;

select COUNT(pais) as clientes_norteamericanos
from clientes
where upper(pais) = 'USA';

/*
6-NUMERO DE CLIENTES DE CADA PAIS
*/
select * from clientes;

select pais, COUNT(pais)
from clientes
group by pais;





/*
7- Muestra el nombre del cliente y el nombre de su 
representante de ventas (si lo tiene).
*/

select c.nombrecliente as "Nombre cliente",
e.nombre as "Nombre representante"
from clientes c, empleados e 
where c.codigoempleadorepventas=e.CODIGOEMPLEADO;

/*
8. Nombre de los clientes que hayan hecho un pago en 2007
*/

select distinct c.nombrecliente
from clientes c, pagos p
where c.codigocliente= p.codigocliente
and p.fechapago > to_date('01/01/2007', 'dd/mm/yyyy')
and p.fechapago < to_date('31/12/2007', 'dd/mm/yyyy');

/*
los posibles estados de un pedido
*/
select DISTINCT c.nombrecliente, p.estado 
from pedidos p, clientes c 
where p.codigopedido= c.codigocliente;

/*
10. Muestra el número de pedido, 
el nombre del cliente, la fecha de entrega y 
la fecha requerida  de los pedidos que no
han sido entregados a tiempo.
*/

select p.codigopedido, c.nombrecliente, p.fechaentrega, p.fechaesperada 
from clientes c, pedidos p 
where c.codigocliente = p.CODIGOCLIENTE 
and p.FECHAESPERADA < p.fechaentrega;

/*
13-muestra el codigo y la cantidad de veces que se ha pedido 
un producto al menos una vez
*/
select p.codigoproducto, dp.cantidad as cantidad_pedida
from productos p, detallepedidos dp 
where p.codigoproducto= dp.codigoproducto;
group by p.codigoproducto; 




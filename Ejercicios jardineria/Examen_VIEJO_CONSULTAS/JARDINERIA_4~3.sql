--1. Obtener el nombre completo (nombre y apellido) del empleado 
--que no tiene jefe.
select emple.nombre, emple.apellido1, emple.apellido2
from empleados emple
where emple.codigojefe is null; 

--2. Cu�nto dinero se hubiera gastado cada cliente si hubiera vendido 
--los productos al precio de venta registrado en productos.
select c.nombrecliente, sum(dp.preciounidad * dp.cantidad) as  posible_gasto
from productos p, detallepedidos dp, pedidos pe, clientes c
where p.codigoproducto= dp.codigoproducto
and pe.codigopedido= dp.codigopedido
and c.codigocliente= pe.codigocliente
group by c.nombrecliente;

/*
3- Si la diferencia entre el precio de venta y el precio del proveedor 
es el margen. �Qu� margen hubiera tenido cada pedido?
*/
select p.codigopedido, sum(dp.cantidad *(pro.precioventa - pro.precioproveedor))
from pedidos p, detallepedidos dp, productos pro
where pro.codigoproducto= dp.codigoproducto
and p.codigopedido= dp.codigopedido
group by p.codigopedido;

select pro.precioventa , pro.precioproveedor from productos pro;

4. Obtener el pa�s donde han invertido m�s dinero en compras.


5. Obtener el cliente que ha hecho el pedido con el comentario m�s largo (n�mero de letras del comentario).

6. Teniendo presente que el dinero de los pedidos rechazados es devuelto al cliente, obtener cuanto se ha gastado cada cliente en 'Plantas arom�ticas'.

7. Obtener el n�mero de clientes distintos que han comprado en cada gama.

8. Obtener los empleados que est�n en oficinas espa�olas y que no tienen ning�n cliente a su cargo.

9. Obtener el nombre de los clientes y el nombre de los empleados donde los empleados trabajan en el mismo pa�s que los clientes.

10. Obtener el pa�s donde se ha gastado m�s dinero en comprar productos.
11. ENMANUEL tienes problemas con su jefe y quieres quejarse al jefe de su jefe, pero no sabe ni quien se, ni en qu� oficina trabaja (ciudad). �Podr�as ayudarle, necesita saber el nombre completo, el email, y la ciudad donde est� su oficina?

12. Si por cada letra del comentario se le resta un d�a a la fecha de pedido, obtener el cliente (nombre) del pedido que se pidi� el primero, en base a la fecha de pedido.

13. Si de lo gastado (pedidos) por los clientes, los directores de oficina tienen una comisi�n del 20%, y los representantes de ventas un 15%, obt�n cuanta comisi�n tiene cada uno de los empleados de estos tipos, mostrando el nombre del empleado.

14. Obtener en una sola consulta el nombre, ciudad y pa�s de los empleados y el nombre ciudad y pa�s de su jefe.

15. Borrar los productos que no se han vendido nunca. Hacer posteriormente Rollback







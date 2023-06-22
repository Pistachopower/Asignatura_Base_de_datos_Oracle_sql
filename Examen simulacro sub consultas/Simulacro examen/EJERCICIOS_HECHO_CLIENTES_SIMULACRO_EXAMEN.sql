--1
select fecha as fecha_realizacion, id, id_cliente, id_comercial, total  
from pedido
order by fecha DESC;

--2 
select id || ' ' || nombre || ' ' || apellido1 as NOMBRE_APELLIDO
from cliente 
where lower(apellido2) is not null
order by apellido1 asc,apellido2 asc, nombre asc;

--3
select nombre 
from cliente
where UPPER(nombre) like 'A%'
or UPPER(nombre) like 'P%'
or UPPER(nombre) like '%N';

--4
select DISTINCT c.id, c.nombre, c.apellido1, c.apellido2, p.total
from cliente c, pedido p
where lower(c.id)= p.id
order by c.nombre, c.apellido1, c.apellido2;


--5
select c.nombre, c.apellido1, c.apellido2, p.total, come.nombre, 
come.apellido1, come.apellido2 
from cliente c, pedido p, comercial come
where lower(c.id)= p.id
and p.id= come.id;

--6
select distinct c.nombre, c.categoría, to_char(p.fecha, 'yyyy')as fecha_pedido
from cliente c, pedido p
where lower(c.id) = p.id
and c.categoría in (select categoría 
                    from cliente
                    where categoría in (300, 1000))
or to_char(p.fecha, 'yyyy') = '2017';

--7
--falta: Este listado también debe incluir los comerciales
--que no han realizado ningún pedido
select c.apellido1,c.apellido2,c.nombre,p.total,p.fecha 
from comercial c, pedido p
where lower(c.id)= p.id_comercial
order by c.apellido1,c.apellido2,c.nombre;

--8
/*
Devuelve un listado con los clientes que no han realizado ningún
pedido y de los comerciales que no han participado en ningún pedido. 
Ordene el listado alfabéticamente por los apellidos y el nombre. 
En el listado deberá diferenciar de algún modo los clientes 
y los comerciales.
*/

select 'Datos comercial: ', co.apellido1,co.apellido2, 
'Datos cliente: ',cli.apellido1, cli.apellido2, cli.categoría
from comercial co, pedido p, cliente cli
where lower(co.id)= p.id_comercial
and p.id= cli.id
or cli.categoría =  (select cli.categoría 
                    from cliente cli
                    where cli.categoría is null)
order by co.apellido1,co.apellido2, cli.apellido1, cli.apellido2;


--9

--10
select p.total, max(p.total), p.fecha, com.nombre, com.apellido1,
com.apellido2
from pedido p, comercial com
where lower(p.id)= com.id
or p.fecha= (select p.fecha 
        from pedido p
        where p.fecha= to_date('17/08/2016', 'dd/mm/yyyy'))
group by p.total,p.fecha, com.nombre, com.apellido1,
com.apellido2;

--11
select c.id,c.nombre,c.apellido1,c.apellido2,COUNT(p.total) as total_pedidos
from cliente c, pedido p
where c.id= p.id
group by c.id,c.nombre,c.apellido1,c.apellido2,p.total;

--12
select count(total) as total_pedido, fecha 
from pedido
group by total,fecha;

--13
select *
from cliente c, pedido p
where c.id= p.id_cliente
and p.fecha in (select fecha 
                from pedido
                where fecha>= (to_date('01/01/2017', 'dd/mm/yyyy'))
                and fecha<= (to_date('31/12/2017', 'dd/mm/yyyy'))
                    )
and p.total in (select total  
                from pedido
                where total>= (select avg(total)
                from pedido)
);


--14
--no aparece datos
select * 
from comercial c, pedido p
where c.id= p.id_comercial
and c.comisión is null;



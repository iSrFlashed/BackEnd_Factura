
use cobis
go
if OBJECT_ID('G_Jasy_producto') is not null
begin
	drop table G_Jasy_producto
	print 'borra  G_Jasy_producto'
end
go
create table G_Jasy_producto (
	pr_codigo 			int 		not null,
	pr_codigoProducto  	varchar(5) 	not null,
	pr_nombre 			varchar(50) not null,
	pr_precio 			money 		not null,
	pr_moneda 			char(2) 	not null,
	pr_estado 			char(1)
)



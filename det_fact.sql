
use cobis
go
if OBJECT_ID('G_Jasy_detalle_factura') is not null
begin
	drop table G_Jasy_cabecera_factura
	print 'borra  G_Jasy_detalle_factura'
end
go
create table G_Jasy_detalle_factura  
(
	df_codigoProducto varchar(5) not null,
	df_codigoFactura int not null,
	df_cantidad int not null,
	df_subtotal money not null
)
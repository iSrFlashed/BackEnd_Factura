
use cobis
go
if OBJECT_ID('G_Jasy_cabecera_factura') is not null
begin
	drop table G_Jasy_cabecera_factura
	print 'borra  G_Jasy_cabecera_factura'
end
go
create table G_Jasy_cabecera_factura  
(
	cf_codigoFactura int not null,
	cf_codigo_cliente int not null,
	cf_fecha datetime not null,
	cf_total money not null,
	cf_estado varchar(1) not null
)
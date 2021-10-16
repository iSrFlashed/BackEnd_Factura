use cobis
go
if OBJECT_ID('G_Jasy_cliente') is not null
begin
	drop table G_Jasy_cliente
	print 'borra  G_Jasy_cliente'
end
go
create table G_Jasy_cliente (
	cl_codigo 		int 		identity(1,1) 	not null,
	cl_cedula 		varchar(10) 	not null,
	cl_nombre 		varchar(100) 	not null,
	cl_apellido 	varchar(100) 	not null,
	cl_telefono 	varchar(10) 	not null,
	cl_direccion 	varchar(10) 	not null,
	cl_fecha_nac 	datetime 		null,
	cl_sexo      	char (1) 		not null,
	cl_estado 		varchar(1) 		null
)


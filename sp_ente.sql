USE cobis
GO
if exists(select 1 from sysobjects where name = 'sp_G_Jasy_cliente')
	drop procedure sp_G_Jasy_cliente
go

create procedure sp_G_Jasy_cliente
	@s_srv      		varchar(30) = null,
   	@s_ssn          	int         = null,
   	@s_date         	datetime    = null,
   	@s_ofi          	smallint    = null,
   	@s_user         	varchar(30) = null,
   	@s_rol		    	smallint    = null,
   	@s_term		    	varchar(10) = null,
   	@t_file		    	varchar(14) = null,
   	@t_trn		   		int			= null,
   	@t_debug        	char(1)     = 'N' ,
   	@t_from         	varchar(32) = null,
   	
	@i_operacion		char(1)			  ,
	@i_codigo 			int 		= null,
	@i_cedula 			varchar(10) = null,
	@i_nombre 			varchar(100)= null,
	@i_apellido 		varchar(100)= null,
	@i_telefono 		varchar(10) = null,
	@i_direccion 		varchar(10) = null,
	@i_fecha_nac		datetime	= null,
	@i_sexo				char(1)		= 'M' ,
	
	@i_nombreBusqueda 	varchar(50) = null
as 
declare
   @w_codigo_cli	int,
   @w_error       	int,
   @w_return       	int,
   @w_sp_name		varchar(30)

select @w_sp_name = 'sp_G_Jasy_cliente'

if @i_operacion = 'I'
begin
   	if @i_cedula is null
    begin
      select @w_error =  1730110 
      goto ERROR_FIN
	end
	
	if @i_nombre is null
    begin
      select @w_error =  1730106 
      goto ERROR_FIN
	end
	
	if @i_apellido is null
    begin
      select @w_error =  1730107 
      goto ERROR_FIN
	end
	
	if @i_telefono is null
    begin
      select @w_error =  1730108 
      goto ERROR_FIN
	end
	
	if @i_direccion is null
    begin
      select @w_error =  1730109 
      goto ERROR_FIN
	end
	
	
	
	if exists (select cl_cedula from G_Jasy_cliente where cl_cedula = @i_cedula)
	begin
		select @w_error = 1730105
		goto ERROR_FIN
	end

	insert into G_Jasy_cliente(
		cl_cedula 	 ,	cl_nombre 	,	cl_apellido ,	cl_telefono ,	
		cl_direccion ,	cl_fecha_nac,	cl_sexo		,	cl_estado)
	values(
		@i_cedula	 ,	@i_nombre	,	@i_apellido	,	@i_telefono	,	
		@i_direccion ,	@i_fecha_nac,	@i_sexo		,	'V')

	
end

if @i_operacion = 'A'
begin
	
	if @i_cedula is null
    begin
      select @w_error =  1730110 
      goto ERROR_FIN
	end
   
	if @i_nombre is null
    begin
      select @w_error =  1730106 
      goto ERROR_FIN
	end
	
	if @i_apellido is null
    begin
      select @w_error =  1730107 
      goto ERROR_FIN
	end
	
	if @i_telefono is null
    begin
      select @w_error =  1730108 
      goto ERROR_FIN
	end
	
	if @i_direccion is null
    begin
      select @w_error =  1730109 
      goto ERROR_FIN
	end
	
	if exists (select cl_cedula from G_Jasy_cliente where cl_cedula = @i_cedula and cl_codigo<>@i_codigo )
	begin
		select @w_error = 1730105
		goto ERROR_FIN
	end
	
	update G_Jasy_cliente 
	set
	   	cl_cedula 	= 	@i_cedula	,	
	   	cl_nombre 	=	@i_nombre	,	
	   	cl_apellido =	@i_apellido	,	
	   	cl_telefono =	@i_telefono	,	
		cl_direccion=	@i_direccion,
		cl_fecha_nac=	@i_fecha_nac,	
		cl_sexo		=@i_sexo
	where 
		cl_codigo=@i_codigo
	
	if @@ROWCOUNT =0
	begin
		select @w_error =  1730074 
      	goto ERROR_FIN
	end
end

if @i_operacion = 'D'
begin
   
	if @i_cedula is null
    begin
      select @w_error =  1730110 
      goto ERROR_FIN
	end

	update G_Jasy_cliente 
	set 
		cl_estado = 'E' 
	where cl_cedula = @i_cedula
	
	if @@ROWCOUNT =0
	begin
		select @w_error =  1730074 
      	goto ERROR_FIN
	end
end

if @i_operacion = 'S'
begin
	select 
		'codigo'=cl_codigo,
		'cedula'=cl_cedula,
		'nombre'=cl_nombre,
		'apellido'=cl_apellido,
		'direccion'=cl_direccion,
		'fecha nacimiento'=convert(varchar(10),cl_fecha_nac,103),
		'telefono'=cl_telefono,
		'sexo'=cl_sexo
	from G_Jasy_cliente where  cl_estado='V'
	order by cl_codigo desc
end

if @i_operacion = 'Q'
begin 
	
	select 
		'codigo'=cl_codigo,
		'cedula'=cl_cedula,
		'nombre'=cl_nombre,
		'apellido'=cl_apellido,
		'direccion'=cl_direccion,
		'fecha nacimiento'=convert(varchar(10),cl_fecha_nac,103),
		'telefono'=cl_telefono,
		'sexo'=cl_sexo 
	from G_Jasy_cliente
	where cl_nombre like '%'+@i_nombreBusqueda+'%' 
			
end
return 0

ERROR_FIN:
begin
   exec cobis..sp_cerror
   @t_debug  = @t_debug,
   @t_file   = @t_file,
   @t_from   = @w_sp_name,				
   @i_num    = @w_error 
end
return @w_error


GO
USE cobis
GO
if exists(select 1 from sysobjects where name = 'sp_G_Jasy_productos')
	drop procedure sp_G_Jasy_productos
go

create procedure sp_G_Jasy_productos(
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
	@i_codigoProducto  	varchar(5) 	= null,
	@i_nombre 			varchar(50) = null,
	@i_precio 			money 		= null,
	@i_moneda 			char(2) 	= null,
	
	@i_nombreBusqueda	varchar(50) = null
)
as 
declare
   @w_secuencialMax	int,
   @w_error       	int,
   @w_return       	int,
   @w_sp_name		varchar(30),
   
  	@w_codigo		int,
	@w_max			int


select @w_sp_name = 'sp_G_Jasy_productos'

if @i_operacion = 'I'
begin
	if @i_codigoProducto is null
    begin
      select @w_error =  1730077 
      goto ERROR_FIN
	end
	
	if @i_nombre is null
    begin
      select @w_error =  1730078 
      goto ERROR_FIN
	end
	
	if @i_precio is null
    begin
      select @w_error =  1730079  
      goto ERROR_FIN
	end
	
	if @i_moneda is null
    begin
      select @w_error =  1730080  
      goto ERROR_FIN
	end

	if exists(select 1 from G_Jasy_producto where pr_codigoProducto = @i_codigoProducto)
	begin
		select @w_error =  1730076  
      	goto ERROR_FIN
	end
	
	select @w_secuencialMax = max(pr_codigo) from G_Jasy_producto

   	if @w_secuencialMax is null
		select @w_secuencialMax = 0
	
	select @w_secuencialMax = @w_secuencialMax + 1
	
	
	insert into G_Jasy_producto(
		pr_codigo 		,	pr_codigoProducto  	,	pr_nombre 	,	pr_precio,	
		pr_moneda 		,	pr_estado )	
	values(
		@w_secuencialMax,	@i_codigoProducto	,	@i_nombre 	,	@i_precio,
		@i_moneda		,	'V')

	return 0
end

if @i_operacion = 'A'
begin
	if @i_codigoProducto is null
    begin
      select @w_error =  1730077 
      goto ERROR_FIN
	end
	
	if @i_nombre is null
    begin
      select @w_error =  1730078 
      goto ERROR_FIN
	end
	
	if @i_precio is null
    begin
      select @w_error =  1730079  
      goto ERROR_FIN
	end
	
	if @i_moneda is null
    begin
      select @w_error =  1730080  
      goto ERROR_FIN
	end
	
	if exists(select 1 from G_Jasy_producto where pr_codigoProducto = @i_codigoProducto and pr_codigo <> @i_codigo)
	begin
		select @w_error =  1730076  
      	goto ERROR_FIN
	end
	if exists(select 1 from G_Jasy_producto where pr_codigo = @i_codigo  )
	begin
	   update G_Jasy_producto
		set 
			pr_codigoProducto 	= @i_codigoProducto,
			pr_nombre			= @i_nombre,
			pr_precio			= @i_precio,
			pr_moneda			= @i_moneda
		where 
			pr_codigo	=@i_codigo
	end
	   
	if @@ROWCOUNT = 0
	begin
		select @w_error =  1730074 
      	goto ERROR_FIN
	end
end

if @i_operacion = 'D'
begin
 	if @i_codigo is null
    begin
      select @w_error =  1730077 
      goto ERROR_FIN
	end

	if exists(select 1 from G_Jasy_producto where pr_codigo = @i_codigo)
	begin
		update G_Jasy_producto
		set 
			pr_estado	= 'E'
		where 
			pr_codigo	=@i_codigo
	end

	if @@ROWCOUNT = 0
	begin
		select @w_error =  1730074 
      	goto ERROR_FIN
	end
	
end

if @i_operacion = 'S'
begin
   	select 	
		'codigo'=pr_codigo,
		'codigoProducto'=pr_codigoProducto,
		'nombre'=pr_nombre,
		'precio'=pr_precio,
		'moneda'=pr_moneda,
		'estado'=pr_estado
	from
		G_Jasy_producto
	where  
		pr_estado 	= 'V'
	order by pr_codigo desc
end

if @i_operacion = 'Q'
begin 
	select 
		'codigo'=pr_codigo,
		'codigoProducto'=pr_codigoProducto,
		'nombre'=pr_nombre,
		'precio'=pr_precio,
		'moneda'=pr_moneda,
		'estado'=pr_estado
	from G_Jasy_producto
	where pr_nombre like '%'+@i_nombreBusqueda+'%' or pr_codigoProducto like '%'+@i_nombreBusqueda+'%'
			
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
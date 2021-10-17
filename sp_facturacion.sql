use cobis
go
IF OBJECT_ID('sp_facturacion_JJJ') IS NOT NULL
	DROP PROCEDURE sp_facturacion_JJJ
GO

create procedure sp_facturacion_JJJ
	@s_srv      			varchar(30) = null,
	@s_ssn                  int         = null,
	@s_date                 datetime    = null,
	@s_ofi                  smallint    = null,
	@s_user                 varchar(30) = null,
	@s_rol		            smallint    = null,
	@s_term		            varchar(10) = null,
	@t_file		            varchar(14) = null,
	@t_trn		   	        int			= null,
	@t_debug              	char(1)     = 'N',
	@t_from               	varchar(32) = null,
	@i_operacion			CHAR(1),
	@i_codigo_cliente		INT			= NULL,
	@i_total				VARCHAR(15)	= NULL,
	@i_codigo_factura 		INT			= NULL,
	@i_codigo_producto 		INT			= NULL,
	@i_cantidad				INT 		= NULL,
	@o_codigo              	int      	= NULL out
AS
declare
	@w_codigo_fact 	INT,
	@w_precio 		INT,
   	@w_subtotal 	INT,
   	@w_error       	int,
  	@w_return       Int,
   	@w_sp_name		varchar(30)
   
select @w_sp_name = 'sp_facturacion_JJJ'
IF @i_operacion = 'I'	
BEGIN
   	select @w_codigo_fact=max(cf_codigoFactura) 
	from G_Jasy_cabecera_factura
	
	if @w_codigo_fact is null
		select @w_codigo_fact = 0
	select @w_codigo_fact = @w_codigo_fact + 1
		INSERT INTO G_Jasy_cabecera_factura(
		   cf_codigoFactura,	cf_codigo_cliente,		cf_fecha ,		cf_total,	cf_estado)
		VALUES(
		   @w_codigo_fact,	-1,		GETDATE() ,		0.0000,				'V')
	IF @@ROWCOUNT = 0
	BEGIN
		select @w_error = 1802159
		goto ERROR_FIN
	END
	select @o_codigo = @w_codigo_fact
END
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
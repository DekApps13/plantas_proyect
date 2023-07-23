CREATE DATABASE JARDINERÍAA

use JARDINERÍAA


--Sección #1 Crear tablas de la base de datos

Create table Clientess
(Nombre varchar (30) not null,
Apellido varchar (30) not null,
Cedula varchar(30) not null,
Telefono int not null,
Email varchar(30) not null,
Direccion varchar(30) null CONSTRAINT DF_DIRECCION Default ('No especificado'),
CONSTRAINT PK_CEDULA Primary key (cedula),
CONSTRAINT UQ_EMAIL Unique (Email),
)

use JARDINERÍAA
Create table Empleadoss
(EmployeeID varchar(5) not null,
Nombre varchar (30) not null,
Apellido varchar (30) not null,
Cedula varchar(30) not null,
Rol varchar(30) not null,
Salario money not null,
Telefono int not null,
Email varchar(30) not null,
Fecha_nacimiento date not null,
Fecha_contratacion date not null,
Direccion varchar(45) not null,
Observaciones varchar(80) not null
CONSTRAINT PK_EmployeeID Primary key (EmployeeID),
CONSTRAINT UQ_CEDULA Unique (Cedula),
CONSTRAINT UQ_EMAILL Unique (Email),
CONSTRAINT CH_SALARIO Check (Salario >= 500.00),
CONSTRAINT CH_FN Check (Fecha_nacimiento > '1955-01-01'),
CONSTRAINT CH_FC Check (Fecha_contratacion > '2015-01-01')
)

use JARDINERÍAA
Create table Categoriaplantass
(IDCategoria varchar (5) not null,
Nombrecategoria varchar (30) not null,
Descripcion varchar (80) not null,
CONSTRAINT PK_IDCategoria Primary key (IDCategoria),
CONSTRAINT UQ_Nombrecategoria Unique (Nombrecategoria)

)

use JARDINERÍAA
Create table Proveedorr
(IDProveedor varchar(5) not null,
Nombre varchar (30) not null,
Telefono int not null,
Email varchar(30) not null,
Direccion varchar(45) not null
CONSTRAINT PK_IDPROVEEDOR Primary key (IDProveedor),
CONSTRAINT UQ_EMAILLL Unique (Email)
)

use JARDINERÍAA
Create table Inventarioo
(IDPlanta varchar(5) not null,
PlantName varchar(30) not null,
Nombrelatin varchar(30) not null,
IDCategoria varchar(5) not null,
Cantidad int not null,
Fecha date not null,
Observaciones varchar(80) not null,
Precio money not null,
CONSTRAINT PK_IDPLANTA Primary key (IDPlanta),
CONSTRAINT CH_CANTIDADD Check (Cantidad >= 0),
CONSTRAINT UQ_PLANTNAME Unique (PlantName),
CONSTRAINT CH_precio Check (Precio <= 250.00),
CONSTRAINT FK_IDcategoria Foreign Key (IDCategoria)  References Categoriaplantass(IDCategoria)
)

use JARDINERÍAA
Create table Sucursall
(IDSucursal varchar(5)  not null,
IDProveedor varchar(5) not null, 
IDGerente varchar(5),
NombreGerente varchar(30),
ApellidoGerente varchar(30),
Direccion varchar(30) not null,
CONSTRAINT PK_IDSUCURSAL primary key (IDSucursal), 
CONSTRAINT FK_IDPROVEEDOR Foreign Key (IDProveedor)  References Proveedorr(IDProveedor),
CONSTRAINT FK_GERENTE Foreign Key (IDGerente)  References Empleadoss(EmployeeID)
)

use JARDINERÍAA
Create table Facturaa
(IDFactura varchar(5) not null,
IDEmpleado varchar(5) not null,
IDSucursal varchar(5) not null,
Fecha date null CONSTRAINT DF_FECHA DEFAULT (getdate()),
Monto money not null,
Cliente varchar(30),
Constraint PK_IDFactura Primary Key (IDFactura),
Constraint FK_IDEmpleado Foreign Key (IDEmpleado) References Empleadoss(EmployeeID),
Constraint FK_IDSucursal Foreign Key (IDSucursal) References Sucursall(IDSucursal),
Constraint FK_Cliente Foreign Key (Cliente) References Clientess(Cedula),
Constraint CH_Fecha CHECK (Fecha <= getdate())
)




ALTER TABLE Sucursall DROP CONSTRAINT FK_GERENTE
ALTER TABLE Empleadoss ADD CONSTRAINT  DF_obs  Default ('Ninguna') for Observaciones
ALTER TABLE Categoriaplantass ADD CONSTRAINT  DF_plt  Default ('Ninguna') for Descripcion
ALTER TABLE Empleadoss DROP CONSTRAINT DF_obs
ALTER TABLE Categoriaplantass DROP CONSTRAINT DF_plt

--Sección #2 Insertar de datos en las tablas
INSERT INTO Clientes
Values ('Alberto', 'Motta', '8-734-989', 65875643, 'alberto.m@gmail.com', 'El Coco, Casa 309, La Chorrera, Panamá Oeste'),
('Juan', 'Pimentel', '6-537-', '', '', '')



--Sección #3 Crear 4 funciones

--FUNCIÓN #1 CREADA POR EL USUARIO
--La empresa necesita una funcion que calcule el monto de la planta + el itbms
CREATE FUNCTION ITBMS
(@PRECIO_PLANTA money = 0.0)
RETURNS money
AS
begin
DECLARE @MONTO_Y_ITBMS money = 0
SET @MONTO_Y_ITBMS = @PRECIO_PLANTA * 1.07
RETURN @MONTO_Y_ITBMS
end

SELECT IDPlanta,dbo.ITBMS (Precio) as Preciototal FROM Inventarioo


--FUNCIÓN #2 CREADA POR EL USUARIO
--la empresa necesita una función que calcule el precio menos 10% de descuento  de todas las plantas
CREATE FUNCTION DESCUENTO_DIEZ
(@PRECIO_PLANTA MONEY = 0.0)
RETURNS MONEY
AS
BEGIN
DECLARE @PRECIO_DESCUENTO MONEY = 0.0
SET @PRECIO_DESCUENTO = @PRECIO_PLANTA - (@PRECIO_PLANTA * 0.1)
RETURN @PRECIO_DESCUENTO
END
SELECT IDPlanta,dbo.DESCUENTO_DIEZ (Precio) as Descuento FROM Inventarioo


--FUNCIÓN #3 CREADA POR EL USUARIO
--La empresa necesita una función que calcule el salario mas 100 dolares de bono para todos los empleados
CREATE FUNCTION SALARIO_BONO
(@SALARIO MONEY = 0.0)
RETURNS MONEY
AS
BEGIN
DECLARE @TOTAL MONEY = 0.0
SET @TOTAL = @SALARIO + 100
RETURN @TOTAL
END

select EmployeeID,dbo.SALARIO_BONO (Salario) as Salariobono from Empleadoss


--FUNCIÓN #4 CREADA POR EL USUARIO
--La empresa necesita una función que una en un solo campo el nombre el apellido y el rol
--de cada empleado así: ATENCIO, JUAN (JEFE DE VENTAS)
CREATE FUNCTION NOMBRECOMP_ROL
(@APELLIDO VARCHAR(15) = '', 
@NOMBRE VARCHAR(15) = '', 
@ROL VARCHAR(30) = '')
RETURNS VARCHAR(65)
AS
BEGIN
DECLARE @RESULTADO VARCHAR(65) = ''
SET @RESULTADO = CONCAT(@APELLIDO, ', ', @NOMBRE, ' (', @ROL, ') ')
RETURN @RESULTADO
END

select EmployeeID, dbo.NOMBRECOMP_ROL (Apellido,Nombre,Rol) as Empleado  from Empleadoss


--Sección #4 Crear 15 Consultas

--Select informacion completa de los clientes
Use JARDINERÍAA
Select * from Clientess

--Select cedula, telefono e email del cliente
Select Cedula, Telefono, Email from Clientess

--Select informacion completa de los empleados
Select * from Empleadoss

--Select Numero de empleado, cedula y rol de empleados de forma descendente
Select EmployeeID, Cedula, Rol from Empleadoss
Order by EmployeeID DESC

--Select la direccion de residencia del empleado
Select Direccion from Empleadoss

--Select el nombre de las plantas que hay en el inventario
Select PlantName from Inventarioo

--Select a traves del ID, la cantidad y el precio de las plantas que hay en el inventario
Select IDPlanta, Cantidad, Precio from Inventarioo

--Select el nombre y telefono de los proveedores
Select Nombre, Telefono from Proveedorr

--Select la direccion del primero proveedor
Select IDProveedor, Nombre,Direccion from Proveedorr
Where IDProveedor = 'AG001'

--Select el nombre del proveedor que distribuye los productos a cada sucursal
Select Nombre, IDSucursal from Proveedorr, Sucursall

--Select el nombre, apellido, numero de empleado del gerente que trabaja en cada sucursal y ordenelo de por el numero de sucursal
Select Nombre, Apellido, EmployeeID, IDSucursal from Empleadoss, Sucursall
Order by IDSucursal

--Select la informacion completa de las facturas
Select * from Facturaa

--Select El nombre del cliente, la cedula, el id de la factura, y el monto
Select Nombre, Apellido, Cedula, IDFactura, Monto from Clientess, Facturaa

--Select la fecha de las facturas, el precio, y ordenarlas basadas en su ID
Select IDFactura, Fecha, Monto from Facturaa

--Select el ID de las facturas que corresponden a cada Sucursal y ordenarlas de manera descendente por su fecha
Select IDFactura, Fecha, IDSucursal from Facturaa
Order by Fecha desc


--Procedimientos
/* Procedimientos almacenados */

/* 1. Procedimiento almacenado para ingresar datos a cada una de las tablas (7) */


/* 1.1. Procedimiento tabla Clientes */

GO 
CREATE PROCEDURE INS_CLIENTESS
@NOMB VARCHAR(30),
@APELL VARCHAR(30),
@CED VARCHAR(30),
@TEL INT,
@EMAIL VARCHAR(30),
@DIREC VARCHAR (30)
AS
BEGIN
INSERT INTO Clientess (Nombre,Apellido,Cedula,Telefono,Email,Direccion)
             VALUES (@NOMB,@APELL,@CED,@TEL,@EMAIL,@DIREC);
			 END
			 EXEC INS_CLIENTESS 'Irvin','Chavarria','8-128-9009',63700515,'irvinch68@gmail.com','Arraijan'
			 Select  *from Clientess
			
/* 1.1. Procedimiento tabla Empleados */
GO 
CREATE PROCEDURE INS_EMPLEADOSS
@IDEMPL VARCHAR(30),
@NOMBR VARCHAR(30),
@APELLI VARCHAR(30),
@CEDU VARCHAR (30),
@ROL VARCHAR(30),
@SALA MONEY,
@TELEF INT,
@EMAIL VARCHAR (30),
@FN DATE,
@FC DATE,
@DIRECCIO VARCHAR (45),
@OBS VARCHAR (80)
AS
BEGIN
INSERT INTO Empleadoss (EmployeeID,Nombre,Apellido,Cedula,Rol,Salario,Telefono, Email,Fecha_nacimiento,Fecha_contratacion,Direccion,Observaciones)
             VALUES (@IDEMPL,@NOMBR,@APELLI,@CEDU,@ROL,@SALA,@TELEF,@EMAIL,@FN,@FC,@DIRECCIO,@OBS);
			 END
			 EXEC INS_EMPLEADOSS'FG809','Cuty','Alvarado','4-544-2312','Cultivador',750.00,69345990,'cuty23@gmail.com','1955-01-12','2021-05-14','Capira'
			 select *from Empleadoss
			 
/* 1.1. Procedimiento tabla categoriaplanta */
GO 
CREATE PROCEDURE INS_CATPLANTA
@IDCategoria varchar (5), 
@Nombrecategoria varchar (30), 
@Descripcion varchar (80)
AS
BEGIN
INSERT INTO Categoriaplantass (IDCategoria,Nombrecategoria,Descripcion)
             VALUES (@IDCategoria,@Nombrecategoria,@Descripcion);
			 END
			 EXEC INS_CATPLANTA 'AL004','marta','reju'
			 Select *from Categoriaplantass
/* 1.1. Procedimiento tabla Inventario */
GO 
CREATE PROCEDURE INS_INVENTARIO
@IDPlanta varchar(5),
@PlantName varchar(30),
@Nombrelatin varchar(30),
@IDCategoria varchar(5),
@Cantidad int,
@Fecha date,
@Observaciones varchar(80),
@Precio money 
AS
BEGIN
INSERT INTO Inventarioo (IDPlanta,PlantName,Nombrelatin,IDCategoria,Cantidad,Fecha,Observaciones,Precio)
             VALUES (@IDPlanta,@PlantName,@Nombrelatin,@IDCategoria,@Cantidad,@Fecha,@Observaciones,@Precio);
			 END
			 EXEC INS_INVENTARIO 'PA009','VERAS','PANUXI','AL004',80,'2020-12-01','Ninguna',35.00
			 select *from Inventarioo
/* 1.1. Procedimiento tabla Proveedor */
GO 
CREATE PROCEDURE INS_PROVEEDOR
@IDProveedor varchar(5),
@Nombre varchar (30),
@Telefono int,
@Email varchar(30),
@Direccion varchar(45)

AS
BEGIN
INSERT INTO Proveedorr (IDProveedor,Nombre,Telefono,Email,Direccion)
             VALUES (@IDProveedor,@Nombre,@Telefono,@Email,@Direccion);
			 END
			 EXEC INS_PROVEEDOR 'LN045','VILLARI','65985436','VILLARIC67@gmail.com','Capira'
			 Select *from Proveedorr
/* 1.1. Procedimiento tabla Sucursal */
GO 
CREATE PROCEDURE INS_SUCURSAL
@IDSucursal varchar(5),
@IDProveedor varchar(5), 
@IDGerente varchar(5),
@NombreGerente varchar(30),
@ApellidoGerente varchar(30),
@Direccion varchar(30)
AS
BEGIN
INSERT INTO Sucursall(IDSucursal,IDProveedor,IDGerente,NombreGerente,ApellidoGerente,Direccion)
             VALUES (@IDSucursal,@IDProveedor,@IDGerente,@NombreGerente,@ApellidoGerente,@Direccion);
			 END
			 EXEC INS_SUCURSAL 'SU008','LN045','AC093','mARIO','Aquila','Arraijan'
			 select *from Sucursall
/* 1.1. Procedimiento tabla Factura */
GO 
CREATE PROCEDURE INS_FACTURA
@IDFactura varchar(5),
@IDEmpleado varchar(5),
@IDSucursal varchar(5),
@Fecha date,
@Monto money,
@Cliente varchar(30)
AS
BEGIN
INSERT INTO Facturaa(IDfactura,IDEmpleado,IDSucursal,Fecha,Monto,Cliente)
             VALUES (@IDFactura,@IDEmpleado,@IDSucursal,@Fecha,@Monto,@Cliente);
			 END
			 EXEC INS_FACTURA 'FC006','AD023','SU008','2021-09-19',46.07,'8-128-9009'
			 select *from Facturaa
			
/* 2. Procedimiento almacenado para hacer actualización de campos a cada una de las tablas (7) */
/* 2.1 Actualizar tabla Clientess */
GO
CREATE PROCEDURE ACT_CLIENTESs
@Cedula varchar(30),
@Nombre varchar (30),
@Apellido varchar (30),
@Telefono int,
@Email varchar(30),
@Direccion varchar(30)

as
update Clientess 
set Nombre=@Nombre,
Apellido=@Apellido,				
Telefono=@Telefono,
Email=@Email,
Direccion=@Direccion
			  where Cedula=@Cedula
GO

EXEC ACT_CLIENTESs '8-432-1222','Milagros','Musiala',6789046,'mili8678@gmail.com','Chame'
Select *from Clientess
/* 2.1 Actualizar tabla Empleadoss */
GO
CREATE PROCEDURE ACT_Empleado
@EmployeeID varchar(5),
@Nombre varchar (30) ,
@Apellido varchar (30),
@Cedula varchar(30),
@Rol varchar(30),
@Salario money,
@Telefono int,
@Email varchar(30),
@Fecha_nacimiento date,
@Fecha_contratacion date,
@Direccion varchar(45),
@Observaciones varchar(80) 
as
update Empleadoss set Nombre=@Nombre  ,
                      Apellido=@Apellido ,
                      Cedula=@Cedula ,
                      Rol=@Rol ,
                      Salario=@Salario ,
                      Telefono=@Telefono ,
                      Email=@Email ,
                      Fecha_nacimiento=@Fecha_nacimiento ,
                      Fecha_contratacion=@Fecha_contratacion ,
                      Direccion=@Direccion ,
                      Observaciones=@Observaciones  
			  where EmployeeID=@EmployeeID
GO

EXEC ACT_Empleado 'AC090','Luisa','Martinez','8-945-3444','Aseadora',800.00,6743045,'luisi8678@gmail.com','1989-09-09','2019-10-24','Arraijan','Ninguna'
select *from Empleadoss
/* 2.1 Actualizar tabla Categoriaplantas */
GO
CREATE PROCEDURE ACT_Categoriaplantas
@IDCategoria varchar (5), 
@Nombrecategoria varchar (30), 
@Descripcion varchar (80)
as
update Categoriaplantass set Nombrecategoria=@Nombrecategoria  ,
                      Descripcion=@Descripcion 
                     
			  where IDCategoria=@IDCategoria
GO

EXEC ACT_Categoriaplantas 'AL003','Belleza','Ninguna'
select *from Categoriaplantass
/* 2.1 Actualizar tabla Proveedor */
GO
CREATE PROCEDURE ACT_PROVEE
@IDProveedor varchar(5),
@Nombre varchar (30),
@Telefono int,
@Email varchar(30),
@Direccion varchar(45)
as
update Proveedorr set Nombre=@Nombre  ,
                      Telefono=@Telefono ,
                      Email=@Email ,
                      Direccion=@Direccion 
                      
			  where IDProveedor=@IDProveedor
GO

EXEC  ACT_PROVEE 'AG001','nanictive',67894532,'nani56@gmail.com','Chame'
select *from Proveedorr
/* 2.1 Actualizar tabla Inventario */
GO
CREATE PROCEDURE ACT_INVENTARIOo
@IDPlanta varchar(5),
@PlantName varchar(30),
@Nombrelatin varchar(30),
@IDCategoria varchar(5),
@Cantidad int,
@Fecha date,
@Observaciones varchar(80),
@Precio money 
as
update Inventarioo set PlantName=@PlantName  ,
                      Nombrelatin=@Nombrelatin ,
                      IDCategoria=@IDCategoria ,
                      Cantidad=@Cantidad ,
                      Fecha=@Fecha ,
                      Observaciones=@Observaciones ,
                      Precio=@Precio 
                      
			  where IDPlanta=@IDPlanta
GO

EXEC ACT_INVENTARIOo 'PA009','Leticio','letinae','OQ002',46,'2021-02-21','Ninguna',5.00
select *from Inventarioo
/* 2.1 Actualizar tabla Sucursal */
GO
CREATE PROCEDURE ACT_SUCURSAL
@IDSucursal varchar(5),
@IDProveedor varchar(5), 
@IDGerente varchar(5),
@NombreGerente varchar(30),
@ApellidoGerente varchar(30),
@Direccion varchar(30)
as
update Sucursall set IDProveedor=@IDProveedor  ,
                      IDGerente=@IDGerente ,
                      NombreGerente=@NombreGerente ,
                      ApellidoGerente=@ApellidoGerente ,
                      Direccion=@Direccion 
                      
			  where IDSucursal=@IDSucursal
GO

EXEC ACT_SUCURSAL 'SU001','AG001','GE013','Polo','Montañez','Arraijan'
select *from Sucursall
/* 2.1 Actualizar tabla Factura */
GO
CREATE PROCEDURE ACT_FACTURA
@IDFactura varchar(5),
@IDEmpleado varchar(5),
@IDSucursal varchar(5),
@Fecha date,
@Monto money,
@Cliente varchar(30)as
update Facturaa   set IDEmpleado=@IDEmpleado  ,
                      IDSucursal=@IDSucursal ,
                      Fecha=@Fecha ,
                      Monto=@Monto ,
                      Cliente=@Cliente 
			  where IDFactura=@IDFactura
GO

EXEC ACT_FACTURA  'FAC01','FD012','SU005','2021-09-13',80.90,'8-978-17'
select *from Facturaa



/* 3. Procedimiento almacenado para borrar una fila o registro por su llave primaria. (7) */

/* 3.1 Eliminar fila tabla clientes */
CREATE PROCEDURE BORRAR_CAMPO_TABLA_CLIENTES
    @CEDULA VARCHAR (30)
AS
BEGIN
    DELETE Clientess WHERE Cedula = @CEDULA;
END
EXEC BORRAR_CAMPO_TABLA_CLIENTES '8-721-1314'
SELECT *FROM Clientess
SELECT *FROM Facturaa
/* 3.2 Eliminar fila tabla Empleados */
CREATE PROCEDURE BORRAR_CAMPO_TABLA_EMPLEADOS
    @IDEMPLEADO VARCHAR (10)
AS
BEGIN
    DELETE Empleadoss WHERE EmployeeID = @IDEMPLEADO;
END
EXEC BORRAR_CAMPO_TABLA_EMPLEADOS 'FG809'
SELECT *FROM Empleadoss
/* 3.2 Eliminar fila tabla Categoriaplantas */
CREATE PROCEDURE BORRAR_CAMPO_TABLA_CATEGORIAPLANTA
    @IDCATEGORIA VARCHAR (10)
AS
BEGIN
    DELETE Categoriaplantass WHERE IDCategoria = @IDCATEGORIA;
END
EXEC BORRAR_CAMPO_TABLA_CATEGORIAPLANTA ''
SELECT *FROM Empleadoss
/* 3.3 Eliminar fila tabla Inventario */
CREATE PROCEDURE BORRAR_CAMPO_TABLA_INVENTARIO
    @IDPLANTA VARCHAR (10)
AS
BEGIN
    DELETE Inventarioo WHERE IDPlanta = @IDPLANTA;
END
EXEC BORRAR_CAMPO_TABLA_INVENTARIO ''
SELECT *FROM Empleadoss
/* 3.4 Eliminar fila tabla Proveedor */
CREATE PROCEDURE BORRAR_CAMPO_TABLA_PROVEEDOR
    @IDPROVEE VARCHAR (10)
AS
BEGIN
    DELETE Proveedorr WHERE IDProveedor = @IDPROVEE;
END
EXEC BORRAR_CAMPO_TABLA_PROVEEDOR ''

/* 3.5 Eliminar fila tabla Sucursal */
CREATE PROCEDURE BORRAR_CAMPO_TABLA_SUCURSAL
    @IDSUCURSAL VARCHAR (10)
AS
BEGIN
    DELETE Sucursall WHERE IDSucursal = @IDSUCURSAL;
END
EXEC BORRAR_CAMPO_TABLA_SUCURSAL ''

/* 3.6 Eliminar fila tabla Factura */
CREATE PROCEDURE BORRAR_CAMPO_TABLA_FACTURA
    @IDFACTURA VARCHAR (10)
AS
BEGIN
    DELETE Facturaa WHERE IDFactura = @IDFACTURA;
END
EXEC BORRAR_CAMPO_TABLA_FACTURA ''


/* 4. Procedimiento almacenado para realizar una búsqueda de un registro utilizando su llave primaria. (7) */

/* 4.1 Búsqueda de registro tabla clientes */
Create Procedure BUSQ_CLIENTESs
@CDL VARCHAR(30)
AS
Select Nombre,Apellido,Cedula,Telefono,Email,Direccion From Clientess Where Cedula=@CDL

GO

EXEC BUSQ_CLIENTESs '8-721-1314'
select *from Clientess
/* 4.2 Búsqueda de registro tabla Empleados */
Create Procedure BUSQ_EMPLEADOS
@IDEMPLEADO VARCHAR(5)
AS
Select EmployeeID,Nombre,Apellido,Cedula,Rol,Salario,Telefono,Email,Fecha_nacimiento,Fecha_contratacion,Direccion,Observaciones From Empleadoss Where EmployeeID=@IDEMPLEADO

GO

EXEC BUSQ_EMPLEADOS'AC090'
select *from Empleadoss
/* 4.4 Búsqueda de registro tabla Proveedor */
Create Procedure BUSQ_PROVEEDOR
@IDPROVEEDOR VARCHAR (5)
AS
Select IDProveedor,Nombre,Telefono,Email,Direccion From Proveedorr Where IDProveedor=@IDPROVEEDOR

GO

EXEC BUSQ_PROVEEDOR 'AG001'
select *from Proveedorr
/* 4.3 Búsqueda de registro tabla Inventario */
Create Procedure BUSQ_INVENTARIO
@IDPLANTA varchar(5)
AS
Select IDPlanta,PlantName,Nombrelatin,IDCategoria,Cantidad,Fecha,Observaciones,Precio From Inventarioo Where IDPlanta=@IDPLANTA

GO

EXEC BUSQ_INVENTARIO 'DC343'
select *from Inventarioo
/* 4.5 Búsqueda de registro tabla Sucursal */
Create Procedure BUSQ_SUCURSAL
@IDSUCURSAL varchar(5)
AS
Select  IDSucursal,IDProveedor,IDGerente,NombreGerente,ApellidoGerente,Direccion From Sucursall Where IDSucursal=@IDSUCURSAL

GO

EXEC BUSQ_SUCURSAL'SU002'
select *from Sucursall
/* 4.6 Búsqueda de registro tabla Factura */
Create Procedure BUSQ_FACTURA
@IDFACTURA varchar(5)
AS
Select IDFactura,IDEmpleado,IDSucursal,Fecha,Monto,Cliente From Facturaa Where IDFactura=@IDFactura

GO

EXEC BUSQ_FACTURA'FAC03'
select *from Facturaa

/* 5. Procedimiento almacenado que me devuelva todos los registros de la tabla. (7) */
/* 5.1 Registro de la tabla Clientes */CREATE PROCEDURE REGISTRO_CLIENTES
AS
BEGIN
SELECT *FROM Clientess
END
goEXEC REGISTRO_CLIENTES/* 5.2 Registro de la tabla empleado */
CREATE PROCEDURE REGISTRO_EMPLEADO
AS
BEGIN
SELECT *FROM Empleadoss
END
goEXEC REGISTRO_EMPLEADO
/* 5.2 Registro de la tabla Categoriaplanta */
CREATE PROCEDURE REGISTRO_CATEGORIAPLANTAS
AS
BEGIN
SELECT *FROM Categoriaplantass
END
goEXEC REGISTRO_CATEGORIAPLANTAS
/* 5.3 Registro de la tabla inventario */
CREATE PROCEDURE REGISTRO_INVENTARIO
AS
BEGIN
SELECT *FROM Inventarioo
END
goEXEC REGISTRO_INVENTARIO
/* 5.4 Registro de la tabla proveedor */
CREATE PROCEDURE REGISTRO_PROVEEDOR
AS
BEGIN
SELECT *FROM Proveedorr
END
goEXEC REGISTRO_PROVEEDOR
/* 5.5 Registro de la tabla sucursal */
CREATE PROCEDURE REGISTRO_SUCURSAL
AS
BEGIN
SELECT *FROM Sucursall
END
goEXEC REGISTRO_SUCURSAL
/* 5.6 Registro de la tabla factura */
sCREATE PROCEDURE REGISTRO_FACTURA
AS
BEGIN
SELECT *FROM Facturaa
END
goEXEC REGISTRO_FACTURA
/* 6. 2 procedimiento almacenados por cada tabla que haga consultas de acuerdo a una funcionalidad de la
aplicación o la lógica del negocio. (14) */

/* Tabla Clientess*/
/* 6. 2.1 Buscar número telefónico y que haga una consulta de los datos del dueño del número */

Create Procedure BUSQUETELEF
@TELEFONO INT
AS
Select Cedula,Nombre,Apellido,Email,Direccion From Clientess Where Telefono=@TELEFONO

GO

EXEC BUSQUETELEF'6789045'
select *from Clientess
/* 6. 2.1 Consulta sobre en que lugar viven los clientes */
Create Procedure Lugar
@Direccion varchar(30)
AS
Select Cedula,Nombre,Apellido,Telefono,Email,Direccion From Clientess Where Direccion=@Direccion

GO

EXEC Lugar'Las lajas'

/* Tabla Empleado*/
/* 6. 2.1 Buscar número telefónico y que haga una consulta de los datos del dueño del número */

Create Procedure Bono_jubilacionn

AS
update Empleadoss
set Salario=Salario+50  Where Fecha_nacimiento<='1961-01-01'

GO

EXEC Bono_jubilacionn
select EmployeeID,Nombre,Apellido,Salario from Empleadoss Where Fecha_nacimiento<='1961-01-01'
select *from Empleadoss
/* 6. 2.1 Consulta sobre en que lugar viven los clientes */
Create Procedure empleadopruebaa

AS
Select Cedula,Nombre,Apellido,Telefono,Email,Direccion,Situación='Empleado a prueba' From Empleadoss Where Fecha_contratacion>='2021-09-13'

GO

EXEC empleadopruebaa

/* Tabla Categoria de plantas*/
/* 6. 2.3 Obtener categorias que empiecen por A*/

Create Procedure CATG_A

AS
SELECT Nombrecategoria FROM Categoriaplantass WHERE Nombrecategoria LIKE 'A%'

GO

EXEC CATG_A

select *from Categoriaplantass
/* 6. 2.3 Consulta sobre obtener codigos que no empiecen por a */
Create Procedure ID_NOA

AS
SELECT IDCategoria FROM Categoriaplantass WHERE IDCategoria  NOT LIKE 'A%'

GO

EXEC ID_NOA

/* Tabla proveedor*/
/* 6. 2.3 Buscar Proveedores más cercanos*/

Create Procedure PROVEEDORESCERCANOS
@DIRE varchar (30)
AS
Select IDProveedor,Nombre,Telefono,Email From Proveedorr Where Direccion=@DIRE

GO

EXEC PROVEEDORESCERCANOS'Capira'
use JARDINERÍAA
select *from Proveedorr
/* 6. 2.3 Consulta sobre obtener IDProveedor sin repeticiones */
Create Procedure IDsinrep

AS
SELECT DISTINCT IDProveedor FROM Proveedorr
GO

EXEC IDsinrep

/* Tabla Inventarioo*/
/* 6. 2.4 Nombre común y científico de las plantas*/

Create Procedure NOMBRES

AS

Select PlantName,Nombrelatin,Cantidad From Inventarioo
GO

EXEC NOMBRES
use JARDINERÍAA
select *from Inventarioo
/* 6. 2.4 Buscar planta con mayor cantidad  */
Create Procedure PLANTCANT

AS
SELECT IDPlanta FROM Inventarioo WHERE Cantidad >=40 AND Cantidad <=50 ORDER BY Cantidad
GO

EXEC PLANTCANT
/* Tabla Sucursal*/
/* 6. 2.4 Primeras tres letras de la ubicacion de la sucursal*/

Create Procedure LETSUCU

AS

Select IDSucursal,left(Direccion,3) AS Inicialessuc from Sucursall

GO

EXEC LETSUCU
use JARDINERÍAA
select *from Sucursall

/* 6. 2.4 Nombre de los gerentes separados  */
Create Procedure GERENTE

AS
SELECT  IDGerente,NombreGerente + ' ' + ApellidoGerente AS NOMBRE_COMPLETO FROM Sucursall 
GO


EXEC GERENTE
/* Tabla Factura*/
/* 6. 2.4 Precios de las plantas de manera ascendente*/

Create Procedure PREC_ASCENDE

AS

SELECT IDFactura,Monto FROM Facturaa ORDER BY Monto ASC

GO

EXEC PREC_ASCENDE
use JARDINERÍAA
select *from Facturaa

/* 6. 2.4 Facturas del año pasado  */
Create Procedure FAC_PASA

AS
Select * from Facturaa where year(Fecha) = 2020;
GO

EXEC FAC_PASA
Select *from Facturaa


--TRRIGGER #1
Create table Insert_Inventario 
(IDPlanta varchar(5) not null,
PlantName varchar(30) not null,
Nombrelatin varchar(30) not null,
IDCategoria varchar(5) not null,
Cantidad int not null,
Fecha date not null,
Observaciones varchar(80) not null,
Precio money not null,
Fecha_Insert datetime not null)

CREATE TRIGGER TR_Inventarioo
ON Inventarioo
FOR INSERT
AS
Declare @IDPlanta varchar(5) = ''
Declare @PlantName varchar(30) = ''
Declare @Nombrelatin varchar(30) = ''
Declare @IDCategoria varchar(5) = ''
Declare @Cantidad int = 0 
Declare @Fecha date = ''
Declare @Observaciones varchar(80) = ''
Declare @Precio money = 0
Declare @Fecha_Insert datetime = ''

Set @IDPlanta = (Select IDPlanta from inserted)
Set @PlantName = (Select PlantName from inserted)
Set @Nombrelatin = (Select Nombrelatin from inserted)
Set @IDCategoria = (Select IDCategoria from inserted)
Set @Cantidad = (Select Cantidad from inserted)
Set @Fecha = (Select Fecha from inserted)
Set @Observaciones = (Select Observaciones from inserted)
Set @Precio = (Select Precio from inserted)
Set @Fecha_Insert = (Select fecha=getdate())

Insert into Insert_Inventario 
Values (@IDPlanta, @PlantName, @Nombrelatin, @IDCategoria, @Cantidad, @Fecha, @Observaciones, @Precio, @Fecha_Insert)

--PRUEBA DEL TRIGGER
USE JARDINERÍAA

INSERT INTO Inventarioo
Values ('JD736', 'Geranios', 'Geranium', 'PR123', '30', '2020-05-07', 'Exteriores', '2.99')
Select * from Inventarioo
Select * from Insert_Inventario


--TRIGGER #2
TRIGGER TABLE CLIENTESS
CREAR TABLA INS_CLIENTES
Create table delete_clientess
(Nombre varchar (30) not null,
Apellido varchar (30) not null,
Cedula varchar(30) not null,
Telefono int not null,
Email varchar(30) not null,
Direccion varchar(30) null,
FECHA_DELETE datetime)

Create trigger TR_1Clientess
On Clientess
After Delete 
as
declare @nombre varchar (30) = ''
declare @apellido varchar (30) = ''
declare @cedula varchar(30) = ''
declare @telefono int = ''
declare @email varchar(30) = ''
declare @direccion varchar(30) = ''
declare @fecha_delete datetime = ''

set @nombre = (select Nombre from deleted)
set @apellido = (select Apellido from deleted)
set @cedula = (select Cedula from deleted)
set @telefono =(select Telefono from deleted)
set @email = (select Email from deleted)
set @direccion = (select Direccion from deleted)
set @fecha_delete = (select fecha=getdate())

Insert into delete_clientess
Values (@nombre, @apellido, @cedula, @telefono, @email, @direccion, @fecha_delete)

--PRUEBA DEL TRIGGER
DELETE FROM Clientess WHERE Cedula='8-7474-823'

INSERT INTO Clientess
values ('BASILIA', 'PEÑA', '8-7474-823', '68372647', 'basiliap@gmail.com', 'Arraiján')
select * from Clientess
select * from delete_clientess


--TRIGGER #3
Create table deleteCategoriaplantasss
(IDCategoria varchar (5) not null,
Nombrecategoria varchar (30) not null,
Descripcion varchar (80) not null,
fecha_delete datetime not null
CONSTRAINT PK_IDCategoria2 Primary key (IDCategoria),
CONSTRAINT UQ_Nombrecategoria2 Unique (Nombrecategoria))


create TRIGGER TR_CATEGORIAPLANTASS
on Categoriaplantass
after Delete
as
declare @IDCategoria varchar(5) = ''
declare @Nombrecategoria varchar(30) = ''
declare @Descripcion varchar(80)=''
declare @fechadelete datetime =''

set @IDCategoria = (select IDCategoria from deleted)
set @Nombrecategoria = (select Nombrecategoria from deleted)
set @Descripcion = (select Descripcion from deleted)
set @fechadelete = (select fecha=getdate())

INSERT INTO deleteCategoriaplantasss
Values (@IDcategoria, @Nombrecategoria, @Descripcion, @Fechadelete)

--PRUEBA DEL TRIGGER
DELETE FROM Categoriaplantass Where IDCategoria='FH983'
SELECT * FROM Categoriaplantass
select * from deleteCategoriaplantasss
INSERT INTO Categoriaplantass
Values ('FH983', 'Veraneras', 'MUCHOS COLORES')

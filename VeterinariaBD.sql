CREATE DATABASE Veterinarias;
GO
USE Veterinarias;
GO
 --USE master
--DROP DATABASE Veterinaria
 
CREATE TABLE Empresas(
Id INT PRIMARY KEY IDENTITY(1,1),
RTN VARCHAR(14) UNIQUE NOT NULL,
Nombre VARCHAR(100) UNIQUE NOT NULL,
Correo_1 VARCHAR(100) NOT NULL,
Correo_2 VARCHAR(100),
Img VARCHAR(50)
);
GO

CREATE TABLE Enfermedades(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(100) UNIQUE NOT NULL
);
GO

CREATE TABLE Generos(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE Estados(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE Especies(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE Razas(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
Id_Especie INT REFERENCES Especies(Id)
);
GO

CREATE TABLE Mascotas(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) NOT NULL,
Carac_Distintiva VARCHAR(100),
Fecha_Nacimiento DATE,
Esterilizacion BIT DEFAULT 0,
Agresivo BIT DEFAULT 0,
Peso VARCHAR(50) NOT NULL,
Tamanio VARCHAR(50) NOT NULL,
Id_Especie INT REFERENCES Especies(Id),
Id_Raza INT REFERENCES Razas(Id),
Id_Genero INT REFERENCES Generos(Id),
Id_Estado INT REFERENCES Estados(Id)
);
GO

CREATE TABLE Expedientes(
Id INT PRIMARY KEY IDENTITY(1,1),
Fecha_Apertura DATE NOT NULL,
Id_Mascota INT REFERENCES Mascotas(Id)
);
GO

CREATE TABLE Enfermedades_Bases(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Expediente INT REFERENCES Expedientes(Id),
Id_Enfermedad INT REFERENCES Enfermedades(Id)
);
GO

CREATE TABLE Tipo_Consulta(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
Descripcion VARCHAR(200) 
);
GO

CREATE TABLE Formas_Farmaceuticas(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
);
GO

CREATE TABLE Farmacias(
Id INT PRIMARY KEY IDENTITY(1,1),
codigo VARCHAR(3) UNIQUE
);
GO

CREATE TABLE Productos(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
Vencimiento DATE NOT NULL,
Precio DECIMAL(10,2) NOT NULL,
Id_Forma INT REFERENCES Formas_Farmaceuticas(Id),
Id_Farmacia INT REFERENCES Farmacias(Id)
);
GO

CREATE TABLE Tipos_Registros(
Id INT PRIMARY KEY IDENTITY(1,1),
Tipo VARCHAR(50) UNIQUE NOT NULL,
Factor VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Tipo_Documentos(
Id INT PRIMARY KEY IDENTITY(1,1),
Tipo VARCHAR(50) UNIQUE NOT NULL,
Codigo VARCHAR(2) UNIQUE NOT NULL
);
GO

CREATE TABLE Tipos_Pagos(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
Activo BIT DEFAULT 0
);

CREATE TABLE Estados_Sucursal(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
);
GO

CREATE TABLE Roles(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO


CREATE TABLE Permisos(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE Tipos_Empleados(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE Periodos_Pago(
Id INT PRIMARY KEY IDENTITY(1,1),
Periodo VARCHAR(25) UNIQUE
);

CREATE TABLE Salarios(
Id INT PRIMARY KEY IDENTITY(1,1),
Salario_Bruto DECIMAL(10,2) NOT NULL,
Salario_Neto DECIMAL(10,2),
Id_Periodo_Pago INT REFERENCES Periodos_Pago(Id)
);
GO

CREATE TABLE Horarios(
Id INT PRIMARY KEY IDENTITY(1,1),
Hora_Inicial TIME NOT NULL,
Hora_Final TIME NOT NULL, 
CONSTRAINT UQ_Horario UNIQUE (Hora_Inicial, Hora_Final)
);
GO

CREATE TABLE Periodos_Laborales(
Id INT PRIMARY KEY IDENTITY(1,1),
Periodo_Laboral VARCHAR(200) UNIQUE
);

CREATE TABLE Departamentos(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE Ciudades(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) NOT NULL,
Id_Departamento INT REFERENCES Departamentos(Id),
CONSTRAINT UQ_Ciudad UNIQUE (Nombre, Id_Departamento)
);
GO

CREATE TABLE Direcciones(
Id INT PRIMARY KEY IDENTITY(1,1),
Referencia VARCHAR(200),
Id_Ciudad INT REFERENCES Ciudades(Id)
);
GO

CREATE TABLE Personas(
Id INT PRIMARY KEY IDENTITY(1,1),
Primer_Nombre VARCHAR(50) NOT NULL,
Segundo_Nombre VARCHAR(50),
Primer_Apellido VARCHAR(50) NOT NULL,
Segundo_Apellido VARCHAR(50),
DNI VARCHAR(13) UNIQUE NOT NULL,
FechaNac DATE NOT NULL,

Edad AS DATEDIFF(YEAR, FechaNac, GETDATE()) - 
           CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, FechaNac, GETDATE()), FechaNac) > GETDATE() 
                THEN 1 
                ELSE 0 
           END,

Id_Direccion INT REFERENCES Direcciones(Id)
);
GO

CREATE TABLE Correos_Personas(
Id INT PRIMARY KEY IDENTITY(1,1),
Correo VARCHAR(100) UNIQUE NOT NULL,
Id_Persona INT NOT NULL,
CONSTRAINT FK_Correo FOREIGN KEY (Id_Persona) REFERENCES Personas (Id)
ON DELETE CASCADE ON UPDATE CASCADE,
);
GO

CREATE TABLE Telefonos_Personas(
Id INT PRIMARY KEY IDENTITY(1,1),
Numero VARCHAR(8) UNIQUE NOT NULL,
Id_Persona INT REFERENCES Personas(Id)
ON DELETE CASCADE ON UPDATE CASCADE,
);
GO

CREATE TABLE Responsables_Mascotas(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Persona INT REFERENCES Personas(Id),
Id_Mascota INT REFERENCES Mascotas(Id),
CONSTRAINT UQ_Res_Mascotas UNIQUE (Id_Persona, Id_Mascota),
);
GO

--SELECT Personas.Primer_Nombre AS Nombre, Personas.Primer_Apellido AS Apellido, Personas.DNI AS Dni FROM Mascotas  JOIN Responsables_Mascotas ON Mascotas.Id = Responsables_Mascotas.Id_Mascota JOIN Personas ON Responsables_Mascotas.Id_Persona = Personas.Id WHERE Mascotas.Id =  2 

CREATE TABLE Contratos(
Id INT PRIMARY KEY IDENTITY(1,1),
Fecha_Inicio DATE NOT NULL,
Fecha_Final DATE NOT NULL, 
Id_Periodo_Laboral INT REFERENCES Periodos_Laborales(Id),
Id_Horario INT REFERENCES Horarios(Id),
Id_Tipo INT REFERENCES Tipos_Empleados(Id),
Id_Salario INT REFERENCES Salarios(Id)
);
GO

CREATE TABLE Deducciones(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
Monto DECIMAL (10,2) NOT NULL
CONSTRAINT UQ_Deducciones UNIQUE (Nombre, Monto),
);
GO

CREATE TABLE Contratos_Deducciones(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Contrato INT REFERENCES Contratos(Id),
Id_Deduccion INT REFERENCES Deducciones(Id)
CONSTRAINT UQ_Contrato_Deduccion UNIQUE (Id_Contrato, Id_Deduccion),
);
GO

CREATE TABLE Beneficios(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
Monto DECIMAL (10,2) NOT NULL
CONSTRAINT UQ_Beneficios UNIQUE (Nombre, Monto),
);
GO

CREATE TABLE Contratos_Beneficios(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Contrato INT REFERENCES Contratos(Id),
Id_Beneficio INT REFERENCES Beneficios(Id)
CONSTRAINT UQ_Contratos_Beneficios UNIQUE (Id_Contrato, Id_Beneficio),
);
GO

CREATE TABLE Sucursales(
Id INT PRIMARY KEY IDENTITY(1,1),
Codigo VARCHAR(3) UNIQUE NOT NULL,
Nombre VARCHAR(100) UNIQUE NOT NULL,
Correo VARCHAR(100) UNIQUE NOT NULL,
Id_Empresa INT REFERENCES Empresas(Id),
Id_Direccion INT REFERENCES Direcciones(Id),
Id_Estado INT REFERENCES Estados_Sucursal(Id),
Id_Farmacia INT REFERENCES Farmacias(Id)
);
GO

CREATE TABLE Empleados(
Id INT PRIMARY KEY IDENTITY(1,1),
Num_Seguro VARCHAR(20) UNIQUE,
Img VARCHAR(50),
Id_Persona INT REFERENCES Personas(Id),
Id_Contrato INT REFERENCES Contratos(Id) UNIQUE NOT NULL,
Id_Sucursal INT REFERENCES Sucursales(Id) NOT NULL
);
GO

CREATE TABLE Citas(
Id INT PRIMARY KEY IDENTITY(1,1),
Fecha DATETIME NOT NULL,
Id_Empleado INT REFERENCES Empleados(Id),
Id_Mascota INT REFERENCES Mascotas(Id)
);
GO

CREATE TABLE Consultas(
Id INT PRIMARY KEY IDENTITY(1,1),
Fecha DATE NOT NULL,
Hora TIME NOT NULL,
Sintomas VARCHAR(200),
Diagnostico VARCHAR(200),
Id_Cita INT REFERENCES Citas(Id),
Id_Medico INT REFERENCES Empleados(Id),
Id_Persona_Ingreso INT REFERENCES Responsables_Mascotas(Id),
Id_Tipo INT REFERENCES Tipo_Consulta(Id),
Id_Expediente INT REFERENCES Expedientes(Id)
);
GO

CREATE TABLE Carnet_Vacunas(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Macota  INT REFERENCES Mascotas(Id)
);
GO

CREATE TABLE Vacunas_Aplicadas(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Vacuna INT REFERENCES Productos(Id),
Id_Carnet INT REFERENCES Carnet_Vacunas(Id),
Fecha DATE DEFAULT GETDATE()
);
GO

CREATE TABLE Proveedores(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(100) NOT NULL,
Correo VARCHAR(100) NOT NULL,
Id_Direccion INT REFERENCES Direcciones(Id)
);
GO

CREATE TABLE Registros(
Id INT PRIMARY KEY IDENTITY(1,1),
Fecha DATE NOT NULL,
Cantidad INT NOT NULL,
Precio_Unitario DECIMAL(10,2) NOT NULL,
Total DECIMAL(10,2) NOT NULL,
Id_Tipo INT REFERENCES Tipos_Registros(Id),
Id_Producto INT REFERENCES Productos(Id),
Id_Proveedor INT REFERENCES Proveedores(Id)
);
GO

CREATE TABLE Recetas_Medicamentos(
Id INT PRIMARY KEY IDENTITY(1,1),
Descripcion VARCHAR(200),
Id_Productos INT REFERENCES Productos(Id),
Dosis VARCHAR(10) NOT NULL,
Id_Consulta INT REFERENCES Consultas(Id)
);
GO

CREATE TABLE Telefonos_Sucursales(
Id INT PRIMARY KEY IDENTITY(1,1),
Numero VARCHAR(8) UNIQUE NOT NULL,
Id_Sucursal INT REFERENCES Sucursales(Id)
);
GO

CREATE TABLE Politicas(
Id INT PRIMARY KEY IDENTITY(1,1),
Descripcion VARCHAR(500) UNIQUE
);
GO

CREATE TABLE Politicas_Sucursal(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Sucursal INT REFERENCES Sucursales(Id),
Id_Politica INT REFERENCES Politicas(Id)
);
GO

CREATE TABLE Usuarios(
Id INT PRIMARY KEY IDENTITY(1,1),
Usuario VARCHAR(20) UNIQUE NOT NULL,
Contrasenia VARCHAR(50) UNIQUE NOT NULL,
Activo BIT DEFAULT 0,
Id_Empleado INT REFERENCES Empleados(Id),
Id_Roles INT REFERENCES Roles(Id)
);
GO

CREATE TABLE Usuarios_Permisos(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Usuario INT REFERENCES Usuarios(Id),
Id_Permiso INT REFERENCES Permisos(Id)
);
GO

CREATE TABLE Punto_Emision(
Id INT PRIMARY KEY IDENTITY(1,1),
Codigo VARCHAR(3) NOT NULL,
id_Ultima_Factura_Emitida INT NOT NULL DEFAULT 0,
Id_Sucursal INT REFERENCES Sucursales(Id),

CONSTRAINT UQ_Punto_Codigo UNIQUE (Codigo, Id_Sucursal)
);
GO

CREATE TABLE Inscripcion_SAR(
Id INT PRIMARY KEY IDENTITY(1,1),
CAI VARCHAR(37) NOT NULL,
Fecha_Limite DATE NOT NULL,
Inicio_Rango INT NOT NULL,
Final_Rango INT NOT NULL,
Num_Actual INT,
Activo BIT DEFAULT 1,
Id_Sucursal INT REFERENCES Sucursales(Id) NOT NULL,
Id_Documento INT REFERENCES Tipo_Documentos(Id) NOT NULL
);
GO

CREATE TABLE Facturas(
Id INT PRIMARY KEY IDENTITY(1,1),
RTN_Cliente VARCHAR(15),
Num_Factura VARCHAR(19) UNIQUE,
Fecha DATE NOT NULL,
Total DECIMAL(10,2) NOT NULL,
Impuesto_15 DECIMAL(10,2),
Impuesto_18 DECIMAL(10,2),
Id_Inscripcion INT REFERENCES Inscripcion_SAR(Id),
Id_Scursal INT REFERENCES Sucursales(Id),
Id_Cliente INT REFERENCES Responsables_Mascotas(Id)
); 
GO

CREATE TABLE Pagos_Facturas(
Id INT PRIMARY KEY IDENTITY(1,1),
Cantidad INT,
Id_Tipo INT REFERENCES Tipos_Pagos(Id),
Id_Factura INT REFERENCES Facturas(Id)
);
GO

CREATE TABLE Detalles_Facturas(
Id INT PRIMARY KEY IDENTITY(1,1),
Cantidad INT NOT NULL,
Impuesto_15 DECIMAL(10,2),
Impuesto_18 DECIMAL(10,2),
Id_Factura INT REFERENCES Facturas(Id),
Id_Producto INT REFERENCES Productos(Id)
);
GO


--INSERTS
--EMPRESA
INSERT INTO Empresas VALUES ('08012023000001', 'Veterinaria Los Ingenieros', 'losinges@gmail.com', 'ingesvet@gmail.com', 'logo.png'); 
GO

--Sucursales
INSERT INTO Estados_Sucursal VALUES ('Abierto'), ('Cerrado'),  ('En mantenimiento');
GO

--RRHH INSERTS
INSERT INTO Departamentos (Nombre)
VALUES
  ('Cortés'),
  ('Islas de la Bahía'),
  ('Atlántida'),
  ('Distrito Central');
GO

INSERT INTO Ciudades (Nombre, Id_Departamento)
VALUES
  ('San Pedro Sula', 1),
  ('Roatán', 2),
  ('La Ceiba', 3),
  ('Tegucigalpa', 4);
GO

INSERT INTO Direcciones (Referencia, Id_Ciudad)
VALUES
  ('GXG5+665, 1 Calle, San Pedro Sula 21102', 1),
  ('9G2P+P6Q, Monte Placentero', 2),
  ('Entre Ave. San Isidro y 14 de Julio, Calle 7, centro de la ciudad de La Ceiba, Calle 7, La Ceiba', 3),
  ('3RQ3+M3H, Boulevard Suyapa, Tegucigalpa', 4);
GO

INSERT INTO Beneficios (Nombre, Monto)
VALUES
  ('Aguinaldo', 10000.00),
  ('Catorceavo', 1500.00),
  ('Vacaciones', 20000.00),
  ('Prestaciones', 50000.00);
GO

INSERT INTO Deducciones (Nombre, Monto)
VALUES
  ('Seguro Social', 300.00),
  ('Contribuciones', 100.00)
GO

INSERT INTO Horarios (Hora_Inicial, Hora_Final)
VALUES
  ('06:00:00',  '14:00:00'),
  ('14:00:00', '22:00:00'),
  ('22:00:00', '06:00:00')
GO

INSERT INTO Tipos_Empleados(Nombre)
VALUES
  ('Veterinario'),
  ('Recepcionista'),
  ('Gerente General'),
  ('Encargado de Farmacia'),
  ('Gerente RRHH'),
  ('Cajero'),
  ('Guardia'),
  ('Conserje')
GO

INSERT INTO Periodos_Pago (Periodo) VALUES
('Mensual'), ('Quincenal');
GO

INSERT INTO Periodos_Laborales VALUES ('Fin de Semana'), ('De Lunes a Viernes');

--SAR
INSERT INTO Tipo_Documentos VALUES ('Factura', '01'), ('Boleta de Venta', '02'), ('Recibo de Alquiler', '03'), ('Recibo por Honorarios', '04'), ('Nota de Crédito', '05'), ('Nota de Débito', '06'), ('Comprobante de Retencion', '07'), ('Boleta de Compra', '08');
GO

--FARMACIAS
INSERT INTO Farmacias VALUES ('001'), ('002'), ('003'), ('004');
GO

--SUCURSALES
INSERT INTO Sucursales VALUES ('001', 'Sucursal 1', 'losinges01@gmail.com', 1, 1, 1, 1),
							  ('002', 'Sucursal 2', 'losinges02@gmail.com', 1, 2, 1, 2),
							  ('003', 'Sucursal 3', 'losinges03@gmail.com', 1, 3, 1, 3),
							  ('004', 'Sucursal 4', 'losinges04@gmail.com', 1, 4, 1, 4);
GO


--INSCRIPCION SAR
INSERT INTO Inscripcion_SAR VALUES ('123DFA-ABC5BC-ABC123-FD12AB-ABC567-12', '2024-12-31', 1, 1500, 0, 1, 1, 1);
GO
INSERT INTO Inscripcion_SAR VALUES ('123DFB-ABC5BC-ABC123-FD12AB-ABC567-12', '2024-12-31', 1, 1500, 0, 1, 2, 1);
GO
INSERT INTO Inscripcion_SAR VALUES ('123DFC-ABC5BC-ABC123-FD12AB-ABC567-12', '2024-12-31', 1, 1500, 0, 1, 3, 1);
GO
INSERT INTO Inscripcion_SAR VALUES ('123DFD-ABC5BC-ABC123-FD12AB-ABC567-12', '2024-12-31', 1, 1500, 0, 1, 4, 1);
GO

--PUNTOS EMISION
INSERT INTO Punto_Emision VALUES ('001', 0, 1), ('002', 0, 1), ('001', 0, 2), ('002', 0, 2), ('001', 0, 3), ('002', 0, 3), ('001', 0, 4), ('002', 0, 4);
GO

--MASCOTAS INSERTS
INSERT INTO Expedientes VALUES (GETDATE(), 1);
INSERT INTO Consultas values('2023-08-09', '12:30:00', 'gripe', '2 acetaminofen y piola', null, null, 1, null, null, 1);
go
INSERT INTO Especies values ('Conejo'),('Perro'), ('Gato'), ('Hamster');
GO
INSERT INTO Razas values('Bulldog', 2),('Beagle', 2),('Esfinge', 3),('Caracal', 3);
GO
INSERT INTO Razas (Nombre) values('No definido');
GO
INSERT INTO Generos VALUES ('Macho'),('Hembra'),('No identificado');
GO
INSERT INTO Estados VALUES ('Sano'),('Enfermo'),('Recuperacion');
GO

INSERT INTO Personas (Primer_Nombre, Primer_Apellido, DNI, FechaNac) VALUES ('Kelin', 'Aguilar', '0801198400000', '2002-03-08');
INSERT INTO Formas_Farmaceuticas values ('Jarabe'),('Pastilla'),('Vacuna');
INSERT INTO Productos values ('NOBIVAC', '2023-08-09', 150.50, 3, 1);
INSERT INTO Productos values ('COVID', '2023-08-09', 150.50, 3, 1);
INSERT INTO Enfermedades values('Alergia'),('parvovirosis'),('moquillo');


--TRIGGERS
CREATE TRIGGER SetSalarioNeto
ON Salarios
AFTER INSERT
AS
BEGIN
	DECLARE @Salario_Bruto AS INT = (SELECT Salario_Bruto FROM inserted)

    UPDATE Salarios
    SET Salario_Neto = @Salario_Bruto
    FROM Salarios
    INNER JOIN inserted ON Salarios.Id = inserted.Id;
END;


CREATE TRIGGER ActualizarSalarioNeto
ON Contratos_Deducciones
AFTER INSERT AS
BEGIN
	DECLARE @Contrato AS INT
	DECLARE @Deduccion AS INT

	SET @Contrato= (SELECT Id_Contrato FROM INSERTED)
	SET @Deduccion= (SELECT Id_Deduccion FROM INSERTED)

    UPDATE Salarios
    SET Salario_Neto = Salarios.Salario_Neto - ( SELECT Monto FROM Deducciones WHERE Id = @Deduccion) 
	FROM Salarios
    INNER JOIN Contratos ON Salarios.Id = Contratos.Id_Salario
	WHERE Contratos.Id = @Contrato;
END;

CREATE TRIGGER ActualizarSalarioNeto2
ON Contratos_Deducciones
AFTER DELETE AS
BEGIN
	DECLARE @Contrato AS INT
	DECLARE @Deduccion AS INT

	SET @Contrato= (SELECT Id_Contrato FROM deleted)
	SET @Deduccion= (SELECT Id_Deduccion FROM deleted)

    UPDATE Salarios
    SET Salario_Neto = Salarios.Salario_Neto + ( SELECT Monto FROM Deducciones WHERE Id = @Deduccion) 
	FROM Salarios
    INNER JOIN Contratos ON Salarios.Id = Contratos.Id_Salario
	WHERE Contratos.Id = @Contrato;
END;


CREATE PROCEDURE movimientoVenta 
@Id_Producto as int,
@Id_Tipo as int,
@CANTIDAD as int,
@Factor as int
AS 
UPDATE Registros SET Cantidad =Cantidad+(@Cantidad*@Factor), Total = Total + (@Cantidad*@Factor*Precio_Unitario)
WHERE Id_Producto = @Id_Producto AND Id_Tipo = @Id_Tipo

CREATE PROCEDURE movimientoCompra
@Id_Producto as int,
@Id_Tipo as int,
@Cantidad as int,
@Total as decimal,
@Factor as int
AS 
UPDATE Registros SET Cantidad =Cantidad+(@Cantidad*@Factor), Total = Total + @Total, Precio_Unitario =  (Total + @Total)/(Cantidad+(@Cantidad*@Factor))
WHERE Id_Producto = @Id_Producto AND Id_Tipo = @Id_Tipo

CREATE PROCEDURE precioProducto
@Id_Producto as int,
@precio as decimal
AS 
UPDATE Productos SET Precio =@precio
WHERE Id = @Id_Producto 


/*Desde donde trabaje Harold*/
/*Tablas que faltabas para crear las citas*/
CREATE TABLE Tipo_Estados(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL
);
GO



CREATE TABLE Estados_Citas(
Id INT PRIMARY KEY IDENTITY(1,1),
FechaInicio VARCHAR(19) CHECK (FechaInicio LIKE '[0-9][0-9][0-9][0-9]/[0-1][0-9]/[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]') NOT NULL,
FechaFinal VARCHAR(19) CHECK (FechaFinal LIKE '[0-9][0-9][0-9][0-9]/[0-1][0-9]/[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]') NOT NULL,
Id_Cita INT REFERENCES Citas(Id),
Id_Tipo_Estado INT REFERENCES Tipo_Estados(Id)
);
GO

INSERT INTO Tipo_Estados VALUES
('Pendiente'),
('Confirmada'),
('Cancelada'),
('Realizada'),
('Reprogramada')
GO


/*Select para obtener el nombre del empleado*/
select Personas.Primer_Nombre as Nombre from Personas
INNER JOIN Empleados
ON Personas.Id = Empleados.Id_Persona
GO

select Empleados.id as ID from Empleados
Inner Join Personas
on Empleados.Id_Persona = Personas.Id
GO



/*Select para mostrar en el datGreedView las Citas*/
CREATE PROCEDURE ObtenerDatosCitas
AS
BEGIN
    SELECT
        est.Id AS 'ID',
        pe.Primer_Nombre AS 'Nombre del Empleado',
		ci.Fecha,
        ma.Nombre AS 'Nombre de la Mascota',
        ti.Nombre AS 'Estado',
        est.FechaInicio AS 'Fecha Inicial del Estado',
        est.FechaFinal AS 'Fecha Final del Estado'
    FROM
        Estados_Citas est
    INNER JOIN Tipo_estados ti ON est.Id_Tipo_Estado = ti.Id
    INNER JOIN Citas ci ON ci.Id = est.Id_Cita
    INNER JOIN Mascotas ma ON ma.Id = ci.Id_Mascota
    INNER JOIN Empleados em ON em.Id = ci.Id_Empleado
    INNER JOIN Personas pe ON pe.Id = em.Id_Persona
END;
GO

EXEC ObtenerDatosCitas;
GO

select * from Tipo_Estados;
select * from Citas;
Select * from Estados_Citas;
GO


/*Inserts de los roles de los usuarios*/
insert into Roles Values ('Administrador');
insert into Roles Values ('Usuario Normal');

/*Tabla modificada de Usuarios*/
CREATE TABLE Usuarios(
Id INT PRIMARY KEY IDENTITY(1,1),
Usuario VARCHAR(25) UNIQUE NOT NULL,
Contrasenia VARCHAR(50) NOT NULL,
Activo BIT DEFAULT 0,
Id_Empleado INT REFERENCES Empleados(Id),
Id_Roles INT REFERENCES Roles(Id)
);
GO

/*Procedimiento almacenado para ver los datos de los usuarios*/
CREATE PROCEDURE ObtenerDatosUsuarios
AS
BEGIN
	SELECT 
		us.Id, us.Usuario, 
		us.Contrasenia 'Contraseña', 
		us.Activo, ro.Nombre as 'Rol del Usuario', 
		pe.DNI as 'DNI de la persona',
		pe.Primer_Nombre + ' '+ pe.Primer_Apellido as 'Nombre del Empleado'
	FROM 
		Usuarios us
	INNER JOIN Roles ro ON ro.Id = us.Id_Roles
	INNER JOIN Empleados em ON em.Id = us.Id_Empleado
	INNER JOIN Personas pe ON pe.Id = em.Id_Persona
END;

EXEC ObtenerDatosUsuarios;


/*Select para obtener el dni*/
SELECT em.Id FROM Empleados em
INNER JOIN Personas pe
ON pe.Id = em.Id_Persona
where pe.DNI = pe.DNI;

SELECT * FROM Personas;
select * from Sucursales;

CREATE TABLE Empleados(
Id INT PRIMARY KEY IDENTITY(1,1),
Num_Seguro VARCHAR(20) UNIQUE,
Img VARCHAR(50),
Id_Persona INT REFERENCES Personas(Id),
Id_Contrato INT REFERENCES Contratos(Id) UNIQUE NOT NULL,
Id_Sucursal INT REFERENCES Sucursales(Id) NOT NULL
);

insert into Contratos values (GETDATE(), '2024-08-08', null, null, 1, null);

insert into Empleados values ('123', 'img', 1,1, 1);

SELECT * FROM Consultas;
insert INTO Consultas values ('2020-02-02', '12:00:00', 'aa', 'aa', null, 1, 1, 4, 2);

select * from Responsables_Mascotas;

SELECT Id FROM Responsables_Mascotas where Id_Persona = 1 AND Id_Mascota = 2;
select * from Responsables_Mascotas;
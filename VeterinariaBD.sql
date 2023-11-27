CREATE DATABASE Veterinaria;
GO
USE Veterinaria;
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

CREATE TABLE Recetas(
Id INT PRIMARY KEY IDENTITY(1,1),
Dosis VARCHAR(10) NOT NULL
);
GO

CREATE TABLE Formas_Farmaceuticas(
Id INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) UNIQUE NOT NULL,
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
Segundo_Apelldio VARCHAR(50),
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
Id_Mascota INT REFERENCES Mascotas(Id)
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

CREATE TABLE Empleados(
Id INT PRIMARY KEY IDENTITY(1,1),
Num_Seguro VARCHAR(20) UNIQUE,
Img VARCHAR(50),
Id_Persona INT REFERENCES Personas(Id),
Id_Contrato INT REFERENCES Contratos(Id)
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
Id_Receta INT REFERENCES Recetas(Id),
Id_Tipo INT REFERENCES Tipo_Consulta(Id),
Id_Expediente INT REFERENCES Expedientes(Id)
);
GO

CREATE TABLE Farmacias(
Id INT PRIMARY KEY IDENTITY(1,1),
Id_Encargado INT REFERENCES Empleados(Id)
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

CREATE TABLE Carnet_Vacunas(
Id INT PRIMARY KEY IDENTITY(1,1),
Fecha DATE NOT NULL,
Id_Macota  INT REFERENCES Mascotas(Id),
Proxima_Vacuna INT REFERENCES Productos(Id)
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
Id_Receta INT REFERENCES Recetas(Id)
);
GO

CREATE TABLE Empresas(
Id INT PRIMARY KEY IDENTITY(1,1),
RTN VARCHAR(14) UNIQUE NOT NULL,
CAI VARCHAR(14) NOT NULL,
Nombre VARCHAR(100) UNIQUE NOT NULL,
Correo_1 VARCHAR(100) NOT NULL,
Correo_2 VARCHAR(100),
Img VARCHAR(50)
);
GO

CREATE TABLE Sucursales(
Id INT PRIMARY KEY IDENTITY(1,1),
Codigo VARCHAR(10) UNIQUE NOT NULL,
Nombre VARCHAR(100) UNIQUE NOT NULL,
Correo VARCHAR(100) UNIQUE NOT NULL,
Id_Empresa INT REFERENCES Empresas(Id),
Id_Direccion INT REFERENCES Direcciones(Id),
Id_Estado INT REFERENCES Estados_Sucursal(Id),
Id_Farmacia INT REFERENCES Farmacias(Id),
Id_Gerente INT REFERENCES Empleados(Id)
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
Descripcion VARCHAR(500)
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
Codigo VARCHAR(20) UNIQUE NOT NULL,
Id_Sucursal INT REFERENCES Sucursales(Id)
);
GO

CREATE TABLE Inscripcion_SAR(
Id INT PRIMARY KEY IDENTITY(1,1),
CAI VARCHAR(14),
Fecha_Limite DATE NOT NULL,
Inicio_Rango INT NOT NULL,
Final_Rango INT NOT NULL,
Num_Actual INT,
Activo BIT DEFAULT 1,
Id_Sucursal INT REFERENCES Sucursales(Id),
Id_Documento INT REFERENCES Tipo_Documentos(Id),
Id_Punto_Emision INT REFERENCES Punto_Emision(Id)
);
GO

CREATE TABLE Facturas(
Id INT PRIMARY KEY IDENTITY(1,1),
Num_Factura INT UNIQUE NOT NULL,
Fecha DATE NOT NULL,
Precio_Consulta DECIMAL(10,2) NOT NULL, 
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
INSERT INTO Mascotas values('Eduardo', 'gris con negro', '2022-08-09', 0, 0, '8.8', '27', 3, 4, 1, 1);
GO
INSERT INTO Personas (Primer_Nombre, Primer_Apellido, DNI, FechaNac) VALUES ('Kelin', 'Aguilar', '0801198400000', '2002-03-08');
INSERT INTO Responsables_Mascotas values (2,9);
INSERT INTO Farmacias values(NULL);
INSERT INTO Formas_Farmaceuticas values ('Jarabe'),('Pastilla'),('Vacuna');
INSERT INTO Productos values ('NOBIVAC', '2023-08-09', 150.50, 3, 1);
INSERT INTO Productos values ('COVID', '2023-08-09', 150.50, 3, 1);
INSERT INTO Carnet_Vacunas VALUES(GETDATE(), 1, NULL);
INSERT INTO Vacunas_Aplicadas values (1, 1, GETDATE());
INSERT INTO Enfermedades values('Alergia');
INSERT INTO Enfermedades_Bases values (1, 1);

--RRHH INSERTS
--INSERTS

INSERT INTO Departamentos (Nombre)
VALUES
  ('Cort�s'),
  ('Islas de la Bah�a'),
  ('Atl�ntida'),
  ('Distrito Central');
GO

INSERT INTO Ciudades (Nombre, Id_Departamento)
VALUES
  ('San Pedro Sula', 1),
  ('Roat�n', 2),
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

INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (1000000.00, 1);
INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (500000.00, 1);
INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (30000.00, 1);
INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (400000.00, 1);
INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (400000.00, 1);
INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (30000.00, 1);
INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (400000.00, 1);
INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (400000.00, 1);
INSERT INTO Salarios (Salario_Bruto, Id_Periodo_Pago) VALUES (400000.00, 2);

INSERT INTO Periodos_Laborales(Periodo_Laboral) VALUES ('De Lunes a Viernes'), ('Fin de Semana');

INSERT INTO Contratos (Fecha_Inicio, Fecha_Final, Id_Periodo_Laboral, Id_Horario, Id_Tipo, Id_Salario) VALUES
						(GETDATE(), '2024-06-01', 1, 1, 8, 11),
						(GETDATE(), '2024-04-01', 1, 2, 1, 10)

						
INSERT INTO Contratos (Fecha_Inicio, Fecha_Final, Id_Periodo_Laboral, Id_Horario, Id_Tipo, Id_Salario) VALUES
						(GETDATE(), '2024-06-01', 1, 1, 8, 1),
						(GETDATE(), '2024-04-01', 1, 2, 1, 2)

INSERT INTO Contratos_Deducciones (Id_Contrato, Id_Deduccion) VALUES
						(8, 2),
						(9, 1)

INSERT INTO Contratos_Deducciones (Id_Contrato, Id_Deduccion) VALUES
						(9, 2)

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


USE Veterinaria;
GO

/*Select para ontener el nombre del empleado*/
select Personas.Primer_Nombre as Nombre from Personas
INNER JOIN Empleados
ON Personas.Id = Empleados.Id_Persona
GO

/*Select para obtener el ID del empleado*/
select Empleados.id as ID from Empleados
Inner Join Personas
on Empleados.Id_Persona = Personas.Id
GO

/*Procedimiento almacenado para obtener los datos que se necesitan de la cita, solo es ejemplo*/
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

/*Procedimiento almacenado para ver los datos de los usuarios*/
CREATE PROCEDURE ObtenerDatosUsuarios
AS
BEGIN
	SELECT 
		us.Id, us.Usuario, 
		us.Contrasenia as 'Contraseņa', 
		us.Activo, ro.Nombre as 'Rol del Usuario', 
		pe.DNI as 'DNI de la persona',
		pe.Primer_Nombre + ' '+ pe.Primer_Apellido as 'Nombre del Empleado'
	FROM 
		Usuarios us
	INNER JOIN Roles ro ON ro.Id = us.Id_Roles
	INNER JOIN Empleados em ON em.Id = us.Id_Empleado
	INNER JOIN Personas pe ON pe.Id = em.Id_Persona
END;
GO

EXEC ObtenerDatosUsuarios;
GO


/*Select para obtener el dni*/
SELECT em.Id FROM Empleados em
INNER JOIN Personas pe
ON pe.Id = em.Id_Persona
where pe.DNI = pe.DNI;
GO

/*Procedimiento almacenado para obtener los permisos de los usuarios */
CREATE PROCEDURE ObtenerDatosPermisosUsuarios
AS
BEGIN
	SELECT 
		usp.Id,
		us.Usuario, 
		per.DNI , 
		per.Primer_Nombre + ' ' + per.Primer_Apellido as 'Nombre Empleado' , 
		pe.Nombre as 'Permisos Usuario', 
		ro.Nombre as 'Rol Usuario'
	FROM 
		Usuarios_Permisos usp
	INNER JOIN Usuarios us ON usp.Id_Usuario = us.Id
	INNER JOIN Permisos pe ON usp.Id_Permiso = pe.Id
	INNER JOIN Roles ro ON ro.Id = us.Id_Roles
	INNER JOIN Empleados em ON us.Id_Empleado = em.Id
	INNER JOIN Personas per ON per.Id = em.Id_Persona
END;
GO

EXEC ObtenerDatosPermisosUsuarios;
GO

/*Select utilizado para poder validar los permisos*/
SELECT pe.Nombre as'Nombre del Permiso', us.Usuario, ro.Nombre as 'Nombre del rol'
FROM Usuarios_Permisos usp
INNER JOIN Usuarios us
ON usp.Id_Usuario = us.Id
INNER JOIN Permisos pe
ON usp.Id_Permiso = pe.Id
INNER JOIN Roles ro
ON ro.Id = us.Id_Roles
WHERE us.Usuario = 'harolds'
GO


/*SELECT para mostrar la informacion personal*/
SELECT per.DNI, us.Usuario, rol.Nombre as 'Rol', perm.Nombre as 'Permisos', per.Primer_Nombre, per.Segundo_Nombre, emp.Img, per.Primer_Apellido, per.Segundo_Apellido, per.Edad, dir.Referencia, ciu.Nombre as 'Ciudad', dep.Nombre as 'Departamento', tip.Nombre as 'Cargo', tel.Numero, corp.Correo, emp.Num_Seguro, sal.Salario_Neto, sal.Salario_Bruto, hor.Hora_Inicial, hor.Hora_Final, pel.Periodo_Laboral, perp.Periodo
FROM Empleados emp
INNER JOIN Personas per ON emp.Id_Persona = per.Id
INNER JOIN Direcciones dir ON per.Id_Direccion = dir.Id
INNER JOIN Ciudades ciu ON ciu.Id = dir.Id_Ciudad
INNER JOIN Departamentos dep ON ciu.Id_Departamento = dep.Id
INNER JOIN Contratos con ON emp.Id_Contrato = con.Id
INNER JOIN Tipos_Empleados tip ON con.Id_Tipo = tip.Id
INNER JOIN Salarios sal ON con.Id_Salario = sal.Id
INNER JOIN Periodos_Pago perp ON sal.Id_Periodo_Pago = perp.Id
INNER JOIN Periodos_Laborales pel ON con.Id_Periodo_Laboral = pel.Id
INNER JOIN Horarios hor ON con.Id_Horario = hor.Id
INNER JOIN Correos_Personas corp ON per.Id = corp.Id
INNER JOIN Telefonos_Personas tel ON per.Id = tel.Id
INNER JOIN Usuarios us ON emp.Id = us.Id_Empleado
INNER JOIN Roles rol ON us.Id_Roles = rol.Id
INNER JOIN Usuarios_Permisos usp ON usp.Id_Usuario = us.Id
INNER JOIN Permisos perm ON perm.Id = usp.Id_Permiso
WHERE per.Id = 1;
GO


/*SELECT para mostrar la informacion de la empresa*/
SELECT em.Nombre, em.Img, em.RTN, em.Correo_1, em.Correo_2, tef.Numero as 'Numero de la Sucursal', suc.Nombre as 'Sucursal', dep.Nombre as 'Departamento', ciu.Nombre as 'Ciudad', dir.Referencia
FROM Empresas em
INNER JOIN Sucursales suc ON em.Id = suc.Id_Empresa
INNER JOIN Empleados emp ON emp.Id_Sucursal = suc.Id
INNER JOIN Personas per ON per.Id = emp.Id_Persona
INNER JOIN Direcciones dir ON dir.Id = suc.Id_Direccion
INNER JOIN Ciudades ciu ON ciu.Id = dir.Id_Ciudad
INNER JOIN Departamentos dep ON dep.Id = ciu.Id_Departamento
INNER JOIN Usuarios us ON us.Id_Empleado = emp.Id
INNER JOIN Telefonos_Sucursales tef ON suc.Id = tef.Id_Sucursal
Where suc.Id = 1;
GO
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
		us.Contrasenia as 'Contraseña', 
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
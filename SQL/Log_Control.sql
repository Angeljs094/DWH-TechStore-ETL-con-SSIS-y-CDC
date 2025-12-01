USE DWH_TechStore;
GO

CREATE SCHEMA ETL;
GO

CREATE TABLE ETL.AuditoriaLote (
    LoteID        BIGINT IDENTITY(1,1) PRIMARY KEY,
    Proceso       VARCHAR(100) NOT NULL,
    InicioLote    DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FinLote       DATETIME2(3) NULL,
    Estado        VARCHAR(20)  NOT NULL DEFAULT 'EN_PROCESO', -- EN_PROCESO | OK | ERROR
    FilasLeidas   BIGINT       NULL,
    FilasExitosas BIGINT       NULL,
    FilasError    BIGINT       NULL,
    Comentario    VARCHAR(500) NULL
);

CREATE TABLE ETL.AuditoriaDetalle (
    DetalleID     BIGINT IDENTITY(1,1) PRIMARY KEY,
    LoteID        BIGINT NOT NULL REFERENCES ETL.AuditoriaLote(LoteID),
    Etapa         VARCHAR(100) NOT NULL,     -- e.g. 'Staging.Clientes'
    InicioEtapa   DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    FinEtapa      DATETIME2(3) NULL,
    Estado        VARCHAR(20)  NOT NULL DEFAULT 'EN_PROCESO',
    Filas         BIGINT       NULL,
    Mensaje       VARCHAR(500) NULL
);

CREATE TABLE ETL.ErrorRows (
    ErrorID       BIGINT IDENTITY(1,1) PRIMARY KEY,
    Proceso       VARCHAR(100) NOT NULL,
    TablaDestino  VARCHAR(200) NOT NULL,
    ErrorMensaje  VARCHAR(500) NOT NULL,
    Payload       NVARCHAR(MAX) NULL,
    FechaRegistro DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- SPs utilitarios para abrir/cerrar lote
CREATE OR ALTER PROCEDURE ETL.sp_IniciarLote
    @Proceso VARCHAR(100),
    @LoteID BIGINT OUTPUT
AS
BEGIN
    INSERT INTO ETL.AuditoriaLote(Proceso) VALUES(@Proceso);
    SET @LoteID = SCOPE_IDENTITY();
END
GO

CREATE OR ALTER PROCEDURE ETL.sp_CerrarLote
    @LoteID BIGINT,
    @Estado VARCHAR(20),
    @FilasLeidas BIGINT = NULL,
    @FilasExitosas BIGINT = NULL,
    @FilasError BIGINT = NULL,
    @Comentario VARCHAR(500) = NULL
AS
BEGIN
    UPDATE ETL.AuditoriaLote
       SET FinLote = SYSUTCDATETIME(),
           Estado = @Estado,
           FilasLeidas = @FilasLeidas,
           FilasExitosas = @FilasExitosas,
           FilasError = @FilasError,
           Comentario = @Comentario
     WHERE LoteID = @LoteID;
END
GO


select COUNT(*) from [Staging].[Productos];

select COUNT(*) from [Staging].[Tiendas];

SELECT *
FROM ETL.AuditoriaLote
ORDER BY LoteID DESC;

-- Tabla de control CDC (CRÍTICO: Esta tabla vive en el DWH)
DROP TABLE IF EXISTS ETL.ControlCDC;
CREATE TABLE ETL.ControlCDC (
    TablaOrigen VARCHAR(100) PRIMARY KEY,
    UltimoLSN VARCHAR(22), -- Guardamos como string para facilitar conversión
    UltimaFechaProceso DATETIME
);

-- Inicializar control CDC con NULL (primera ejecución usará LSN mínimo)
INSERT INTO ETL.ControlCDC VALUES
('Fuente.Clientes', NULL, NULL),
('Fuente.Ventas', NULL, NULL);

select * from ETL.ControlCDC;


SELECT 
    s.name AS Esquema,
    t.name AS Tabla,
    c.capture_instance,
    c.create_date
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
LEFT JOIN cdc.change_tables c ON OBJECT_ID(s.name + '.' + t.name) = c.object_id
WHERE c.capture_instance IS NOT NULL;


-- Verificar las tablas CDC creadas (deben aparecer 3 tablas CDC)
SELECT name, create_date 
FROM sys.tables 
WHERE name LIKE 'dbo_Clientes%' 
   OR name LIKE 'dbo_Cuentas%'
   OR name LIKE 'dbo_Transacciones%';
GO


SELECT ROUTINE_NAME 
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = 'cdc'
  AND ROUTINE_NAME LIKE 'fn_cdc_get%';


  SELECT 'Productos' AS Tabla, COUNT(*) AS Total FROM Fuente.Productos
UNION ALL
SELECT 'Clientes', COUNT(*) FROM Fuente.Clientes
UNION ALL
SELECT 'Tiendas', COUNT(*) FROM Fuente.Tiendas
UNION ALL
SELECT 'Ventas', COUNT(*) FROM Fuente.Ventas;

SELECT 
    YEAR(CAST(FechaVenta AS DATE)) AS Anio,
    MONTH(CAST(FechaVenta AS DATE)) AS Mes,
    COUNT(*) AS TotalVentas
FROM Fuente.Ventas
GROUP BY YEAR(CAST(FechaVenta AS DATE)), MONTH(CAST(FechaVenta AS DATE))
ORDER BY Anio, Mes;
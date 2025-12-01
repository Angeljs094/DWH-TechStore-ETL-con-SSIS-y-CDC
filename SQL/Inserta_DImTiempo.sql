-- Borrar si existe
IF OBJECT_ID('BDS.DimTiempo','U') IS NOT NULL
    DROP TABLE BDS.DimTiempo;
GO

-- Crear tabla DimTiempo
CREATE TABLE BDS.DimTiempo (
    TiempoKey     INT PRIMARY KEY,   -- formato YYYYMMDD
    Fecha         DATE NOT NULL,
    Anio          INT NOT NULL,
    Mes           INT NOT NULL,
    NombreMes     VARCHAR(20) NOT NULL,
    NombreMesCorto VARCHAR(3) NOT NULL,
    Trimestre     INT NOT NULL,
    Dia           INT NOT NULL,
    NombreDia     VARCHAR(20) NOT NULL,
    NombreDiaCorto VARCHAR(3) NOT NULL,
    DiaDelAnio    INT NOT NULL,
    SemanaAnio    INT NOT NULL,
    EsFinDeSemana BIT NOT NULL
);
GO

-- Poblar DimTiempo para 2024-2025
DECLARE @FechaInicio DATE = '20240101';
DECLARE @FechaFin    DATE = '20251231';

;WITH CTE AS (
    SELECT @FechaInicio AS Fecha
    UNION ALL
    SELECT DATEADD(DAY, 1, Fecha)
    FROM CTE
    WHERE Fecha < @FechaFin
)
INSERT INTO BDS.DimTiempo
(
    TiempoKey, Fecha, Anio, Mes, NombreMes, NombreMesCorto,
    Trimestre, Dia, NombreDia, NombreDiaCorto, DiaDelAnio, SemanaAnio, EsFinDeSemana
)
SELECT 
    CONVERT(INT, FORMAT(Fecha,'yyyyMMdd')) AS TiempoKey,
    Fecha,
    YEAR(Fecha) AS Anio,
    MONTH(Fecha) AS Mes,
    DATENAME(MONTH, Fecha) AS NombreMes,
    LEFT(DATENAME(MONTH, Fecha),3) AS NombreMesCorto,
    DATEPART(QUARTER, Fecha) AS Trimestre,
    DAY(Fecha) AS Dia,
    DATENAME(WEEKDAY, Fecha) AS NombreDia,
    LEFT(DATENAME(WEEKDAY, Fecha),3) AS NombreDiaCorto,
    DATEPART(DAYOFYEAR, Fecha) AS DiaDelAnio,
    DATEPART(WEEK, Fecha) AS SemanaAnio,
    CASE WHEN DATENAME(WEEKDAY, Fecha) IN ('Saturday','Sunday','Sábado','Domingo') THEN 1 ELSE 0 END AS EsFinDeSemana
FROM CTE
OPTION (MAXRECURSION 0);
GO

-- =============================================
-- 4. Habilitar CDC en fuente (Clientes, Ventas)
-- =============================================

-- Habilitar CDC a nivel base
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = DB_NAME() AND is_cdc_enabled = 0)
BEGIN
    EXEC sys.sp_cdc_enable_db;
END
GO

-- CDC para Fuente.Clientes
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name='Clientes' AND SCHEMA_NAME(t.schema_id)='Fuente'
               AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'cdc_Fuente_Clientes_CT'))
BEGIN
    EXEC sys.sp_cdc_enable_table 
        @source_schema = N'Fuente',
        @source_name   = N'Clientes',
        @role_name     = NULL,
        @supports_net_changes = 1;
END
GO

-- CDC para Fuente.Ventas
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name='Ventas' AND SCHEMA_NAME(t.schema_id)='Fuente'
               AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'cdc_Fuente_Ventas_CT'))
BEGIN
    EXEC sys.sp_cdc_enable_table 
        @source_schema = N'Fuente',
        @source_name   = N'Ventas',
        @role_name     = NULL,
        @supports_net_changes = 1;
END
GO


-- Crear esquema Staging para CDC
CREATE SCHEMA CDC_Staging;
GO
CREATE TABLE CDC_Staging.Clientes_Changes (
    ClienteID INT PRIMARY KEY,
    NombreCompleto VARCHAR(200),
    Email VARCHAR(150),
    Ciudad VARCHAR(100),
    Pais VARCHAR(100),
    CDC_Operation INT, -- 1=DELETE, 2=INSERT, 4=UPDATE (Before), 3=UPDATE (After en net changes)
    FechaCargaCDC DATETIME DEFAULT GETDATE()
);

CREATE TABLE CDC_Staging.Ventas_Changes (
    VentaID INT PRIMARY KEY,
    FechaVenta VARCHAR(50),   -- deliberately VARCHAR para simular datos sucios
    ProductoID INT,
    ClienteID INT,
    TiendaID INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    CDC_Operation INT, -- 1=DELETE, 2=INSERT, 4=UPDATE (Before), 3=UPDATE (After en net changes)
    FechaCargaCDC DATETIME DEFAULT GETDATE()
);


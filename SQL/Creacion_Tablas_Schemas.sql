IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'DWH_TechStore'
)
BEGIN
    CREATE DATABASE DWH_TechStore;
    PRINT 'Base de datos DWH_TechStore creada correctamente.';
END
ELSE
BEGIN
    PRINT 'La base de datos DWH_TechStore ya existe.';
END
GO

-- Ahora la usamos
USE DWH_TechStore;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Fuente')
BEGIN
    EXEC('CREATE SCHEMA Fuente');
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Staging') EXEC('CREATE SCHEMA Staging');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ODS') EXEC('CREATE SCHEMA ODS');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'BDS') EXEC('CREATE SCHEMA BDS');
GO

DROP TABLE IF EXISTS Fuente.Ventas;
CREATE TABLE Fuente.Ventas (
    VentaID INT PRIMARY KEY,
    FechaVenta VARCHAR(50),   -- deliberately VARCHAR para simular datos sucios
    ProductoID INT,
    ClienteID INT,
    TiendaID INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2)
);

DROP TABLE IF EXISTS Fuente.Productos;
CREATE TABLE Fuente.Productos (
    ProductoID INT PRIMARY KEY,
    NombreProducto VARCHAR(200),
    Categoria VARCHAR(100),
    Marca VARCHAR(100),
    PrecioLista DECIMAL(10,2)
);

DROP TABLE IF EXISTS Fuente.Clientes;
CREATE TABLE Fuente.Clientes (
    ClienteID INT PRIMARY KEY,
    NombreCompleto VARCHAR(200),
    Email VARCHAR(150),
    Ciudad VARCHAR(100),
    Pais VARCHAR(100)
);

DROP TABLE IF EXISTS Fuente.Tiendas;
CREATE TABLE Fuente.Tiendas (
    TiendaID INT PRIMARY KEY,
    NombreTienda VARCHAR(200),
    Ciudad VARCHAR(100),
    Pais VARCHAR(100),
    Tipo VARCHAR(50)
);

-- =============================================
-- PARTE 2: INSERTAR DATOS DE PRUEBA
-- =============================================

-- PRODUCTOS (20 productos)
INSERT INTO Fuente.Productos (ProductoID, NombreProducto, Categoria, Marca, PrecioLista) VALUES
(1, 'iPhone 15 Pro', 'Smartphones', 'Apple', 1199.00),
(2, 'Samsung Galaxy S24', 'Smartphones', 'Samsung', 999.00),
(3, 'MacBook Pro 16"', 'Laptops', 'Apple', 2499.00),
(4, 'Dell XPS 15', 'Laptops', 'Dell', 1799.00),
(5, 'iPad Air', 'Tablets', 'Apple', 599.00),
(6, 'Samsung Galaxy Tab S9', 'Tablets', 'Samsung', 549.00),
(7, 'AirPods Pro', 'Audio', 'Apple', 249.00),
(8, 'Sony WH-1000XM5', 'Audio', 'Sony', 399.00),
(9, 'Apple Watch Series 9', 'Wearables', 'Apple', 399.00),
(10, 'Fitbit Charge 6', 'Wearables', 'Fitbit', 159.00),
(11, 'Canon EOS R6', 'Cámaras', 'Canon', 2499.00),
(12, 'Sony Alpha A7 IV', 'Cámaras', 'Sony', 2499.00),
(13, 'Nintendo Switch', 'Gaming', 'Nintendo', 299.00),
(14, 'PlayStation 5', 'Gaming', 'Sony', 499.00),
(15, 'Xbox Series X', 'Gaming', 'Microsoft', 499.00),
(16, 'LG OLED TV 55"', 'TV', 'LG', 1399.00),
(17, 'Samsung QLED 65"', 'TV', 'Samsung', 1799.00),
(18, 'Bose SoundLink', 'Audio', 'Bose', 199.00),
(19, 'GoPro Hero 12', 'Cámaras', 'GoPro', 399.00),
(20, 'Lenovo ThinkPad X1', 'Laptops', 'Lenovo', 1899.00);

-- CLIENTES (30 clientes)
INSERT INTO Fuente.Clientes (ClienteID, NombreCompleto, Email, Ciudad, Pais) VALUES
(101, 'Juan Pérez', 'JUAN.PEREZ@GMAIL.COM', 'Lima', 'Perú'),
(102, 'María García', 'maria.garcia@HOTMAIL.COM', 'Arequipa', 'Perú'),
(103, 'Carlos López', 'carlos.lopez@yahoo.com', 'Cusco', 'Perú'),
(104, 'Ana Martínez', 'ANA.MARTINEZ@GMAIL.COM', 'Trujillo', 'Perú'),
(105, 'Pedro Rodríguez', 'pedro.rodriguez@outlook.com', 'Lima', 'Perú'),
(106, 'Laura Fernández', 'laura.fernandez@gmail.com', 'Chiclayo', 'Perú'),
(107, 'Diego Sánchez', 'DIEGO.SANCHEZ@HOTMAIL.COM', 'Lima', 'Perú'),
(108, 'Sofía Torres', 'sofia.torres@yahoo.com', 'Lima', 'Perú'),
(109, 'Miguel Ramírez', 'miguel.ramirez@GMAIL.COM', 'Arequipa', 'Perú'),
(110, 'Elena Castro', 'elena.castro@outlook.com', 'Lima', 'Perú'),
(111, 'Roberto Silva', 'ROBERTO.SILVA@GMAIL.COM', 'Santiago', 'Chile'),
(112, 'Carmen Rojas', 'carmen.rojas@hotmail.com', 'Valparaíso', 'Chile'),
(113, 'Fernando Díaz', 'fernando.diaz@YAHOO.COM', 'Concepción', 'Chile'),
(114, 'Patricia Morales', 'patricia.morales@gmail.com', 'Santiago', 'Chile'),
(115, 'Ricardo Vargas', 'RICARDO.VARGAS@OUTLOOK.COM', 'Bogotá', 'Colombia'),
(116, 'Isabel Méndez', 'isabel.mendez@gmail.com', 'Medellín', 'Colombia'),
(117, 'Andrés Herrera', 'andres.herrera@HOTMAIL.COM', 'Cali', 'Colombia'),
(118, 'Gabriela Ortiz', 'gabriela.ortiz@yahoo.com', 'Bogotá', 'Colombia'),
(119, 'Luis Navarro', 'LUIS.NAVARRO@GMAIL.COM', 'Quito', 'Ecuador'),
(120, 'Valentina Cruz', 'valentina.cruz@outlook.com', 'Guayaquil', 'Ecuador'),
(121, 'Daniel Flores', 'daniel.flores@GMAIL.COM', 'Buenos Aires', 'Argentina'),
(122, 'Camila Reyes', 'camila.reyes@hotmail.com', 'Córdoba', 'Argentina'),
(123, 'Sebastián Ruiz', 'sebastian.ruiz@YAHOO.COM', 'Rosario', 'Argentina'),
(124, 'Natalia Jiménez', 'natalia.jimenez@gmail.com', 'Buenos Aires', 'Argentina'),
(125, 'Javier Muñoz', 'JAVIER.MUNOZ@OUTLOOK.COM', 'Montevideo', 'Uruguay'),
(126, 'Andrea Romero', 'andrea.romero@gmail.com', 'Montevideo', 'Uruguay'),
(127, 'Pablo Guerrero', 'pablo.guerrero@HOTMAIL.COM', 'Ciudad de México', 'México'),
(128, 'Carolina Medina', 'carolina.medina@yahoo.com', 'Guadalajara', 'México'),
(129, 'Martín Gutiérrez', 'MARTIN.GUTIERREZ@GMAIL.COM', 'Monterrey', 'México'),
(130, 'Lucía Álvarez', 'lucia.alvarez@outlook.com', 'Ciudad de México', 'México');

-- TIENDAS (10 tiendas)
INSERT INTO Fuente.Tiendas (TiendaID, NombreTienda, Ciudad, Pais, Tipo) VALUES
(1, 'TechStore Lima Centro', 'Lima', 'Perú', 'Física'),
(2, 'TechStore Arequipa', 'Arequipa', 'Perú', 'Física'),
(3, 'TechStore Online Perú', 'Lima', 'Perú', 'Online'),
(4, 'TechStore Santiago', 'Santiago', 'Chile', 'Física'),
(5, 'TechStore Online Chile', 'Santiago', 'Chile', 'Online'),
(6, 'TechStore Bogotá', 'Bogotá', 'Colombia', 'Física'),
(7, 'TechStore Online Colombia', 'Bogotá', 'Colombia', 'Online'),
(8, 'TechStore Buenos Aires', 'Buenos Aires', 'Argentina', 'Física'),
(9, 'TechStore Online Argentina', 'Buenos Aires', 'Argentina', 'Online'),
(10, 'TechStore Online Internacional', 'Lima', 'Perú', 'Online');

-- VENTAS (100 transacciones) - Fechas en formato inconsistente para simular datos reales
INSERT INTO Fuente.Ventas (VentaID, FechaVenta, ProductoID, ClienteID, TiendaID, Cantidad, PrecioUnitario) VALUES
-- Enero 2024
(1, '2024-01-05', 1, 101, 1, 1, 1199.00),
(2, '2024-01-05', 7, 101, 1, 2, 249.00),
(3, '2024-01-08', 2, 102, 2, 1, 999.00),
(4, '2024-01-10', 13, 103, 3, 1, 299.00),
(5, '2024-01-12', 5, 104, 1, 1, 599.00),
(6, '2024-01-15', 14, 105, 3, 1, 499.00),
(7, '2024-01-18', 3, 106, 1, 1, 2499.00),
(8, '2024-01-20', 8, 107, 3, 1, 399.00),
(9, '2024-01-22', 16, 108, 1, 1, 1399.00),
(10, '2024-01-25', 9, 109, 2, 1, 399.00),
-- Febrero 2024
(11, '2024-02-01', 1, 110, 3, 1, 1199.00),
(12, '2024-02-03', 4, 111, 4, 1, 1799.00),
(13, '2024-02-05', 11, 112, 4, 1, 2499.00),
(14, '2024-02-07', 2, 113, 5, 2, 999.00),
(15, '2024-02-10', 15, 114, 4, 1, 499.00),
(16, '2024-02-12', 6, 115, 6, 1, 549.00),
(17, '2024-02-14', 7, 116, 7, 3, 249.00),
(18, '2024-02-17', 18, 117, 6, 2, 199.00),
(19, '2024-02-20', 12, 118, 6, 1, 2499.00),
(20, '2024-02-22', 10, 119, 10, 2, 159.00),
-- Marzo 2024
(21, '2024-03-01', 17, 120, 10, 1, 1799.00),
(22, '2024-03-03', 3, 121, 8, 1, 2499.00),
(23, '2024-03-05', 1, 122, 9, 1, 1199.00),
(24, '2024-03-08', 13, 123, 9, 2, 299.00),
(25, '2024-03-10', 14, 124, 8, 1, 499.00),
(26, '2024-03-12', 5, 125, 10, 1, 599.00),
(27, '2024-03-15', 19, 126, 10, 1, 399.00),
(28, '2024-03-17', 2, 127, 10, 1, 999.00),
(29, '2024-03-20', 8, 128, 10, 2, 399.00),
(30, '2024-03-22', 20, 129, 10, 1, 1899.00),
-- Abril 2024
(31, '2024-04-02', 1, 130, 1, 1, 1199.00),
(32, '2024-04-04', 9, 101, 1, 1, 399.00),
(33, '2024-04-06', 7, 102, 3, 2, 249.00),
(34, '2024-04-08', 4, 103, 1, 1, 1799.00),
(35, '2024-04-10', 16, 104, 1, 1, 1399.00),
(36, '2024-04-12', 2, 105, 3, 1, 999.00),
(37, '2024-04-15', 14, 106, 3, 1, 499.00),
(38, '2024-04-17', 11, 107, 2, 1, 2499.00),
(39, '2024-04-20', 6, 108, 3, 1, 549.00),
(40, '2024-04-22', 15, 109, 3, 1, 499.00),
-- Mayo 2024
(41, '2024-05-01', 3, 110, 1, 1, 2499.00),
(42, '2024-05-03', 7, 111, 5, 4, 249.00),
(43, '2024-05-05', 1, 112, 4, 1, 1199.00),
(44, '2024-05-08', 17, 113, 5, 1, 1799.00),
(45, '2024-05-10', 12, 114, 4, 1, 2499.00),
(46, '2024-05-12', 2, 115, 7, 2, 999.00),
(47, '2024-05-15', 8, 116, 6, 1, 399.00),
(48, '2024-05-17', 13, 117, 7, 2, 299.00),
(49, '2024-05-20', 5, 118, 6, 1, 599.00),
(50, '2024-05-22', 18, 119, 10, 3, 199.00),
-- Junio 2024
(51, '2024-06-01', 10, 120, 10, 2, 159.00),
(52, '2024-06-03', 4, 121, 8, 1, 1799.00),
(53, '2024-06-05', 16, 122, 9, 1, 1399.00),
(54, '2024-06-08', 1, 123, 9, 1, 1199.00),
(55, '2024-06-10', 14, 124, 8, 1, 499.00),
(56, '2024-06-12', 7, 125, 10, 3, 249.00),
(57, '2024-06-15', 3, 126, 10, 1, 2499.00),
(58, '2024-06-17', 19, 127, 10, 2, 399.00),
(59, '2024-06-20', 2, 128, 10, 1, 999.00),
(60, '2024-06-22', 11, 129, 10, 1, 2499.00),
-- Julio 2024
(61, '2024-07-01', 15, 130, 3, 1, 499.00),
(62, '2024-07-03', 8, 101, 3, 1, 399.00),
(63, '2024-07-05', 1, 102, 1, 2, 1199.00),
(64, '2024-07-08', 9, 103, 1, 1, 399.00),
(65, '2024-07-10', 6, 104, 3, 1, 549.00),
(66, '2024-07-12', 13, 105, 3, 3, 299.00),
(67, '2024-07-15', 17, 106, 1, 1, 1799.00),
(68, '2024-07-17', 2, 107, 3, 1, 999.00),
(69, '2024-07-20', 5, 108, 1, 1, 599.00),
(70, '2024-07-22', 20, 109, 2, 1, 1899.00),
-- Agosto 2024
(71, '2024-08-01', 3, 110, 1, 1, 2499.00),
(72, '2024-08-03', 14, 111, 5, 1, 499.00),
(73, '2024-08-05', 7, 112, 4, 4, 249.00),
(74, '2024-08-08', 1, 113, 5, 1, 1199.00),
(75, '2024-08-10', 12, 114, 4, 1, 2499.00),
(76, '2024-08-12', 4, 115, 6, 1, 1799.00),
(77, '2024-08-15', 16, 116, 7, 1, 1399.00),
(78, '2024-08-17', 2, 117, 6, 2, 999.00),
(79, '2024-08-20', 18, 118, 7, 2, 199.00),
(80, '2024-08-22', 10, 119, 10, 3, 159.00),
-- Septiembre 2024
(81, '2024-09-01', 15, 120, 10, 1, 499.00),
(82, '2024-09-03', 1, 121, 8, 1, 1199.00),
(83, '2024-09-05', 11, 122, 9, 1, 2499.00),
(84, '2024-09-08', 13, 123, 8, 2, 299.00),
(85, '2024-09-10', 3, 124, 9, 1, 2499.00),
(86, '2024-09-12', 7, 125, 10, 3, 249.00),
(87, '2024-09-15', 19, 126, 10, 1, 399.00),
(88, '2024-09-17', 2, 127, 10, 2, 999.00),
(89, '2024-09-20', 8, 128, 10, 1, 399.00),
(90, '2024-09-22', 5, 129, 10, 1, 599.00),
-- Octubre 2024 (datos recientes)
(91, '2024-10-01', 17, 130, 1, 1, 1799.00),
(92, '2024-10-03', 1, 101, 3, 1, 1199.00),
(93, '2024-10-05', 14, 102, 1, 1, 499.00),
(94, '2024-10-08', 4, 103, 1, 1, 1799.00),
(95, '2024-10-10', 9, 104, 3, 2, 399.00),
(96, '2024-10-12', 2, 105, 3, 1, 999.00),
(97, '2024-10-14', 7, 106, 1, 3, 249.00),
(98, '2024-10-15', 16, 107, 1, 1, 1399.00),
(99, '2024-10-16', 3, 108, 1, 1, 2499.00),
(100, '2024-10-17', 20, 109, 2, 1, 1899.00);

GO

-- =============================================
-- PARTE 3: CONSULTAS DE VERIFICACIÓN
-- =============================================

-- Verificar los datos cargados
SELECT 'Productos' AS Tabla, COUNT(*) AS Total FROM Fuente.Productos
UNION ALL
SELECT 'Clientes', COUNT(*) FROM Fuente.Clientes
UNION ALL
SELECT 'Tiendas', COUNT(*) FROM Fuente.Tiendas
UNION ALL
SELECT 'Ventas', COUNT(*) FROM Fuente.Ventas;

-- Ver distribución de ventas por mes
SELECT 
    YEAR(CAST(FechaVenta AS DATE)) AS Anio,
    MONTH(CAST(FechaVenta AS DATE)) AS Mes,
    COUNT(*) AS TotalVentas
FROM Fuente.Ventas
GROUP BY YEAR(CAST(FechaVenta AS DATE)), MONTH(CAST(FechaVenta AS DATE))
ORDER BY Anio, Mes;

-- Ver ventas totales por producto
SELECT 
    p.NombreProducto,
    p.Categoria,
    COUNT(v.VentaID) AS NumeroVentas,
    SUM(v.Cantidad) AS UnidadesVendidas,
    SUM(v.Cantidad * v.PrecioUnitario) AS MontoTotal
FROM Fuente.Ventas v
INNER JOIN Fuente.Productos p ON v.ProductoID = p.ProductoID
GROUP BY p.NombreProducto, p.Categoria
ORDER BY MontoTotal DESC;

-- Ver ventas por país
SELECT 
    c.Pais,
    COUNT(v.VentaID) AS NumeroVentas,
    SUM(v.Cantidad * v.PrecioUnitario) AS MontoTotal
FROM Fuente.Ventas v
INNER JOIN Fuente.Clientes c ON v.ClienteID = c.ClienteID
GROUP BY c.Pais
ORDER BY MontoTotal DESC;

-- Ver ventas por tipo de tienda
SELECT 
    t.Tipo,
    COUNT(v.VentaID) AS NumeroVentas,
    SUM(v.Cantidad * v.PrecioUnitario) AS MontoTotal
FROM Fuente.Ventas v
INNER JOIN Fuente.Tiendas t ON v.TiendaID = t.TiendaID
GROUP BY t.Tipo
ORDER BY MontoTotal DESC;


IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Log')
BEGIN
    EXEC('CREATE SCHEMA Log');
END
GO

DROP TABLE IF EXISTS Log.ControlCargas;
CREATE TABLE Log.ControlCargas (
    LoteID INT IDENTITY PRIMARY KEY,
    Proceso VARCHAR(100) NOT NULL,        -- Nombre del paquete o flujo
    FechaInicio DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    FechaFin DATETIME2(0) NULL,
    Estado VARCHAR(20) NOT NULL DEFAULT 'EN_PROCESO', -- EN_PROCESO / OK / ERROR
    RegistrosInsertados INT DEFAULT 0,
    RegistrosActualizados INT DEFAULT 0,
    RegistrosRechazados INT DEFAULT 0,
    MensajeError VARCHAR(500) NULL
);

DROP TABLE IF EXISTS Log.Rechazos;
CREATE TABLE Log.Rechazos (
    RechazoID INT IDENTITY PRIMARY KEY,
    LoteID INT NOT NULL,
    TablaOrigen VARCHAR(100) NOT NULL,
    ClaveRegistro VARCHAR(100) NULL,
    Motivo VARCHAR(200) NOT NULL,
    DatosOriginales NVARCHAR(MAX) NULL,   -- JSON o concatenación de columnas
    FechaRegistro DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Rechazos_ControlCargas FOREIGN KEY (LoteID) REFERENCES Log.ControlCargas(LoteID)
);

DROP TABLE IF EXISTS Log.MetricasCarga;
CREATE TABLE Log.MetricasCarga (
    LoteID INT NOT NULL,
    TablaDestino VARCHAR(100) NOT NULL,
    RegistrosInsertados INT DEFAULT 0,
    RegistrosActualizados INT DEFAULT 0,
    RegistrosRechazados INT DEFAULT 0,
    FechaRegistro DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Metricas_ControlCargas FOREIGN KEY (LoteID) REFERENCES Log.ControlCargas(LoteID)
);

SELECT name, is_cdc_enabled FROM sys.databases WHERE name = 'DWH_TechStore';

EXEC sys.sp_cdc_enable_db;

-- =============================================
-- 1. Tablas STAGING (crudo)
-- =============================================
DROP TABLE IF EXISTS Staging.Ventas;
CREATE TABLE Staging.Ventas (
    VentaID        INT,
    FechaVenta     VARCHAR(50),
    ProductoID     INT,
    ClienteID      INT,
    TiendaID       INT,
    Cantidad       INT,
    PrecioUnitario DECIMAL(10,2),
    FechaCarga     DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);

DROP TABLE IF EXISTS Staging.Productos;
CREATE TABLE Staging.Productos (
    ProductoID     INT,
    NombreProducto VARCHAR(200),
    Categoria      VARCHAR(100),
    Marca          VARCHAR(100),
    PrecioLista    DECIMAL(10,2),
    FechaCarga     DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);

DROP TABLE IF EXISTS Staging.Clientes;
CREATE TABLE Staging.Clientes (
    ClienteID      INT,
    NombreCompleto VARCHAR(200),
    Email          VARCHAR(150),
    Ciudad         VARCHAR(100),
    Pais           VARCHAR(100),
    FechaCarga     DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);

DROP TABLE IF EXISTS Staging.Tiendas;
CREATE TABLE Staging.Tiendas (
    TiendaID       INT,
    NombreTienda   VARCHAR(200),
    Ciudad         VARCHAR(100),
    Pais           VARCHAR(100),
    Tipo           VARCHAR(50),
    FechaCarga     DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);


-- =============================================
-- 2. Tablas ODS (consolidado)
-- =============================================
DROP TABLE IF EXISTS ODS.Ventas;
CREATE TABLE ODS.Ventas (
    VentaID        INT        NOT NULL PRIMARY KEY,
    FechaVenta     DATE       NOT NULL,
    ProductoID     INT        NOT NULL,
    ClienteID      INT        NOT NULL,
    TiendaID       INT        NOT NULL,
    Cantidad       INT        NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    MontoTotal     DECIMAL(10,2) NOT NULL,
    FechaActualizacion DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);

DROP TABLE IF EXISTS ODS.Productos;
CREATE TABLE ODS.Productos (
    ProductoID     INT NOT NULL PRIMARY KEY,
    NombreProducto NVARCHAR(200) NOT NULL,
    Categoria      NVARCHAR(100) NOT NULL,
    Marca          NVARCHAR(100) NOT NULL,
    PrecioLista    DECIMAL(10,2) NOT NULL,
    FechaActualizacion DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);

DROP TABLE IF EXISTS ODS.Clientes;
CREATE TABLE ODS.Clientes (
    ClienteID      INT NOT NULL PRIMARY KEY,
    NombreCompleto NVARCHAR(200) NOT NULL,
    Email          NVARCHAR(150) NOT NULL, -- en minúsculas
    Ciudad         NVARCHAR(100) NOT NULL,
    Pais           VARCHAR(100) NOT NULL,
    FechaActualizacion DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);

DROP TABLE IF EXISTS ODS.Tiendas;
CREATE TABLE ODS.Tiendas (
    TiendaID       INT NOT NULL PRIMARY KEY,
    NombreTienda   NVARCHAR(200) NOT NULL,
    Ciudad         NVARCHAR(100) NOT NULL,
    Pais           NVARCHAR(100) NOT NULL,
    Tipo           NVARCHAR(50)  NOT NULL,
    FechaActualizacion DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE ODS.Clientes_Errores (
    ClienteID INT,
    NombreCompleto VARCHAR(200),
    Email VARCHAR(150),
    Ciudad VARCHAR(100),
    Pais VARCHAR(100),
    MotivoError VARCHAR(200),
    FechaError DATETIME DEFAULT GETDATE()
);

CREATE TABLE ODS.Ventas_Errores (
    VentaID        INT        NOT NULL PRIMARY KEY,
    FechaVenta     DATE       NOT NULL,
    ProductoID     INT        NOT NULL,
    ClienteID      INT        NOT NULL,
    TiendaID       INT        NOT NULL,
    Cantidad       INT        NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    MontoTotal     DECIMAL(10,2) NOT NULL,
    FechaActualizacion DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
    MotivoError VARCHAR(200),
    FechaError DATETIME DEFAULT GETDATE()
);

-- =============================================
-- 3. Tablas BDS (dimensional)
-- =============================================
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='BDS')     EXEC('CREATE SCHEMA BDS');

DROP TABLE IF EXISTS BDS.DimProducto;
CREATE TABLE BDS.DimProducto (
    ProductoKey    INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID     INT NOT NULL,
    NombreProducto VARCHAR(200) NOT NULL,
    Categoria      VARCHAR(100) NOT NULL,
    Marca          VARCHAR(100) NOT NULL,
    PrecioLista    DECIMAL(10,2) NOT NULL,
    FechaInicio    DATE NOT NULL,
    FechaFin       DATE NULL,
    EsActual       BIT NOT NULL
);
CREATE INDEX IX_DimProducto_BK ON BDS.DimProducto(ProductoID, EsActual);

DROP TABLE IF EXISTS BDS.DimCliente;
CREATE TABLE BDS.DimCliente (
    ClienteKey     INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID      INT NOT NULL,
    NombreCompleto VARCHAR(200) NOT NULL,
    Email          VARCHAR(150) NOT NULL,
    Ciudad         VARCHAR(100) NOT NULL,
    Pais           VARCHAR(100) NOT NULL,
    FechaInicio    DATE NOT NULL,
    FechaFin       DATE NULL,
    EsActual       BIT NOT NULL
);
CREATE INDEX IX_DimCliente_BK ON BDS.DimCliente(ClienteID, EsActual);

DROP TABLE IF EXISTS BDS.DimTienda;
CREATE TABLE BDS.DimTienda (
    TiendaKey      INT IDENTITY(1,1) PRIMARY KEY,
    TiendaID       INT NOT NULL,
    NombreTienda   VARCHAR(200) NOT NULL,
    Ciudad         VARCHAR(100) NOT NULL,
    Pais           VARCHAR(100) NOT NULL,
    Tipo           VARCHAR(50)  NOT NULL,
    FechaInicio    DATE NOT NULL,
    FechaFin       DATE NULL,
    EsActual       BIT NOT NULL
);
CREATE INDEX IX_DimTienda_BK ON BDS.DimTienda(TiendaID, EsActual);

DROP TABLE IF EXISTS BDS.DimTiempo;
CREATE TABLE BDS.DimTiempo (
    TiempoKey      INT NOT NULL PRIMARY KEY, -- YYYYMMDD
    Fecha          DATE NOT NULL,
    Anio           INT NOT NULL,
    Mes            INT NOT NULL,
    NombreMes      VARCHAR(20) NOT NULL,
    Trimestre      INT NOT NULL,
    Semana         INT NOT NULL,
    DiaSemana      INT NOT NULL,
    NombreDiaSemana VARCHAR(20) NOT NULL,
    EsFinDeSemana  BIT NOT NULL
);
CREATE INDEX IX_DimTiempo_AnoMes ON BDS.DimTiempo(Anio, Mes);

DROP TABLE IF EXISTS BDS.FactVentas;
CREATE TABLE BDS.FactVentas (
    VentaKey       BIGINT IDENTITY(1,1) PRIMARY KEY,
    TiempoKey      INT NOT NULL REFERENCES BDS.DimTiempo(TiempoKey),
    ProductoKey    INT NOT NULL REFERENCES BDS.DimProducto(ProductoKey),
    ClienteKey     INT NOT NULL REFERENCES BDS.DimCliente(ClienteKey),
    TiendaKey      INT NOT NULL REFERENCES BDS.DimTienda(TiendaKey),
    Cantidad       INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    MontoTotal     DECIMAL(10,2) NOT NULL,
    FechaCarga     DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);
-- Columnstore para analítica
CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactVentas ON BDS.FactVentas;
GO


-- Declarar variables de rango
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
    TiempoKey, Fecha, Anio, Mes, NombreMes, Trimestre, Dia, NombreDia, SemanaAnio, EsFinDeSemana
)
SELECT 
    CONVERT(INT, FORMAT(Fecha,'yyyyMMdd')) AS TiempoKey,
    Fecha,
    YEAR(Fecha) AS Anio,
    MONTH(Fecha) AS Mes,
    DATENAME(MONTH, Fecha) AS NombreMes,
    DATEPART(QUARTER, Fecha) AS Trimestre,
    DAY(Fecha) AS Dia,
    DATENAME(WEEKDAY, Fecha) AS NombreDia,
    DATEPART(WEEK, Fecha) AS SemanaAnio,
    CASE WHEN DATENAME(WEEKDAY, Fecha) IN ('Saturday','Sunday','Sábado','Domingo') THEN 1 ELSE 0 END AS EsFinDeSemana
FROM CTE
OPTION (MAXRECURSION 0);




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



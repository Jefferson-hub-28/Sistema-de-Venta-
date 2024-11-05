-- Tabla de Usuarios: almacena la información de los usuarios que pueden acceder al sistema.
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada usuario.
    Nombre NVARCHAR(100) NOT NULL, -- Nombre completo del usuario.
    Correo NVARCHAR(100) UNIQUE NOT NULL, -- Correo electrónico único para identificar al usuario.
    Contrasena NVARCHAR(100) NOT NULL, -- Contraseña de acceso al sistema.
    Rol NVARCHAR(50) NOT NULL, -- Rol del usuario (Ej.: 'Administrador', 'Vendedor').
    FechaCreacion DATETIME DEFAULT GETDATE() -- Fecha de creación del registro.
);

-- Tabla de Proveedores: almacena los datos de los proveedores de productos.
CREATE TABLE Proveedores (
    ProveedorID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada proveedor.
    Nombre NVARCHAR(100) NOT NULL, -- Nombre del proveedor.
    Direccion NVARCHAR(200), -- Dirección del proveedor.
    Telefono NVARCHAR(15), -- Teléfono de contacto del proveedor.
    Correo NVARCHAR(100) UNIQUE, -- Correo electrónico único del proveedor.
    FechaRegistro DATETIME DEFAULT GETDATE() -- Fecha en que se registra el proveedor en el sistema.
);

-- Tabla de Clientes: almacena los datos de los clientes que realizan compras.
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada cliente.
    Nombre NVARCHAR(100) NOT NULL, -- Nombre del cliente.
    Direccion NVARCHAR(200), -- Dirección del cliente.
    Telefono NVARCHAR(15), -- Teléfono de contacto del cliente.
    Correo NVARCHAR(100) UNIQUE, -- Correo electrónico único del cliente.
    FechaRegistro DATETIME DEFAULT GETDATE() -- Fecha en que se registra el cliente en el sistema.
);

-- Tabla de Inventario: almacena los productos disponibles en el inventario.
CREATE TABLE Inventario (
    ProductoID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada producto.
    Nombre NVARCHAR(100) NOT NULL, -- Nombre del producto.
    Descripcion NVARCHAR(255), -- Descripción del producto.
    PrecioCosto DECIMAL(18, 2) NOT NULL, -- Precio de costo del producto.
    PrecioVenta DECIMAL(18, 2) NOT NULL, -- Precio de venta al cliente.
    StockActual INT DEFAULT 0, -- Cantidad actual en el inventario.
    StockMinimo INT DEFAULT 0, -- Cantidad mínima requerida para evitar desabastecimiento.
    FechaIngreso DATETIME DEFAULT GETDATE() -- Fecha en que el producto ingresa al inventario.
);

-- Tabla de Compras: registra las compras realizadas a proveedores.
CREATE TABLE Compras (
    CompraID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada compra.
    ProveedorID INT FOREIGN KEY REFERENCES Proveedores(ProveedorID), -- Relación con el proveedor.
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID), -- Relación con el usuario que realiza la compra.
    FechaCompra DATETIME DEFAULT GETDATE(), -- Fecha de la compra.
    TotalCompra DECIMAL(18, 2) NOT NULL, -- Monto total de la compra.
    TipoPago NVARCHAR(50) NOT NULL, -- Tipo de pago (Ej.: 'Contado', 'Crédito').
    Estado NVARCHAR(50) DEFAULT 'Pendiente' -- Estado de la compra (Ej.: 'Pendiente', 'Pagado').
);

-- Tabla de DetalleCompras: detalle de los productos comprados en cada compra.
CREATE TABLE DetalleCompras (
    DetalleCompraID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada detalle de compra.
    CompraID INT FOREIGN KEY REFERENCES Compras(CompraID) ON DELETE CASCADE, -- Relación con la compra.
    ProductoID INT FOREIGN KEY REFERENCES Inventario(ProductoID), -- Relación con el producto comprado.
    Cantidad INT NOT NULL, -- Cantidad de producto comprado.
    PrecioUnitario DECIMAL(18, 2) NOT NULL, -- Precio unitario de cada producto.
    Subtotal AS (Cantidad * PrecioUnitario) -- Subtotal calculado automáticamente.
);

-- Tabla de Ventas: registra las ventas realizadas a los clientes.
CREATE TABLE Ventas (
    VentaID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada venta.
    ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID), -- Relación con el cliente.
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID), -- Relación con el usuario que realiza la venta.
    FechaVenta DATETIME DEFAULT GETDATE(), -- Fecha de la venta.
    TotalVenta DECIMAL(18, 2) NOT NULL, -- Monto total de la venta.
    Descuento DECIMAL(5, 2) DEFAULT 0.00, -- Porcentaje de descuento aplicado.
    TipoPago NVARCHAR(50) NOT NULL, -- Tipo de pago (Ej.: 'Contado', 'Crédito').
    Estado NVARCHAR(50) DEFAULT 'Pendiente' -- Estado de la venta (Ej.: 'Pendiente', 'Pagado').
);

-- Tabla de DetalleVentas: detalle de los productos vendidos en cada venta.
CREATE TABLE DetalleVentas (
    DetalleVentaID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada detalle de venta.
    VentaID INT FOREIGN KEY REFERENCES Ventas(VentaID) ON DELETE CASCADE, -- Relación con la venta.
    ProductoID INT FOREIGN KEY REFERENCES Inventario(ProductoID), -- Relación con el producto vendido.
    Cantidad INT NOT NULL, -- Cantidad de producto vendido.
    PrecioUnitario DECIMAL(18, 2) NOT NULL, -- Precio unitario de cada producto.
    Subtotal AS (Cantidad * PrecioUnitario) -- Subtotal calculado automáticamente.
);

-- Tabla de CuentasPorPagar: gestiona las cuentas pendientes de las compras a crédito.
CREATE TABLE CuentasPorPagar (
    CuentaPagarID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada cuenta por pagar.
    ProveedorID INT FOREIGN KEY REFERENCES Proveedores(ProveedorID), -- Relación con el proveedor.
    CompraID INT FOREIGN KEY REFERENCES Compras(CompraID), -- Relación con la compra a crédito.
    Monto DECIMAL(18, 2) NOT NULL, -- Monto pendiente de pago.
    FechaEmision DATETIME DEFAULT GETDATE(), -- Fecha de emisión de la cuenta.
    FechaVencimiento DATETIME NOT NULL, -- Fecha límite para el pago.
    Estado NVARCHAR(50) DEFAULT 'Pendiente' -- Estado de la cuenta (Ej.: 'Pendiente', 'Pagado').
);

-- Tabla de CuentasPorCobrar: gestiona las cuentas pendientes de las ventas a crédito.
CREATE TABLE CuentasPorCobrar (
    CuentaCobrarID INT PRIMARY KEY IDENTITY(1,1), -- Identificador único para cada cuenta por cobrar.
    ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID), -- Relación con el cliente.
    VentaID INT FOREIGN KEY REFERENCES Ventas(VentaID), -- Relación con la venta a crédito.
    Monto DECIMAL(18, 2) NOT NULL, -- Monto pendiente de cobro.
    FechaEmision DATETIME DEFAULT GETDATE(), -- Fecha de emisión de la cuenta.
    FechaVencimiento DATETIME NOT NULL, -- Fecha límite para el cobro.
    Estado NVARCHAR(50) DEFAULT 'Pendiente' -- Estado de la cuenta (Ej.: 'Pendiente', 'Pagado').
);

-- Trigger para actualizar el inventario al realizar una compra.
CREATE TRIGGER tr_AfterInsertDetalleCompras
ON DetalleCompras
AFTER INSERT
AS
BEGIN
    -- Incrementa el stock actual del producto en el inventario según la cantidad comprada.
    UPDATE Inventario
    SET StockActual = StockActual + i.Cantidad
    FROM Inventario inv
    INNER JOIN inserted i ON inv.ProductoID = i.ProductoID
END;

-- Trigger para actualizar el inventario al realizar una venta, evitando stock negativo.
CREATE TRIGGER tr_AfterInsertDetalleVentas
ON DetalleVentas
AFTER INSERT
AS
BEGIN
    -- Decrementa el stock actual del producto si es suficiente, manteniéndolo en cero si no es suficiente.
    UPDATE Inventario
    SET StockActual = CASE 
        WHEN StockActual >= i.Cantidad THEN StockActual - i.Cantidad
        ELSE StockActual 
    END
    FROM Inventario inv
    INNER JOIN inserted i ON inv.ProductoID = i.ProductoID;
END;

-- Trigger para crear automáticamente una cuenta por pagar cuando una compra es a crédito.
CREATE TRIGGER tr_AfterInsertCompras
ON Compras
AFTER INSERT
AS
BEGIN
    INSERT INTO CuentasPorPagar (ProveedorID, CompraID, Monto, FechaEmision, FechaVencimiento, Estado)
    SELECT 
        ProveedorID, 
        CompraID, 
        TotalCompra, 
        GETDATE(), 
        DATEADD(DAY, 30, GETDATE()), 
        'Pendiente'
    FROM inserted
    WHERE TipoPago = 'Crédito';
END;

-- Trigger para crear automáticamente una cuenta por cobrar cuando una venta es a crédito.
CREATE TRIGGER tr_AfterInsertVentas
ON Ventas
AFTER INSERT
AS
BEGIN
    INSERT INTO CuentasPorCobrar (ClienteID, VentaID, Monto, FechaEmision, FechaVencimiento, Estado)
    SELECT 
        ClienteID, 
        VentaID, 
        TotalVenta, 
        GETDATE(), 
        DATEADD(DAY, 30, GETDATE()), 
        'Pendiente'
    FROM inserted
    WHERE TipoPago = 'Crédito';
END;

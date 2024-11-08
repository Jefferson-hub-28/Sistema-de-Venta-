-- Tabla de Usuarios: almacena la informaci�n de los usuarios que pueden acceder al sistema.
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada usuario.
    Nombre NVARCHAR(100) NOT NULL, -- Nombre completo del usuario.
    Correo NVARCHAR(100) UNIQUE NOT NULL, -- Correo electr�nico �nico para identificar al usuario.
    Contrasena NVARCHAR(100) NOT NULL, -- Contrase�a de acceso al sistema.
    Rol NVARCHAR(50) NOT NULL, -- Rol del usuario (Ej.: 'Administrador', 'Vendedor').
    FechaCreacion DATETIME DEFAULT GETDATE() -- Fecha de creaci�n del registro.
);

-- Tabla de Proveedores: almacena los datos de los proveedores de productos.
CREATE TABLE Proveedores (
    ProveedorID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada proveedor.
    Nombre NVARCHAR(100) NOT NULL, -- Nombre del proveedor.
    Direccion NVARCHAR(200), -- Direcci�n del proveedor.
    Telefono NVARCHAR(15), -- Tel�fono de contacto del proveedor.
    Correo NVARCHAR(100) UNIQUE, -- Correo electr�nico �nico del proveedor.
    FechaRegistro DATETIME DEFAULT GETDATE() -- Fecha en que se registra el proveedor en el sistema.
);

-- Tabla de Clientes: almacena los datos de los clientes que realizan compras.
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada cliente.
    Nombre NVARCHAR(100) NOT NULL, -- Nombre del cliente.
    Direccion NVARCHAR(200), -- Direcci�n del cliente.
    Telefono NVARCHAR(15), -- Tel�fono de contacto del cliente.
    Correo NVARCHAR(100) UNIQUE, -- Correo electr�nico �nico del cliente.
    FechaRegistro DATETIME DEFAULT GETDATE() -- Fecha en que se registra el cliente en el sistema.
);

-- Tabla de Inventario: almacena los productos disponibles en el inventario.
CREATE TABLE Inventario (
    ProductoID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada producto.
    Nombre NVARCHAR(100) NOT NULL, -- Nombre del producto.
    Descripcion NVARCHAR(255), -- Descripci�n del producto.
    PrecioCosto DECIMAL(18, 2) NOT NULL, -- Precio de costo del producto.
    PrecioVenta DECIMAL(18, 2) NOT NULL, -- Precio de venta al cliente.
    StockActual INT DEFAULT 0, -- Cantidad actual en el inventario.
    StockMinimo INT DEFAULT 0, -- Cantidad m�nima requerida para evitar desabastecimiento.
    FechaIngreso DATETIME DEFAULT GETDATE() -- Fecha en que el producto ingresa al inventario.
);

-- Tabla de Compras: registra las compras realizadas a proveedores.
CREATE TABLE Compras (
    CompraID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada compra.
    ProveedorID INT FOREIGN KEY REFERENCES Proveedores(ProveedorID), -- Relaci�n con el proveedor.
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID), -- Relaci�n con el usuario que realiza la compra.
    FechaCompra DATETIME DEFAULT GETDATE(), -- Fecha de la compra.
    TotalCompra DECIMAL(18, 2) NOT NULL, -- Monto total de la compra.
    TipoPago NVARCHAR(50) NOT NULL, -- Tipo de pago (Ej.: 'Contado', 'Cr�dito').
    Estado NVARCHAR(50) DEFAULT 'Pendiente' -- Estado de la compra (Ej.: 'Pendiente', 'Pagado').
);

-- Tabla de DetalleCompras: detalle de los productos comprados en cada compra.
CREATE TABLE DetalleCompras (
    DetalleCompraID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada detalle de compra.
    CompraID INT FOREIGN KEY REFERENCES Compras(CompraID) ON DELETE CASCADE, -- Relaci�n con la compra.
    ProductoID INT FOREIGN KEY REFERENCES Inventario(ProductoID), -- Relaci�n con el producto comprado.
    Cantidad INT NOT NULL, -- Cantidad de producto comprado.
    PrecioUnitario DECIMAL(18, 2) NOT NULL, -- Precio unitario de cada producto.
    Subtotal AS (Cantidad * PrecioUnitario) -- Subtotal calculado autom�ticamente.
);

-- Tabla de Ventas: registra las ventas realizadas a los clientes.
CREATE TABLE Ventas (
    VentaID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada venta.
    ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID), -- Relaci�n con el cliente.
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID), -- Relaci�n con el usuario que realiza la venta.
    FechaVenta DATETIME DEFAULT GETDATE(), -- Fecha de la venta.
    TotalVenta DECIMAL(18, 2) NOT NULL, -- Monto total de la venta.
    Descuento DECIMAL(5, 2) DEFAULT 0.00, -- Porcentaje de descuento aplicado.
    TipoPago NVARCHAR(50) NOT NULL, -- Tipo de pago (Ej.: 'Contado', 'Cr�dito').
    Estado NVARCHAR(50) DEFAULT 'Pendiente' -- Estado de la venta (Ej.: 'Pendiente', 'Pagado').
);

-- Tabla de DetalleVentas: detalle de los productos vendidos en cada venta.
CREATE TABLE DetalleVentas (
    DetalleVentaID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada detalle de venta.
    VentaID INT FOREIGN KEY REFERENCES Ventas(VentaID) ON DELETE CASCADE, -- Relaci�n con la venta.
    ProductoID INT FOREIGN KEY REFERENCES Inventario(ProductoID), -- Relaci�n con el producto vendido.
    Cantidad INT NOT NULL, -- Cantidad de producto vendido.
    PrecioUnitario DECIMAL(18, 2) NOT NULL, -- Precio unitario de cada producto.
    Subtotal AS (Cantidad * PrecioUnitario) -- Subtotal calculado autom�ticamente.
);

-- Tabla de CuentasPorPagar: gestiona las cuentas pendientes de las compras a cr�dito.
CREATE TABLE CuentasPorPagar (
    CuentaPagarID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada cuenta por pagar.
    ProveedorID INT FOREIGN KEY REFERENCES Proveedores(ProveedorID), -- Relaci�n con el proveedor.
    CompraID INT FOREIGN KEY REFERENCES Compras(CompraID), -- Relaci�n con la compra a cr�dito.
    Monto DECIMAL(18, 2) NOT NULL, -- Monto pendiente de pago.
    FechaEmision DATETIME DEFAULT GETDATE(), -- Fecha de emisi�n de la cuenta.
    FechaVencimiento DATETIME NOT NULL, -- Fecha l�mite para el pago.
    Estado NVARCHAR(50) DEFAULT 'Pendiente' -- Estado de la cuenta (Ej.: 'Pendiente', 'Pagado').
);

-- Tabla de CuentasPorCobrar: gestiona las cuentas pendientes de las ventas a cr�dito.
CREATE TABLE CuentasPorCobrar (
    CuentaCobrarID INT PRIMARY KEY IDENTITY(1,1), -- Identificador �nico para cada cuenta por cobrar.
    ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID), -- Relaci�n con el cliente.
    VentaID INT FOREIGN KEY REFERENCES Ventas(VentaID), -- Relaci�n con la venta a cr�dito.
    Monto DECIMAL(18, 2) NOT NULL, -- Monto pendiente de cobro.
    FechaEmision DATETIME DEFAULT GETDATE(), -- Fecha de emisi�n de la cuenta.
    FechaVencimiento DATETIME NOT NULL, -- Fecha l�mite para el cobro.
    Estado NVARCHAR(50) DEFAULT 'Pendiente' -- Estado de la cuenta (Ej.: 'Pendiente', 'Pagado').
);

-- Trigger para actualizar el inventario al realizar una compra.
CREATE TRIGGER tr_AfterInsertDetalleCompras
ON DetalleCompras
AFTER INSERT
AS
BEGIN
    -- Incrementa el stock actual del producto en el inventario seg�n la cantidad comprada.
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
    -- Decrementa el stock actual del producto si es suficiente, manteni�ndolo en cero si no es suficiente.
    UPDATE Inventario
    SET StockActual = CASE 
        WHEN StockActual >= i.Cantidad THEN StockActual - i.Cantidad
        ELSE StockActual 
    END
    FROM Inventario inv
    INNER JOIN inserted i ON inv.ProductoID = i.ProductoID;
END;

-- Trigger para crear autom�ticamente una cuenta por pagar cuando una compra es a cr�dito.
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
    WHERE TipoPago = 'Cr�dito';
END;

-- Trigger para crear autom�ticamente una cuenta por cobrar cuando una venta es a cr�dito.
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
    WHERE TipoPago = 'Cr�dito';
END;

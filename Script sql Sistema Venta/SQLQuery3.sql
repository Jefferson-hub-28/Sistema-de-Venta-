-- Insertar usuarios
INSERT INTO Usuarios (Nombre, Correo, Contrasena, Rol)
VALUES 
('Juan Pérez', 'juan.perez@ejemplo.com', 'contraseña123', 'Administrador'),
('Ana Gómez', 'ana.gomez@ejemplo.com', 'secreta123', 'Vendedor');

-- Insertar proveedores
INSERT INTO Proveedores (Nombre, Direccion, Telefono, Correo)
VALUES 
('Proveedor A', 'Calle Ficticia 123', '123456789', 'proveedorA@ejemplo.com'),
('Proveedor B', 'Avenida Siempre Viva 456', '987654321', 'proveedorB@ejemplo.com');

-- Insertar clientes
INSERT INTO Clientes (Nombre, Direccion, Telefono, Correo)
VALUES 
('Carlos López', 'Calle Principal 789', '555123456', 'carlos.lopez@cliente.com'),
('Marta Ruiz', 'Calle Secundaria 234', '555987654', 'marta.ruiz@cliente.com');

-- Insertar productos en inventario
INSERT INTO Inventario (Nombre, Descripcion, PrecioCosto, PrecioVenta, StockActual, StockMinimo)
VALUES 
('Producto A', 'Descripción del Producto A', 50.00, 80.00, 100, 10),
('Producto B', 'Descripción del Producto B', 30.00, 60.00, 50, 5);

-- Realizar una compra a Proveedor A, por un monto total de 500.00, tipo de pago credito
INSERT INTO Compras (ProveedorID, UsuarioID, TotalCompra, TipoPago, Estado)
VALUES (1, 1, 500.00, 'Crédito', 'Pendiente');

-- Insertar detalle de la compra (10 unidades de Producto A y 20 unidades de Producto B)
INSERT INTO DetalleCompras (CompraID, ProductoID, Cantidad, PrecioUnitario)
VALUES 
(1, 1, 10, 50.00),
(1, 2, 20, 30.00);

-- Realizar una venta a Cliente Carlos López, por un monto total de 600.00, tipo de pago crédito
INSERT INTO Ventas (ClienteID, UsuarioID, TotalVenta, Descuento, TipoPago, Estado)
VALUES (1, 2, 600.00, 5.00, 'Crédito', 'Pendiente');

-- Insertar detalle de la venta (5 unidades de Producto A y 10 unidades de Producto B)
INSERT INTO DetalleVentas (VentaID, ProductoID, Cantidad, PrecioUnitario)
VALUES 
(1, 1, 5, 80.00),
(1, 2, 10, 60.00);

-- Consultar las cuentas por cobrar (debería mostrar la cuenta de la venta a crédito)
SELECT * FROM CuentasPorCobrar;

-- Consultar las cuentas por pagar (debería mostrar la cuenta de la compra a crédito)
SELECT * FROM CuentasPorPagar;

-- Actualizar el estado de la cuenta por pagar (simular que se pagó la compra)
UPDATE CuentasPorPagar
SET Estado = 'Pagado'
WHERE CuentaPagarID = 1;

-- Actualizar el estado de la cuenta por cobrar (simular que se cobró la venta)
UPDATE CuentasPorCobrar
SET Estado = 'Pagado'
WHERE CuentaCobrarID = 1;

-- Verificar inventario actualizado (debería reducir las existencias de los productos vendidos)
SELECT * FROM Inventario;

-- Verificar detalles de compras y ventas
SELECT * FROM DetalleCompras;
SELECT * FROM DetalleVentas;




SELECT * FROM Inventario;
SELECT * FROM Clientes;
SELECT * FROM Proveedores;
SELECT * FROM Usuarios;

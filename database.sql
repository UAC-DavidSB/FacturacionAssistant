CREATE DATABASE IF NOT EXISTS sistema_facturacion;
USE sistema_facturacion;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    precio_kg DECIMAL(10,2) NOT NULL DEFAULT 0,
    precio_unidad DECIMAL(10,2) NOT NULL DEFAULT 0,
    precio_libra DECIMAL(10,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS facturas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    forma_pago ENUM('efectivo', 'transferencia') NOT NULL DEFAULT 'efectivo',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE IF NOT EXISTS detalle_factura (
    id INT PRIMARY KEY AUTO_INCREMENT,
    factura_id INT,
    producto_id INT, -- Nota: Ya no es NOT NULL implícitamente
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    unidad_medida ENUM('KG', 'UND', 'LB') DEFAULT 'KG',
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (factura_id) REFERENCES facturas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS configuracion_impresion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_negocio VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    nit VARCHAR(50),
    pie_pagina TEXT,
    ancho_papel INT DEFAULT 80,
    font_size INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    logo_data LONGBLOB,
    logo_tipo VARCHAR(50),
    qr_data LONGBLOB,
    qr_tipo VARCHAR(50)
); 


INSERT INTO productos (codigo, nombre, precio_kg, precio_unidad, precio_libra) VALUES 
-- Carnes (Precios por peso, 0 en unidad)
('CAR-001', 'Lomo Fino de Res', 48.50, 0.00, 22.00),
('CAR-002', 'Pechuga de Pollo Entera', 18.20, 0.00, 8.30),
('CAR-003', 'Chuleta de Cerdo', 24.00, 0.00, 10.90),
('CAR-004', 'Molida Especial', 26.50, 0.00, 12.00),

-- Abarrotes y Envasados (Precios por unidad, 0 en peso)
('ABA-010', 'Arroz Costeño (Bolsa 5kg)', 0.00, 22.50, 0.00),
('ABA-011', 'Aceite Primor 1L', 0.00, 11.80, 0.00),
('ABA-012', 'Fideos Don Vittorio 500g', 0.00, 3.50, 0.00),
('ABA-013', 'Leche Gloria Tarro Azul', 0.00, 4.20, 0.00),
('BEB-020', 'Coca Cola 3 Litros', 0.00, 13.50, 0.00),
('LIM-030', 'Detergente Marsella 1kg', 0.00, 15.00, 0.00),

-- Verduras y Frutas (Precios por peso, a veces por unidad si es por atado)
('VER-100', 'Papa Amarilla', 5.50, 0.00, 2.50),
('VER-101', 'Cebolla Roja', 3.20, 0.00, 1.50),
('VER-102', 'Tomate Italiano', 4.00, 0.00, 1.80),
('FRU-200', 'Manzana Israel', 6.00, 0.00, 2.70),
('FRU-201', 'Plátano de Seda (Mano)', 4.50, 2.00, 2.10); -- Este tiene precio en varias unidades


INSERT INTO clientes (nombre, direccion, telefono) VALUES 
('Cliente Mostrador', NULL, NULL), -- Típico cliente genérico para ventas rápidas
('Juan Pérez', 'Av. Principal 123, Centro', '987654321'),
('María Rodríguez', 'Jr. Las Flores 456, Urb. San José', '912345678'),
('Restaurante El Buen Sabor', 'Calle Los Olivos 789', '01-4445555'),
('Bodega Don Lucho', 'Av. Arequipa 2020', '998877665'),
('Carlos Sánchez', 'Urb. Los Jardines Mz C Lt 4', '951753852'),
('Ana Martínez', NULL, '963258741'), -- Cliente sin dirección registrada
('Luis García', 'Pasaje Los Pinos 101', NULL); -- Cliente sin teléfono
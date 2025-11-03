BEGIN TRANSACTION;

-- 1. Crear la tabla STATUS (no depende de nadie)
CREATE TABLE IF NOT EXISTS status (
    id_status INTEGER PRIMARY KEY AUTOINCREMENT, -- Corregido a id_status
    status_name TEXT NOT NULL
);

-- 2. Crear la tabla ORDERS (no depende de nadie)
CREATE TABLE IF NOT EXISTS orders ( 
    id_order INTEGER PRIMARY KEY AUTOINCREMENT,
    total REAL NOT NULL DEFAULT 0.0 CHECK (total >= 0),
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP 
);

-- 3. Crear la tabla PRODUCTS (depende de STATUS)
CREATE TABLE IF NOT EXISTS products (
    id_product INTEGER PRIMARY KEY AUTOINCREMENT,
    id_status INTEGER NOT NULL DEFAULT 1,
    product_name TEXT NOT NULL,
    image_path TEXT,
    price REAL NOT NULL CHECK (price >= 0),
    category TEXT NOT NULL DEFAULT 'comida', -- ERROR CORREGIDO: Faltaba esta coma
    FOREIGN KEY (id_status) REFERENCES status (id_status) 
);

-- 4. Crear la tabla ORDER_ITEMS (depende de ORDERS y PRODUCTS)
CREATE TABLE IF NOT EXISTS order_items (
    id_order_item INTEGER PRIMARY KEY AUTOINCREMENT,
    id_order INTEGER NOT NULL,
    id_product INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price_at_order REAL NOT NULL,
    FOREIGN KEY (id_order) REFERENCES orders(id_order) ON DELETE CASCADE,
    FOREIGN KEY (id_product) REFERENCES products(id_product) ON DELETE RESTRICT,
    UNIQUE (id_order, id_product)
);


INSERT INTO "status" (status_name) VALUES 
    ("activo"),
    ("desactivado"), 
    ("sin stock");

INSERT INTO "products" ("id_product","product_name","image_path","price","category") VALUES (1,'Hamburguesa Clásica','assets/images/Hamburguesa.jpg',85.0,'comida'),
 (2,'Alitas de Pollo BBQ','assets/images/alitas_de_pollo.jpg',70.0,'comida'),
 (3,'Empanadas de Carne','assets/images/empanadas.jpg',50.0,'comida'),
 (4,'Papas a la Francesa','assets/images/papas_a_la_francesa.jpg',40.0,'comida'),
 (5,'Ensalada César','assets/images/ensalada.jpg',60.0,'comida'),
 (7,'Cerveza Corona','assets/images/cerveza.jpeg',45.0,'bebidas'),
 (8,'Cerveza Modelo','assets/images/cerveza.jpeg',42.0,'bebidas'),
 (9,'Cerveza Victoria','assets/images/cerveza.jpeg',40.0,'bebidas'),
 (10,'Jugo del Valle Naranja','assets/images/jugo.jpg',22.0,'bebidas'),
 (11,'Jugo del Valle Manzana','assets/images/jugo.jpg',22.0,'bebidas'),
 (12,'Pepsi 500ml','assets/images/refresco.jpg',28.0,'bebidas'),
 (13,'Coca Cola 500ml','assets/images/refresco.jpg',30.0,'bebidas'),
 (14,'Jarritos Limón','assets/images/refresco.jpg',25.0,'bebidas'),
 (15,'Jarritos Mandarina','assets/images/refresco.jpg',25.0,'bebidas'),
 (16,'Jarritos Tamarindo','assets/images/refresco.jpg',25.0,'bebidas');


INSERT INTO orders (total) VALUES (4000.00);
--Ahora vamos a aniadir todos los productos seleccionados para esta orden, recuerdan que deben sumar 4000 como total

INSERT INTO orders (total) VALUES (1500.00);

-- Asumiendo que el id_order de la orden de $4000.00 es 1.

-- Alitas de Pollo BBQ ($70.00 x 10 = $700.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 2, 10, 70.0);

-- Empanadas de Carne ($50.00 x 10 = $500.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 3, 10, 50.0);

-- Papas a la Francesa ($40.00 x 10 = $400.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 4, 10, 40.0);

-- Ensalada César ($60.00 x 10 = $600.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 5, 10, 60.0);

-- Cerveza Corona ($45.00 x 10 = $450.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 7, 10, 45.0);

-- Cerveza Modelo ($42.00 x 10 = $420.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 8, 10, 42.0);

-- Cerveza Victoria ($40.00 x 10 = $400.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 9, 10, 40.0);

-- Jugo del Valle Naranja ($22.00 x 1 = $22.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 10, 1, 22.0);

-- Jugo del Valle Manzana ($22.00 x 1 = $22.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 11, 1, 22.0);

-- Pepsi 500ml ($28.00 x 1 = $28.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 12, 1, 28.0);

-- Coca Cola 500ml ($30.00 x 1 = $30.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 13, 1, 30.0);

-- Jarritos Limón ($25.00 x 1 = $25.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 14, 1, 25.0);

-- Jarritos Mandarina ($25.00 x 1 = $25.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 15, 1, 25.0);

-- Jarritos Tamarindo ($25.00 x 1 = $25.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (1, 16, 1, 25.0);










--aqui termina orden 1 
-- Asumiendo que el id_order de la orden de $1500.00 es 2.

-- Alitas de Pollo BBQ ($70.00 x 10 = $700.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (2, 2, 10, 70.0);

-- Empanadas de Carne ($50.00 x 8 = $400.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (2, 3, 8, 50.0);

-- Papas a la Francesa ($40.00 x 5 = $200.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (2, 4, 5, 40.0);

-- Ensalada César ($60.00 x 3 = $180.00)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (2, 5, 3, 60.0);

-- Cerveza Corona (id_product 7, Cantidad 0. No lo incluiremos para mantener los 5 items de producto con cantidad > 0)
/* Si deseas incluir 5 productos con cantidad > 0 y sumar 1500, usaremos el producto id 7 con una cantidad de 4.
$1480.00 + (4 x $45.00) = $1660.00. 
Para mantenerlo en 5 items y cerca de $1500, vamos a usar esta combinación:
*/
-- Opción mejorada para acercar el total y mantener 5 ítems:
-- Sustituimos Cerveza Corona por Cerveza Modelo (id_product 8) con 4 unidades.
-- Total con: (70*10) + (50*8) + (40*5) + (60*3) + (42*4) = $700 + $400 + $200 + $180 + $168 = $1648.00 

-- Usaremos los 5 items originales (2, 3, 4, 5) y añadiremos el item 7 con cantidad 1 para mantener el total en $1,480.00 + $45.00 = $1,525.00 (muy cercano a $1,500)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (2, 7, 1, 45.0);



create VIEW ORDER_VIEW as 
SELECT  
	orders.id_order,
	orders.total,
	orders.order_date,
	sum(order_items.quantity) total_products
	--products.product_name
	from orders 
	JOIN order_items on
	orders.id_order = order_items.id_order
	JOIN products on
	order_items.id_product = products.id_product
	GROUP by 1, 2, 3;


CREATE INDEX idx_order_items_order ON order_items(id_order);
CREATE INDEX idx_order_items_product ON order_items(id_product);







COMMIT;

BEGIN TRANSACTION;
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

CREATE TABLE IF NOT EXISTS orders (
    id_order INTEGER PRIMARY KEY AUTOINCREMENT,
    total REAL NOT NULL DEFAULT 0.0 CHECK (total >= 0),
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP 
);
CREATE TABLE IF NOT EXISTS products (
    id_product INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name TEXT NOT NULL,
    image_path TEXT,
    price REAL NOT NULL CHECK (price >= 0),
    category TEXT NOT NULL DEFAULT 'comida'
); 
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
CREATE INDEX idx_order_items_order ON order_items(id_order);
CREATE INDEX idx_order_items_product ON order_items(id_product);
COMMIT;

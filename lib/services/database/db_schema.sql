-- Tabla de categorías
CREATE TABLE categories (
    id_category INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL UNIQUE
);

-- Tabla de productos
CREATE TABLE products (
    id_product INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name TEXT NOT NULL,
    image_path TEXT,
    price REAL NOT NULL CHECK (price >= 0),
    id_category INTEGER,
    FOREIGN KEY (id_category) REFERENCES categories(id_category) ON DELETE SET NULL
);

-- Tabla de órdenes
CREATE TABLE orders (
    id_order INTEGER PRIMARY KEY AUTOINCREMENT,
    total REAL NOT NULL DEFAULT 0.0 CHECK (total >= 0),
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de ingredientes extra
CREATE TABLE extra_ingredients (
    id_extra INTEGER PRIMARY KEY AUTOINCREMENT,
    extra_name TEXT NOT NULL,
    extra_price REAL NOT NULL CHECK (extra_price >= 0)
);

-- Tabla de items de orden
CREATE TABLE order_items (
    id_order_item INTEGER PRIMARY KEY AUTOINCREMENT,
    id_order INTEGER NOT NULL,
    id_product INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price_at_order REAL NOT NULL,
    FOREIGN KEY (id_order) REFERENCES orders(id_order) ON DELETE CASCADE,
    FOREIGN KEY (id_product) REFERENCES products(id_product) ON DELETE RESTRICT,
    UNIQUE (id_order, id_product)
);

-- Tabla de extras aplicados a items de orden
CREATE TABLE order_item_extras (
    id_order_item_extra INTEGER PRIMARY KEY AUTOINCREMENT,
    id_order_item INTEGER NOT NULL,
    id_extra INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price_at_order REAL NOT NULL,
    FOREIGN KEY (id_order_item) REFERENCES order_items(id_order_item) ON DELETE CASCADE,
    FOREIGN KEY (id_extra) REFERENCES extra_ingredients(id_extra) ON DELETE RESTRICT
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_products_category ON products(id_category);
CREATE INDEX idx_order_items_order ON order_items(id_order);
CREATE INDEX idx_order_items_product ON order_items(id_product);
CREATE INDEX idx_order_item_extras_item ON order_item_extras(id_order_item);
CREATE INDEX idx_order_item_extras_extra ON order_item_extras(id_extra);
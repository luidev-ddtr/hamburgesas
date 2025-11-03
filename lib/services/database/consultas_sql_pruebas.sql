<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="flutter_hamburgesas.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="100"/><column_width id="3" width="2611"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><table title="products" custom_title="0" dock_id="1" table="4,8:mainproducts"/><dock_state state="000000ff00000000fd00000001000000020000069f00000374fc0100000001fb000000160064006f0063006b00420072006f007700730065003101000000000000069f0000012f00ffffff0000026e0000000000000004000000040000000800000008fc00000000"/><default_encoding codec=""/><browse_table_settings><table schema="main" name="order_items" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_" freeze_columns="0"><sort/><column_widths><column index="1" value="102"/><column index="2" value="66"/><column index="3" value="82"/><column index="4" value="63"/><column index="5" value="140"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="orders" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_" freeze_columns="0"><sort/><column_widths><column index="1" value="64"/><column index="2" value="39"/><column index="3" value="81"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table><table schema="main" name="products" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_" freeze_columns="0"><sort/><column_widths><column index="1" value="79"/><column index="2" value="179"/><column index="3" value="296"/><column index="4" value="41"/><column index="5" value="66"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table></browse_table_settings></tab_browse><tab_sql><sql name="SQL 1*">create VIEW ORDER_VIEW as 
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
	GROUP by 1, 2, 3
	
	SELECT * FROM ORDER_VIEW
	
SELECT 
	product_name,
FROM products
WHERE id_product in 	
	(
	SELECT 	
		id_product
	from order_items
		WHERE id_order = 1
	)
GROUP by 
	
	
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

-- Cerveza Corona (id_product 7, Cantidad 0. No lo incluiremos para mantener los 5 items de producto con cantidad &gt; 0)
/* Si deseas incluir 5 productos con cantidad &gt; 0 y sumar 1500, usaremos el producto id 7 con una cantidad de 4.
$1480.00 + (4 x $45.00) = $1660.00. 
Para mantenerlo en 5 items y cerca de $1500, vamos a usar esta combinación:
*/
-- Opción mejorada para acercar el total y mantener 5 ítems:
-- Sustituimos Cerveza Corona por Cerveza Modelo (id_product 8) con 4 unidades.
-- Total con: (70*10) + (50*8) + (40*5) + (60*3) + (42*4) = $700 + $400 + $200 + $180 + $168 = $1648.00 

-- Usaremos los 5 items originales (2, 3, 4, 5) y añadiremos el item 7 con cantidad 1 para mantener el total en $1,480.00 + $45.00 = $1,525.00 (muy cercano a $1,500)
INSERT INTO order_items (id_order, id_product, quantity, unit_price_at_order) 
VALUES (2, 7, 1, 45.0);
</sql><current_tab id="0"/></tab_sql></sqlb_project>

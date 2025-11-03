import 'package:flutter_hamburgesas/models/order_item_model.dart';
import 'package:flutter_hamburgesas/models/order_model.dart';
import 'package:flutter_hamburgesas/models/view_order_model.dart';
import 'package:flutter_hamburgesas/models/order_detail_model.dart';
import 'package:flutter_hamburgesas/services/database/conexion.dart';
import 'package:sqflite/sqflite.dart';

/// Repositorio para gestionar las operaciones de la base de datos para las órdenes.
class OrderRepository {
  /// Obtiene una instancia de la base de datos.
  Future<Database> get _db async => await DatabaseService.instance.database;

  /// Inserta una nueva orden junto con sus artículos en la base de datos.
  ///
  /// Esta operación se realiza dentro de una transacción para garantizar la
  /// integridad de los datos. Si alguna de las inserciones falla, todos los
  /// cambios se revierten.
  ///
  /// [order]: El objeto Order principal que se va a insertar.
  /// [items]: Una lista de objetos OrderItem asociados a la orden.
  ///
  /// Devuelve el ID de la orden recién creada.
  Future<int> insertOrder(Order order, List<OrderItem> items) async {
    final db = await _db;

    // Usamos una transacción para asegurar que la orden y sus artículos se inserten
    // de forma atómica. O se inserta todo, o no se inserta nada.
    return await db.transaction((txn) async {
      // 1. Insertar la orden principal y obtener su ID.
      final orderId = await txn.insert('orders', order.toJson());

      // 2. Preparar y insertar cada uno de los artículos de la orden.
      final batch = txn.batch();
      for (final item in items) {
        // Creamos una copia del mapa del item y le asignamos el ID de la orden.
        final itemJson = item.toJson();
        itemJson['id_order'] = orderId;
        
        batch.insert('order_items', itemJson);
      }
      // 3. Ejecutar todas las inserciones de los artículos en un solo lote para mayor eficiencia.
      await batch.commit(noResult: true);
      // print("Se introdujeron todos los datos a la BD");
      // print("La informacion que se introdujo fue $order y $items");
      return orderId;
    });
  }

  /// Obtiene todas las órdenes de la base de datos, ordenadas por fecha descendente.
  /// Utiliza la vista `ORDER_VIEW` para obtener datos agregados.
  ///
  /// Devuelve una lista de objetos [DashboardOrder].
  Future<List<DashboardOrder>> getOrders() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'ORDER_VIEW',
    );

    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (i) => DashboardOrder.fromJson(maps[i]));
  }

  /// Obtiene los productos y cantidades para una orden específica.
  ///
  /// [orderId]: El ID de la orden de la cual se quieren obtener los detalles.
  ///
  /// Devuelve una lista de objetos [OrderDetail].
  Future<List<OrderDetail>> getOrderDetails(int orderId) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.product_name, oi.quantity 
      FROM order_items oi
      JOIN products p ON oi.id_product = p.id_product
      WHERE oi.id_order = ?
    ''', [orderId]);

    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (i) => OrderDetail.fromJson(maps[i]));
  }
}
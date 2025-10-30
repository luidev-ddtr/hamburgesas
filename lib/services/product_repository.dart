import 'package:flutter_hamburgesas/models/product_model.dart';
import 'package:flutter_hamburgesas/services/database/conexion.dart';
import 'package:sqflite/sqflite.dart';

/// Repositorio para gestionar las operaciones CRUD de la entidad Product.
///
/// Esta clase abstrae el acceso a la base de datos para los productos,
/// permitiendo que el resto de la aplicación interactúe con objetos `Product`
/// sin necesidad de conocer la implementación de la base de datos.
class ProductRepository {
  /// Obtiene una instancia de la base de datos.
  Future<Database> get _db async => await DatabaseService.instance.database;

  /// Inserta un nuevo producto en la base de datos.
  ///
  /// Convierte el objeto [Product] a un mapa usando `toJson()` y lo inserta.
  /// Devuelve el ID del producto recién insertado.
  Future<int> insertProduct(Product product) async {
    final db = await _db;
    // El método `insert` de sqflite espera un Map<String, dynamic>
    return await db.insert('products', product.toJson());
  }

  /// Obtiene todos los productos de la base de datos.
  ///
  /// Realiza una consulta a la tabla 'products' y convierte cada
  /// resultado (que es un mapa) en un objeto `Product` usando `fromJson()`.
  Future<List<Product>> getAllProducts() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('products');

    // Si no hay resultados, devuelve una lista vacía.
    if (maps.isEmpty) {
      return [];
    }

    // Convierte la lista de mapas en una lista de Productos.
    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  /// Actualiza un producto existente en la base de datos.
  ///
  /// Busca el producto por su `idProduct` y actualiza sus datos.
  Future<int> updateProduct(Product product) async {
    final db = await _db;
    return await db.update(
      'products',
      product.toJson(),
      where: 'idProduct = ?',
      whereArgs: [product.idProduct],
    );
  }

  /// Elimina un producto de la base de datos por su ID.
  Future<int> deleteProduct(int id) async {
    final db = await _db;
    return await db.delete(
      'products',
      where: 'idProduct = ?',
      whereArgs: [id],
    );
  }
}
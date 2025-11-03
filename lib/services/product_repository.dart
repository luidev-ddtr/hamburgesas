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


  /// Obtiene todos los productos de una categoría específica.
  ///
  /// Realiza una consulta a la tabla 'products' filtrando por el campo 'category'
  /// y convierte cada resultado en un objeto `Product`.
  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      // Especificamos las columnas para que coincidan con el modelo Product.
      columns: ['id_product', 'id_status', 'product_name', 'image_path', 'price'],
      where: 'category = ? AND id_status = 1',
      whereArgs: [category],
    );
 
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (i) => Product.fromJson(maps[i]));
  }

  /// Obtiene todos los productos de la base de datos, sin importar la categoría.
  Future<List<Product>> getAllProducts() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('products');

    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (i) => Product.fromJson(maps[i]));
  }

  /// Actualiza el estado de un producto a 'desactivado' (archivado).
  Future<int> archiveProduct(int productId) async {
    final db = await _db;
    return await db.update('products', {'id_status': 2}, where: 'id_product = ?', whereArgs: [productId]);
  }

  /// Actualiza el estado de un producto a 'activo'.
  Future<int> unarchiveProduct(int productId) async {
    final db = await _db;
    return await db.update('products', {'id_status': 1}, where: 'id_product = ?', whereArgs: [productId]);
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
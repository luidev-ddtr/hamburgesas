import 'package:flutter/foundation.dart';
import 'package:flutter_hamburgesas/models/product_model.dart';

/// Gestiona el estado del carrito de compras de la aplicación.
///
/// Utiliza `ChangeNotifier` para notificar a los widgets que lo escuchan
/// cuando la orden ha sido modificada.
class OrderService with ChangeNotifier {
  final List<Map<String, dynamic>> _order = [];

  /// Devuelve una copia no modificable de la lista de ítems de la orden.
  List<Map<String, dynamic>> get orderItems => List.unmodifiable(_order);

  /// Devuelve `true` si la orden está vacía.
  bool get isEmpty => _order.isEmpty;

  /// Añade un producto a la orden.
  void addToOrder(Product product) {
    final uniqueId = DateTime.now().millisecondsSinceEpoch;
    _order.add({
      'id': uniqueId,
      'id_product': product.idProduct,
      'name': product.productName,
      'price': product.price,
      'base_price': product.price,
      'quantity': 1,
      'extras': [],
      'notes': '',
    });
    // Notifica a los listeners que la orden ha cambiado.
    notifyListeners();
  }

  /// Actualiza un ítem existente en la orden.
  void updateOrderItem(Map<String, dynamic> updatedItem) {
    final index = _order.indexWhere((item) => item['id'] == updatedItem['id']);
    if (index != -1) {
      _order[index] = updatedItem;
      notifyListeners();
    }
  }

  /// Elimina un ítem de la orden por su ID único.
  void deleteOrderItem(int itemId) {
    _order.removeWhere((item) => item['id'] == itemId);
    notifyListeners();
  }

  /// Limpia completamente la orden.
  void clearOrder() {
    _order.clear();
    notifyListeners();
  }
}
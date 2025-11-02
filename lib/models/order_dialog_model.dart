class OrderItem {
  final int id;
  final String name;
  final double price;
  final double? basePrice;
  final int quantity;
  final List<String>? extras;
  final String? notes;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    this.basePrice,
    required this.quantity,
    this.extras,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'base_price': basePrice,
      'quantity': quantity,
      'extras': extras,
      'notes': notes,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as int,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      basePrice: (map['base_price'] as num?)?.toDouble(),
      quantity: (map['quantity'] as num).toInt(),
      extras: (map['extras'] as List<dynamic>?)?.cast<String>(),
      notes: map['notes'] as String?,
    );
  }
}

class OrderSummary {
  final List<OrderItem> items;
  final double subtotal;

  OrderSummary({required this.items, required this.subtotal});

  factory OrderSummary.fromItems(List<OrderItem> items) {
    final subtotal = items.fold(0.0, (sum, item) {
      return sum + (item.price * item.quantity);
    });
    
    return OrderSummary(items: items, subtotal: subtotal);
  }
}
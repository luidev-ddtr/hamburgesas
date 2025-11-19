import '../models/order_dialog_model.dart';

class OrderCalculatorService {
  static double calculateSubtotal(List<OrderItem> items) {
    return items.fold(0.0, (sum, item) {
      return sum + (item.price * item.quantity);
    });
  }

  static Map<String, List<OrderItem>> groupItemsByName(List<OrderItem> items) {
    final Map<String, List<OrderItem>> groupedItems = {};
    
    for (var item in items) {
      if (!groupedItems.containsKey(item.name)) {
        groupedItems[item.name] = [];
      }
      groupedItems[item.name]!.add(item);
    }
    
    return groupedItems;
  }

  static int calculateTotalQuantityForGroup(List<OrderItem> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  static String formatExtras(List<String>? extras) {
    if (extras == null || extras.isEmpty) return '';
    
    final formattedExtras = extras.map((e) => 
      e.replaceAll('_', ' ')
       .split(' ')
       .map((word) => word[0].toUpperCase() + word.substring(1))
       .join(' ')
    ).toList();
    
    return 'Extras: ${formattedExtras.join(', ')}';
  }

  static String formatNotes(String? notes) {
    return (notes?.isNotEmpty ?? false) ? 'Notas: "$notes"' : '';
  }
} 
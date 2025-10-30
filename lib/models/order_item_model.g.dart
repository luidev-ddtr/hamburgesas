// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
    idOrderItem: (json['id_order_item'] as num?)?.toInt(),
    idOrder: (json['id_order'] as num).toInt(),
    idProduct: (json['id_product'] as num).toInt(),
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    unitPriceAtOrder: (json['unit_price_at_order'] as num).toDouble(),
  );
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id_order_item': instance.idOrderItem,
      'id_order': instance.idOrder,
      'id_product': instance.idProduct,
      'quantity': instance.quantity,
      'unit_price_at_order': instance.unitPriceAtOrder,
    };
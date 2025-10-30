// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_extra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemExtra _$OrderItemExtraFromJson(Map<String, dynamic> json) =>
    OrderItemExtra(
      idOrderItemExtra: (json['id_order_item_extra'] as num?)?.toInt(),
      idOrderItem: (json['id_order_item'] as num).toInt(),
      idExtra: (json['id_extra'] as num).toInt(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPriceAtOrder: (json['unit_price_at_order'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemExtraToJson(OrderItemExtra instance) =>
    <String, dynamic>{
      'id_order_item_extra': instance.idOrderItemExtra,
      'id_order_item': instance.idOrderItem,
      'id_extra': instance.idExtra,
      'quantity': instance.quantity,
      'unit_price_at_order': instance.unitPriceAtOrder,
    };

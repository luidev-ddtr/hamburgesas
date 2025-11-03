// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  idOrder: (json['id_order'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toDouble() ?? 0.0,
  orderDate: DateTime.parse(json['order_date'] as String),
);


Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id_order': instance.idOrder,
  'total': instance.total,
  'order_date': instance.orderDate.toIso8601String(),
};

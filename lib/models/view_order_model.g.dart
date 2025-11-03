// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardOrder _$DashboardOrderFromJson(Map<String, dynamic> json) => DashboardOrder(
  idOrder: (json['id_order'] as num).toInt(),
  total: (json['total'] as num).toDouble(),
  orderDate: DateTime.parse(json['order_date'] as String),
  totalProducts: (json['total_products'] as num).toInt(),
);

Map<String, dynamic> _$DashboardOrderToJson(DashboardOrder instance) => <String, dynamic>{
  'id_order': instance.idOrder,
  'total': instance.total,
  'order_date': instance.orderDate.toIso8601String(),
  'total_products': instance.totalProducts,
};
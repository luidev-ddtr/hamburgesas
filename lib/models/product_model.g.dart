// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  idProduct: (json['id_product'] as num?)?.toInt(),
  productName: json['product_name'] as String,
  imagePath: json['image_path'] as String?,
  price: (json['price'] as num).toDouble()
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id_product': instance.idProduct,
  'product_name': instance.productName,
  'image_path': instance.imagePath,
  'price': instance.price
};

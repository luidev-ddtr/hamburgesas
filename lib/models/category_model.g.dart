// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  idCategory: (json['id_category'] as num?)?.toInt(),
  categoryName: json['category_name'] as String,
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id_category': instance.idCategory,
  'category_name': instance.categoryName,
};

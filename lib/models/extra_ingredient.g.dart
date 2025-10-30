// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtraIngredient _$ExtraIngredientFromJson(Map<String, dynamic> json) =>
    ExtraIngredient(
      idExtra: (json['id_extra'] as num?)?.toInt(),
      extraName: json['extra_name'] as String,
      extraPrice: (json['extra_price'] as num).toDouble(),
    );

Map<String, dynamic> _$ExtraIngredientToJson(ExtraIngredient instance) =>
    <String, dynamic>{
      'id_extra': instance.idExtra,
      'extra_name': instance.extraName,
      'extra_price': instance.extraPrice,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<_Product> {
  @override
  final typeId = 2;

  @override
  _Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _Product(
      id: fields[0] as String,
      title: fields[1] as String,
      price: (fields[2] as num).toDouble(),
      cost: (fields[3] as num).toDouble(),
      category: fields[4] as ProductCategory,
      imageUrl: fields[5] as String,
      isAvailable: fields[6] == null ? true : fields[6] as bool,
      customCategory: fields[7] == null ? '' : fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _Product obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.cost)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.isAvailable)
      ..writeByte(7)
      ..write(obj.customCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductCategoryAdapter extends TypeAdapter<ProductCategory> {
  @override
  final typeId = 1;

  @override
  ProductCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProductCategory.iceCream;
      case 1:
        return ProductCategory.vessel;
      case 2:
        return ProductCategory.topping;
      case 3:
        return ProductCategory.drink;
      case 4:
        return ProductCategory.other;
      default:
        return ProductCategory.iceCream;
    }
  }

  @override
  void write(BinaryWriter writer, ProductCategory obj) {
    switch (obj) {
      case ProductCategory.iceCream:
        writer.writeByte(0);
      case ProductCategory.vessel:
        writer.writeByte(1);
      case ProductCategory.topping:
        writer.writeByte(2);
      case ProductCategory.drink:
        writer.writeByte(3);
      case ProductCategory.other:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  cost: (json['cost'] as num).toDouble(),
  category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
  imageUrl: json['imageUrl'] as String,
  isAvailable: json['isAvailable'] as bool? ?? true,
  customCategory: json['customCategory'] as String? ?? '',
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'price': instance.price,
  'cost': instance.cost,
  'category': _$ProductCategoryEnumMap[instance.category]!,
  'imageUrl': instance.imageUrl,
  'isAvailable': instance.isAvailable,
  'customCategory': instance.customCategory,
};

const _$ProductCategoryEnumMap = {
  ProductCategory.iceCream: 'iceCream',
  ProductCategory.vessel: 'vessel',
  ProductCategory.topping: 'topping',
  ProductCategory.drink: 'drink',
  ProductCategory.other: 'other',
};

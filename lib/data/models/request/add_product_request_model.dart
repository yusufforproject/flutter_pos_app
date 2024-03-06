// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class AddProductRequestModel {
  final String name;
  final int price;
  final int stock;
  final String category;
  final int isBestSeller;
  final XFile image;
  AddProductRequestModel({
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.isBestSeller,
    required this.image,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'price': price.toString(),
      'stock': stock.toString(),
      'category': category,
      'isBestSeller': isBestSeller.toString(),
    };
  }
}

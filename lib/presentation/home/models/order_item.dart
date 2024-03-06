// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../data/models/response/product_response_model.dart';

class OrderItem {
  final Product product;
  int quantity;
  OrderItem({
    required this.product,
    required this.quantity,
  });
}

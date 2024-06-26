import 'package:ecommerce/data/models/product/product_model.dart';

class CartItemModel {
  ProductModel? product;
  int? quantity;
  String? sId;

  CartItemModel({
    this.quantity,
    this.sId,
    this.product,
  });

  CartItemModel.fromJson(Map<String, dynamic> json) {
  try {
    product = json["product"] != null ? ProductModel.fromJson(json["product"]) : null;
    quantity = json['quantity'];
    sId = json['_id'];
  } catch (e) {
    print("Error in CartItemModel.fromJson: $e");
    // Handle or debug further as needed
  }
}

Map<String, dynamic> toJson({
  bool objectMode = false,
}) {
  try {
    final Map<String, dynamic> data = {
      'quantity': quantity,
      '_id': sId,
    };

    if (product != null) {
      data['product'] = objectMode ? product!.toJson() : product!.sId;
    } else {
      data['product'] = null;
    }

    return data;
  } catch (e) {
    print("Error in CartItemModel.toJson: $e");
    // Handle or debug further as needed
    return {};
  }
}

}

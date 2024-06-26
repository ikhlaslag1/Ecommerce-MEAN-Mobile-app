import '../../data/models/cart/cart_item_model.dart';

class Calculations {

  static double cartTotal(List<CartItemModel> items) {
    double total = 0;

    for (var item in items) {
      // Check if product and quantity are not null
      if (item.product != null && item.quantity != null) {
        // Check if price is not null before calculating
        if (item.product!.price != null) {
          total += item.product!.price! * item.quantity!;
        }
      }
    }

    return total;
  }

}

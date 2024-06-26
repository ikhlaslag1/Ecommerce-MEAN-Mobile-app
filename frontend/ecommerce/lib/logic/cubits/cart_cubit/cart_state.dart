import 'package:ecommerce/data/models/cart/cart_item_model.dart';

abstract class CartState {
  final List<CartItemModel> items;

  CartState(this.items);
}

class CartInitialState extends CartState {
  CartInitialState() : super([]);
}

class CartLoadingState extends CartState {
  CartLoadingState(List<CartItemModel> items) : super(items);
}

class CartLoadedState extends CartState {
  CartLoadedState(List<CartItemModel> items) : super(items);
}

class CartErrorState extends CartState {
  final String message;

  CartErrorState(this.message, List<CartItemModel> items) : super(items);
}

import 'dart:async';

import 'package:ecommerce/data/models/cart/cart_item_model.dart';
import 'package:ecommerce/data/models/product/product_model.dart';
import 'package:ecommerce/data/repositories/cart_repository.dart';
import 'package:ecommerce/logic/cubits/cart_cubit/cart_state.dart';
import 'package:ecommerce/logic/cubits/user_cubit/user_cubit.dart';
import 'package:ecommerce/logic/cubits/user_cubit/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  final UserCubit _userCubit;
  StreamSubscription? _userSubscription;
  final CartRepository _cartRepository = CartRepository();

  CartCubit(this._userCubit) : super(CartInitialState()) {
    _handleUserState(_userCubit.state);
    _userSubscription = _userCubit.stream.listen(_handleUserState);
  }

  void _handleUserState(UserState userState) {
    if (userState is UserLoggedInState) {
      _initialize(userState.userModel.sId!);
    } else if (userState is UserLoggedOutState) {
      emit(CartInitialState());
    }
  }

  void sortAndLoad(List<CartItemModel> items) {
    items.sort((a, b) {
      if (a.product?.title != null && b.product?.title != null) {
        return b.product!.title!.compareTo(a.product!.title!);
      }
      return 0;
    });
    emit(CartLoadedState(items));
  }

  Future<void> _initialize(String userId) async {
    emit(CartLoadingState(state.items)); // Initial state before fetching
    try {
      final items = await _cartRepository.fetchCartForUser(userId);
      sortAndLoad(items);
    } catch (ex) {
      emit(CartErrorState(ex.toString(), state.items));
    }
  }

  Future<void> addToCart(ProductModel? product, int quantity) async {
    if (product == null) {
      emit(CartErrorState("Product cannot be null", state.items));
      return;
    }

    emit(CartLoadingState(state.items)); // Show loading state

    try {
      if (_userCubit.state is UserLoggedInState) {
        UserLoggedInState userState = _userCubit.state as UserLoggedInState;

        CartItemModel newItem = CartItemModel(
          product: product,
          quantity: quantity,
        );

        final items = await _cartRepository.addToCart(newItem, userState.userModel.sId!);
        sortAndLoad(items);
      } else {
        throw "User is not logged in!";
      }
    } catch (ex) {
      emit(CartErrorState(ex.toString(), state.items));
    }
  }

  Future<void> removeFromCart(ProductModel? product) async {
    if (product == null) {
      emit(CartErrorState("Product cannot be null", state.items));
      return;
    }

    emit(CartLoadingState(state.items)); // Show loading state

    try {
      if (_userCubit.state is UserLoggedInState) {
        UserLoggedInState userState = _userCubit.state as UserLoggedInState;

        final items = await _cartRepository.removeFromCart(product.sId!, userState.userModel.sId!);
        sortAndLoad(items);
      } else {
        throw "User is not logged in!";
      }
    } catch (ex) {
      emit(CartErrorState(ex.toString(), state.items));
    }
  }

  bool cartContains(ProductModel product) {
    return state.items.any((item) => item.product?.sId == product.sId);
  }

  void clearCart() {
    emit(CartLoadedState([]));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}

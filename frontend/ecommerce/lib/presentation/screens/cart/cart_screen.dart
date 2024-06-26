import 'package:ecommerce/core/ui.dart';
import 'package:ecommerce/data/models/cart/cart_item_model.dart';
import 'package:ecommerce/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:ecommerce/logic/cubits/cart_cubit/cart_state.dart';
import 'package:ecommerce/logic/services/calculations.dart';
import 'package:ecommerce/logic/services/formatter.dart';
import 'package:ecommerce/presentation/screens/order/order_detail_screen.dart';
import 'package:ecommerce/presentation/widgets/cart_list_view.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const routeName = "cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is CartErrorState) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is CartLoadedState) {
              if (state.items.isEmpty) {
                return const Center(
                  child: Text("Cart items will show up here.."),
                );
              } else {
                return _buildCartContent(state.items);
              }
            }

            return const Center(
              child: Text("Something went wrong."),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartContent(List<CartItemModel> items) {
    return Column(
      children: [
        Expanded(
          child: CartListView(items: items),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      items.isEmpty ? "No items" : "${items.length} items",
                      style: TextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Total: ${Formatter.formatPrice(Calculations.cartTotal(items))}",
                      style: TextStyles.heading3,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: CupertinoButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, OrderDetailScreen.routeName),
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width / 22),
                  color: AppColors.accent,
                  child: const Text("Place Order"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

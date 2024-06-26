import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/data/models/cart/cart_item_model.dart';
import 'package:ecommerce/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:ecommerce/logic/services/formatter.dart';
import 'package:ecommerce/presentation/widgets/link_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

class CartListView extends StatelessWidget {
  final List<CartItemModel> items;
  final bool shrinkWrap;
  final bool noScroll;

  const CartListView({super.key, required this.items, this.shrinkWrap = false, this.noScroll = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: (noScroll) ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final product = item.product;

        return ListTile(
          leading: CachedNetworkImage(
            width: 50,
            imageUrl: product?.images?.isNotEmpty == true ? product!.images![0] : "https://via.placeholder.com/150", // Placeholder image URL
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          title: Text(product?.title ?? "Product title not available"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product != null && product.price != null && item.quantity != null)
                Text(
                  "${Formatter.formatPrice(product.price!)} x ${item.quantity} = ${Formatter.formatPrice(product.price! * item.quantity!)}",
                ),
              LinkButton(
                onPressed: () {
                  if (product != null) {
                    BlocProvider.of<CartCubit>(context).removeFromCart(product);
                  }
                },
                text: "Delete",
                color: Colors.red,
              ),
            ],
          ),
          trailing: InputQty(
            maxVal: 99,
            initVal: item.quantity!,
            minVal: 1,
            messageBuilder: null,
            onQtyChanged: (value) {
              if (value == item.quantity) return;
              if (product != null) {
                BlocProvider.of<CartCubit>(context).addToCart(product, value as int);
              }
            },
          ),
        );
      },
    );
  }
}



import 'package:ecommerce/data/models/cart/cart_item_model.dart';
import 'package:equatable/equatable.dart';

import '../user/user_model.dart';

// ignore: must_be_immutable
class OrderModel extends Equatable {
   String? sId;
   UserModel? user;
   List<CartItemModel>? items;
   String? status;
   double? totalAmount;
   String? razorPayOrderId;
   DateTime? updatedOn;
   DateTime? createdOn;

   OrderModel({
     this.sId,
     this.user,
     this.items,
     this.status,
     this.totalAmount,
     this.razorPayOrderId,
     this.updatedOn,
     this.createdOn,
  });

   factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      sId: json['_id'],
      user: UserModel.fromJson(json["user"]),
      items: (json["items"] as List<dynamic>).map((item) => CartItemModel.fromJson(item)).toList(),
      status: json['status'],
      razorPayOrderId: json['razorPayOrderId'],
      totalAmount: double.tryParse(json['totalAmount'].toString()) ?? 0.0,
      updatedOn: DateTime.tryParse(json['updatedOn']) ?? DateTime.now(),
      createdOn: DateTime.tryParse(json['createdOn']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user?.toJson();
    data['items'] = items?.map((item) => item.toJson()).toList();
    data['status'] = status;
    data['razorPayOrderId'] = razorPayOrderId;
    data['totalAmount'] = totalAmount;
    data['updatedOn'] = updatedOn?.toIso8601String();
    data['createdOn'] = createdOn?.toIso8601String();
    return data;
  }

  @override
  List<Object?> get props => [ sId ];
}

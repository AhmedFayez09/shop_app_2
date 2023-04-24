import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_2/medical/logic/profile/profile_cubit.dart';
import 'package:shop_app_2/medical/presentation/models/medical_product_model.dart';
import 'package:shop_app_2/shared/styles/colors.dart';

class CartItemAsGrid extends StatefulWidget {
  CartItemAsGrid({Key? key, required this.product}) : super(key: key);
  MedicalProductModel product;

  @override
  State<CartItemAsGrid> createState() => _CartItemAsGridState();
}

class _CartItemAsGridState extends State<CartItemAsGrid> {
  final uID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(widget.product.imageUrl),
                    width: double.infinity,
                    height: 200,
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$ ${widget.product.price * widget.product.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: defaultColor,
                          ),
                        ),
                        Text(
                          widget.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(height: 1.3),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            int quantityAddFireStore = widget.product.quantity += 1;
                            int totalP = quantityAddFireStore * widget.product.price;
                            FirebaseFirestore.instance
                                .doc('Users/$uID/cart/${widget.product.id}')
                                .update({
                              'quantity': quantityAddFireStore,
                              'totalPrice': totalP
                            });
                            ProfileCubit.get(context).getTotalPrice(uID);
                            //     .then((value) {
                            //   setState(() {
                            //   totle = quantityAddFireStore * int.parse(product.price);
                            //
                            //   });
                            //   print(totle);
                            // });
                          },
                          icon: Icon(
                            Icons.add_circle_rounded,
                          ),
                        ),
                        Text(widget.product.quantity.toString()),
                        IconButton(
                          onPressed: () {
                            if (widget.product.quantity != 1) {
                              final quantitymunFireStore =
                                  widget.product.quantity -= 1;

                              int totalP = quantitymunFireStore * widget.product.price;
                              FirebaseFirestore.instance
                                  .doc('Users/$uID/cart/${widget.product.id}')
                                  .update({
                                'quantity': quantitymunFireStore,
                                'totalPrice': totalP
                              });
                            } else {
                              FirebaseFirestore.instance
                                  .doc('test/${widget.product.id}')
                                  .update({'inCart': false}).then((value) {
                                FirebaseFirestore.instance
                                    .doc('Users/$uID/cart/${widget.product.id}')
                                    .delete();
                              });
                            }
                            ProfileCubit.get(context).getTotalPrice(uID);
                          },
                          icon: Icon(
                            Icons.minimize_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

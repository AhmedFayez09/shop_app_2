import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_2/medical/logic/profile/profile_cubit.dart';
import 'package:shop_app_2/medical/logic/profile/profile_state.dart';
import 'package:shop_app_2/medical/presentation/models/add_to_cart_to_admin_model.dart';
import 'package:shop_app_2/medical/presentation/widgets/cart_widgets/cart_item.dart';
import 'package:shop_app_2/medical/presentation/models/medical_product_model.dart';
import 'package:shop_app_2/service/firestore.dart';
import 'package:shop_app_2/service/pop_up.dart';

class MedicalCartScreen extends StatefulWidget {
  const MedicalCartScreen({Key? key}) : super(key: key);

  @override
  State<MedicalCartScreen> createState() => _MedicalCartScreenState();
}

class _MedicalCartScreenState extends State<MedicalCartScreen> {
  final uID = FirebaseAuth.instance.currentUser!.uid;

  int total = 0;
  var adminKey = GlobalKey<FormState>();

  @override
  void initState() {
    ProfileCubit.get(context).getTotalPrice(uID);
    super.initState();
  }

  var addressController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder(
        stream: getProductFromFireStore('Users/$uID/cart'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong'));
          }
          List<MedicalProductModel> product =
              snapshot.data!.docs.map((e) => e.data()).toList();

          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Form(
                    key: adminKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: "name"),
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return "invalid Value";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(labelText: "address"),
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return "invalid Value";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: phoneNumberController,
                          decoration:
                              InputDecoration(labelText: "Phone Number"),
                              validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return "invalid Value";
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if(adminKey.currentState!.validate()){
                              AddToAllCartToAdmin model = AddToAllCartToAdmin(
                              listAddToCart: product,
                              name: nameController.text,
                              address: addressController.text,
                              phoneNumber: phoneNumberController.text,
                            );
                            addListProCartToAdmin(model, "modelToAddAdmin")
                                .then((value) async {
                              for (var doc in product) {
                                await FirebaseFirestore.instance
                                    .doc('test/${doc.id}')
                                    .update({'inCart': false});
                              }
                              var collection = FirebaseFirestore.instance
                                  .collection('Users/$uID/cart');
                              var snapshots = await collection.get();
                              for (var doc in snapshots.docs) {
                                await doc.reference.delete();
                              }
                              Navigator.pop(context);
                              flutterSnackBar(context: context, msg: "Success");
                            }).catchError((e) {
                              flutterSnackBar(
                                  context: context, msg: "Error is $e");
                            });
                            }
                          },
                          child: Text("Send to Admin"),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey,
              ),
              width: size.width * 0.8,
              child: Center(
                child: Text("Check out"),
              ),
            ),
          );
        },
      ),
      appBar: AppBar(title: const Text("Medical Cart Screen")),
      body: StreamBuilder<QuerySnapshot<MedicalProductModel>>(
        stream: getProductFromFireStore('Users/$uID/cart'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong'));
          }
          List<MedicalProductModel> product =
              snapshot.data!.docs.map((e) => e.data()).toList();
          for (var doc in product) {
            total += doc.totalPrice;
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.0,
                      childAspectRatio: 1 / 1.58,
                      mainAxisSpacing: 1.0,
                    ),
                    itemCount: product.length,
                    itemBuilder: (BuildContext context, int index) {
                      final productM = product[index];
                      return CartItemAsGrid(
                        product: productM,
                      );
                    }),
              ),
              // BlocBuilder<ProfileCubit, ProfileState>(
              //   builder: (context, state) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 20,
              //         vertical: 10,
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text('Total Amount'),
              //           if (state is ChangeTotalPriceSuccess)
              //             Text(state.total.toString(),
              //                 style: const TextStyle(fontSize: 18)),
              //           if (state is ChangeTotalPriceError)
              //             const Text('Error', style: TextStyle(fontSize: 18)),
              //           if (state is ChangeTotalPriceLoading)
              //             const Text('.......', style: TextStyle(fontSize: 18)),
              //         ],
              //       ),
              //     );
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount'),
                    Text(total.toString()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

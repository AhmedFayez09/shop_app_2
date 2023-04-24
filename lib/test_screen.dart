import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_2/layout/Shop_App/Cubit/cubit.dart';
import 'package:shop_app_2/medical/logic/profile/profile_cubit.dart';
import 'package:shop_app_2/medical/logic/profile/profile_state.dart';
import 'package:shop_app_2/medical/presentation/models/medical_product_model.dart';
import 'package:shop_app_2/medical/presentation/screens/medical_cart_screen.dart';
import 'package:shop_app_2/medical/presentation/screens/medical_fav_screen.dart';
import 'package:shop_app_2/service/firestore.dart';
import 'package:shop_app_2/shared/styles/colors.dart';

class TestScreen extends StatefulWidget {
  TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List listCarouse = [
    'https://azb4fstg-cdn-endpoint.azureedge.net/mediacontainer/medialibraries/smithersb4f/industries/life%20science/medical%20device/thumbnail/medical-device-testing-644x350.png?ext=.png',
    'https://www.shutterstock.com/image-photo/medical-products-equipment-260nw-166381400.jpg',
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg',
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg',
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg',
  ];

  final ref = FirebaseFirestore.instance;
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var profile = ProfileCubit.get(context);
        print("/////////////////*****************************///////////////");
        print(profile.userData);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => MedicalFavScreen()));
                },
                icon: const Icon(Icons.favorite),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => MedicalCartScreen()));
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ],
          ),
          body: Column(
            children: [
              CarouselSlider(
                items: List.generate(
                  listCarouse.length,
                  (index) => Image(
                    image: NetworkImage(listCarouse[index]),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                options: CarouselOptions(
                  height: 200,
                  initialPage: 0,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              StreamBuilder<QuerySnapshot<MedicalProductModel>>(
                stream: getProductFromFireStore('test'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something Went Wrong'),
                    );
                  }
                  List<MedicalProductModel> product =
                      snapshot.data!.docs.map((e) => e.data()).toList();

                  return Expanded(
                      child: SingleChildScrollView(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.0,
                      childAspectRatio: 1 / 1.70,
                      mainAxisSpacing: 1.0,
                      children: List.generate(
                          product.length,
                          (index) =>

                              //  buildGridProduct(
                              //   modelMedical: product[index],
                              //   context: context,
                              // ),
                              Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment:
                                          AlignmentDirectional.bottomStart,
                                      children: [
                                        Image(
                                          image: NetworkImage(
                                              product[index].imageUrl),
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(product[index].name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      height: 1.3)),
                                              IconButton(
                                                onPressed: () {
                                                  MedicalProductModel favModel =
                                                      MedicalProductModel(
                                                    id: product[index].id,
                                                    imageUrl:
                                                        product[index].imageUrl,
                                                    name: product[index].name,
                                                    price: product[index].price,
                                                    totalPrice:product[index].price ,
                                                    inCart: true,
                                                  );
                                                  ShopCubit.get(context)
                                                      .addTOCart(favModel)
                                                      .then((value) async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .doc(
                                                            'test/${product[index].id}')
                                                        .update(
                                                            {'inCart': true});
                                                    // final totlePrice = profile.userData != null ? profile.userData!.totalPrice : 0;
                                                    // final totle = totlePrice + int.parse(product[index].price);
                                                    // FirebaseFirestore.instance.doc('Users/$userId').
                                                    // update(
                                                    //   {
                                                    //     'totalPrice' : totle
                                                    //   }
                                                    // ).asStream();
                                                  });
                                                },
                                                icon: CircleAvatar(
                                                  backgroundColor:
                                                      product[index].inCart ==
                                                              true
                                                          ? defaultColor
                                                          : Colors.grey,
                                                  radius: 15.0,
                                                  child: const Icon(
                                                    Icons.add_shopping_cart,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '\$ ${product[index].price}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: defaultColor,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Spacer(),
                                              IconButton(
                                                alignment: AlignmentDirectional
                                                    .bottomEnd,
                                                onPressed: () {
                                                  MedicalProductModel favModel =
                                                      MedicalProductModel(
                                                    id: product[index].id,
                                                    imageUrl:
                                                        product[index].imageUrl,
                                                    name: product[index].name,
                                                    price: product[index].price,
                                                    totalPrice:product[index].price ,
                                                    inFavorites: true,
                                                  );
                                                  ShopCubit.get(context)
                                                      .addTOFav(favModel)
                                                      .then((value) async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .doc(
                                                            'test/${product[index].id}')
                                                        .update({
                                                      'inFavorites': true
                                                    });
                                                  });
                                                },
                                                icon: CircleAvatar(
                                                  radius: 15.0,
                                                  backgroundColor: product[
                                                                  index]
                                                              .inFavorites ==
                                                          true
                                                      ? defaultColor
                                                      : Colors.grey,
                                                  child: const Icon(
                                                    Icons.favorite_border,
                                                    size: 14.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

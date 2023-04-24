import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_2/layout/Shop_App/Cubit/cubit.dart';
import 'package:shop_app_2/layout/Shop_App/Cubit/status.dart';
import 'package:shop_app_2/models/Shop_App/categroies_model.dart';
import 'package:shop_app_2/models/Shop_App/home_model.dart';
import 'package:shop_app_2/medical/presentation/models/medical_product_model.dart';
import 'package:shop_app_2/service/firestore.dart';
import 'package:shop_app_2/shared/components/components.dart';
import 'package:shop_app_2/shared/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_2/test_screen.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List listMedicalCategorName = [
    'Beauty',
    'HomeHealthcare',
    'MamAndBaby',
    'MedicalTools',
    'Medication',
    'Vitamins',
  ];

  List listMedicalCaImages = [
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg',
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg',
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg',
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg',
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg',
    'https://www.shutterstock.com/image-photo/beautician-on-marble-background-makeup-260nw-1692212833.jpg'
  ];
  // getDate() async {
  //   FirebaseFirestore.instance.collection('Beauty').snapshots().listen((event) {
      
  //     event.docs.forEach((element) {
  //       log('${element.data()}');
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   getDate();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status!) {
            showToast(
              text: state.model.message!,
              state: ToastStates.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
            ShopCubit.get(context).homeModel,
            ShopCubit.get(context).categoriesModel,
            context,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel? model, CategoriesModel? categoriesModel, context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: model!.data!.banners!
                .map(
                  (e) => Image(
                    image: NetworkImage('${e.image}'),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
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
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => TestScreen()));
                  },
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  height: 100,
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategoriesItem(
                            img: listMedicalCaImages[index],
                            name: listMedicalCategorName[index],
                          ),
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      itemCount: listMedicalCaImages.length),
                ),
                SizedBox(height: 5.0),
                Text(
                  'New Products',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
//  Expanded(
//               child: StreamBuilder<QuerySnapshot<MedicalProductModel>>(
//                 stream: getProductFromFireStore('test'),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   if (snapshot.hasError) {
//                     return const Center(
//                       child: Text('Something Went Wrong'),
//                     );
//                   }
//                   List<MedicalProductModel> clients =
//                       snapshot.data!.docs.map((e) => e.data()).toList();
//                   return ListView.builder(
//                     itemCount: clients.length,
//                     itemBuilder: (context, index) {
//                      return buildGridProduct(modelMedical: clients[index]);
//                     },
//                   );
//                 },
//               ),
//             ),
          // Expanded(
          //   child: StreamBuilder<QuerySnapshot<MedicalProductModel>>(
          //     stream: getProductFromFireStore('test'),
          //     builder: (context, snapshot) {
          //       List<MedicalProductModel> listProduct = snapshot.data!.docs
          //           .map(
          //             (e) => e.data(),
          //           )
          //           .toList();
          //       // log(' *******************************${snapshot.data} *******************************');
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         log('${listProduct}');
          //         return ListView.builder(
          //           itemBuilder: (context, index) {
          //             return buildGridProduct(modelMedical: listProduct[index]);
          //           },
          //           // separatorBuilder: (context, index) =>
          //           //     const SizedBox(width: 30),
          //           itemCount: listProduct.length,
          //         );
          //       }
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //       if (snapshot.hasError) {
          //         log("*************************      Error      ********************" );
          //         log(snapshot.error.toString());
          //       }
          //       return const Center(child: Text("Error"));
          //     },
          //   ),
          // )
         
          // Container(
          //   color: Colors.grey[300],
          //   child: GridView.count(
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 1.0,
          //     childAspectRatio: 1 / 1.58,
          //     mainAxisSpacing: 1.0,
          //     children: List.generate(
          //       model.data!.products!.length,
          //       (index) =>
          //           buildGridProduct(model.data!.products![index], context),
          //     ),
          //   ),
          // ),
        ],
      );

  Widget buildGridProduct({required MedicalProductModel modelMedical}) =>
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(modelMedical.imageUrl),
                  width: double.infinity,
                  height: 200,
                ),
                // if (model.discount != 0)
                //   Container(
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 5.0),
                //       child: Text(
                //         'DISCOUNT',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 8.0,
                //         ),
                //       ),
                //     ),
                //     color: Colors.red,
                //   ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modelMedical.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${modelMedical.price}',
                        style: TextStyle(
                          fontSize: 12,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // if (model.discount != 0)
                      //   Text(
                      //     '${model.oldPrice.round()}',
                      //     style: TextStyle(
                      //       fontSize: 10,
                      //       color: Colors.grey,
                      //       decoration: TextDecoration.lineThrough,
                      //     ),
                      //   ),
                      Spacer(),
                      IconButton(
                        alignment: AlignmentDirectional.bottomEnd,
                        onPressed: () {
                          // ShopCubit.get(context).changeFavorites(model.id!);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              // ShopCubit.get(context).favorites[model.id] == true
                              // ?
                              defaultColor
                          // : Colors.grey,
                          ,
                          child: Icon(
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
      );

  Widget buildCategoriesItem({required String name, required String img}) =>
      Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(img),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
            width: 100.0,
            color: Colors.black.withOpacity(.7),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}

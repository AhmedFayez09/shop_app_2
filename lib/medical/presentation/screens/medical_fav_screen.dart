import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_2/medical/presentation/models/medical_product_model.dart';
import 'package:shop_app_2/service/firestore.dart';
import 'package:shop_app_2/shared/styles/colors.dart';

class MedicalFavScreen extends StatelessWidget {
  MedicalFavScreen({Key? key}) : super(key: key);
  final uID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Fav Screen"),
      ),
      body: StreamBuilder<QuerySnapshot<MedicalProductModel>>(
        stream: getProductFromFireStore('Users/$uID/fav'),
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

          return SingleChildScrollView(
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1 / 1.58,
              mainAxisSpacing: 1.0,
              children: List.generate(
                  product.length,
                  (index) => Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomStart,
                              children: [
                                Image(
                                  image: NetworkImage(product[index].imageUrl),
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
                                  Text(
                                    product[index].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(height: 1.3),
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
                                        alignment:
                                            AlignmentDirectional.bottomEnd,
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .doc('test/${product[index].id}')
                                              .update({
                                            'inFavorites': false
                                          }).then((value) {
                                            FirebaseFirestore.instance
                                                .doc(
                                                    'Users/$uID/fav/${product[index].id}')
                                                .delete();
                                          });
                                        },
                                        icon: CircleAvatar(
                                          radius: 15.0,
                                          backgroundColor:
                                              product[index].inFavorites == true
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
          );
        },
      ),
    );
  }
}

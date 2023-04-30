import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app_2/medical/presentation/models/add_to_cart_to_admin_model.dart';
import 'package:shop_app_2/medical/presentation/models/medical_product_model.dart';
import 'package:shop_app_2/medical/presentation/models/user_model.dart';

CollectionReference<MedicalProductModel> getDataFromFirebase(
    String nameCollection) {
  return FirebaseFirestore.instance
      .collection(nameCollection)
      .withConverter<MedicalProductModel>(
    fromFirestore: (docSnapshot, _) {
      return MedicalProductModel.fromJson(docSnapshot.data()!);
    },
    toFirestore: (clientM, _) {
      return clientM.toJson();
    },
  );
}

CollectionReference<AddToAllCartToAdmin> getDataFromFirebaseToSendAdmin(
    String nameCollection) {
  return FirebaseFirestore.instance
      .collection(nameCollection)
      .withConverter<AddToAllCartToAdmin>(
    fromFirestore: (docSnapshot, _) {
      return AddToAllCartToAdmin.fromJson(docSnapshot.data()!);
    },
    toFirestore: (clientM, _) {
      return clientM.toJson();
    },
  );
}

Future addProductToFireStore(
    MedicalProductModel product, String nameCollection) {
  CollectionReference<MedicalProductModel> collection =
      getDataFromFirebase(nameCollection);
  DocumentReference<MedicalProductModel> doc = collection.doc();
  product.id = doc.id;
  return doc.set(product);
}

Future addListProCartToAdmin(
    AddToAllCartToAdmin product, String nameCollection) {
  CollectionReference<AddToAllCartToAdmin> collection =
      getDataFromFirebaseToSendAdmin(nameCollection);
  DocumentReference<AddToAllCartToAdmin> doc = collection.doc();
  product.id = doc.id;
  return doc.set(product);
}

////////////////////////////////////////////////////////////////////////

// CollectionReference<UserModel> userInFireStore(String path) {
//   return FirebaseFirestore.instance.collection(path).withConverter<UserModel>(
//     fromFirestore: (docSnapshot, _) {
//       return UserModel.fromJson(docSnapshot.data()!, docSnapshot.id);
//     },
//     toFirestore: (userM, _) {
//       return userM.toJson();
//     },
//   );
// }

Future<void> addUserToFireStore(UserModel user) {
  final ref = FirebaseFirestore.instance.doc('Users/${user.uId}');
  return ref.set(user.toJson());
}

Stream<QuerySnapshot<MedicalProductModel>> getProductFromFireStore(
    String nameCollection) {
  var collection = getDataFromFirebase(nameCollection);
  return collection.snapshots();
}










































































// Future addClintToFireStore(ProductModel client, String nameCollection) {
//   var collection = getDataFromFirebase(nameCollection);
//   var doc = collection.doc();
//   client.id = doc.id;
//   return doc.set(client);
// }

// Future<QuerySnapshot<ProductModel>> getClientFromFireStore(DateTime time) async {
//   var collection = await getDataFromFirebase();
//   return collection
//       .where(
//         'startTime',
//         isEqualTo: DateUtils.dateOnly(time).microsecondsSinceEpoch,
//       )
//       .get();
// }

// Stream<QuerySnapshot<ProductModel>> getClientFromFireStoreUsingStream(
//     DateTime time) {
//   var collection = getDataFromFirebase();
//   return collection
//       .where(
//         'startTime',
//         isEqualTo: DateUtils.dateOnly(time).microsecondsSinceEpoch,
//       )
//       .snapshots();
// }

// Future<void> deleteFromFirebase(ProductModel client, String nameCollection) {
//   var collection = getDataFromFirebase(nameCollection);
//   return collection.doc(client.id).delete();
// }

// Future<void> editDataFromFirebase(ProductModel client) {
//   var collection = getDataFromFirebase();
//   return collection.doc(client.id).update({
//     'id': client.id,
//     'name': client.name,
//     'section': client.section,
//     'note': client.note,
//     'price': client.price
//   });
// }
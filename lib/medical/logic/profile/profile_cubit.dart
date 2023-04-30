import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app_2/medical/logic/profile/profile_state.dart';
import 'package:shop_app_2/medical/presentation/models/medical_product_model.dart';
import 'package:shop_app_2/medical/presentation/models/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? userData;




  void getUserDataFromFireStore() {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      final id = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .get()
          .then((value) {
        userData = UserModel.fromJson(value.data()!);
        log('/////////////*****************///////////////////////////');
        log('${userData!.email}');
        log('/////////////*****************///////////////////////////');
      });
    }
  }

  /**
   *
   *
   *  FirebaseFirestore.instance
      .collection('users')
      .get()
      .then(
      (value) => value.docs.forEach(
      (element) {
      var docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(element.id);

      docRef.update({'bio': ''});
      },
      ),
      );
   */

  void getTotalPrice(String uid) {
    List<num> listTolePrice = [50,30,100];
    emit(ChangeTotalPriceLoading());
    FirebaseFirestore.instance
        .collection('Users/$uid/cart')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        var total = doc.data()['totalPrice'];
        // total += total;
        listTolePrice.add(total);
        print(listTolePrice);
        for (var t in listTolePrice) {
          num sum =
              listTolePrice.fold(0, (previous, current) => previous + current);

          emit(ChangeTotalPriceSuccess(total: sum));

        }
      }
    }).catchError((e) {
      emit(ChangeTotalPriceError());
    });
    //  DocumentReference doc = FirebaseFirestore.instance.doc(path);
    //  doc.get().asStream().listen((event) {
    // print('**********************************************************************');
    // print(event.data());
    // print('**********************************************************************');
    //  });

  }
}

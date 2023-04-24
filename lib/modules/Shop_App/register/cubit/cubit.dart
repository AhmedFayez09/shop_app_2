import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_2/medical/presentation/models/user_model.dart';
import 'package:shop_app_2/modules/Shop_App/register/cubit/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_2/service/firestore.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());
  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  // ShopLoginModel? loginModel;
  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(ShopRegisterLoadingState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
     UserModel  userM = UserModel(
        uId: credential.user!.uid,
        phone: phone,
        email: email,
        name: name,
      );
      addUserToFireStore(userM);
      emit(ShopRegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(ShopRegisterErrorState('The password provided is too weak.'));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(ShopRegisterErrorState(
            'The account already exists for that email.'));
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    // DioHelper.postData(
    //   url: REGISTER,
    //   data: {
    //     'email': email,
    //     'name': name,
    //     'phone': phone,
    //     'password': password,
    // },
    // ).then((value) {
    //   loginModel = ShopLoginModel.fromJson(value.data);
    //   emit(ShopRegisterSuccessState(loginModel!));
    // }).catchError((error) {
    //   print(error);
    //   emit(ShopRegisterErrorState(error.toString()));
    // });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordIconState());
  }
}

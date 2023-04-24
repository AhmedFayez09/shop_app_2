import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_2/modules/Shop_App/login/cubit/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());
  static ShopLoginCubit get(context) => BlocProvider.of(context);

  // ShopLoginModel? loginModel;
  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(ShopLoginLoadingState());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(ShopLoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(ShopLoginErrorState('No user found for that email.'));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        emit(ShopLoginErrorState('Wrong password provided for that user.'));
        print('Wrong password provided for that user.');
      }
    }
    // DioHelper.postData(
    //     url: LOGIN,
    //     data: {
    //       'email':email,
    //       'password':password,

    //     },
    // ).then((value){
    // loginModel=ShopLoginModel.fromJson(value.data);
    //   emit(ShopLoginSuccessState(loginModel!));
    // }).catchError((error){
    //   print(error);
    //   emit(ShopLoginErrorState(error.toString()));
    // });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }
}

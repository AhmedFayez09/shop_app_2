import 'package:shop_app_2/models/shop_app/shop_login_model.dart';

abstract class ShopRegisterStates{}

class ShopRegisterInitialState extends ShopRegisterStates{}

class ShopRegisterLoadingState extends ShopRegisterStates{}

class ShopRegisterSuccessState extends ShopRegisterStates
{
  // final ShopLoginModel loginModel;

  ShopRegisterSuccessState(
    // this.loginModel
    );
}

class ShopRegisterErrorState extends ShopRegisterStates
{
  final String error;

  ShopRegisterErrorState(this.error);
}
class ShopChangePasswordIconState extends ShopRegisterStates{}
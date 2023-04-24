import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_2/layout/Shop_App/Cubit/status.dart';
import 'package:shop_app_2/models/Shop_App/categroies_model.dart';
import 'package:shop_app_2/models/Shop_App/favorites_model.dart';
import 'package:shop_app_2/models/Shop_App/home_model.dart';
import 'package:shop_app_2/medical/presentation/models/medical_product_model.dart';
import 'package:shop_app_2/medical/presentation/models/user_model.dart';
import 'package:shop_app_2/modules/Shop_App/categories/categories_screen.dart';
import 'package:shop_app_2/modules/Shop_App/favorites/favorites_screen.dart';
import 'package:shop_app_2/modules/Shop_App/products/products_screen.dart';
import 'package:shop_app_2/modules/Shop_App/setting/setting_screen.dart';
import 'package:shop_app_2/shared/components/constants.dart';
import 'package:shop_app_2/shared/network/end_point.dart';
import 'package:shop_app_2/shared/network/local/cache_helper.dart';
import 'package:shop_app_2/shared/network/remote/Dio_Helper.dart';
import 'package:shop_app_2/test_screen.dart';

import '../../../models/shop_app/change_favorites_model.dart';
import '../../../models/shop_app/shop_login_model.dart';
import '../../../service/firestore.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItem = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home_outlined,
      ),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.apps,
      ),
      label: 'Categories',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.favorite_outline,
      ),
      label: 'Favorites',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.settings_outlined,
      ),
      label: 'Settings',
    ),
  ];

  List<Widget> bottomScreens = [
    // ProductsScreen(),
    TestScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;

    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  // ProductModel mm = ProductModel.fromJson(json)
  // void getHomeData() {
  //   // token = CacheHelper.getData(key: 'token');
  //   emit(ShopLoadingHomeState());
  //   DioHelper.getData(
  //     url: HOME,
  //     // token: token,
  //   ).then((value) {
  //     homeModel = HomeModel.fromJson(value.data);
  //     homeModel!.data!.products!.forEach((element) {
  //       favorites.addAll({
  //         element.id!: element.inFavorites!,
  //       });
  //     });
  //
  //     emit(ShopSuccessHomeState());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(ShopErrorHomeState());
  //   });
  // }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      // token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productsId) {
    favorites[productsId] = !favorites[productsId]!;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      // token: token,
      data: {
        'product_id': productsId,
      },
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productsId] = !favorites[productsId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productsId] = !favorites[productsId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      // token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      // token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessUserDataState(loginModel: userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String? name,
    required String? phone,
    required String? email,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      // token: token,
      data: {
        'name': name,
        'phone': phone,
        'email': email,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(ShopChangeThemeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(ShopChangeThemeModeState());
      });
    }
  }

  String pathAddToFav(String Uid, String proId) => 'Users/$Uid/fav/$proId';
  String pathAddToCart(String Uid, String proId) => 'Users/$Uid/cart/$proId';


  Future<void> addTOFav(MedicalProductModel model) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .doc(pathAddToFav(uid, model.id))
        .set(model.toJson());
  }

  Future<void> addTOCart(MedicalProductModel model) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .doc(pathAddToCart(uid, model.id))
        .set(model.toJson());
  }
}

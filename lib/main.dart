import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_2/layout/Shop_App/Cubit/cubit.dart';
import 'package:shop_app_2/layout/Shop_App/Cubit/status.dart';
import 'package:shop_app_2/layout/Shop_App/Shop_Layout.dart';
import 'package:shop_app_2/medical/logic/profile/profile_cubit.dart';
import 'package:shop_app_2/modules/Shop_App/login/shop_login_screen.dart';
import 'package:shop_app_2/modules/Shop_App/on_boarding/on_boarding_screen.dart';
import 'package:shop_app_2/modules/Shop_App/register/cubit/cubit.dart';
import 'package:shop_app_2/shared/block_observer.dart';
import 'package:shop_app_2/shared/components/constants.dart';
import 'package:shop_app_2/shared/network/local/cache_helper.dart';
import 'package:shop_app_2/shared/network/remote/Dio_Helper.dart';
import 'package:shop_app_2/shared/styles/Themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  DioHelper.init();
  var onBoarding = CacheHelper.getData(key: 'onBoarding');
  // token = CacheHelper.getData(key: 'token');
  // String isAuth = CacheHelper.getData(key: 'isAuth');

  Widget widget;
  if (onBoarding != null) {
    if (CacheHelper.getData(key: 'isAuth') == "auth") {
      widget = ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = onBoardingScreen();
  }
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  const MyApp({super.key, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()
            // ..getUserData(),
        ),
        BlocProvider(
          create: (context) => ShopRegisterCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit()..getUserDataFromFireStore(),
        ),
      ],
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Shop App',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
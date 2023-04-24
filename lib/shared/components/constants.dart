
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_app_2/modules/Shop_App/login/shop_login_screen.dart';
import 'package:shop_app_2/shared/network/local/cache_helper.dart';

import 'components.dart';

 void signOut(context){
  FirebaseAuth.instance.signOut();
   CacheHelper.removeData(key:'isAuth',
   ).then((value){
     if(value){
       navigateAndFinish(context,ShopLoginScreen());
     }
   });
 }
 void printFullText(String text)
 {
   final pattern =RegExp('.{1,800}');
   pattern.allMatches(text).forEach((match)=>print(match.group(0)));
 }

// String? token='';
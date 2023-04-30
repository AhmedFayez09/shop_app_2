import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_2/layout/Shop_App/Cubit/cubit.dart';
import 'package:shop_app_2/layout/Shop_App/Cubit/status.dart';
import 'package:shop_app_2/medical/logic/profile/profile_cubit.dart';
import 'package:shop_app_2/medical/logic/profile/profile_state.dart';
import 'package:shop_app_2/shared/components/components.dart';
import 'package:shop_app_2/shared/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        var profile = ProfileCubit.get(context);
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is ShopLoadingUpdateUserState)
                        LinearProgressIndicator(),
                      const SizedBox(height: 20),
                      defaultFormField(
                        onValidate: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your User Name!!';
                          }
                          return null;
                        },
                        prefix: Icons.person_outline,
                        initialValue: profile.userData != null
                            ? profile.userData!.name
                            : 'Loading...',
                        // controller: nameController,

                        type: TextInputType.name,
                        label: 'User Name',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        initialValue: profile.userData != null
                            ? profile.userData!.email
                            : 'Loading',
                        onValidate: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Email Address!!';
                          }
                          return null;
                        },
                        prefix: Icons.email_outlined,
                        // controller: emailController,
                        type: TextInputType.emailAddress,
                        label: 'Email Address',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        initialValue: profile.userData != null
                            ? profile.userData!.phone
                            : 'Loading',
                        onValidate: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Phone Number!!';
                          }
                          return null;
                        },
                        prefix: Icons.phone_android_outlined,
                        // controller: phoneController,
                        type: TextInputType.phone,
                        label: 'Phone Number',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {}
                          },
                          text: 'update',
                          radius: 30),
                      SizedBox(height: 20),
                      defaultButton(
                        function: () {
                          signOut(context);
                        },
                        text: 'logout',
                        textColor: Colors.white,
                        radius: 30,
                        background: Colors.red.shade300,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

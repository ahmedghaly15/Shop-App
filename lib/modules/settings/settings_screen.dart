import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/cubit/cubit.dart';
import '/layout/cubit/states.dart';
import '/shared/components/default_button.dart';
import '/shared/components/input_field.dart';
import '/shared/constants.dart';
import '/styles/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Email Text Field Controller
    TextEditingController emailController = TextEditingController();
    // User Name Text Field Controller
    TextEditingController nameController = TextEditingController();
    // Phone Text Field Controller
    TextEditingController phoneController = TextEditingController();

    // A Key For The Form
    final GlobalKey<FormState> formKey = GlobalKey();

    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // For Getting The Screen Height
        double screenHeight = MediaQuery.of(context).size.height;
        // For Getting The Screen Width
        double screenWidth = MediaQuery.of(context).size.width;
        // Getting An Object Of The userModel
        var model = ShopAppCubit.getObject(context).userModel;

        //====== Assigning The Current User Info To The Text Fields ======
        emailController.text = model!.data!.email!;
        nameController.text = model.data!.name!;
        phoneController.text = model.data!.phone!;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.01,
          ),
          child: Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    //======== In Case Loading ========
                    if (state is LoadingUpdateUserDataState)
                      const LinearProgressIndicator(color: defaultColor),

                    // For Adding Some Space
                    SizedBox(height: screenHeight * 0.03),

                    //============ User Name Text Form Field ============
                    InputField(
                      hint: "Name",
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.words,
                      prefixIcon: const Icon(Icons.person),
                      obsecure: false,
                      validating: (value) {
                        if (value!.isEmpty) {
                          return "Name must not be empty";
                        }
                        return null;
                      },
                    ),

                    // For Adding Some Space
                    SizedBox(height: screenHeight * 0.025),

                    //============ User Email Text Form Field ============
                    InputField(
                      hint: "Email",
                      controller: emailController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.none,
                      prefixIcon: const Icon(Icons.email),
                      obsecure: false,
                      validating: (value) {
                        if (value!.isEmpty) {
                          return "Email must not be empty";
                        }
                        return null;
                      },
                    ),

                    // For Adding Some Space
                    SizedBox(height: screenHeight * 0.025),

                    //============ User Phone Text Form Field ============
                    InputField(
                      hint: "Phone",
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      textCapitalization: TextCapitalization.none,
                      prefixIcon: const Icon(Icons.phone),
                      obsecure: false,
                      validating: (value) {
                        if (value!.isEmpty) {
                          return "Phone must not be empty";
                        }
                        return null;
                      },
                    ),

                    // For Adding Some Space
                    SizedBox(height: screenHeight * 0.05),

                    //============ Update The Current User's Info Button ============
                    DefaultButton(
                      buttonText: "Update",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          ShopAppCubit.getObject(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      height: 0.015,
                      width: 0.32,
                      buttonRaduis: 0.05,
                    ),

                    // For Adding Some Space
                    SizedBox(height: screenHeight * 0.03),

                    //============ Signing The Current User Out Button ============
                    DefaultButton(
                      buttonText: "Sign Out",
                      onPressed: () => signOut(context),
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      height: 0.015,
                      width: 0.3,
                      buttonRaduis: 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

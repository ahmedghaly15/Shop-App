import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/auth/cubit/cubit.dart';
import 'package:shop_app/modules/auth/cubit/states.dart';
import 'package:shop_app/styles/colors.dart';
import 'package:shop_app/widgets/helper/components_helper.dart';

import '../../widgets/components/default_button.dart';
import '../../widgets/components/input_field.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey();
  AuthMode authMode = AuthMode.signIn;

  //============ TextFormFields Controllers ============
  // Email TextFormField Controller
  final TextEditingController emailController = TextEditingController();
  // Password TextFormField Controller
  final TextEditingController passwordController = TextEditingController();
  // Confrim Password TextFormField Controller
  final TextEditingController confirmPassController = TextEditingController();

  // For Controlling Password Visibility
  bool passVisiblity = true;
  // For Controlling Confirmation Password Visibility
  bool confirmPassVisiblity = true;

  // For Storing User Info
  final Map<String, String> authData = {
    'email': '',
    'pass': '',
  };

  // Animations
  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    //============ Controlling Animations ============
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn),
    );

    super.initState();
  }

  @override
  void dispose() {
    // Destroying The Controller
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthScreenCubit(),
      child: BlocConsumer<AuthScreenCubit, AuthScreenStates>(
        listener: (context, state) {
          if (state is SignInSuccessState) {
            if (state.signInModel.status!) {
              print(state.signInModel.message);
              print(state.signInModel.data!.token);
            } else {
              ComponentsHelper.buildSnackBar(
                context: context,
                message: state.signInModel.message!,
                color: Colors.red,
              );
              print(state.signInModel.message);
            }
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (BuildContext context, _) {
              double screenWidth = MediaQuery.of(context).size.width;
              double screenHeight = MediaQuery.of(context).size.height;
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  body: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              authMode == AuthMode.signIn
                                  ? "SIGN IN"
                                  : "SIGN UP",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            Text(
                              authMode == AuthMode.signIn
                                  ? "Sign in now to browse our hot offers"
                                  : "Let's make a new account",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Colors.black54,
                                  ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.025,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: <Widget>[
                                  InputField(
                                    key: const ValueKey("email"),
                                    hint: "Email",
                                    controller: emailController,
                                    obsecure: false,
                                    keyboardType: TextInputType.emailAddress,
                                    validating: (val) {
                                      if (val!.isEmpty || !val.contains('@')) {
                                        return "Enter an email";
                                      }
                                      return null;
                                      // return "";
                                    },
                                    saving: (val) {
                                      authData['email'] = val!;
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  InputField(
                                    key: const ValueKey("password"),
                                    hint: "Password",
                                    controller: passwordController,
                                    obsecure: passVisiblity,
                                    keyboardType: TextInputType.visiblePassword,
                                    icon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          passVisiblity = !passVisiblity;
                                        });
                                      },
                                      icon: Icon(passVisiblity
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded),
                                    ),
                                    validating: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter a password";
                                      } else if (val.length < 8) {
                                        return "Too short pasword";
                                      }
                                      return null;
                                      // return val;
                                      // return "";
                                    },
                                    saving: (val) {
                                      authData['pass'] = val!;
                                    },
                                    onSubmit: (String value) {
                                      if (formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        AuthScreenCubit.getObject(context)
                                            .userSignIn(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  if (authMode == AuthMode.signUp)
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeIn,
                                      child: SlideTransition(
                                        position: _slideAnimation!,
                                        child: InputField(
                                          key: const ValueKey(
                                              "confirm_password"),
                                          hint: "Confirm Password",
                                          controller: confirmPassController,
                                          obsecure: confirmPassVisiblity,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          icon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                confirmPassVisiblity =
                                                    !confirmPassVisiblity;
                                              });
                                            },
                                            icon: Icon(confirmPassVisiblity
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded),
                                          ),
                                          validating: (val) {
                                            if (val! !=
                                                passwordController.text) {
                                              return "Password doesn't match";
                                            }
                                            return null;
                                            // return null;
                                          },
                                          saving: (val) {
                                            authData['pass'] = val!;
                                          },
                                          onSubmit: (String value) {},
                                        ),
                                      ),
                                    ),

                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),

                                  Align(
                                    alignment: Alignment.center,
                                    child: ConditionalBuilder(
                                      condition: state is! SignInLoadingState,
                                      builder: (context) => DefaultButton(
                                        buttonText: authMode == AuthMode.signIn
                                            ? "SIGN IN"
                                            : "SIGN UP",
                                        onPressed: () =>
                                            signInOrSignUp(context),
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        height: 0.02,
                                        width: 0.33,
                                        buttonRaduis: 0.05,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      fallback: (context) => const Center(
                                        child: CircularProgressIndicator(
                                          color: defaultColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // For Adding Some Space
                                  SizedBox(height: screenHeight * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        authMode == AuthMode.signIn
                                            ? "Don't have an account?"
                                            : "Already have an account?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      TextButton(
                                        onPressed: switchAuthMode,
                                        child: Text(
                                          authMode == AuthMode.signIn
                                              ? "SIGN UP"
                                              : "SIGN IN",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: defaultColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void switchAuthMode() {
    if (authMode == AuthMode.signIn) {
      setState(() {
        authMode = AuthMode.signUp;
      });

      _controller!.forward();
    } else {
      setState(() {
        authMode = AuthMode.signIn;
      });
      _controller!.reverse();
    }
  }

  void signInOrSignUp(BuildContext ctx) {
    if (authMode == AuthMode.signIn) {
      if (formKey.currentState!.validate()) {
        FocusScope.of(ctx).unfocus();
        AuthScreenCubit.getObject(ctx).userSignIn(
          email: emailController.text,
          password: passwordController.text,
        );
      }
    } else if (authMode == AuthMode.signUp) {
      print("Sign up mode");
    }
  }
}

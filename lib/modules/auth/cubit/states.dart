// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shop_app/models/sign_in_model.dart';

abstract class AuthScreenStates {}

class AuthScreenInitialState extends AuthScreenStates {}

class SignInLoadingState extends AuthScreenStates {}

class SignInSuccessState extends AuthScreenStates {
  final SignInModel signInModel;
  SignInSuccessState(this.signInModel);
}

class SignInErrorState extends AuthScreenStates {
  final String error;
  SignInErrorState(this.error);
}

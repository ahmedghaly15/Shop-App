import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/sign_in_model.dart';
import '/modules/auth/cubit/states.dart';
import '/network/end_points.dart';
import '/network/remote/dio_helper.dart';

// For Toggling Between Sign In Screen & Sign Up Screen
enum AuthMode { signIn, signUp }

//==================== Auth Screen Cubit ====================
class AuthScreenCubit extends Cubit<AuthScreenStates> {
  AuthScreenCubit() : super(AuthScreenInitialState());

  //============ Getting An Object Of The Cubit ============
  static AuthScreenCubit getObject(context) => BlocProvider.of(context);

  SignInModel? signInModel;

  //============ For Signing In A User ============
  void userSignIn({
    required String email,
    required String password,
  }) {
    emit(SignInLoadingState());

    DioHelper.postData(
      pathUrl: loginEndPoint,
      data: {
        'email': email,
        'password': password,
      },
      lang: 'en',
    ).then((value) {
      signInModel = SignInModel.fromJson(value.data);

      emit(SignInSuccessState(signInModel!));
    }).catchError((error) {
      print(error.toString());
      emit(SignInErrorState(error.toString()));
    });
  }

  //============ For Signing Up A User ============
  void userSignUp({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SignUpLoadingState());

    DioHelper.postData(
      pathUrl: signUpEndPoint,
      data: {
        'name': username,
        'email': email,
        'password': password,
        'phone': phone,
      },
      lang: 'en',
    ).then((value) {
      signInModel = SignInModel.fromJson(value.data);

      emit(SignUpSuccessState(signInModel!));
    }).catchError((error) {
      print(error.toString());
      emit(SignUpErrorState(error.toString()));
    });
  }
}

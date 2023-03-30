import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/sign_in_model.dart';
import 'package:shop_app/modules/auth/cubit/states.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

enum AuthMode { signIn, signUp }

class AuthScreenCubit extends Cubit<AuthScreenStates> {
  AuthScreenCubit() : super(AuthScreenInitialState());

  static AuthScreenCubit getObject(context) => BlocProvider.of(context);

  SignInModel? signInModel;

  void userSignIn({
    required String email,
    required String password,
  }) {
    emit(SignInLoadingState());

    DioHelper.postData(
      pathUrl: login,
      data: {
        'email': email,
        'password': password,
      },
      lang: 'en',
    ).then((value) {
      print(value.data);
      signInModel = SignInModel.fromJson(value.data);

      emit(SignInSuccessState(signInModel!));
    }).catchError((error) {
      print(error.toString());
      emit(SignInErrorState(error.toString()));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:shop_app/modules/on_boarding/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/on_boarding_model.dart';
import '../../auth/auth_screen.dart';

class ShopAppCubit extends Cubit<OnBoardingStates> {
  ShopAppCubit() : super(InitialOnBoardingState());

  static ShopAppCubit getObject(context) => BlocProvider.of(context);

  bool isLastBoarding = false;

  void onChangePageIndex(int index, List<OnBoardingModel> modelList) {
    if (index == modelList.length - 1) {
      isLastBoarding = true;
      print("last");
    } else {
      isLastBoarding = false;
      print("not last");
    }
    emit(PageViewIndexChangedState());
  }

  void navigateToAuthScreen(context, PageController boardPageController) {
    getObject(context).isLastBoarding
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthScreen(),
            ),
            (Route<dynamic> route) => false,
          )
        : boardPageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn,
          );

    emit(GetToAuthScreenState());
  }

  void skipOnBoardingScreen(context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false, // remove all previous routes
    );
    emit(SkipOnBoardingState());
  }
}

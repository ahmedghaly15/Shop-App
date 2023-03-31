import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/auth_screen.dart';
import '/models/on_boarding_model.dart';
import '/modules/on_boarding/cubit/states.dart';
import '/network/local/cache_helper.dart';
import '/shared/constants.dart';

//========================== On Boarding Screen Cubit ==========================
class OnBoardingScreenCubit extends Cubit<OnBoardingStates> {
  OnBoardingScreenCubit() : super(InitialOnBoardingState());

  //============ Getting An Object Of The Cubit ============
  static OnBoardingScreenCubit getObject(context) => BlocProvider.of(context);

  // To Check If The Current Screen Is OnBoardingScreen Or Not
  bool isLastBoarding = false;

  //=========== For Navigating Between OnBoarding Screen Pages ===========
  void onChangePageIndex(int index, List<OnBoardingModel> modelList) {
    if (index == modelList.length - 1) {
      isLastBoarding = true;
    } else {
      isLastBoarding = false;
    }
    emit(PageViewIndexChangedState());
  }

  //=========== For Navigating To Auth Screen According To isLastBoarding ===========
  void navigateToAuthScreen(context, PageController boardPageController) {
    //=========== Navigating To Auth Screen When The Last Page Is Reached ===========
    if (getObject(context).isLastBoarding) {
      navigateDirectlyToAuthScreen(context);
      emit(GetToAuthScreenState());
    }
    //=========== For Navigating To The Next Page When The Last Page Is Not Reached ===========
    boardPageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    );

    emit(PageViewIndexChangedState());
  }

  //============ For Moving Directly To Auth Screen ============
  void navigateDirectlyToAuthScreen(context) {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateAndFinish(context, screen: const AuthScreen());
        emit(SkipOnBoardingState());
      }
    });
  }
}

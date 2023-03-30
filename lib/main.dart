import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/bloc_observer.dart';

import 'modules/on_boarding/on_boarding_screen.dart';
import 'network/remote/dio_helper.dart';
import 'styles/colors.dart';

void main() {
  //===================== Observing My Bloc =====================
  Bloc.observer = MyBlocObserver();

  //===================== Initializing My API =====================
  DioHelper.initDio();

  //===================== Running App =====================
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: defaultColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Jannah',
      ),
      home: const OnBoardingScreen(),
    );
  }
}

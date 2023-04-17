import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/cubit/cubit.dart';
import '/modules/splash/splash_screen.dart';
import '/network/local/cache_helper.dart';
import '/shared/bloc_observer.dart';
import '/shared/constants.dart';
import 'network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //===================== Observing My Bloc =====================
  Bloc.observer = MyBlocObserver();

  //===================== Initializing My API =====================
  DioHelper.initDio();

  //===================== Initializing SharedPref =====================
  await CacheHelper.init();

  //===================== Using SharedPref To Open The Home Screen =====================
  token = CacheHelper.getStringData(key: 'token');

  //===================== Running App =====================
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopAppCubit()
        ..getHomeData()
        ..getCategoriesData()
        ..getFavorites()
        ..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: defaultColor,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Jannah',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

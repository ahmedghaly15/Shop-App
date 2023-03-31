import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/layout/cubit/cubit.dart';
import '/layout/shop_layout.dart';
import '/modules/auth/auth_screen.dart';
import '/network/local/cache_helper.dart';
import '/shared/bloc_observer.dart';
import '/shared/constants.dart';
import 'modules/on_boarding/on_boarding_screen.dart';
import 'network/remote/dio_helper.dart';
import 'styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //===================== Observing My Bloc =====================
  Bloc.observer = MyBlocObserver();

  //===================== Initializing My API =====================
  DioHelper.initDio();

  //===================== Initializing SharedPref =====================
  await CacheHelper.init();

  //===================== Using SharedPref To Open The Home Screen =====================
  bool? onBoarding = CacheHelper.getBoolData(key: 'onBoarding');
  token = CacheHelper.getStringData(key: 'token');
  Widget screen;

  if (onBoarding != null) {
    if (token != null)
      screen = const ShopLayout();
    else
      screen = const AuthScreen();
  } else {
    screen = const OnBoardingScreen();
  }

  //===================== Running App =====================
  runApp(MainApp(screen));
}

class MainApp extends StatelessWidget {
  final Widget startScreen;
  const MainApp(this.startScreen, {super.key});
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
          primarySwatch: defaultColor,
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
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Jannah',
        ),
        home: startScreen,
      ),
    );
  }
}

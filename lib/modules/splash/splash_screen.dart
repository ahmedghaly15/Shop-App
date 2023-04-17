import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/layout/shop_layout.dart';
import '/modules/auth/auth_screen.dart';
import '/modules/on_boarding/on_boarding_screen.dart';
import '/shared/constants.dart';

import '/network/local/cache_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ============ Storing User Email Using SharedPrererences ============
  goToApp() async {
    bool? onBoarding = CacheHelper.getBoolData(key: 'onBoarding');

    if (onBoarding != null) {
      if (token != null)
        navigateTo(context, const ShopLayout());
      else
        navigateTo(context, const AuthScreen());
    } else {
      navigateTo(context, const OnBoardingScreen());
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    // Time Of Showing Splash Screen
    Timer(const Duration(milliseconds: 2200), goToApp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(255, 36, 0, 1),
            Color.fromRGBO(255, 36, 0, 0.8),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(
                "assets/images/app logo/logo.jpg",
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

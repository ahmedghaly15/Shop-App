import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/models/on_boarding_model.dart';
import '/modules/on_boarding/cubit/cubit.dart';
import '/modules/on_boarding/cubit/states.dart';
import '/styles/colors.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    PageController boardPageController = PageController();

    //======= OnBoarding Pages Content =======
    List<OnBoardingModel> boarding = [
      OnBoardingModel(
        imgPath: 'assets/images/onBoarding1.jpg',
        title: "Easy products exploring",
        body: "Explore items easily wherever you are",
      ),
      OnBoardingModel(
        imgPath: 'assets/images/onBoarding2.jpg',
        title: "Whatever you want",
        body: "You'll find all you want here",
      ),
      OnBoardingModel(
        imgPath: 'assets/images/onBoarding3.jpg',
        title: "Deliver Products",
        body: "We deliver your product to you wherever you are",
      ),
      OnBoardingModel(
        imgPath: 'assets/images/onBoarding4.png',
        title: "Many ways to pay",
        body: "You can pay as you like",
      ),
    ];

    return BlocProvider(
      create: (BuildContext context) => OnBoardingScreenCubit(),
      child: BlocConsumer<OnBoardingScreenCubit, OnBoardingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          OnBoardingScreenCubit cubit =
              OnBoardingScreenCubit.getObject(context);
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                TextButton(
                  onPressed: () => cubit.navigateDirectlyToAuthScreen(context),
                  child: const Text(
                    "SKIP",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: defaultColor,
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: boardPageController,
                      itemBuilder: (context, index) => buildOnBoardingItem(
                        screenWidth,
                        screenHeight,
                        boarding[index],
                      ),
                      itemCount: boarding.length,
                      onPageChanged: (int index) =>
                          cubit.onChangePageIndex(index, boarding),
                    ),
                  ),
                  //======== For Adding Some Space ==========
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: <Widget>[
                      SmoothPageIndicator(
                        controller: boardPageController,
                        count: boarding.length,
                        effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor: defaultColor,
                          dotHeight: screenHeight * 0.01,
                          expansionFactor: screenWidth * 0.013,
                          dotWidth: screenWidth * 0.02,
                          spacing: screenWidth * 0.015,
                        ),
                      ),
                      const Spacer(),
                      FloatingActionButton(
                        backgroundColor: defaultColor,
                        onPressed: () => cubit.navigateToAuthScreen(
                          context,
                          boardPageController,
                        ),
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //================== For Building On Boarding Items ==================
  Widget buildOnBoardingItem(
    double screenWidth,
    double screenHeight,
    OnBoardingModel model,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Image(
            image: AssetImage(model.imgPath),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          model.title,
          style: const TextStyle(fontSize: 30),
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(model.body),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }
}

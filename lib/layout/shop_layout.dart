import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/styles/colors.dart';
import '/layout/cubit/cubit.dart';
import '/layout/cubit/states.dart';
import '/modules/search/search_screen.dart';
import '/shared/constants.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // An Object Of The Cubit
        ShopAppCubit cubit = ShopAppCubit.getObject(context);
        return GestureDetector(
          //======= For Closing The Keyboard When The Screen Is Tapped =======
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              actions: <Widget>[
                IconButton(
                  onPressed: () => navigateTo(context, const SearchScreen()),
                  icon: const Icon(
                    Icons.search,
                    color: defaultColor,
                    size: 30,
                  ),
                ),
              ],
            ),
            body: cubit.bottomNavScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavItems,
              currentIndex: cubit.currentIndex,
              onTap: (int index) => cubit.changeBottomNavIndex(index),
              type: BottomNavigationBarType.shifting,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              showSelectedLabels: true,
              showUnselectedLabels: false,
            ),
          ),
        );
      },
    );
  }
}

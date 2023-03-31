import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/cubit/cubit.dart';
import '/layout/cubit/states.dart';
import '/shared/constants.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // For Getting The Screen Width
        double screenHeight = MediaQuery.of(context).size.height;
        // For Getting The Screen Height
        double screenWidth = MediaQuery.of(context).size.width;
        return ListView.builder(
          itemBuilder: (context, index) => buildProductsList(
            ShopAppCubit.getObject(context)
                .favoritesModel!
                .data!
                .data![index]
                .product!,
            screenHeight,
            screenWidth,
            context,
          ),
          itemCount: ShopAppCubit.getObject(context)
              .favoritesModel!
              .data!
              .data!
              .length,
          physics: const BouncingScrollPhysics(),
        );
      },
    );
  }
}

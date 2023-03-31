import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/layout/cubit/cubit.dart';
import '/layout/cubit/states.dart';
import '/models/categories_model.dart';
import '/styles/colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // For Getting The Screen Width
        double screenHeight = MediaQuery.of(context).size.height;
        // For Getting The Screen Height
        double screenWidth = MediaQuery.of(context).size.width;
        return ConditionalBuilder(
          condition: ShopAppCubit.getObject(context).categoriesModel != null,
          builder: (context) => ListView.builder(
            itemBuilder: (context, index) => buildCatItem(
              screenWidth,
              screenHeight,
              ShopAppCubit.getObject(context)
                  .categoriesModel!
                  .data!
                  .data[index],
            ),
            itemCount: ShopAppCubit.getObject(context)
                .categoriesModel!
                .data!
                .data
                .length,
            physics: const BouncingScrollPhysics(),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(color: defaultColor),
          ),
        );
      },
    );
  }

  Widget buildCatItem(
          double screenWidth, double screenHeight, DataModel dataModel) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.008,
        ),
        child: Card(
          elevation: screenHeight * 0.01,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.015,
            ),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    image: NetworkImage(dataModel.image!),
                    fit: BoxFit.cover,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.15,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  dataModel.name!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

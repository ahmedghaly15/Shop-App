import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/cubit/cubit.dart';
import '/layout/cubit/states.dart';
import '/models/categories_model.dart';
import '/models/home_model.dart';
import '/shared/constants.dart';
import '/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is SuccessChangeFavoritesState) {
          //========= In Case There's Something Wrong =========
          if (!state.model.status!) {
            buildSnackBar(
              message: state.model.message!,
              state: SnackBarStates.error,
              context: context,
            );
          }
        }
      },
      builder: (context, state) {
        // For Getting The Screen Height
        double screenHeight = MediaQuery.of(context).size.height;
        // For Getting The Screen Width
        double screenWidth = MediaQuery.of(context).size.width;
        return ConditionalBuilder(
          condition: ShopAppCubit.getObject(context).homeModel != null &&
              ShopAppCubit.getObject(context).categoriesModel != null,
          builder: (context) => productsBuilder(
            ShopAppCubit.getObject(context).homeModel!,
            screenHeight,
            screenWidth,
            ShopAppCubit.getObject(context).categoriesModel!,
            context,
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(color: defaultColor),
          ),
        );
      },
    );
  }

  //=============== For Getting The Products ===============
  Widget productsBuilder(
    HomeModel model,
    double screenHeight,
    double screenWidth,
    CategoriesModel categoriesModel,
    BuildContext context,
  ) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
                items: model.data!.banners
                    .map(
                      (e) => ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image(
                          image: NetworkImage(e.image!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: screenHeight * 0.25,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 0.85,
                ),
              ),
              // For Adding Some Space
              SizedBox(height: screenHeight * 0.02),
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                // The Same Height Of Image
                height: screenHeight * 0.18,
                child: ListView.separated(
                  itemBuilder: (context, index) => buildCategoryItem(
                    screenHeight,
                    screenWidth,
                    categoriesModel.data!.data[index],
                  ),
                  separatorBuilder: (context, index) =>
                      SizedBox(width: screenWidth * 0.04),
                  itemCount: categoriesModel.data!.data.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                "New Products",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 1 / 2,
                children: List.generate(
                  model.data!.products.length,
                  (index) => buildGridProduct(
                    model.data!.products[index],
                    screenHeight,
                    screenWidth,
                    context,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  //================= For Building The Categories ===============
  Widget buildCategoryItem(
    double screenHeight,
    double screenWidth,
    DataModel dataModel,
  ) =>
      Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image(
            image: NetworkImage(dataModel.image!),
            height: screenHeight * 0.18,
            width: screenWidth * 0.4,
            fit: BoxFit.cover,
          ),
          Container(
            width: screenWidth * 0.4,
            color: Colors.black.withOpacity(0.6),
            child: Text(
              dataModel.name!.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );

  //================= For Getting The Product Info ===============
  Widget buildGridProduct(
    ProductsModel model,
    double screenHeight,
    double screenWidth,
    BuildContext context,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Image(
                image: NetworkImage(model.image!),
                height: screenHeight * 0.25,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: const Text(
                    "DISCOUNT",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          // For Adding Some Space
          SizedBox(height: screenHeight * 0.01),
          Text(
            model.name!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: <Widget>[
              Text(
                "\$${model.price.round()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: defaultColor,
                ),
              ),
              // For Adding Some Space
              SizedBox(width: screenWidth * 0.015),
              if (model.discount != 0)
                Text(
                  "\$${model.oldPrice.round()}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ShopAppCubit.getObject(context).changeFavorites(model.id!);
                  // print(model.id);
                },
                icon: CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundColor:
                      ShopAppCubit.getObject(context).favorites[model.id]!
                          ? defaultColor
                          : Colors.grey,
                  child: const Icon(
                    Icons.favorite_border,
                    size: 23,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}

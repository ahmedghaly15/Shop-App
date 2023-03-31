import 'package:flutter/material.dart';
import '/layout/cubit/cubit.dart';
import '/modules/auth/auth_screen.dart';
import '/network/local/cache_helper.dart';
import '/styles/colors.dart';

//=========== For Switching Between The State Of The Snack Bar ===========
enum SnackBarStates { success, error, warning }

// The User's Token
String? token;

//================== For Building A Snack Bar ==================
void buildSnackBar({
  required String message,
  required SnackBarStates state,
  required BuildContext context,
}) {
  final SnackBar snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ),
    dismissDirection: DismissDirection.down,
    clipBehavior: Clip.hardEdge,
    backgroundColor: chooseSnackBarClr(state),
    duration: const Duration(seconds: 5),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    padding: const EdgeInsets.all(15.0),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

//================== For Easy Choosing The Color Of The SnackBar ==================
Color chooseSnackBarClr(SnackBarStates state) {
  Color color;
  switch (state) {
    case SnackBarStates.success:
      color = Colors.green;
      break;
    case SnackBarStates.error:
      color = Colors.red;
      break;
    case SnackBarStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

//================== For Navigating To A Screen & Remove All The Previous Screens ==================
void navigateAndFinish(context, {required Widget screen}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => screen),
    (Route<dynamic> route) => false, // remove all previous routes
  );
}

//================== For Navigating To A Screen ==================
navigateTo(context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

//================== For Signing The Current User Out ==================
void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(context, screen: const AuthScreen());
    }
  });
}

//================== For Print A Complete String ==================
void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

//================== For Building A List Of Products In FavoritesScreen & SearchScrean ==================
Widget buildProductsList(
  model,
  double screenHeight,
  double screenWidth,
  BuildContext context, {
  bool isOldPrice = true,
}) =>
    Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.008,
      ),
      child: SizedBox(
        height: screenHeight * 0.2,
        child: Card(
          elevation: screenHeight * 0.01,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.025,
              vertical: screenHeight * 0.015,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        image: NetworkImage(
                          model.image!,
                        ),
                        height: screenHeight * 0.2,
                        width: screenWidth * 0.35,
                      ),
                    ),
                    if (model.discount != 0 && isOldPrice)
                      Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
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
                SizedBox(width: screenWidth * 0.01),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name!,
                        // model.name!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          Text(
                            "\$${model.price.round().toString()}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: defaultColor,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.025),
                          if (model.discount != 0 && isOldPrice)
                            Text(
                              "\$${model.oldPrice.round().toString()}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              ShopAppCubit.getObject(context)
                                  .changeFavorites(model.id!);
                              // print(model.id);
                            },
                            icon: CircleAvatar(
                              radius: screenWidth * 0.1,
                              backgroundColor: ShopAppCubit.getObject(context)
                                      .favorites[model.id]!
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/layout/cubit/states.dart';
import '/models/categories_model.dart';
import '/models/change_favorites_model.dart';
import '/models/favorites_model.dart';
import '/models/home_model.dart';
import '/models/sign_in_model.dart';
import '/modules/categories/categories_screen.dart';
import '/modules/favorites/favorites_screen.dart';
import '/modules/products/products_screen.dart';
import '/modules/settings/settings_screen.dart';
import '/network/end_points.dart';
import '/network/remote/dio_helper.dart';
import '/shared/constants.dart';
import '/styles/colors.dart';

//========================== Main Cubit In The App ==========================
class ShopAppCubit extends Cubit<ShopAppStates> {
  ShopAppCubit() : super(ShopAppInitialState());

  //============ Getting An Object Of The Cubit ============
  static ShopAppCubit getObject(context) => BlocProvider.of(context);

  //============ Current Index Of Bottom Nav Bar Item ============
  int currentIndex = 0;

  //============ Bottom Nav Bar Screens ============
  List<Widget> bottomNavScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  //============ Bottom Nav Bar Content ============
  List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
      backgroundColor: defaultColor,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: "Categories",
      backgroundColor: defaultColor,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: "Favorites",
      backgroundColor: defaultColor,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: "Settings",
      backgroundColor: defaultColor,
    ),
  ];

  //============ App Bar Titles Of Bottom Nav Bar Screens ============
  List<String> titles = [
    "Products",
    "Categories",
    "Favorites",
    "Settings",
  ];

  //============ For Moving Between Bottom Nav Bar Screens ============
  void changeBottomNavIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  //============ For Getting The Products ============
  void getHomeData() {
    emit(LoadingHomeDataState());
    DioHelper.getData(
      pathUrl: homeEndPoint,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      for (ProductsModel element in homeModel!.data!.products) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      }
      emit(SuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  //============ For Getting Categories ============
  void getCategoriesData() {
    DioHelper.getData(
      pathUrl: getCategoriesEndPoint,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(SuccessCategoriesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoriesDataState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  //============ For Making A Product As A Fav Or Not ============
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ChangeFavoritesState());

    DioHelper.postData(
      pathUrl: favoritesEndPoint,
      token: token,
      data: {
        'product_id': productId,
      },
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }

      emit(SuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      print(error.toString());

      favorites[productId] = !favorites[productId]!;

      emit(ErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  //============ For Getting Favorite Products ============
  void getFavorites() {
    emit(LoadingGetFavoritesState());
    DioHelper.getData(
      pathUrl: favoritesEndPoint,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(SuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetFavoritesState());
    });
  }

  SignInModel? userModel;

  //============ For Getting The Current User Data ============
  void getUserData() {
    emit(LoadingGetUserDataState());
    DioHelper.getData(
      pathUrl: profileEndPoint,
      token: token,
    ).then((value) {
      userModel = SignInModel.fromJson(value.data);

      emit(SuccessGetUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetUserDataState());
    });
  }

  //============ For Updating The Current User Data ============
  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(LoadingUpdateUserDataState());
    DioHelper.putData(
      pathUrl: updateEndPoint,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = SignInModel.fromJson(value.data);

      emit(SuccessUpdateUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateUserDataState());
    });
  }
}

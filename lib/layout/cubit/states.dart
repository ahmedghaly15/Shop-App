import '/models/change_favorites_model.dart';
import '/models/sign_in_model.dart';

//========================== Main Cubit States In The App ==========================
abstract class ShopAppStates {}

class ShopAppInitialState extends ShopAppStates {}

class ChangeBottomNavState extends ShopAppStates {}

class LoadingHomeDataState extends ShopAppStates {}

class SuccessHomeDataState extends ShopAppStates {}

class ErrorHomeDataState extends ShopAppStates {}

class SuccessCategoriesDataState extends ShopAppStates {}

class ErrorCategoriesDataState extends ShopAppStates {}

class SuccessChangeFavoritesState extends ShopAppStates {
  final ChangeFavoritesModel model;

  SuccessChangeFavoritesState(this.model);
}

class ChangeFavoritesState extends ShopAppStates {}

class ErrorChangeFavoritesState extends ShopAppStates {}

class LoadingGetFavoritesState extends ShopAppStates {}

class SuccessGetFavoritesState extends ShopAppStates {}

class ErrorGetFavoritesState extends ShopAppStates {}

class LoadingGetUserDataState extends ShopAppStates {}

class SuccessGetUserDataState extends ShopAppStates {
  final SignInModel signInModel;
  SuccessGetUserDataState(this.signInModel);
}

class ErrorGetUserDataState extends ShopAppStates {}

class LoadingUpdateUserDataState extends ShopAppStates {}

class SuccessUpdateUserDataState extends ShopAppStates {
  final SignInModel signInModel;
  SuccessUpdateUserDataState(this.signInModel);
}

class ErrorUpdateUserDataState extends ShopAppStates {}

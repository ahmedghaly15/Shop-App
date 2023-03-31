import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/search_model.dart';
import '/modules/search/cubit/states.dart';
import '/network/end_points.dart';
import '/network/remote/dio_helper.dart';
import '/shared/constants.dart';

//========================== Search Cubit ==========================
class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  //============ Getting An Object Of The Cubit ============
  static SearchCubit getObject(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  //================ For Doing The Search ================
  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(
      pathUrl: searchEndPoint,
      token: token,
      data: {'text': text},
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/modules/search/cubit/cubit.dart';
import '/modules/search/cubit/states.dart';
import '/shared/components/input_field.dart';
import '/shared/constants.dart';
import '/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A Key For The Form
    final GlobalKey<FormState> formKey = GlobalKey();

    // Search Text Field Controller
    TextEditingController searchController = TextEditingController();

    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          // For Getting The Screen Height
          double screenHeight = MediaQuery.of(context).size.height;
          // For Getting The Screen Width
          double screenWidth = MediaQuery.of(context).size.width;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Search"),

              //========== Getting Back Button ==========
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
            //================ Search Text Form Field ================
            body: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.008,
                ),
                child: Column(
                  children: <Widget>[
                    InputField(
                      hint: "Search",
                      controller: searchController,
                      textCapitalization: TextCapitalization.none,
                      obsecure: false,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.search),
                      validating: (val) {
                        if (val!.isEmpty) {
                          return "Enter a text to search";
                        }
                        return null;
                      },
                      onSubmit: (String text) {
                        SearchCubit.getObject(context).search(text);
                      },
                    ),
                    if (state is SearchLoadingState)
                      SizedBox(height: screenHeight * 0.03),
                    if (state is SearchLoadingState)
                      const LinearProgressIndicator(color: defaultColor),
                    if (state is SearchSuccessState)
                      SizedBox(height: screenHeight * 0.03),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) => buildProductsList(
                            SearchCubit.getObject(context)
                                .searchModel!
                                .data!
                                .data![index],
                            screenHeight,
                            screenWidth,
                            context,
                            isOldPrice: false,
                          ),
                          itemCount: SearchCubit.getObject(context)
                              .searchModel!
                              .data!
                              .data!
                              .length,
                          physics: const BouncingScrollPhysics(),
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

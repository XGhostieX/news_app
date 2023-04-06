import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/helpers/cashe_helper.dart';
import 'package:news_app/helpers/dio_helper.dart';

import 'package:news_app/models/states.dart';
import 'package:news_app/screens/business_screen.dart';
import 'package:news_app/screens/sports_screen.dart';
import 'package:news_app/screens/science_screen.dart';
import 'package:news_app/screens/settings_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeAppMode({bool? sharedDark}) {
    if (sharedDark != null) {
      isDark = sharedDark;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CasheHelper.setData("isDark", isDark).then(
        (value) => emit(AppChangeModeState()),
      );
    }
  }
}

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());
  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'Science',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  List<Widget> screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
    const SettingsScreen(),
  ];

  void changeBotNavBar(int index) {
    currentIndex = index;
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    if (business.isEmpty) {
      DioHelper.getData(
        'v2/top-headlines',
        {
          'country': 'us',
          'category': 'business',
          'apiKey': 'ba0d78e2233841aca221f9d893d3b01e',
        },
      ).then(
        (value) {
          business = value.data['articles'];
          emit(NewsGetBusinessSuccessState());
        },
      ).catchError((error) {
        emit(NewsGetBusinessErrorState(error.toString()));
      });
    } else {
      emit(NewsGetBusinessSuccessState());
    }
  }

  List<dynamic> sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingState());
    if (sports.isEmpty) {
      DioHelper.getData(
        'v2/top-headlines',
        {
          'country': 'us',
          'category': 'sports',
          'apiKey': 'ba0d78e2233841aca221f9d893d3b01e',
        },
      ).then(
        (value) {
          sports = value.data['articles'];
          emit(NewsGetSportsSuccessState());
        },
      ).catchError((error) {
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingState());
    if (science.isEmpty) {
      DioHelper.getData(
        'v2/top-headlines',
        {
          'country': 'us',
          'category': 'science',
          'apiKey': 'ba0d78e2233841aca221f9d893d3b01e',
        },
      ).then(
        (value) {
          science = value.data['articles'];
          emit(NewsGetScienceSuccessState());
        },
      ).catchError((error) {
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic> search = [];

  void getSearch(String value) {
    emit(NewsGetSearchLoadingState());
    if (search.isEmpty) {
      DioHelper.getData(
        'v2/everything',
        {
          'q': value,
          'apiKey': 'ba0d78e2233841aca221f9d893d3b01e',
        },
      ).then(
        (value) {
          search = value.data['articles'];
          emit(NewsGetSearchSuccessState());
        },
      ).catchError((error) {
        emit(NewsGetSearchErrorState(error.toString()));
      });
    } else {
      emit(NewsGetSearchSuccessState());
    }
  }
}

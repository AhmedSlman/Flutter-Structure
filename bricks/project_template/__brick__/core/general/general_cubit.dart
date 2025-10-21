import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../localization/localization_helper.dart';
import '../theme/theme_manager.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(GeneralInitial());
  static GeneralCubit get(context) => BlocProvider.of(context);

  //change app theme
  bool isLightMode = true;
  changeAppTheme() {
    isLightMode = !isLightMode;
    // تحديث AppThemeManager
    if (isLightMode) {
      AppThemeManager.instance.setLightTheme();
    } else {
      AppThemeManager.instance.setDarkTheme();
    }
    emit(GeneralChangeAppTheme());
  }

  changeLocale(String localeName) {
    if (LocalizationHelper.currentLanguageName == localeName) return;

    LocalizationHelper.changeLanguage(localeName);
    emit(GeneralChangeLocale(locale: LocalizationHelper.currentLanguageName));
  }

  /// تبديل اللغة
  toggleLanguage() {
    LocalizationHelper.toggleLanguage();
    emit(GeneralChangeLocale(locale: LocalizationHelper.currentLanguageName));
  }
}

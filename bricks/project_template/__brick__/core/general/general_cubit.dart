import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:easy_localization/easy_localization.dart';
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
    if (EasyLocalization.of(context)?.locale.languageCode == localeName) return;

    context.setLocale(Locale(localeName));
    emit(GeneralChangeLocale(locale: EasyLocalization.of(context)?.locale.languageCode ?? 'en'));
  }

  /// تبديل اللغة
  toggleLanguage() {
    final currentLocale = EasyLocalization.of(context)?.locale ?? const Locale('en');
    final newLocale = currentLocale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    context.setLocale(newLocale);
    emit(GeneralChangeLocale(locale: EasyLocalization.of(context)?.locale.languageCode ?? 'en'));
  }
}

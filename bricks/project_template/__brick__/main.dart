import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/localization/localization_helper.dart';
import 'core/locator/locator_setup.dart';
import 'core/utils/utils.dart';
import 'app.dart';
import 'core/general/my_bloc_observer.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Setup all dependencies
    await setupLocator();

    // Init Easy Localization
    await EasyLocalization.ensureInitialized();

    // Bloc observer
    Bloc.observer = MyBlocObserver();

    // Init theme
    await Utils.initTheme();

    runApp(
      EasyLocalization(
        supportedLocales: LocalizationHelper.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: LocalizationHelper.supportedLocales.first,
        child: const MyApp(),
      ),
    );
  }, (error, stackTrace) => log(error.toString(), stackTrace: stackTrace));
}

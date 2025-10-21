import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'core/general/general_cubit.dart';
import 'core/localization/localization_helper.dart';
import 'core/theme/theme_manager.dart';
import 'core/Router/app_router.dart';
import 'core/utils/responsive_framework_widget.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppThemeManager _themeManager;

  @override
  void initState() {
    super.initState();
    _themeManager = AppThemeManager.instance;
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _themeManager.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _themeManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider(
        create: (context) => GeneralCubit(),
        child: BlocConsumer<GeneralCubit, GeneralState>(
          listener: (context, state) {},
          builder: (context, state) {
            final generalCubit = GeneralCubit.get(context);
            return MaterialApp.router(
              title: 'App',
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              theme: AppThemeManager.lightTheme,
              darkTheme: AppThemeManager.darkTheme,
              themeMode: generalCubit.isLightMode
                  ? ThemeMode.light
                  : ThemeMode.dark,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: LocalizationHelper.supportedLocales,
              locale: context.locale,
              builder: (_, child) {
                final botToastBuilder = BotToastInit();
                final smartDialog = FlutterSmartDialog.init();
                child = smartDialog(context, child);
                child = botToastBuilder(context, child);

                // تحديث System UI بناءً على الثيم
                SystemChrome.setSystemUIOverlayStyle(
                  generalCubit.isLightMode
                      ? SystemUiOverlayStyle.dark
                      : SystemUiOverlayStyle.light,
                );

                return AppResponsiveWrapper(child: child!);
              },
            );
          },
        ),
      ),
    );
  }
}

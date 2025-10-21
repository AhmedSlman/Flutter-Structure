import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/data_source/dio_helper.dart';
import '../domain/model/splash_model.dart';
import '../domain/repository/splash_repository.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitial());
  static SplashCubit get(context) => BlocProvider.of(context);
  
  SplashRepository splashRepository =  SplashRepository(locator<DioService>());

  List<OnBoardingModel> onboardingModel = [
    OnBoardingModel(
      stackUrl: "Assets.icons.firstOnboardingCover.path",
      imageUrl: 'Assets.icons.bannerImg.path',
      title: "AppStrings.onboarding1",
      subTitle: "AppStrings.onboardingSubtitle1"
    ),
    OnBoardingModel(
      stackUrl: "Assets.icons.secondOnBoardingCover.path",
      imageUrl: "Assets.icons.meat.path",
      title: "AppStrings.onboarding2",
      subTitle: "AppStrings.onboardingSubtitle2"
    ),
    OnBoardingModel(
      stackUrl: "Assets.icons.thirdOnboradingCover.path",
      imageUrl: "Assets.icons.meats.path",
      title: "AppStrings.onboarding3",
      subTitle:  "AppStrings.onboardingSubtitle2"
    ),
  ];
  int sliderIndex = 0;
 late  PageController controller;
  void updateSliderIndex(int index) {
    sliderIndex = index;
    emit(ChangeIntroState());
  }

}
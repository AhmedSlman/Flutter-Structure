import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitial());

  static SplashCubit get(context) => BlocProvider.of(context);

  Future<void> checkAuthStatus() async {
    emit(SplashLoading());
    // Add authentication check logic here
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashLoaded());
  }
}

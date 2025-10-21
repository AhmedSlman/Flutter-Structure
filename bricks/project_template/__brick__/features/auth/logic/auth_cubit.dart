import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/request/login_request.dart';
import '../data/models/response/user_model.dart';
import '../data/repository/auth_repository.dart';
import '../../../../core/error/result_extensions.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final request = LoginRequest(email: email, password: password);
    final result = await repository.login(request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());

    final request = LoginRequest(email: email, password: password);
    final result = await repository.register(request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());

    final result = await repository.forgotPassword(email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthForgotPasswordSuccess()),
    );
  }

  Future<void> resetPassword(String code, String newPassword) async {
    emit(AuthLoading());

    final result = await repository.resetPassword(code, newPassword);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthResetPasswordSuccess()),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());

    final result = await repository.logout();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthLogoutSuccess()),
    );
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());

    final result = await repository.getCurrentUser();

    result.fold((failure) => emit(AuthError(failure.message)), (user) {
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    });
  }
}

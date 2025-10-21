import '../data/models/response/user_model.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthSuccess extends AuthStates {
  final UserModel user;
  AuthSuccess(this.user);
}

class AuthError extends AuthStates {
  final String message;
  AuthError(this.message);
}

class AuthForgotPasswordSuccess extends AuthStates {}

class AuthResetPasswordSuccess extends AuthStates {}

class AuthLogoutSuccess extends AuthStates {}

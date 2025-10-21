part of 'general_cubit.dart';

@immutable
abstract class GeneralState {}

class GeneralInitial extends GeneralState {}

class GeneralChangeAppTheme extends GeneralState {}

class GeneralChangeLocale extends GeneralState {
  final String locale;
  GeneralChangeLocale({required this.locale});
}

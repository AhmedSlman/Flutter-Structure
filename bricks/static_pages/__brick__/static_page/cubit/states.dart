abstract class StaticPageStates {}

class StaticPageInitial extends StaticPageStates {}

class ContactUsSendSuccess extends StaticPageStates {
  String message;
  ContactUsSendSuccess({required this.message});
}

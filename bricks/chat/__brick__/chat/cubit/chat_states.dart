abstract class ChatStates {}

class ChatInitial extends ChatStates {}

class ChatLoadingState extends ChatStates {}

class ChatErrorState extends ChatStates {}

class ChatSuccessState extends ChatStates {}

class ReceivedMessageState extends ChatStates {}

class MessageUpdatedState extends ChatStates {}

class RefreshStateSuceess extends ChatStates {}

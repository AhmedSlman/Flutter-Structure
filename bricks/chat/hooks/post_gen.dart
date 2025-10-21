import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) {
  final addToRouter = context.vars['addToRouter'] as bool? ?? true;
  final registerRepositories =
      context.vars['registerRepositories'] as bool? ?? true;

  final masonPath = Directory.current.path;
  final projectPath = Directory(masonPath).parent.path;

  if (registerRepositories) {
    _registerRepositories(projectPath, context);
  }

  if (addToRouter) {
    _addRoutes(projectPath, context);
  }

  context.logger.success("✅ Chat module successfully generated!");
  context.logger.info("");
  context.logger.info("📋 Next steps:");
  context.logger.info("  1. Run: flutter pub get");
  context.logger
      .info("  2. Update Pusher credentials in chat/cubit/chat_cubit.dart");
  context.logger.info("  3. Update Google Maps API key");
  context.logger.info("  4. Add Firebase configuration files");
  context.logger.info("");
  context.logger.info("📚 For detailed setup, check DEPENDENCIES.md");
}

void _registerRepositories(String projectPath, HookContext context) {
  final locatorPath = '$projectPath/core/utils/Locator.dart';

  if (!File(locatorPath).existsSync()) {
    context.logger.warn("⚠️  Locator.dart not found at: $locatorPath");
    context.logger.info("   Please register repositories manually:");
    context.logger.info("   - ChatsRepository");
    context.logger.info("   - ChatRepository");
    context.logger.info("   - ChatBotRepository");
    return;
  }

  try {
    final file = File(locatorPath);
    String content = file.readAsStringSync();

    // Check if already registered
    if (content.contains('ChatsRepository') &&
        content.contains('ChatRepository') &&
        content.contains('ChatBotRepository')) {
      context.logger
          .info("ℹ️  Chat repositories already registered in Locator.dart");
      return;
    }

    // Add imports
    final imports = [
      "import '../../features/chats/domain/repository/repository.dart';",
      "import '../../features/chat/domain/repository/repository.dart';",
      "import '../../features/chat_bot/domain/repository/repository.dart';",
    ];

    for (var import in imports) {
      if (!content.contains(import)) {
        // Add after existing imports
        final lastImportIndex = content.lastIndexOf("import ");
        if (lastImportIndex != -1) {
          final lineEnd = content.indexOf('\n', lastImportIndex);
          content = content.substring(0, lineEnd + 1) +
              import +
              '\n' +
              content.substring(lineEnd + 1);
        }
      }
    }

    // Add repository registrations
    final registrations = [
      "  locator.registerLazySingleton(() => ChatsRepository(locator<DioService>()));",
      "  locator.registerLazySingleton(() => ChatRepository(locator<DioService>()));",
      "  locator.registerLazySingleton(() => ChatBotRepository(locator<DioService>()));",
    ];

    // Find the last registerLazySingleton call
    final lastRegisterIndex =
        content.lastIndexOf('locator.registerLazySingleton');
    if (lastRegisterIndex != -1) {
      final lineEnd = content.indexOf('\n', lastRegisterIndex);
      for (var registration in registrations) {
        if (!content.contains(registration)) {
          content = content.substring(0, lineEnd + 1) +
              registration +
              '\n' +
              content.substring(lineEnd + 1);
        }
      }
    }

    file.writeAsStringSync(content);
    context.logger.success("✅ Repositories registered in Locator.dart");
  } catch (e) {
    context.logger.err("❌ Error updating Locator.dart: $e");
  }
}

void _addRoutes(String projectPath, HookContext context) {
  final routerPath = '$projectPath/core/Router/Router.dart';

  if (!File(routerPath).existsSync()) {
    context.logger.warn("⚠️  Router.dart not found at: $routerPath");
    context.logger.info("   Please add routes manually:");
    context.logger.info("   - Routes.chatsScreen");
    context.logger.info("   - Routes.chatScreen");
    context.logger.info("   - Routes.chatBotScreen");
    context.logger.info("   - Routes.VideoCallScreen");
    return;
  }

  try {
    final file = File(routerPath);
    String content = file.readAsStringSync();

    // Check if routes already exist
    if (content.contains('Routes.chatsScreen') &&
        content.contains('Routes.chatScreen')) {
      context.logger.info("ℹ️  Chat routes already exist in Router.dart");
      return;
    }

    // Add imports
    final imports = [
      "import '../../features/chats/presentation/screens/chats_screen.dart';",
      "import '../../features/chat/presentation/screens/chat_screen.dart';",
      "import '../../features/chat/presentation/screens/video_call_screen.dart';",
      "import '../../features/chat_bot/presentation/screens/chat_bot_screen.dart';",
    ];

    for (var import in imports) {
      if (!content.contains(import)) {
        final lastImportIndex = content.lastIndexOf("import ");
        if (lastImportIndex != -1) {
          final lineEnd = content.indexOf('\n', lastImportIndex);
          content = content.substring(0, lineEnd + 1) +
              import +
              '\n' +
              content.substring(lineEnd + 1);
        }
      }
    }

    // Add route constants
    final routeConstants = [
      '  static const String chatsScreen = "chatsScreen";',
      '  static const String chatScreen = "chatScreen";',
      '  static const String chatBotScreen = "chatBotScreen";',
      '  static const String videoCallScreen = "videoCallScreen";',
    ];

    final routesClassIndex = content.indexOf("class Routes");
    if (routesClassIndex != -1) {
      final classEndIndex = _findClassEndIndex(content, routesClassIndex);
      if (classEndIndex != -1) {
        for (var routeConst in routeConstants) {
          if (!content.contains(routeConst)) {
            content = content.substring(0, classEndIndex) +
                '\n$routeConst\n' +
                content.substring(classEndIndex);
          }
        }
      }
    }

    // Add route cases
    final routeCases = '''
  case Routes.chatsScreen:
    return CupertinoPageRoute(
      settings: routeSettings,
      builder: (_) => const ChatsScreen(),
    );
    
  case Routes.chatScreen:
    return CupertinoPageRoute(
      settings: routeSettings,
      builder: (_) => ChatScreen(
        userId: (routeSettings.arguments as ChatArgs?)?.userId,
        chatId: (routeSettings.arguments as ChatArgs?)?.chatId,
        name: (routeSettings.arguments as ChatArgs?)?.name,
        image: (routeSettings.arguments as ChatArgs?)?.image,
      ),
    );
    
  case Routes.chatBotScreen:
    return CupertinoPageRoute(
      settings: routeSettings,
      builder: (_) => const ChatBotScreen(),
    );
    
  case Routes.videoCallScreen:
    return CupertinoPageRoute(
      settings: routeSettings,
      builder: (_) => VideoCall(
        channel: (routeSettings.arguments as VideoCallArgs?)?.channelName ?? '',
        token: (routeSettings.arguments as VideoCallArgs?)?.token ?? '',
        uid: (routeSettings.arguments as VideoCallArgs?)?.uid ?? 0,
      ),
    );
''';

    final switchIndex = content.indexOf("switch (routeSettings.name)");
    if (switchIndex != -1 && !content.contains('case Routes.chatsScreen:')) {
      final defaultIndex = content.indexOf("default:", switchIndex);
      if (defaultIndex != -1) {
        content = content.substring(0, defaultIndex) +
            routeCases +
            '\n' +
            content.substring(defaultIndex);
      }
    }

    // Add ChatArgs class if not exists
    if (!content.contains('class ChatArgs')) {
      final chatArgsClass = '''

class ChatArgs {
  final String? userId;
  final String? chatId;
  final String? name;
  final String? image;

  ChatArgs({this.userId, this.chatId, this.name, this.image});
}

class VideoCallArgs {
  final String channelName;
  final String token;
  final int uid;

  VideoCallArgs({
    required this.channelName,
    required this.token,
    required this.uid,
  });
}
''';
      content = content + chatArgsClass;
    }

    file.writeAsStringSync(content);
    context.logger.success("✅ Routes added to Router.dart");
  } catch (e) {
    context.logger.err("❌ Error updating Router.dart: $e");
  }
}

int _findClassEndIndex(String content, int classStartIndex) {
  int openBraces = 0;
  for (int i = classStartIndex; i < content.length; i++) {
    if (content[i] == '{') {
      openBraces++;
    } else if (content[i] == '}') {
      openBraces--;
      if (openBraces == 0) {
        return i;
      }
    }
  }
  return -1;
}

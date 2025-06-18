import 'package:MetatechCRM/features/invoice/InvoiceScreen.dart';
import 'package:MetatechCRM/features/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;

import '../features/dashboard/dashboard_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/support/bloc/chat_bloc.dart';
import '../features/support/chat_conversation_screen.dart';
import '../features/support/chat_feature.dart';
import '../features/support/models/chat.dart';
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home': return MaterialPageRoute(builder: (_) => DashboardScreen());
      case '/invoices': return MaterialPageRoute(builder: (_) => InvoiceListScreen());
      case '/addInvoice':
        return MaterialPageRoute(builder: (_) => const AddInvoiceScreen());

      case '/support':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<ChatBloc>(context),
            child: ChatFeature(),
          ),
        );

      case '/chatDetail':
        final args = settings.arguments;
        if (args is! Chat) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Error: Invalid or missing chat data')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<ChatBloc>(context),
            child: ChatConversationScreen(chat: args),
          ),
        );
        // support end


    case '/profile': return MaterialPageRoute(builder: (_) => ProfileScreen());
      default: return MaterialPageRoute(builder: (_) => DashboardScreen());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/chat_bloc.dart';
import 'chat_home_screen.dart';

class ChatFeature extends StatelessWidget {
  const ChatFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc()..add(LoadChats()),
      lazy: false, // Ensure ChatBloc is created immediately
      child: const ChatHomeScreen(),
    );
  }
}
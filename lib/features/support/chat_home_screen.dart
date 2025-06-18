import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';
import '../../design_system/dimensions.dart';
import '../../widgets/CustomAppBar.dart';
import '../../widgets/customDrawer.dart';
import 'bloc/chat_bloc.dart';
import 'chat_list_screen.dart';
import 'create_ticket_form.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  void _showCreateTicketForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.cardRadius(context)),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
        ),
        // Wrap CreateTicketForm with BlocProvider to ensure access to ChatBloc
        child: BlocProvider.value(
          value: context.read<ChatBloc>(),
          child: const CreateTicketForm(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: const ChatListScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        onPressed: () => _showCreateTicketForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';
import '../../design_system/dimensions.dart';
import 'bloc/chat_bloc.dart';
import 'models/chat.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        print('ChatListScreen: Building with state: $state'); // Debug print
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF075E54)));
        } else if (state is ChatLoaded) {
          if (state.chats.isEmpty) {
            return const Center(child: Text('No tickets available'));
          }
          return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final chat = state.chats[index];
              return ChatListItem(chat: chat);
            },
          );
        } else if (state is ChatError) {
          return Center(
            child: Text(
              state.message,
              style: AppTextStyles.textTheme(context).bodyLarge?.copyWith(
                color: AppColors.error,
              ),
            ),
          );
        }
        return const Center(child: Text('Unexpected state. Please try again.'));
      },
    );
  }
}

class ChatListItem extends StatelessWidget {
  final Chat chat;

  const ChatListItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (itemContext) => ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chat.avatarUrl),
          radius: AppDimensions.iconSize(context) / 2,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              chat.contactName,
              style: AppTextStyles.textTheme(context).titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              chat.priority,
              style: AppTextStyles.textTheme(context).bodySmall?.copyWith(
                color: chat.priority == 'High'
                    ? Colors.red
                    : chat.priority == 'Medium'
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat.lastMessage,
              style: AppTextStyles.textTheme(context).bodyMedium?.copyWith(
                color: Colors.black54,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Status: ${chat.status}',
              style: AppTextStyles.textTheme(context).bodySmall?.copyWith(
                color: Colors.black54,
              ),
            ),
          ],
        ),
        trailing: Text(
          _formatTime(chat.lastMessageTime),
          style: AppTextStyles.textTheme(context).bodySmall?.copyWith(
            color: Colors.black54,
          ),
        ),
        onTap: () {
          print('ChatListItem: Navigating to /support with chat ID: ${chat.id}'); // Debug print
          Navigator.pushNamed(itemContext, '/chatDetail', arguments: chat);
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}';
  }
}
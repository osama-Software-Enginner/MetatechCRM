import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_text_styles.dart';
import '../../design_system/dimensions.dart';
import 'bloc/chat_bloc.dart';
import 'models/chat.dart';
import 'models/message.dart';

class ChatConversationScreen extends StatefulWidget {
  final Chat chat;

  const ChatConversationScreen({super.key, required this.chat});

  @override
  _ChatConversationScreenState createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('Loading messages for chat ID: ${widget.chat.id}'); // Debug print
    context.read<ChatBloc>().add(LoadMessages(widget.chat.id));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        elevation: AppDimensions.elevationLow(context),
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                print('Navigating back from ChatConversationScreen'); // Debug print
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.avatarUrl),
              radius: AppDimensions.iconSizeSmall(context) / 2,
            ),
          ],
        ),
        title: Text(
          widget.chat.contactName,
          style: AppTextStyles.textTheme(context).titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                print('ChatConversationScreen state: $state'); // Debug print
                if (state is MessagesLoaded && state.chatId == widget.chat.id) {
                  if (state.messages.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(AppDimensions.padding(context)),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[state.messages.length - 1 - index];
                      return MessageBubble(message: message);
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: CircularProgressIndicator(color: Color(0xFF075E54)));
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding(context),
        vertical: AppDimensions.paddingSmall(context),
      ),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: AppTextStyles.textTheme(context).bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.buttonRadius(context) * 2),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF075E54)),
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                context.read<ChatBloc>().add(
                  SendMessage(widget.chat.id, _messageController.text.trim()),
                );
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.isSentByMe;
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppDimensions.marginSmall(context)),
        padding: EdgeInsets.all(AppDimensions.padding(context)),
        decoration: BoxDecoration(
          color: isSentByMe ? const Color(0xFFDCF8C6) : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content,
              style: AppTextStyles.textTheme(context).bodyMedium?.copyWith(
                color: Colors.black,
              ),
            ),
            SizedBox(height: AppDimensions.spacingSmall(context)),
            Text(
              _formatTime(message.timestamp),
              style: AppTextStyles.textTheme(context).bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
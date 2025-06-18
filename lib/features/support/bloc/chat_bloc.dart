import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat.dart';
import '../models/message.dart';

// BLoC Events
abstract class ChatEvent {}

class LoadChats extends ChatEvent {}
class LoadMessages extends ChatEvent {
  final String chatId;
  LoadMessages(this.chatId);
}
class SendMessage extends ChatEvent {
  final String chatId;
  final String content;
  SendMessage(this.chatId, this.content);
}
class CreateTicketEvent extends ChatEvent {
  final String customerName;
  final String issueDescription;
  final String priority;

  CreateTicketEvent({
    required this.customerName,
    required this.issueDescription,
    required this.priority,
  });
}

// BLoC States
abstract class ChatState {}

class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Chat> chats;
  ChatLoaded(this.chats);
}
class MessagesLoaded extends ChatState {
  final String chatId;
  final List<Message> messages;
  MessagesLoaded(this.chatId, this.messages);
}
class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

// Chat BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatLoading()) {
    on<LoadChats>(_onLoadChats);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<CreateTicketEvent>(_onCreateTicket);
  }

  final List<Chat> _chats = [
    Chat(
      id: '1',
      contactName: 'John Doe',
      lastMessage: 'Issue with my order',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      avatarUrl: 'https://picsum.photos/200',
      priority: 'High',
      status: 'Open',
    ),
    Chat(
      id: '2',
      contactName: 'Jane Smith',
      lastMessage: 'Need help with login',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      avatarUrl: 'https://picsum.photos/201',
      priority: 'Medium',
      status: 'Open',
    ),
  ];

  final Map<String, List<Message>> _messages = {
    '1': [
      Message(
        id: 'm1',
        chatId: '1',
        senderId: 'john',
        content: 'Issue with my order',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isSentByMe: false,
      ),
      Message(
        id: 'm2',
        chatId: '1',
        senderId: 'agent',
        content: 'Can you provide the order number?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        isSentByMe: true,
      ),
    ],
    '2': [
      Message(
        id: 'm3',
        chatId: '2',
        senderId: 'jane',
        content: 'Need help with login',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isSentByMe: false,
      ),
    ],
  };

  void _onLoadChats(LoadChats event, Emitter<ChatState> emit) {
    emit(ChatLoaded(_chats));
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) {
    final messages = _messages[event.chatId] ?? [];
    emit(MessagesLoaded(event.chatId, messages));
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    final message = Message(
      id: Random().nextInt(100000).toString(),
      chatId: event.chatId,
      senderId: 'agent',
      content: event.content,
      timestamp: DateTime.now(),
      isSentByMe: true,
    );

    _messages[event.chatId] ??= [];
    _messages[event.chatId]!.add(message);

    final chatIndex = _chats.indexWhere((chat) => chat.id == event.chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = Chat(
        id: _chats[chatIndex].id,
        contactName: _chats[chatIndex].contactName,
        lastMessage: event.content,
        lastMessageTime: DateTime.now(),
        avatarUrl: _chats[chatIndex].avatarUrl,
        priority: _chats[chatIndex].priority,
        status: _chats[chatIndex].status,
      );
    }

    emit(MessagesLoaded(event.chatId, _messages[event.chatId]!));
    emit(ChatLoaded(_chats));
  }

  void _onCreateTicket(CreateTicketEvent event, Emitter<ChatState> emit) {
    final ticketId = (Random().nextInt(100000) + 3).toString();
    final now = DateTime.now();

    final newChat = Chat(
      id: ticketId,
      contactName: event.customerName,
      lastMessage: event.issueDescription,
      lastMessageTime: now,
      avatarUrl: 'https://picsum.photos/seed/$ticketId/200',
      priority: event.priority,
      status: 'Open',
    );

    _chats.add(newChat);

    final newMessage = Message(
      id: 'm${Random().nextInt(100000)}',
      chatId: ticketId,
      senderId: event.customerName.toLowerCase().replaceAll(' ', '_'),
      content: event.issueDescription,
      timestamp: now,
      isSentByMe: false,
    );

    _messages[ticketId] = [newMessage];

    emit(ChatLoaded(_chats));
  }
}
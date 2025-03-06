import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class QuickReply {
  final String question;
  final String answer;

  const QuickReply({
    required this.question,
    required this.answer,
  });
}

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;
  final bool showQuickReplies;
  final List<QuickReply> quickReplies;
  final bool showAllQuickReplies;

  ChatbotState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
    this.showQuickReplies = true,
    this.showAllQuickReplies = false,
    this.quickReplies = const [
      QuickReply(
        question: "1. Who can donate blood?",
        answer: "Anyone who:\n• Is between 18 and 65 years old\n• Weighs at least 50 kg\n• Is in good health and free from infections\n• Has not donated blood in the past 3 months (for men) or 4 months (for women)\n• Meets other health and lifestyle criteria set by medical professionals",
      ),
      QuickReply(
        question: "2. Can I donate blood if I have a medical condition?",
        answer: "Some conditions may prevent you from donating, such as:\n• Hypertension (if not well managed)\n• Diabetes (if insulin-dependent)\n• Recent infections, malaria, or certain chronic diseases\n\nConsult a medical professional before donating.",
      ),
      QuickReply(
        question: "3. Can pregnant or breastfeeding women donate blood?",
        answer: "No, for their own health and the baby's well-being, pregnant and breastfeeding women should not donate blood.",
      ),
      QuickReply(
        question: "4. Where can I donate blood?",
        answer: "You can donate at designated blood donation centers, hospitals, or during special blood drives. Donix will help you find the nearest approved donation center.",
      ),
      QuickReply(
        question: "5. How often can I donate blood?",
        answer: "Men can donate every 3 months, while women should wait at least 4 months between donations.",
      ),
      QuickReply(
        question: "6. Is blood donation safe?",
        answer: "Yes. Blood donation is conducted under strict medical supervision using sterile equipment, ensuring there is no risk of infection.",
      ),
      QuickReply(
        question: "7. Will donating blood make me weak?",
        answer: "No. Your body replenishes the lost blood within a few weeks. However, you might feel slightly tired for a short time, so it's recommended to rest and stay hydrated after donating.",
      ),
      QuickReply(
        question: "8. How does Donix help with blood donation?",
        answer: "Donix connects blood donors with patients in need. You can:\n• Receive real-time donation requests\n• Find nearby donation centers\n• Track your donation history\n• Chat with patients after accepting a request",
      ),
      QuickReply(
        question: "9. Is there any reward for donating blood?",
        answer: "While blood donation is a voluntary and lifesaving act, some hospitals and blood banks may offer incentives such as health checkups or appreciation certificates. Donix plans to introduce a gamification system to recognize and reward frequent donors.",
      ),
      QuickReply(
        question: "10. How do I register as a blood donor on Donix?",
        answer: "Once registration is available, you can sign up in the app, complete a donor profile, and start receiving blood donation requests.",
      ),
    ],
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
    bool? showQuickReplies,
    bool? showAllQuickReplies,
    List<QuickReply>? quickReplies,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
      showQuickReplies: showQuickReplies ?? this.showQuickReplies,
      showAllQuickReplies: showAllQuickReplies ?? this.showAllQuickReplies,
      quickReplies: quickReplies ?? this.quickReplies,
    );
  }
}

class ChatbotNotifier extends StateNotifier<ChatbotState> {
  ChatbotNotifier() : super(ChatbotState());

  void sendMessage(String text) async {
    // Add user message
    state = state.copyWith(
      messages: [
        ChatMessage(text: text, isUser: true),
        ...state.messages,
      ],
      isTyping: true,
      showQuickReplies: false,
    );

    try {
      // Find matching quick reply or generate response
      String response = '';
      final matchingReply = state.quickReplies.firstWhere(
            (reply) => reply.question.toLowerCase().contains(text.toLowerCase()),
        orElse: () => QuickReply(
          question: '',
          answer: "I understand you're asking about '$text'. To help you better, please choose a question number from 1 to 10, or ask your question more specifically.",
        ),
      );
      response = matchingReply.answer;

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Add bot response
      state = state.copyWith(
        messages: [
          ChatMessage(text: response, isUser: false),
          ...state.messages,
        ],
        isTyping: false,
        showQuickReplies: true,
      );
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Failed to send message. Please try again.',
      );
    }
  }

  void toggleShowAllQuickReplies() {
    state = state.copyWith(showAllQuickReplies: !state.showAllQuickReplies);
  }

  void clearChat() {
    state = ChatbotState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final chatbotProvider =
StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  return ChatbotNotifier();
});

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatbotState = ref.watch(chatbotProvider);
    final chatbotNotifier = ref.read(chatbotProvider.notifier);

    // Show only the first 3 quick replies initially
    final visibleQuickReplies = chatbotState.showAllQuickReplies
        ? chatbotState.quickReplies
        : chatbotState.quickReplies.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: chatbotNotifier.clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              reverse: true, // Newest messages at the bottom
              itemCount: chatbotState.messages.length,
              itemBuilder: (context, index) {
                final message = chatbotState.messages[index];
                return ChatMessageWidget(message: message);
              },
            ),
          ),

          // Quick Replies
          if (chatbotState.showQuickReplies)
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: visibleQuickReplies.map((reply) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            chatbotNotifier.sendMessage(reply.question);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: Text(
                            reply.question,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (!chatbotState.showAllQuickReplies)
                  TextButton(
                    onPressed: chatbotNotifier.toggleShowAllQuickReplies,
                    child: const Text('Show More'),
                  ),
              ],
            ),

          // Message Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (text) {
                      chatbotNotifier.sendMessage(text);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = ''; // Replace with actual text input
                    chatbotNotifier.sendMessage(text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
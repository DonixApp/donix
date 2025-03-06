import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../utils/chatbot_provider.dart';
import '../widgets/typing_indicator.dart';
import '../utils/theme_notifier.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatbotProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDarkMode = ref.watch(themeProvider);

    Widget content = Expanded(
      child: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty
                ? _buildWelcomeMessage(isTablet)
                : ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: isTablet ? size.width * 0.1 : 16,
              ),
              itemCount: state.messages.length + (state.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (state.isTyping && index == 0) {
                  return _buildTypingIndicator(isDarkMode);
                }
                final messageIndex = index - (state.isTyping ? 1 : 0);
                return _buildMessageBubble(
                  state.messages[messageIndex],
                  isDarkMode,
                  isTablet,
                );
              },
            ),
          ),
          if (state.error != null)
            Container(
              color: Colors.red.withOpacity(0.1),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => ref.read(chatbotProvider.notifier).clearError(),
                  ),
                ],
              ),
            ),
          _buildQuickReplySection(state, isDarkMode, isTablet),
          _buildInputArea(isDarkMode, isTablet),
        ],
      ),
    );

    // For tablets, constrain the width
    if (isTablet) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: content,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donix Assistant',
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showClearConfirmation(context, isDarkMode),
            tooltip: 'Clear chat history',
          ),
        ],
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
      ),
      body: content,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'chatbot_emergency_fab', // Add this line
        onPressed: () => _showEmergencyDialog(context),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.warning_amber, color: Colors.white),
        label: const Text(
          'Emergency',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: isTablet ? 64 : 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to Donix Assistant',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How can I help you today?',
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      ChatMessage message,
      bool isDarkMode,
      bool isTablet,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
        message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            _buildAvatar(isBot: true, isDarkMode: isDarkMode),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: message.isUser
                          ? Theme.of(context).primaryColor
                          : isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(isBot: false, isDarkMode: isDarkMode),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isBot, required bool isDarkMode}) {
    return CircleAvatar(
      backgroundColor:
      isBot ? Theme.of(context).primaryColor : Colors.blue,
      child: isBot
          ? Text(
        'D',
        style: TextStyle(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )
          : Icon(
        Icons.person,
        color: isDarkMode ? Colors.grey[900] : Colors.white,
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _buildAvatar(isBot: true, isDarkMode: isDarkMode),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Typing',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(width: 8),
                const TypingIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplySection(
      ChatbotState state,
      bool isDarkMode,
      bool isTablet,
      ) {
    if (!state.showQuickReplies) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final reply in state.quickReplies)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () => ref
                            .read(chatbotProvider.notifier)
                            .sendMessage(reply.question),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 16,
                            vertical: isTablet ? 16 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          reply.question,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!state.showAllQuickReplies)
              TextButton(
                onPressed: () => ref
                    .read(chatbotProvider.notifier)
                    .toggleShowAllQuickReplies(),
                child: const Text('Show More'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isDarkMode, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Ask me anything...',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 16,
                    vertical: isTablet ? 16 : 12,
                  ),
                ),
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
                size: isTablet ? 28 : 24,
              ),
              onPressed: _sendMessage,
              tooltip: 'Send message',
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    ref.read(chatbotProvider.notifier).sendMessage(text);
    _controller.clear();

    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showClearConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text(
          'Are you sure you want to clear all messages? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(chatbotProvider.notifier).clearChat();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Clear'),
          ),
        ],
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert'),
        content: const Text(
          'This will send an emergency alert to your contacts. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement emergency alert logic here
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );
  }
}
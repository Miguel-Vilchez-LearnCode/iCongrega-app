import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/theme/theme_helpers.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';

class ChatMessage {
  final String text;
  final DateTime time;
  final bool isMe;

  ChatMessage({required this.text, required this.time, required this.isMe});
}

class ChatChurchScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String avatarUrl;

  const ChatChurchScreen({super.key, required this.title, required this.subtitle, required this.avatarUrl});

  @override
  State<ChatChurchScreen> createState() => _ChatChurchScreenState();
}

class _ChatChurchScreenState extends State<ChatChurchScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // mensajes simples
    _messages.addAll([
      ChatMessage(text: 'Hola, ¿cómo estás?', time: DateTime.now().subtract(Duration(minutes: 10)), isMe: false),
      ChatMessage(text: 'Bien, gracias. Revisé la actividad de la iglesia.', time: DateTime.now().subtract(Duration(minutes: 9)), isMe: true),
      ChatMessage(text: 'Perfecto, gracias por el update.', time: DateTime.now().subtract(Duration(minutes: 2)), isMe: false),
    ]);
    // scroll to bottom after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, time: DateTime.now(), isMe: true));
    });
    _controller.clear();
    // small delay then scroll
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = context.palette;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.botDark),
            onPressed: () {},
          )
        ],
        title:widget.title,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg.isMe;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical:6),
                    child: Row(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isMe)
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: Image.network(widget.avatarUrl, fit: BoxFit.cover).image,
                          ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: isMe ? context.colors.surfaceContainer : context.colors.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: context.colors.shadow,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: context.colors.outline),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(msg.text, style: GoogleFonts.inter(color: isMe ? context.colors.background : AppColors.botDark)),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      '${msg.time.hour.toString().padLeft(2,'0')}:${msg.time.minute.toString().padLeft(2,'0')}',
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 10, color: isMe ? AppColors.neutralMidDark : AppColors.neutralSecondaryLight),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isMe)
                          SizedBox(
                            width: 46,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundImage: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6eL5RUT4tdMCYufPglpc8GU6qSbbIF8WbPA&s', fit: BoxFit.cover).image,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo9wFvKsH3hSLUw5QY9Z6ZqwMJo6UPJ1r8l1c8fABphNtbP76XPR9aPwx6aqwiOcO0t6A&usqp=CAU', fit: BoxFit.cover).image,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: context.colors.primary)),
                boxShadow: [BoxShadow(color: context.colors.shadow, blurRadius: 6, offset: Offset(-2, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.shadow, blurRadius: 6, offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Mensaje...',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          filled: true,
                          fillColor: context.colors.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: palette.primaryLight,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send_sharp, color: AppColors.botDark),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

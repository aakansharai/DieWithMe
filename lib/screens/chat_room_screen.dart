import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/message.dart';
import '../services/supabase_service.dart';
import '../utils/name_generator.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  const ChatRoomScreen({super.key, required this.roomId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final String _username = NameGenerator.generate();

  @override
  void initState() {
    super.initState();
    SupabaseService.updateMemberCount(widget.roomId, 1);
  }

  @override
  void dispose() {
    SupabaseService.updateMemberCount(widget.roomId, -1);
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    final message = ChatMessage(
      id: '', // Supabase will generate this
      roomId: widget.roomId,
      username: _username,
      content: _controller.text,
      createdAt: DateTime.now(),
    );

    SupabaseService.sendMessage(message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'VOID_ROOM_${widget.roomId.substring(0, 4).toUpperCase()}',
          style: GoogleFonts.jetBrainsMono(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(color: Colors.red, height: 1, thickness: 0.5),
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: SupabaseService.getMessages(widget.roomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final isMe = msg.username == _username;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.username.toUpperCase(),
                            style: GoogleFonts.jetBrainsMono(
                              color: isMe ? Colors.blueAccent : Colors.greenAccent,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg.content,
                            style: GoogleFonts.jetBrainsMono(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.red, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: Colors.red,
              style: GoogleFonts.jetBrainsMono(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'TYPE_A_MESSAGE...',
                hintStyle: GoogleFonts.jetBrainsMono(color: Colors.grey[700]),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: Colors.red),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

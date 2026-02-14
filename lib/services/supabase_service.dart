import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';
import '../models/room.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  static Future<ChatRoom> getOrCreateRoom() async {
    // Find a room that is not full
    final response = await client
        .from('rooms')
        .select()
        .eq('is_full', false)
        .order('created_at', ascending: true)
        .limit(1)
        .maybeSingle();

    if (response != null) {
      final room = ChatRoom.fromJson(response);
      return room;
    } else {
      // Create a new room
      final newRoomResponse = await client
          .from('rooms')
          .insert({'member_count': 1, 'is_full': false})
          .select()
          .single();
      return ChatRoom.fromJson(newRoomResponse);
    }
  }

  static Stream<List<ChatMessage>> getMessages(String roomId) {
    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: true)
        .map((data) => data.map((json) => ChatMessage.fromJson(json)).toList());
  }

  static Future<void> sendMessage(ChatMessage message) async {
    await client.from('messages').insert(message.toJson());
  }

  static Future<void> updateMemberCount(String roomId, int delta) async {
    // This is simplified; in a real app, you'd use a RPC or transaction
    final roomResponse = await client
        .from('rooms')
        .select('member_count')
        .eq('id', roomId)
        .single();

    int currentCount = roomResponse['member_count'];
    int newCount = currentCount + delta;

    await client
        .from('rooms')
        .update({'member_count': newCount, 'is_full': newCount >= 8})
        .eq('id', roomId);
  }
}

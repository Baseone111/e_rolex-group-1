import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDetailPage extends StatelessWidget {
  final String chatId;
  final String vendorId;
  final String message;
  final Map<String, dynamic>? product;

  ChatDetailPage({
    required this.chatId,
    required this.vendorId,
    required this.message,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var msg in messages) {
                  final msgData = msg.data() as Map<String, dynamic>;

                  messageWidgets.add(
                    ListTile(
                      title: Text(msgData['text'] ?? ''),
                      subtitle: Text(msgData['senderId'] ?? ''),
                      trailing: Text(_formatTimestamp(msgData['timestamp'])),
                    ),
                  );
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onSubmitted: (text) {
                _sendMessage(text);
              },
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Handle message send action
              _sendMessage(_messageController.text);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.isNotEmpty) {
      final messageData = {
        'senderId': vendorId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'readBy': [],
      };

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatId)
          .collection('messages')
          .add(messageData);

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatId)
          .update({
        'lastMessage': text,
      });
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 1) {
      return '${date.month}/${date.day}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}

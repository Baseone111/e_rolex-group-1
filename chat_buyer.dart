import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPageBuyer extends StatefulWidget {
  final String chatId; // Unique ID for the chatroom
  final String productId; // Product ID for the chat
  final String vendorId; // Vendor ID for the chat

  ChatPageBuyer({
    required this.chatId,
    required this.productId,
    required this.vendorId,
  });

  @override
  _ChatPageBuyerState createState() => _ChatPageBuyerState();
}

class _ChatPageBuyerState extends State<ChatPageBuyer> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  Map<String, dynamic>? _buyerData;

  @override
  void initState() {
    super.initState();
    _fetchBuyerData();
  }

  Future<void> _fetchBuyerData() async {
    _currentUser = _auth.currentUser;

    if (_currentUser != null) {
      try {
        DocumentSnapshot buyerDoc = await FirebaseFirestore.instance
            .collection('buyers')
            .doc(_currentUser!.uid)
            .get();

        setState(() {
          _buyerData = buyerDoc.data() as Map<String, dynamic>?;
        });
      } catch (e) {
        print("Error fetching buyer data: $e");
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty && _buyerData != null) {
      final messageData = {
        'senderId': _currentUser!.uid,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'product': {
          'productId': widget.productId,
        },
        'senderProfile': {
          'profileImage': _buyerData!['profileImage'],
          'fullName': _buyerData!['fullName'],
        },
      };

      try {
        await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.chatId)
            .collection('messages')
            .add(messageData);

        await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.chatId)
            .update({
          'lastMessage': _messageController.text,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
        });

        _messageController.clear();
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Vendor')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  final messageData = message.data() as Map<String, dynamic>;
                  final isSentByCurrentUser =
                      messageData['senderId'] == _currentUser!.uid;

                  messageWidgets.add(
                    ListTile(
                      title: Text(messageData['message']),
                      subtitle: Text(
                        messageData['senderProfile']['fullName'] ?? 'Unknown',
                      ),
                      trailing: isSentByCurrentUser
                          ? const Icon(Icons.sentiment_satisfied)
                          : null,
                    ),
                  );
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_details_page.dart';

class ChatPageVendor extends StatefulWidget {
  final String userId; // Current vendor's ID

  ChatPageVendor({required this.userId});

  @override
  _ChatPageVendorState createState() => _ChatPageVendorState();
}

class _ChatPageVendorState extends State<ChatPageVendor>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _sendMessage(
      String chatId, Map<String, dynamic>? product) async {
    if (_messageController.text.isNotEmpty) {
      final messageData = {
        'senderId': widget.userId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'product': product != null
            ? {
                'productName': product['productName'],
                'price': product['price'],
                'quantity': product['quantity'],
                'imageUrl': product['imageUrl'],
                'description': product['description'],
              }
            : null,
        'senderProfile': {
          'profileImage': 'path_to_vendor_profile_image',
          'fullName': 'Vendor Name',
        },
      };

      try {
        await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatId)
            .collection('messages')
            .add(messageData);

        await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatId)
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
      appBar: AppBar(
        title: Text('Chats'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Chats'),
            Tab(text: 'Status'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatList(),
          Center(child: Text('Status Page')), // Placeholder for status page
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .where('participants', arrayContains: widget.userId)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final chatrooms = snapshot.data!.docs;

              List<Widget> chatList = [];

              for (var chatroom in chatrooms) {
                final chatData = chatroom.data() as Map<String, dynamic>;
                final buyerProfile =
                    chatData['buyerProfile'] as Map<String, dynamic>?;

                if (buyerProfile != null) {
                  chatList.add(
                    ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: CircleAvatar(
                        backgroundImage: buyerProfile['profileImage'] != null
                            ? NetworkImage(
                                buyerProfile['profileImage'] as String)
                            : AssetImage('assets/default_avatar.png')
                                as ImageProvider<Object>,
                        radius: 30.0,
                      ),
                      title: Text(
                        buyerProfile['fullName'] ?? 'No Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(chatroom.id)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> messageSnapshot) {
                          if (!messageSnapshot.hasData) {
                            return Text('No message');
                          }

                          final messages = messageSnapshot.data!.docs;
                          if (messages.isEmpty) {
                            return Text('No message');
                          }

                          final messageData =
                              messages.first.data() as Map<String, dynamic>;
                          return Text(
                            messageData['message'] ?? 'No message',
                            style: TextStyle(color: Colors.black87),
                          );
                        },
                      ),
                      onTap: () {
                        // Navigate to detailed chat view with product details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailPage(
                              chatId: chatroom.id,
                              vendorId: widget.userId,
                              message: '',
                              product: chatData['product'],
                            ),
                          ),
                        );
                      },
                      trailing: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(chatroom.id)
                            .collection('messages')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> messageSnapshot) {
                          if (!messageSnapshot.hasData) {
                            return SizedBox.shrink();
                          }

                          final messages = messageSnapshot.data!.docs;
                          if (messages.isEmpty) {
                            return SizedBox.shrink();
                          }

                          final messageData =
                              messages.first.data() as Map<String, dynamic>;
                          final timestamp =
                              messageData['timestamp'] as Timestamp?;
                          return Text(
                            _formatTimestamp(timestamp),
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  );
                }
              }

              return ListView(
                children: chatList.isNotEmpty
                    ? chatList
                    : [
                        Center(
                          child: Text('No messages available.'),
                        ),
                      ],
              );
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageInput() {
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
                // Handle message send action
              },
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Implement sending message functionality
              // Replace `chatId` and `product` with appropriate values
              _sendMessage('exampleChatId', null);
            },
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 1) {
      return '${date.month}/${date.day}';
    } else if (difference.inHours > 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

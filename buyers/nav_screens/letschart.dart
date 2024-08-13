// import 'package:buyerapp/controllers/chat_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class LetsChat extends StatefulWidget {
//   final String chatId;
//   final Map<String, dynamic> product;

//   LetsChat({required this.chatId, required this.product});

//   @override
//   _LetsChatState createState() => _LetsChatState();
// }

// class _LetsChatState extends State<LetsChat> {
//   final TextEditingController _controller = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _sendMessage() async {
//     if (_controller.text.isEmpty) return;

//     final User? user = _auth.currentUser;
//     if (user == null) return;

//     final message = ChatMessage(
//       text: _controller.text,
//       senderId: user.uid,
//       timestamp: Timestamp.now(),
//     );

//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .collection('messages')
//         .add(message.toMap());

//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with Vendor'),
//       ),
//       body: Column(
//         children: [
//           // Display product details at the top
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.product['productName'],
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text('Price: ${widget.product['price']} UGX'),
//                 const SizedBox(height: 4),
//                 Text('Quantity: ${widget.product['quantity']}'),
//                 const SizedBox(height: 8),
//                 Image.network(
//                   widget.product['imageUrl'],
//                   height: 100,
//                   fit: BoxFit.cover,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(widget.chatId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var messages = snapshot.data!.docs.map((doc) {
//                   return ChatMessage.fromDocument(doc);
//                 }).toList();

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var message = messages[index];
//                     return ListTile(
//                       title: Text(message.text),
//                       subtitle: Text(message.senderId),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       tileColor: message.senderId == _auth.currentUser?.uid
//                           ? Colors.blueAccent
//                           : Colors.grey.shade200,
//                       textColor: message.senderId == _auth.currentUser?.uid
//                           ? Colors.white
//                           : Colors.black,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/services/chat/services.dart';
import 'package:messenger/features/widgets/text_field.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessages() async {
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserId, _messageController.text);

      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail)),
      body: Column(
        children: [
          /// messages
          Expanded(
              child: _buildMessageList(),
          ),

          /// user input
          _buildMessageInput()
        ],
      ),
    );
  }
  
  /// build message list
  Widget _buildMessageList(){
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserId,
            _firebaseAuth.currentUser!.uid
        ),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text('Error${snapshot.error}');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text('loading...');
          }
          return ListView(
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        },
    );
  }
  /// build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align messages
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft);

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderEmail']),
          Text(data['message']),
        ],
      ),
    );
  }
  /// build message input
  Widget _buildMessageInput(){
    return Row(
      children: [
        // textfield
        Expanded(
          child: MyTextField(
              controller: _messageController,
              hintText: 'Type a message...',
              obscureText: false,
          ),
        ),
        
        // send button
        IconButton(onPressed: sendMessages, icon: Icon(Icons.send_rounded, size: 40)),
      ],
    );
  } 
}

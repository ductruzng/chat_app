import 'package:auth_firebase/components/chat_bubble.dart';
import 'package:auth_firebase/components/my_textField.dart';
import 'package:auth_firebase/services/auth/auth_service.dart';
import 'package:auth_firebase/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to the focus node
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
      // cause a delay so that the keyboard has time to show up
      // then the amount of remaining space will be calculated,
      // then scroll down
      Future.delayed(
        const Duration(microseconds: 500),
        () => scrollDown(),
      );
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
      scrollDown();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.receiverEmail),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            // display messages
            Expanded(child: _buildMessageList()),

            // user input
            _buildUserInput(),

            const SizedBox(height: 10),
          ],
        ));
  }

  // build the message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // data
        return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList());
      },
    );
  }

// build a list item for each message
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is the current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // align the message to the right if the sender is the current user, otherwise align it to the left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              message: data['message'],
              isCurrentUser: isCurrentUser,
            ),
          ],
        ));
  }

  // build the user input
  Widget _buildUserInput() {
    return Row(
      children: [
        // textfield
        Expanded(
          child: MyTextfield(
            controller: _messageController,
            hintText: 'Type a message',
            obscureText: false,
            focusNode: _focusNode,
          ),
        ),

        // send button
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(50),
          ),
          margin: const EdgeInsets.only(right: 25),
          child: IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: sendMessage,
          ),
        ),
      ],
    );
  }
}

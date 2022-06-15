// ignore_for_file: deprecated_member_use, prefer_const_constructors, use_key_in_widget_constructors, unused_import, unused_field, unused_local_variable, await_only_futures, avoid_print, non_constant_identifier_names, avoid_types_as_parameter_names, prefer_const_constructors_in_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constrain.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
User logInUser;
double counter = 0.0;

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    getCureentUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String messegeText;
  final controller = TextEditingController();
  void getCureentUser() async {
    final user = await _auth.currentUser;
    try {
      if (user != null) {
        logInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessegesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        messegeText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection("messeges").add(
                        {
                          "text": messegeText,
                          "sender": logInUser.email,
                          "time": DateTime.now().microsecondsSinceEpoch,
                        },
                      );

                      controller.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessegesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messeges").orderBy("time").snapshots(),
      builder: (context, AsyncSnapshot) {
        if (!AsyncSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(color: Colors.lightBlueAccent),
          );
        }
        final messeges = AsyncSnapshot.data.docs.reversed;
        List<MessegeBubble> messegeWidget = [];
        for (var msg in messeges) {
          final messegeText = msg["text"];
          final messegeSender = msg["sender"];
          final currentUser = logInUser.email;
          final messegeBubble = MessegeBubble(
            messegeText,
            messegeSender,
            currentUser == messegeSender,
          );
          messegeWidget.add(messegeBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            children: messegeWidget,
          ),
        );
      },
    );
  }
}

class MessegeBubble extends StatelessWidget {
  MessegeBubble(this.text, this.sender, this.isMe);
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Material(
            elevation: 10,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe ? Colors.grey[900] : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

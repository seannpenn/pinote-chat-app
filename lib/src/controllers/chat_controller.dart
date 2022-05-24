import 'dart:async';

import 'package:chat_app/src/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatController with ChangeNotifier {
  ChatMessage ?chatMessage;
  late StreamSubscription _chatSub;
  List<ChatMessage> chats = [];

  ChatController() {
    _chatSub = ChatMessage.currentChats().listen(chatUpdateHandler);
  }

  @override
  void dispose() {
    _chatSub.cancel();
    super.dispose();
  }

  chatUpdateHandler(List<ChatMessage> update) {
    chats = update;
    notifyListeners();
  }
  // updateMessage(String newDetails) {
  //   chatMessage?.updateDetails(newDetails);
  //   notifyListeners();
  // }
  Future updateMessage(String newDetails) async {
    // FirebaseFirestore.instance.collection('chats').doc().update();
    // print(message.doc().);
    chatMessage?.updateDetails(newDetails);
  }

  Future sendMessage({required String message}) {
    return FirebaseFirestore.instance.collection('chats').add(ChatMessage(
            sentBy: FirebaseAuth.instance.currentUser!.uid, message: message,)
        .json);
  }
}
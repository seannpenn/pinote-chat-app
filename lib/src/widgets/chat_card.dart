import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/chat_message_model.dart';

class ChatCard extends StatelessWidget {
  final Function()? onLongPress;
  final Function()? onTap;

  ChatCard({Key? key, required this.chat, this.onLongPress, this.onTap})
      : super(key: key);

  final ChatController _chatController = ChatController();
  final ChatMessage chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            left:
                chat.sentBy == FirebaseAuth.instance.currentUser?.uid ? 60 : 10,
            bottom: 10,
            top: 10,
            right: chat.sentBy == FirebaseAuth.instance.currentUser?.uid
                ? 10
                : 60),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: chat.sentBy == FirebaseAuth.instance.currentUser?.uid
              ? Colors.white
              : Colors.yellow,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                color: chat.sentBy == FirebaseAuth.instance.currentUser?.uid
                    ? Colors.white
                    : Colors.yellow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<ChatUser>(
                        future: ChatUser.fromUid(uid: chat.sentBy),
                        builder: (context, AsyncSnapshot<ChatUser> snap) {
                          if (snap.hasData) {
                            return Text(chat.sentBy ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? 'You sent:'
                                : '${snap.data?.username} sent');
                          }
                          return const Text('User');
                        }),
                    Text(chat.message),

                    //'Message seen by ${chat.seenBy}')
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (chat.sentBy == FirebaseAuth.instance.currentUser?.uid)
                  Text(chat.edited ? 'edited' : ''),
                  
                const SizedBox(
                  width: 10,
                ),
                Text(chat.tapped ? chat.dateFormatter(chat.ts.toDate()) : '')
              ],
            ),
          ],
        ),
      ),
    );
  }
}

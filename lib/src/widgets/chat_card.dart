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
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            left: chat.sentBy == currentUserId ? 60 : 10,
            bottom: 10,
            top: 10,
            right: chat.sentBy == currentUserId ? 10 : 60),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: chat.sentBy == currentUserId
                  ? const Radius.circular(24)
                  : const Radius.circular(0),
              bottomLeft: chat.sentBy == currentUserId
                  ? const Radius.circular(24)
                  : const Radius.circular(24),
              bottomRight: const Radius.circular(24),
              topRight: chat.sentBy == currentUserId
                  ? const Radius.circular(0)
                  : const Radius.circular(24)),
          color: chat.sentBy == currentUserId ? Colors.teal[400] : Colors.white,
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
                padding: const EdgeInsets.only(left: 15, top: 5),
                color:
                    chat.sentBy == currentUserId ? Colors.teal[400] : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<ChatUser>(
                        future: ChatUser.fromUid(uid: chat.sentBy),
                        builder: (context, AsyncSnapshot<ChatUser> snap) {
                          if (snap.hasData) {
                            if(chat.message == 'You deleted a message.'){
                              return const Text('');
                            }
                            else{
                              return Text(chat.sentBy == currentUserId
                                ? 'You sent:'
                                : '${snap.data?.username} sent');
                            }
                            
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
                if (chat.sentBy == currentUserId)
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

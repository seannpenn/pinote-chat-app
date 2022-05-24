// import 'package:chat_app/models/chat_user_model.dart';
// import 'package:chat_app/src/controllers/chat_controller.dart';
// import 'package:flutter/material.dart';

// import '../../../service_locators.dart';
// import '../../controllers/auth_controller.dart';

// class HomeScreen extends StatefulWidget {
//   static const String route = 'home-screen';
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final AuthController _auth = locator<AuthController>();
//   final ChatController _chatController = ChatController();

//   final TextEditingController _messageController = TextEditingController();
//   final FocusNode _messageFN = FocusNode();
//   final ScrollController _scrollController = ScrollController();

//   ChatUser? user;
//   @override
//   void initState() {
//     ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
//       if (mounted) {
//         setState(() {
//           user = value;
//         });
//       }
//     });
//     _chatController.addListener(scrollToBottom);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _chatController.removeListener(scrollToBottom);
//     _messageFN.dispose();
//     _messageController.dispose();
//     _chatController.dispose();
//     super.dispose();
//   }

//   scrollToBottom() async {
//     await Future.delayed(const Duration(milliseconds: 250));
//     print('scrolling to bottom');
//     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//         curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chatting from ${user?.username ?? '...'}'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _auth.logout();
//             },
//             icon: const Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Signed in'),
//             IconButton(
//                 onPressed: () async {
//                   _auth.logout();
//                 },
//                 icon: const Icon(Icons.logout)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/widgets/chat_card.dart';
import 'package:chat_app/src/widgets/input_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../service_locators.dart';
import '../../models/chat_message_model.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _auth = locator<AuthController>();
  final ChatController _chatController = ChatController();

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();
  final ScrollController _scrollController = ScrollController();

  ChatUser? user;
  @override
  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
    _chatController.addListener(scrollToBottom);
    super.initState();
  }

  @override
  void dispose() {
    _chatController.removeListener(scrollToBottom);
    _messageFN.dispose();
    _messageController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 250));
    print('scrolling to bottom');
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Chatting from ${user?.username ?? '...'}'),
        actions: [
          IconButton(
              onPressed: () {
                _auth.logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                  animation: _chatController,
                  builder: (context, Widget? w) {
                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          for (ChatMessage chat in _chatController.chats)
                            ChatCard(
                              chat: chat,
                              onLongPress: () {
                                // showEditDialog(context, chat);
                                showMessageOptions();
                              },
                            )
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onFieldSubmitted: (String text) {
                        send();
                      },
                      focusNode: _messageFN,
                      controller: _messageController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.redAccent,
                    ),
                    onPressed: send,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  testPrint() {
    print('Hello onlongpress is working!!');
  }

  send() {
    _messageFN.unfocus();
    if (_messageController.text.isNotEmpty) {
      _chatController.sendMessage(message: _messageController.text.trim());
      _messageController.text = '';
    }
  }

  showEditDialog(BuildContext context, ChatMessage chatMessage) async {
    ChatMessage? result = await showDialog<ChatMessage>(
        context: context,
        //if you don't want issues on navigator.pop, rename the context in the builder to something other than context
        builder: (dContext) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: InputWidget(
              current: chatMessage.message,
            ),
          );
        });
    if (result != null) {
      _chatController.updateMessage(result.message);
    }
  }

  showMessageOptions() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Align(
            child: AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
              actions: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Edit')),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Delete'),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}

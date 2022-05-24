import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatMessage {
  late String message;
  final String uid, sentBy, seenBy;
  late Timestamp ts;
  bool tapped = false;
  final bool edited;

  ChatMessage(
      {this.edited = false,this.uid = '', required this.sentBy, this.seenBy = '', this.message = '', Timestamp? ts})
      : ts = ts ?? Timestamp.now();

  String dateFormatter(DateTime dt){
    final DateFormat formatter = DateFormat.yMd().add_jm();
    final String formatted = formatter.format(dt);

    return formatted;
  }
  static ChatMessage fromDocumentSnap(DocumentSnapshot snap) {
    Map<String, dynamic> json = snap.data() as Map<String, dynamic>;
    return ChatMessage(
      uid: snap.id,
      sentBy: json['sentBy'] ?? '',
      edited: json['edited'] ?? false,
      seenBy: json['seenBy']?? '',
      message: json['message'] ?? '',
      ts: json['ts'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> get json =>
      {'sentBy': sentBy, 'seenBy': seenBy, 'message': message, 'ts': ts, 'edited': edited};

  static List<ChatMessage> fromQuerySnap(QuerySnapshot snap) {
    try {
      return snap.docs.map(ChatMessage.fromDocumentSnap).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Stream<List<ChatMessage>> currentChats() => FirebaseFirestore.instance
      .collection('chats')
      .orderBy('ts')
      .snapshots()
      .map(ChatMessage.fromQuerySnap);


    updateDetails(String update){
      FirebaseFirestore.instance.collection('chats').doc(uid).update({'message':update, 'edited': true});
      print('done update');
    }
    deleteMessage(){
      FirebaseFirestore.instance.collection('chats').doc(uid).delete();
      print('message with $uid is deleted.');
    }

    showMessageDetails(){
      tapped = !tapped;
    }
}
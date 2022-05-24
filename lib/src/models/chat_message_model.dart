import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatMessage {
  late String message;
  final String uid, sentBy, seenBy;
  late Timestamp ts;

  ChatMessage(
      {this.uid = '', required this.sentBy, this.seenBy = '', this.message = '', Timestamp? ts})
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
      seenBy: json['seenBy']?? '',
      message: json['message'] ?? '',
      ts: json['ts'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> get json =>
      {'sentBy': sentBy, 'seenBy': seenBy, 'message': message, 'ts': ts};

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
    message = update;
    ts = Timestamp.now();
  }
}
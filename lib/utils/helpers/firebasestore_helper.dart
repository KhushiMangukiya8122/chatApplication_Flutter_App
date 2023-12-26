import 'package:cloud_firestore/cloud_firestore.dart';

mixin DBMixin {
  Future addUser({required Map<String, dynamic> data});

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUser();

  Future<void> deleteUser({required String id});

  Future<void> createChatDoc({required String uid1, required String uid2});

  Future<void> sendChatMessage(
      {required String uid1, required String uid2, required String msg});

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> displayMessage(
      {required String uid1, required String uid2});
}

class FirestoreHelper with DBMixin {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future addUser({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore.collection("records").doc("users").get();

    Map<String, dynamic>? fetchedData = documentSnapshot.data();

    int id = (fetchedData == null) ? 0 : fetchedData['id'];
    int length = (fetchedData == null) ? 0 : fetchedData['length'];

    //TODO: check if a user already exist or not

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection("users").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
        querySnapshot.docs;

    bool isUserAlreadyExists = false;

    for (QueryDocumentSnapshot<Map<String, dynamic>> element in allDocs) {
      if (data['uid'] == element.data()['uid']) {
        isUserAlreadyExists = true;
        break;
      } else {
        isUserAlreadyExists = false;
        break;
      }
    }

    if (isUserAlreadyExists == false) {
      await firebaseFirestore.collection("users").doc("${++id}").set(data);

      await firebaseFirestore
          .collection("records")
          .doc("users")
          .update({"id": id, "length": ++length});
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUser() {
    return firebaseFirestore.collection("users").snapshots();
  }

  @override
  Future<void> deleteUser({required String id}) async {
    await firebaseFirestore.collection("users").doc(id).delete();

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firebaseFirestore.collection("records").doc("users").get();

    Map<String, dynamic>? fetchedData = documentSnapshot.data();

    int length = (fetchedData == null) ? 0 : fetchedData['length'];

    await firebaseFirestore
        .collection("record")
        .doc("users")
        .update({"length": --length});
  }

  Future<void> createChatDoc(
      {required String uid1, required String uid2}) async {
    String chatDocId = "${uid1}_$uid2";
    String reverseChatId = "${uid2}_$uid1";
    bool isChatExists = false;
    String? chatId;

    QuerySnapshot<Map<String, dynamic>> chatDocs =
        await firebaseFirestore.collection("chat").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocList =
        chatDocs.docs;

    for (var element in chatDocList) {
      if (element.id == chatDocId || element.id == reverseChatId) {
        isChatExists = true;
        chatId = element.id;
        break;
      }
    }

    if (isChatExists == false) {
      await firebaseFirestore.collection("chat").doc("${uid1}_$uid2").set({
        "users": [uid1, uid2],
      });
    }
  }

  Future<void> sendChatMessage(
      {required String uid1, required String uid2, required String msg}) async {
    String chatDocId = "${uid1}_$uid2";
    String reverseChatId = "${uid2}_$uid1";
    String? chatId;

    QuerySnapshot<Map<String, dynamic>> chatDocs =
        await firebaseFirestore.collection("chat").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocList =
        chatDocs.docs;

    for (var element in chatDocList) {
      if (element.id == chatDocId || element.id == reverseChatId) {
        chatId = element.id;
        break;
      }
    }

    await firebaseFirestore
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .add(
      {
        "msg": msg,
        "timestamp": FieldValue.serverTimestamp(),
        "sendBy": uid1,
        "receivedBy": uid2,
      },
    );
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> displayMessage(
      {required String uid1, required String uid2}) async {
    await createChatDoc(uid1: uid1, uid2: uid2);

    String chatDocId = "${uid1}_$uid2";
    String reverseChatId = "${uid2}_$uid1";
    String? chatId;

    QuerySnapshot<Map<String, dynamic>> chatDocs =
        await firebaseFirestore.collection("chat").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocList =
        chatDocs.docs;

    for (var element in chatDocList) {
      if (element.id == chatDocId || element.id == reverseChatId) {
        chatId = element.id;
        break;
      }
    }

    return firebaseFirestore
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}

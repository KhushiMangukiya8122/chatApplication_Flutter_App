import 'package:firebase_messaging/firebase_messaging.dart';

class FCMHelper {
  FCMHelper._();
  static final FCMHelper fcmHelper = FCMHelper._();

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> fetchFCMToken() async {
    String? token = await firebaseMessaging.getToken();

    print("==========================");
    print("TOKEN : $token");
    print("==========================");

    return token;

  }
}

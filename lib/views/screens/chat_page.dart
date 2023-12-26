import 'package:chat_application/utils/globals.dart';
import 'package:chat_application/utils/helpers/firebase_auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/helpers/firebasestore_helper.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController sendmessageController = TextEditingController();
  String? msg;

  @override
  Widget build(BuildContext context) {
    List<String> args =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
            ),
            SizedBox(width: 10,),
            Text("${args[2].split("@")[0]}",),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.videocam,
              size: 30,
            ),
          ),
          IconButton(
            //ok
            onPressed: () {},
            icon: Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 12,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: StreamBuilder(
                stream: allMessages,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>> data =
                        snapshot.data as QuerySnapshot<Map<String, dynamic>>;

                    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                        (data == null) ? [] : data.docs;

                    return (allDocs.isEmpty)
                        ? Center(
                            child: Text("No any Message Yet..."),
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: allDocs.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    (allDocs[index].data()['sendBy'] ==
                                            FirebaseAuthHelper
                                                .firebaseAuth.currentUser!.uid)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        (allDocs[index].data()['sendBy'] ==
                                                FirebaseAuthHelper.firebaseAuth
                                                    .currentUser!.uid)
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 15,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Chip(
                                            label: Text(
                                              "${allDocs[index].data()['msg']}",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Transform.scale(
                      scale: 0.95,
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.photo_camera_back,
                            size: 30,
                          ),
                          hintText: "Enter Your Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                        ),
                        controller: sendmessageController,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () async {
                        await FirestoreHelper.firestoreHelper.sendChatMessage(
                          msg: sendmessageController.text,
                          uid1: args[0],
                          uid2: args[1],
                        );
                        sendmessageController.clear();
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

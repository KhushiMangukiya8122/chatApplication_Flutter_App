
import 'package:chat_application/utils/helpers/fcm_helper.dart';
import 'package:chat_application/utils/helpers/firebasestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/signIn_controller.dart';
import '../../utils/globals.dart';
import '../../utils/helpers/firebase_auth_helper.dart';
import 'dart:io';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

final FlutterContactPicker contactPicker = new FlutterContactPicker();
Contact? contact;

  String SelectedOption = "Option 1";


  File? image;

  Future<void> getImageFromCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
    }
  }

  Future<void> getImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
    }
  }

  int initialIndex = 0;


  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)!.settings.arguments as User?;

    SignInController signInController = Get.put(SignInController());

    double height = Get.height;
    double width = Get.width;

    return SafeArea(
      child: IndexedStack(
          index: initialIndex,

        children: [


          Scaffold(
            drawer: Drawer(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.08,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        foregroundImage: (user!.photoURL == null)
                            ? (image != null)
                            ? FileImage(File(image!.path),)
                            : AssetImage("assets/images/login/user.png") as ImageProvider
                            : NetworkImage(user.photoURL!) as ImageProvider?,
                        child: Text("Add"),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Your Image Source",
                                ),
                                content: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          getImageFromCamera();
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text("Camera"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          getImageFromGallery();
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Text("Gallery"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        child: Icon(Icons.add),
                        mini: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  (user!.email == null)
                      ? Text("Email : Anonymous User")
                      : Text("Email : ${user!.email}"),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: height * 0.02,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      IconButton(
                        onPressed: () async {
                          await FirebaseAuthHelper.firebaseAuthHelper.signOut();
                          signInController.signOut();
                          Get.offNamedUntil("/signUp_page", (route) => false);
                        },
                        icon: const Icon(Icons.logout_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: Text(
                "Home page",
              ),
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "Option 1",
                      child: Row(
                        children: [
                          const Icon(
                            Icons.group,
                          ),
                          SizedBox(width: 10,),
                          const Text("New Group"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "Option 2",
                      child: Row(
                        children: [
                          const Icon(Icons.broadcast_on_personal,),
                          SizedBox(width: 10,),
                          const Text("New Broadcast"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "Option 3",
                      child: Row(
                        children: [
                          const Icon(Icons.phonelink,),
                          SizedBox(width: 10,),
                          const Text("Linked Device"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "Option 4",
                      child: Row(
                        children: [
                          const Icon(Icons.star,),
                          SizedBox(width: 10,),
                          const Text("Starred messages"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "Option 5",
                      child: Row(
                        children: [
                          const Icon(Icons.payment,),
                          SizedBox(width: 10,),
                          const Text("Payments"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "Option 6",
                      child: Row(
                        children: [
                          const Icon(Icons.settings,),
                          SizedBox(width: 10,),
                          const Text("Settings"),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (selectedOption) {
                    setState(() {
                      SelectedOption = selectedOption;
                    });
                    if (selectedOption == "Option 1") {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: 600,
                          );
                        },
                      );
                    } else if (selectedOption == "Option 2") {
                      setState(() {
                        initialIndex = 1;
                      });
                    } else if (selectedOption == "Option 3") {
                      setState(() {
                        initialIndex = 2;
                      });
                    } else if (selectedOption == "Option 4") {
                      setState(() {
                        initialIndex = 3;
                      });
                    } else if (selectedOption == "Option 5") {
                      setState(() {
                        initialIndex = 4;
                      });
                    } else if (selectedOption == "Option 6") {
                      setState(() {
                        initialIndex = 5;
                      });
                    }
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: Transform.scale(
                      scale: 0.9,
                      child: SearchBar(
                        onTap: () {},
                        leading: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Icon(
                            CupertinoIcons.search,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 8,
                    child: StreamBuilder(
                      stream: FirestoreHelper.firestoreHelper.fetchAllUser(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("${snapshot.error}"),
                          );
                        } else if (snapshot.hasData) {
                          QuerySnapshot<Map<String, dynamic>> data =
                          snapshot.data as QuerySnapshot<Map<String, dynamic>>;

                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          allDocs = data.docs;

                          Set<String> uniqueSet = {};

                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          uniqueList = allDocs
                              .where((e) => uniqueSet.add(e.data()['uid']))
                              .toList();

                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          documents = [];

                          for (int i = 0; i < uniqueList.length; i++) {
                            if (user!.uid != uniqueList[i].data()['uid']) {
                              documents.add(uniqueList[i]);
                            }
                          }

                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              return (documents[index]['uid'] ==
                                  FirebaseAuthHelper
                                      .firebaseAuth.currentUser!.uid)
                                  ? Container()
                                  : Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      allMessages = await FirestoreHelper.firestoreHelper
                                          .displayMessage(
                                        uid1: FirebaseAuthHelper
                                            .firebaseAuth.currentUser!.uid,
                                        uid2: documents[index]['uid'],
                                      );
                                      Get.toNamed(
                                        "/chat_page",
                                        arguments: <String>[
                                          FirebaseAuthHelper
                                              .firebaseAuth.currentUser!.uid,
                                          documents[index]['uid'],
                                          documents[index]['email'],
                                        ],
                                      );
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "This contact is confirm delete??",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.of(context).pop();
                                                        });
                                                      },
                                                      child: Text("Dissmiss"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        await FirestoreHelper
                                                            .firestoreHelper
                                                            .deleteUser(
                                                            id: allDocs[index]
                                                                .id);
                                                        setState(() {
                                                          Navigator.of(context).pop();
                                                        });
                                                      },
                                                      child: Text("ok"),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    leading: CircleAvatar(
                                      radius: 30,
                                          foregroundImage: (documents[index].data()['email'] != null)
                                          ? AssetImage("assets/images/login/user.png")
                                          : NetworkImage(user.photoURL!) as ImageProvider,
                                    ),
                                    title: Text(
                                      documents[index].data()['email'].split("@")[0],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Text(
                                        documents[index].data()['email']
                                    ),
                                  ),
                                  Divider(),
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
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                  Contact? contact = await contactPicker.selectContact();
                  setState(() {
                    contact = contact;
                  });
                },
              child: Icon(Icons.contacts),
            ),

          ),

          Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    initialIndex = 0;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.red,
                ),
              ),
            ),
          ),

          Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    initialIndex = 0;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),

          Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    initialIndex = 0;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.pink,
                ),
              ),
            ),
          ),

          Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    initialIndex = 0;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.brown,
                ),
              ),
            ),
          ),

          Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    initialIndex = 0;
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.green,
                ),
              ),
            ),
          ),


        ],
      )
    );
  }
}


// IconButton(
// onPressed: () async {
// // await FirestoreHelper.firestoreHelper
// //     .updateUser(
// //   id: allDocs[index].id,
// //   email: 'Khushi Mangukiya',
// // );
// },
// icon: Icon(
// Icons.edit,
// ),
// ),


// import 'package:flutter/material.dart';
// import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final FlutterContactPicker _contactPicker = new FlutterContactPicker();
//   Contact? _contact;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Contact Picker Example App'),
//         ),
//         body: new Center(
//           child: new Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               new MaterialButton(
//                 color: Colors.blue,
//                 child: new Text("CLICK ME"),
//                 onPressed: () async {
//                   Contact? contact = await _contactPicker.selectContact();
//                   setState(() {
//                     _contact = contact;
//                   });
//                 },
//               ),
//               new Text(
//                 _contact == null ? 'No contact selected.' : _contact.toString(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
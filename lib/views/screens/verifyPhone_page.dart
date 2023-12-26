import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/error_message.dart';
import '../../utils/helpers/firebase_auth_helper.dart';

class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage({super.key});

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {

  final GlobalKey<FormState> verifyCodeFormKey = GlobalKey<FormState>();

  final TextEditingController phoneNumberVerifyController = TextEditingController();
  bool verifyLoading = false;

  @override
  Widget build(BuildContext context) {

    String verificationID =
    ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/login.PNG",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Phone No.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                            },
                            child: Text(
                              "phone Number",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Form(
                        key: verifyCodeFormKey,
                        child: Transform.scale(
                          scale: 0.8,
                          child: TextFormField(
                            onTap: () async {
                              setState(() {
                                verifyLoading = true;
                              });
                              var mergingCodeAndVerificationID = PhoneAuthProvider.credential(
                                verificationId: verificationID!,
                                smsCode: phoneNumberVerifyController.text,
                              );
                              await FirebaseAuthHelper.firebaseAuth
                                  .signInWithCredential(mergingCodeAndVerificationID)
                                  .then(
                                    (value) {
                                  Get.toNamed('/home_page');
                                  setState(() {
                                    verifyLoading = false;
                                  });
                                },
                              ).onError(
                                    (error, stackTrace) {
                                  setState(() {
                                    verifyLoading = false;
                                  });
                                  Utils()
                                      .errorMassage(massage: error.toString().split(']')[1]);
                                },
                              );
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              prefixIcon: Icon(
                                Icons.phone_locked,
                                size: 30,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              border: const OutlineInputBorder(),
                              hintText: "6 Digit Code",
                              hintStyle: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            controller: phoneNumberVerifyController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 105,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 70,
                          ),
                          Container(
                            child: TextButton(
                              child: Text(
                                "Verify ➡",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  verifyLoading = true;
                                });
                                var mergingCodeAndVerificationID = PhoneAuthProvider.credential(
                                  verificationId: verificationID,
                                  smsCode: phoneNumberVerifyController.text,
                                );
                                await FirebaseAuthHelper.firebaseAuth
                                    .signInWithCredential(mergingCodeAndVerificationID)
                                    .then(
                                      (value) {
                                    Get.toNamed('home_page');
                                    setState(() {
                                      verifyLoading = false;
                                    });
                                  },
                                ).onError(
                                      (error, stackTrace) {
                                    setState(() {
                                      verifyLoading = false;
                                    });
                                    Utils()
                                        .errorMassage(massage: error.toString().split(']')[1]);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 85,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Map<String, dynamic> data =
                                  await FirebaseAuthHelper
                                      .firebaseAuthHelper
                                      .signInWithGoogle();

                                  if (data['user'] != null) {
                                    Get.snackbar(
                                      'Successfully',
                                      "Login Successfully",
                                      backgroundColor: Colors.green,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                    );
                                    Get.offAllNamed('/home_page',
                                        arguments: data['user']);
                                  } else {
                                    Get.snackbar(
                                      'Failed',
                                      data['msg'],
                                      backgroundColor: Colors.red,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                },
                                child: CircleAvatar(
                                  child: Image.asset(
                                    "assets/images/google.png",
                                  ),
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 45,
                              ),
                              CircleAvatar(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    "assets/images/facebook.png",
                                  ),
                                ),
                                radius: 16,
                                backgroundColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


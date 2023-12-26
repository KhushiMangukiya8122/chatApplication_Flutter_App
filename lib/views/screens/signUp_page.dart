import 'package:chat_application/utils/helpers/fcm_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../../controllers/error_message.dart';
import '../../controllers/signIn_controller.dart';
import '../../utils/helpers/firebase_auth_helper.dart';
import '../../utils/helpers/local_notification_helper.dart';
import '../../utils/helpers/theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with WidgetsBindingObserver {
  int initialIndex = 0;

  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneVeryficationFormKey = GlobalKey<FormState>();

  SignInController signInController = Get.put(SignInController());

  final TextEditingController emailSignInController = TextEditingController();
  final TextEditingController passwordSignInController =
      TextEditingController();

  final TextEditingController usernameSignUpController =
      TextEditingController();
  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController passwordSignUpController =
      TextEditingController();
  final TextEditingController signUpConfirmPasswordController =
      TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  String? signInemail;
  String? signInpassword;
  String? token;

  String? signUpusername;
  String? signUpemail;
  String? signUppassword;
  String? signUpConfirmPassword;

  int? phoneNumber;
  int? phoneNumberVerify;
  bool phoneLoading = false;
  bool verifyLoading = false;

  @override
  void initState() {
    super.initState();

    getToken();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    tz.initializeTimeZones();

    LocalNotificationHelper.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("========================================");
        print("PAYLOAD: ${response.payload}");
        print("========================================");
      },
    );

    WidgetsBinding.instance.addObserver(this);
  }

  getToken() async {
    token = await FCMHelper.fcmHelper.fetchFCMToken();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {
      print("Inactive State");
    }
    if (state == AppLifecycleState.paused) {
      print("Paused State");
    }
    if (state == AppLifecycleState.detached) {
      print("Detached State");
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: initialIndex,
      children: [

        //todo:signIn
        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/login/login.PNG",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> user = await FirebaseAuthHelper
                                .firebaseAuthHelper
                                .anonymousLogin(token: token!);

                            if (user['user'] != null) {

                              Get.offAllNamed('/home_page',
                                  arguments: user['user']);

                              Get.snackbar(
                                "Success",
                                "SignIn Successfully...",
                                backgroundColor: Colors.green,
                                snackPosition: SnackPosition.BOTTOM,
                              );

                              signInController.signIn();
                              emailSignInController.clear();
                              passwordSignInController.clear();
                            } else {
                              Get.snackbar(
                                "Failed",
                                user['msg'],
                                backgroundColor: Colors.redAccent,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }


                            if (user != null) {
                              Get.snackbar(
                                "Anonymously",
                                "Sign in Successfully...",
                              );
                              Get.offNamedUntil("/home_page", (route) => false, arguments: user['user']);
                            } else {
                              Get.snackbar(
                                "Anonymously",
                                "Sign in Failed...",
                              );
                            }

                          },
                          child: Text(
                            "Guest",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Form(
                      key: signInFormKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.09,
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: TextFormField(
                              onSaved: (val) {
                                signInemail = val;
                              },
                              // validator: (val) =>
                              //     (val!.isEmpty) ? "Enter a Email" : null,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    size: 30,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  border: const OutlineInputBorder(),
                                  hintText: "Your Email/User Name",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  )),
                              controller: emailSignInController,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: TextFormField(
                              controller: passwordSignInController,
                              onSaved: (val) {
                                signInpassword = val;
                              },
                              // validator: (val) =>
                              //     (val!.isEmpty) ? "Enter a Password" : null,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: true,
                              decoration: InputDecoration(
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.password,
                                    size: 30,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  border: const OutlineInputBorder(),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                        ),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "      By Logging / Signing Up in, You agree to our",
                      style: TextStyle(color: Colors.white),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Terms Of Service",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: "  And  ",
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.2,
                        ),
                        Container(
                          child: TextButton(
                            child: Text(
                              "LOGIN ➡",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (signInFormKey.currentState!.validate()) {
                                signInFormKey.currentState!.save();

                                Map<String, dynamic> data =
                                    await FirebaseAuthHelper.firebaseAuthHelper
                                        .signinWithEmailPassword(
                                  email: signInemail!,
                                  password: signInpassword!,
                                  token: token!,
                                );

                                if (data['user'] != null) {

                                  Get.offAllNamed('/home_page',
                                      arguments: data['user']);

                                  Get.snackbar(
                                    "Success",
                                    "SignIn Successfully...",
                                    backgroundColor: Colors.green,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );

                                  signInController.signIn();
                                  emailSignInController.clear();
                                  passwordSignInController.clear();
                                } else {
                                  Get.snackbar(
                                    "Failed",
                                    data['msg'],
                                    backgroundColor: Colors.redAccent,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.12,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: Get.width * 0.02,
                            ),
                            GestureDetector(
                              onTap: () async {
                                Map<String, dynamic> data =
                                    await FirebaseAuthHelper.firebaseAuthHelper
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
                                child: Image.asset("assets/images/login/google.png"),
                                radius: 16,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  initialIndex = 1;
                                });
                              },
                              child: Transform.rotate(
                                angle: 0.65,
                                child: Text(
                                  "Create New One",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: boldText),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: Get.width * 0.14,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    "assets/images/login/facebook.png",
                                  ),
                                ),
                                radius: 16,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        //todo:signup
        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/login/login.PNG",
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
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    initialIndex = 2;
                                  });
                                },
                                child: Text(
                                  "phone Number",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.09,
                          ),
                          Form(
                            key: signUpFormKey,
                            child: Column(
                              children: [
                                Transform.scale(
                                  scale: 0.7,
                                  child: TextFormField(
                                    onSaved: (val) {
                                      signUpemail = val;
                                    },
                                    // validator: (val) =>
                                    //     (val!.isEmpty)
                                    //     ? "Enter a Email"
                                    //     : null,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                        size: 30,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      border: const OutlineInputBorder(),
                                      hintText: "Your Email",
                                      hintStyle: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    controller: emailSignUpController,
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: TextFormField(
                                    controller: passwordSignUpController,
                                    onSaved: (val) {
                                      signUppassword = val;
                                    },
                                    // validator: (val) => (val!.isEmpty)
                                    //     ? "Enter a Password"
                                    //     : null,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.password,
                                        size: 30,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      border: const OutlineInputBorder(),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.7,
                                  child: TextFormField(
                                    controller: signUpConfirmPasswordController,
                                    onSaved: (val) {
                                      signUpConfirmPassword = val;
                                    },
                                    // validator: (val) => (val!.isEmpty)
                                    //     ? "Enter a Password"
                                    //     : null,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.password,
                                        size: 30,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      border: const OutlineInputBorder(),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                            height: Get.height * 0.135,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.2,
                              ),
                              Container(
                                child: TextButton(
                                  child: Text(
                                    "Sign In ➡",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (signUpFormKey.currentState!
                                        .validate()) {
                                      signUpFormKey.currentState!.save();
                                      if (signUppassword !=
                                          signUpConfirmPassword) {
                                        Get.snackbar(
                                          "Failed",
                                          "Password and Confirm password not match..",
                                          backgroundColor: Colors.redAccent,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      } else {
                                        Map<String, dynamic> data =
                                            await FirebaseAuthHelper
                                                .firebaseAuthHelper
                                                .signupWithEmailPassword(
                                                    email: signUpemail!,
                                                    password: signUppassword!);

                                        if (data['user'] != null) {
                                          Get.snackbar(
                                            "Success",
                                            "SignUp Successfully...",
                                            backgroundColor: Colors.green,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          initialIndex = 0;
                                          emailSignUpController.clear();
                                          passwordSignUpController.clear();
                                          setState(() {});
                                        } else {
                                          Get.snackbar(
                                            "Failed",
                                            data['msg'],
                                            backgroundColor: Colors.redAccent,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.11,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.02,
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
                                        "assets/images/login/google.png",
                                      ),
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.09,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        initialIndex = 0;
                                      });
                                    },
                                    child: Transform.rotate(
                                      angle: 0.65,
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: boldText,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.12,
                                  ),
                                  CircleAvatar(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        "assets/images/login/facebook.png",
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
        ),

        //todo:phone veryfication
        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/login/login.PNG",
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
                            height: Get.height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "phone Number",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.18,
                          ),
                          Form(
                            key: phoneVeryficationFormKey,
                            child: Transform.scale(
                              scale: 0.8,
                              child: TextFormField(
                                onTap: () {
                                  setState(() {
                                    phoneNumberController.text = "+91";
                                  });
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
                                    Icons.call,
                                    size: 30,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  border: const OutlineInputBorder(),
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                controller: phoneNumberController,
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
                            height: Get.height * 0.14,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Get.width * 0.22,
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
                                  onPressed: () {
                                    if (phoneVeryficationFormKey.currentState!.validate()) {
                                      setState(() {
                                        phoneLoading = true;
                                      });
                                      FirebaseAuthHelper.firebaseAuth.verifyPhoneNumber(
                                        phoneNumber: phoneNumberController.text,
                                        verificationCompleted: (e) {
                                          setState(() {
                                            phoneLoading = false;
                                          });
                                        },
                                        verificationFailed: (e) {
                                          Utils().errorMassage(massage: e.toString().split(']')[1]);
                                          setState(() {
                                            phoneLoading = false;
                                          });
                                        },
                                        codeSent: (String verificationId, int? token) async {
                                          await Get.toNamed('/verifyPhone_page', arguments: verificationId);
                                          setState(() {
                                            phoneLoading = false;
                                          });
                                        },
                                        codeAutoRetrievalTimeout: (e) {
                                          Utils().errorMassage(massage: e.toString().split(']')[1]);
                                          setState(() {
                                            phoneLoading = false;
                                          });
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.12,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.02,
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
                                        "assets/images/login/google.png",
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
                                    width: Get.width * 0.13,
                                  ),
                                  CircleAvatar(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        "assets/images/login/facebook.png",
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
        ),

      ],
    );
  }
}


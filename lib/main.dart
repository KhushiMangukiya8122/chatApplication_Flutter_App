import 'package:chat_application/utils/helpers/theme.dart';
import 'package:chat_application/views/screens/Intro_page.dart';
import 'package:chat_application/views/screens/chat_page.dart';
import 'package:chat_application/views/screens/home_page.dart';
import 'package:chat_application/views/screens/setting_page.dart';
import 'package:chat_application/views/screens/signUp_page.dart';
import 'package:chat_application/views/screens/splash_screen.dart';
import 'package:chat_application/views/screens/verifyPhone_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      getPages: [
        GetPage(
          name: '/',
          page: () => SplashScreen(),
        ),
        GetPage(
          name: '/Intro_page',
          page: () => IntroPage(),
        ),
        GetPage(
          name: '/signUp_page',
          page: () => SignUpPage(),
        ),
        GetPage(
          name: '/home_page',
          page: () => HomePage(),
        ),
        GetPage(
          name: '/chat_page',
          page: () => ChatPage(),
        ),
        GetPage(
          name: '/setting_page',
          page: () => SettingPage(),
        ),
        GetPage(
          name: '/verifyPhone_page',
          page: () => VerifyPhonePage(),
        ),
      ],
    ),
  );
}

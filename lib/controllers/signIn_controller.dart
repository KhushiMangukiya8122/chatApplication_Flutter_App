import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../modals/user_model.dart';

class SignInController extends GetxController {

  GetStorage getStorage = GetStorage();

  SignInModel signInModel = SignInModel(isSignIn: false);

  signIn() {
    signInModel.isSignIn = true;

    getStorage.write("isSignIn", signInModel.isSignIn);
    update();
  }

  signOut() {
    signInModel.isSignIn = false;

    getStorage.write("isSignIn", signInModel.isSignIn);
    update();
  }
}


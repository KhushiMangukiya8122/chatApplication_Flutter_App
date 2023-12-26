class UserModel {
  String email;
  String uid;

  UserModel({
    required this.email,
    required this.uid,
  });
}


class SignInModel {
  bool isSignIn;

  SignInModel({required this.isSignIn});
}
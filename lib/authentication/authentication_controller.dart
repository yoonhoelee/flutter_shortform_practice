import 'dart:io';
import 'package:shortform/authentication/login_screen.dart';
import 'package:shortform/authentication/registration_screen.dart';
import 'package:shortform/global.dart';
import 'package:shortform/home/home_screen.dart';

import 'user.dart' as userModel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController instanceAuth = Get.find();
  late Rx<User?> _currentUser;
  late Rx<File?> _pickedFile;
  File? get profileImage => _pickedFile.value;

  void chooseImageFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      Get.snackbar(
        "Profile Image",
        "You have Successfully Selected Your Profile Image",
      );
    }
    _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }

  void captureImageWithCamera() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImageFile != null) {
      Get.snackbar(
        "Profile Image",
        "You have Successfully Captured Your Profile Image With Camera",
      );
    }
    _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }

  void createAccountForNewUser(File imageFile, String userName, String userEmail, String userPassword) async{
    try{
      // 1. create user in the firebase authentication
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userEmail, password: userPassword);

      // 2. save the user profile image to firebase storage
      String imageDownloadUrl = await uploadImageToStorage(imageFile);

      // 3. save to firestore database
      userModel.User user = userModel.User(name: userName, email: userEmail, image: imageDownloadUrl, uid: credential.user!.uid,);
      await FirebaseFirestore.instance.collection("users").doc(credential.user!.uid).set(user.toJson());
      Get.snackbar("Account Created", "Your account has been created successfully");
      showProgressBar = false;
    }catch(error){
      Get.snackbar("Account Creation Unsuccessful", "Error occured, password needs to be longer than 6 characters");
      showProgressBar = false;
      Get.to(LoginScreen());
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async{
    Reference reference = FirebaseStorage.instance.ref().child("Profile Images").child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  void loginUserNow(String userEmail, String userPassword) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      Get.snackbar("Logged in", "You have logged in successfully");
      showProgressBar = false;
    }catch(error){
      Get.snackbar("Login Unsuccessful", "Error occurred during authentication");
      showProgressBar = false;
      Get.to(LoginScreen());
    }
  }

  goToScreen(User? currentUser){
    if(currentUser == null){
      //when user is not logged in send to login screen
      Get.offAll(LoginScreen());
    }else{
      // when user is logged in
      Get.offAll(HomeScreen());
    }
  }

  @override
  void onReady(){
    super.onReady();
    _currentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    _currentUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_currentUser, goToScreen);
  }
}

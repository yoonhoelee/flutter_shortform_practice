import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController instanceAuth = Get.find();
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

  void createAccountForNewUser(File imageFile, String userName, String userEmail, String userPassword){
    //create user in the firebase authentication
  }
}

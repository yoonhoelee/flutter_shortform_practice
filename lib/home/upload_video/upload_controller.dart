import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shortform/global.dart';
import 'package:shortform/home/home_screen.dart';
import 'package:shortform/home/upload_video/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController{

  compressVideoFile(String videoFilePath) async{
    final compressedVideoFile = await VideoCompress.compressVideo(videoFilePath, quality: VideoQuality.LowQuality);
    return compressedVideoFile!.file;
  }

  uploadCompressedVideoFileToFirebaseStorage(String videoId, String videoFilePath) async{
    UploadTask videoUploadTask = FirebaseStorage.instance.ref().child("All Videos").child(videoId).putFile(await compressVideoFile(videoFilePath));
    TaskSnapshot snapshot = await videoUploadTask;
    String downloadUrlOfUploadedVideo = await snapshot.ref.getDownloadURL();
    return downloadUrlOfUploadedVideo;
  }

  uploadThumbnailImageToFirebaseStorage(String videoId, String videoFilePath) async{
    UploadTask thumbnailUploadTask = FirebaseStorage.instance.ref().child("All Thumbnails").child(videoId).putFile(await getThumbnailImage(videoFilePath));
    TaskSnapshot snapshot = await thumbnailUploadTask;
    String downloadUrlOfUploadedThumbnail = await snapshot.ref.getDownloadURL();
    return downloadUrlOfUploadedThumbnail;
  }

  getThumbnailImage(String videoFilePath) async{
    final thumbnail = await VideoCompress.getFileThumbnail(videoFilePath);
    return thumbnail;
  }

  saveVideoInformationToFirestoreDatabase(String artistSongName, String descriptionTags, String videoFilePath, BuildContext context)async{
    try{
      //get current user info from Firestore
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      Map<String, dynamic> currentUserMap = userDocumentSnapshot.data() as Map<String, dynamic>;

      String videoId = DateTime.now().millisecondsSinceEpoch.toString();
      // 1. upload video to storage
      String videoDownloadUrl = await uploadCompressedVideoFileToFirebaseStorage(videoId, videoFilePath);
      // 2. upload thumbnail to storage
      String thumbnailDownloadUrl = await uploadThumbnailImageToFirebaseStorage(videoId, videoFilePath);
      //3. save overall video info to database
      Video videoObject = Video(
        userId: FirebaseAuth.instance.currentUser!.uid,
        userName:currentUserMap["name"],
        userProfileImage: currentUserMap["image"],
        videoId: videoId,
        totalComments: 0,
        totalShares: 0,
        likesList: [],
        artistSongName: artistSongName,
        descriptionTags:  descriptionTags,
        videoUrl: videoDownloadUrl,
        thumbnailUrl: thumbnailDownloadUrl,
        publishedDateTime: DateTime.now().millisecondsSinceEpoch,
      );
      await FirebaseFirestore.instance.collection("videos").doc(videoId).set(videoObject.toJson());
      Get.to(HomeScreen());
      Get.snackbar("New Video", "You have successfully uploaded your new video");
      showProgressBar = false;
    }catch(errMsg){
      Get.snackbar("Video Upload Unsuccessful", "your video is not uploaded");
    }
  }
}
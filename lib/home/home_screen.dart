import 'package:flutter/material.dart';
import 'package:shortform/home/following/followings_video_screen.dart';
import 'package:shortform/home/for_you/for_you_video_screen.dart';
import 'package:shortform/home/profile/profile_screen.dart';
import 'package:shortform/home/search/search_screen.dart';
import 'package:shortform/home/upload_video/upload_custom_icon.dart';
import 'package:shortform/home/upload_video/upload_video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;
  List screensList = [ForYouVideoScreen(), SearchScreen(), UploadVideoScreen(), FollowingsVideoScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white12,
        currentIndex: screenIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30,), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30,), label: "Discover"),
          BottomNavigationBarItem(
              icon: UploadCustomIcon(), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.inbox_sharp, size: 30,), label: "Following"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30,), label: "Me"),
        ],
      ),
      body: screensList[screenIndex],
    );
  }
}

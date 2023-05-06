import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shortform/authentication/authentication_controller.dart';
import 'package:shortform/authentication/login_screen.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../widgets/input_text_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;
  var authenticationController = AuthenticationController.instanceAuth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "Create Account",
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Let's get started!",
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                ),
              ),
              //profile avatar
              GestureDetector(
                onTap: () {
                  //allow user to choose image
                  authenticationController.chooseImageFromGallery();
                },
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("images/profile_avatar.jpg"),
                  backgroundColor: Colors.black,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //userName input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                    textEditingController: userNameTextEditingController,
                    labelString: "username",
                    iconData: Icons.person_outline,
                    isObscure: false),
              ),
              const SizedBox(
                height: 25,
              ),
              //email input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                    textEditingController: emailTextEditingController,
                    labelString: "Email",
                    iconData: Icons.email_outlined,
                    isObscure: false),
              ),
              const SizedBox(
                height: 25,
              ),

              //password input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                    textEditingController: passwordTextEditingController,
                    labelString: "Password",
                    iconData: Icons.lock_outline,
                    isObscure: true),
              ),
              const SizedBox(
                height: 30,
              ),
              //login button
              showProgressBar == false
                  ? Column(
                      children: [
                        //login button
                        Container(
                          width: MediaQuery.of(context).size.width - 38,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showProgressBar = true;
                              });
                              //login user now
                            },
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        //not have an account button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already Have an Account?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                //send user to login screen
                                Get.to(const LoginScreen());
                              },
                              child: const Text(
                                "Login Now",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Container(
                      //show animations
                      child: const SimpleCircularProgressBar(
                        progressColors: [
                          Colors.green,
                          Colors.blueAccent,
                          Colors.red,
                          Colors.amber,
                          Colors.purpleAccent,
                        ],
                        animationDuration: 3,
                        backColor: Colors.white38,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

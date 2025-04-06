import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jewellery/Auth/loginPage.dart';
import 'package:jewellery/Controllers/mainController.dart';
import 'package:jewellery/Themes/textstyle.dart';
import 'package:jewellery/landingPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();
  final mainController = Get.put(MainController());

  Future<void> checkLogin() async {
    
    try {
      final userId = await storage.read(key: "id");
      log("UserId: $userId");

      if (userId != null) {
        Get.offAll(() => LandingPage(currentIndex: 0));
      } else {
        Get.offAll(() => LoginPage());
      }
    } catch (e) {
      Get.offAll(() => LoginPage());
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), checkLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome! to Jewellery App",
                style: blackText,
              ),
           
            ],
          ),
        ),
      ),
    );
  }
}

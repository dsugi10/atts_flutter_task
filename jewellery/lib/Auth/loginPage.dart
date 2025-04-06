
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jewellery/Themes/colors.dart';
import 'package:jewellery/Themes/textstyle.dart';
import 'package:jewellery/Themes/toast.dart';
import 'package:jewellery/landingPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = ScrollController();
  final storage = const FlutterSecureStorage();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    const pattern = r'^[a-zA-Z0-9._%+-]+@gmail\.com$';

    final regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }

    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              controller: controller,
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: purpleText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 20, right: 20, bottom: 12),
                    child: TextFormField(
                      controller: loginController,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      decoration: InputDecoration(
                        hintText: "Login",
                        hintStyle: TextStyle(color: TextColorPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: TextColorPurple),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 24, 
                            width: 24, 
                            child: SvgPicture.asset("images/login.svg"),
                          ),
                        ),
                      ),
                      onTap: () {
                        controller.animateTo(
                          controller.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 20, right: 20, bottom: 12),
                    child: TextFormField(
                      controller: passwordController,
                      validator: validatePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: TextColorPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: TextColorPurple),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset("images/password.svg"),
                          ),
                        ),
                      ),
                      onTap: () {
                        controller.animateTo(
                          controller.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (loginController.text == "admin@gmail.com" &&
                          passwordController.text == "Admin@123") {
                        await storage.write(key: "id", value: "admin_user");
                        Get.offAll(() => LandingPage(currentIndex: 0));
                      } else {
                        SnackbarUtils.showSnackbar(
                          context,
                          "Invalid credentials",
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: gradientColor,
                      ),
                      child: Center(
                          child: Text(
                        "Login",
                        style: whiteText,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

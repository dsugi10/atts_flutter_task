
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jewellery/Auth/loginPage.dart';
import 'package:jewellery/Controllers/mainController.dart';
import 'package:jewellery/Invoice/addInvoice.dart';
import 'package:jewellery/Themes/colors.dart';
import 'package:jewellery/landingPage.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final mainController = Get.put(MainController());
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
   
  }

 

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                storage.deleteAll();
                Get.offAll(() => LoginPage());
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await storage.deleteAll();

    Get.off(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 160,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 20,
                  color: TextColorBlack,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              showLogoutDialog(context);
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SvgPicture.asset("images/logout.svg"),
              ),
            ),
          ),
        ],
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Vertically center
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: TextColorPurple),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddInvoice(),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("images/new_invoice.svg"),
                              Text(
                                "New",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: TextColorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                "Invoice",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: TextColorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LandingPage(currentIndex: 1),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("images/new_product.svg"),
                              Text(
                                "New",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: TextColorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                "Product",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: TextColorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddInvoice(isBack: true),
                        ),
                      );
                    },
                    child: Center(
                      child: Container(
                        height: 90,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: gradientColor,
                        ),
                        child: Center(
                          child: Text(
                            "Create Invoice",
                            style: TextStyle(
                              color: TextColorWhite,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}

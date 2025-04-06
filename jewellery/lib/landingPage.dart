
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery/Controllers/mainController.dart';
import 'package:jewellery/History/billhistory.dart';
import 'package:jewellery/Home/home.dart';
import 'package:jewellery/Products/products.dart';
import 'package:jewellery/animated_bottom_bar.dart';

class LandingPage extends StatefulWidget {
  int currentIndex;
  LandingPage({super.key, required this.currentIndex});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final mainController = Get.put(MainController());
  final List<Widget> _pages = [
    Home(),
    
     Products(),
    const BillHistory(),
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  String getTitle(currentIndex) {
    switch (currentIndex) {
      case 0:
        return "Home";
      case 1:
        return "Products";
      default:
        return "Bill History";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<BarItem> barItems = [
      BarItem(
        text: "Home",
        image: 'images/home.svg',
      ),
     
      BarItem(
        text: "Products",
        image: 'images/product.svg',
      ),
       BarItem(
        text: "Bill History",
        image: 'images/new.svg',
      ),
    ];

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.white,
          key: scaffoldKey,
          body: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                ),
                color: Colors.white),
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: _pages[widget.currentIndex],
            ),
          ),
          bottomNavigationBar: AnimatedBottomBar(
            barItems: barItems,
            selectedBarIndex: widget.currentIndex,
            onBarTap: (index) {
              setState(() {
                mainController.selectedCatIndex = 0;
                widget.currentIndex = index;
              });
            },
          )
    );
  }
}

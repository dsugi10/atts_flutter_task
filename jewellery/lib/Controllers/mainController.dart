
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery/Model/product_model.dart';

class MainController extends GetxController {
  int selectedCatIndex = 0;
  List<DateTime?> values = [
    DateTime.now(),
  ];
List<Product> productList = [];
  List invoiceProductList = [];
  List billingProduct=[];
   TextEditingController quantityController =  TextEditingController();


  var totalProdCount = 0.obs;

  
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jewellery/Controllers/mainController.dart';
import 'package:jewellery/Model/product_model.dart';
import 'package:jewellery/Themes/colors.dart';
import 'package:jewellery/Themes/toast.dart';

class ProductInfo extends StatefulWidget {
  final Product? productInfo;
  const ProductInfo({super.key, this.productInfo});

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  final mainController = Get.put(MainController());

  double amount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("productInfo ${widget.productInfo}");
    mainController.quantityController.clear();
  }

  void calculateAmount() {
    setState(() {
      String quantityText = mainController.quantityController.text;

      if (quantityText.isEmpty) {
        amount = 0;
      } else {
        int quantity = int.tryParse(quantityText) ?? 0;
        double price =
            double.tryParse(widget.productInfo!.price.toString()) ?? 0.0;
        double discount =
            double.tryParse(widget.productInfo!.discount.toString()) ?? 0.0;
        double tax = double.tryParse(widget.productInfo!.tax.toString()) ?? 0.0;

        if (quantity <= 0) {
          amount = 0;
          return;
        }
        double amountonTax = price * (100 + tax) / 100;
        double subtotal = amountonTax * (100 - discount) / 100;
        amount = quantity * subtotal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset("images/back.svg")),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text("Products Info",
                    style: TextStyle(
                      fontSize: 20,
                      color: TextColorBlack,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              // height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: TextColorPurple),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Item Name",
                            style: TextStyle(
                              fontSize: 18,
                              color: TextColorBlack,
                              // fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                        Text("${widget.productInfo?.name}",
                            style: TextStyle(
                              fontSize: 18,
                              color: TextColorPurple,
                              // fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            )),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Quantity",
                            style: TextStyle(
                              fontSize: 18,
                              color: TextColorBlack,
                              fontFamily: 'Poppins',
                            )),
                        Flexible(
                          child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(color: TextColorPurple),
                            ),
                            child: TextFormField(
                              controller: mainController.quantityController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => calculateAmount(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Price",
                            style: TextStyle(
                              fontSize: 18,
                              color: TextColorBlack,
                              fontFamily: 'Poppins',
                            )),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: TextColorPurple),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${widget.productInfo?.price}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: TextColorPurple,
                                  fontFamily: 'Poppins',
                                )),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discount",
                            style: TextStyle(
                              fontSize: 18,
                              color: TextColorBlack,
                              fontFamily: 'Poppins',
                            )),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: TextColorPurple),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${widget.productInfo?.discount}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: TextColorPurple,
                                  fontFamily: 'Poppins',
                                )),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tax",
                            style: TextStyle(
                              fontSize: 18,
                              color: TextColorBlack,
                              fontFamily: 'Poppins',
                            )),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: TextColorPurple),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${widget.productInfo?.tax}",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: TextColorPurple,
                                  fontFamily: 'Poppins',
                                )),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount",
                            style: TextStyle(
                              fontSize: 18,
                              color: TextColorBlack,
                              fontFamily: 'Poppins',
                            )),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: TextColorPurple),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                color: TextColorPurple,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (mainController.quantityController.text.isEmpty) {
                    SnackbarUtils.showSnackbar(
                      context,
                      "Enter Quantity",
                    );
                  } else if (int.tryParse(
                              mainController.quantityController.text) ==
                          null ||
                      int.parse(mainController.quantityController.text) <=
                          0) {
                    SnackbarUtils.showSnackbar(
                      context,
                      "The quantity must be greater than 0",
                    );
                  } else {
                    widget.productInfo?.count =
                        int.parse(mainController.quantityController.text);
                    log("widget.productInfo ${widget.productInfo}");

                    setState(() {
                      mainController.invoiceProductList.add(widget.productInfo);
                    });

                    Navigator.pop(context);
                    Navigator.pop(context, mainController.invoiceProductList);
                  }
                },
                child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: TextColorPurple,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text("+ Add",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: TextColorPurple,
                            fontFamily: 'Poppins',
                          )),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

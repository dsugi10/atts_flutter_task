import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jewellery/Controllers/mainController.dart';
import 'package:jewellery/Model/product_model.dart';
import 'package:jewellery/Products/addProducts.dart';
import 'package:jewellery/Products/productInfo.dart';
import 'package:jewellery/Themes/colors.dart';

class Products extends StatefulWidget {
  bool forbill;
  Products({super.key, this.forbill = false});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  TextEditingController searchController = TextEditingController();
  final mainController = Get.put(MainController());
  List allProds = [];
  bool isCheckVariable = false;
  List searchedProd = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isCheckVariable = true;
    log("productlist-------${mainController.productList}");
    filteredProducts = List.from(mainController.productList);
  }

  void _filterOrder(String query) {
    final results = mainController.productList.where((product) {
      final productName = product.name.toLowerCase();
      final input = query.toLowerCase();
      return productName.contains(input);
    }).toList();

    setState(() {
      filteredProducts = results;
    });
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
                  "Product",
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
         
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          isCheckVariable = false;
                        });
                        _filterOrder(value);
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: TextColorPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: TextColorPurple),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "images/search.svg",
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  filteredProducts.isEmpty
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("images/empty.svg"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "No Product found",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: TextColorBlack,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Dismissible(
                                key: Key(filteredProducts[index].name),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  mainController.productList
                                      .remove(filteredProducts[index]);
                                  filteredProducts.removeAt(index);
                                },
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        widget.forbill
                                            ? Get.to(() => ProductInfo(
                                                  productInfo:
                                                      filteredProducts[index],
                                                ))
                                            : Get.to(() => AddProducts(
                                                  canEdit: true,
                                                  product:
                                                      filteredProducts[index],
                                                ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: GreyColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  height: 120,
                                                  width: 80,
                                                  child: Image.network(
                                                    filteredProducts[index]
                                                        .image,
                                                    fit: BoxFit.cover,
                                                  )),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${filteredProducts[index].name}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: TextColorBlack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    "Category: ${filteredProducts[index].category}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: TextColorBlack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    "Discount:${filteredProducts[index].discount}%",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: TextColorBlack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Text(
                                                    "Tax:${filteredProducts[index].tax}%",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: TextColorBlack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Price: ",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: TextColorGrey,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        "₹ ${filteredProducts[index].price}",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              TextColorPurple,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: widget.forbill
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Get.to(() => AddProducts(
                        canEdit: false,
                      ));
                },
                backgroundColor: TextColorPurple,
                child: SvgPicture.asset("images/plus.svg")));
    // });
  }
}

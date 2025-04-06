import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery/Controllers/mainController.dart';
import 'package:jewellery/Model/product_model.dart';
import 'package:jewellery/Themes/colors.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart' as dio;
import 'package:jewellery/landingPage.dart';

class AddProducts extends StatefulWidget {
  bool canEdit;
  final Product? product;
  AddProducts({super.key, required this.canEdit, this.product});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final mainController = Get.put(MainController());
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = ScrollController();
  bool uploading = false;
  String? productImage;
  bool imageload1 = false;
  File? _file;
  String? selectedCategory;
  List<String> categoryList = ['Ring', 'Chain', 'Bangles'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.canEdit && widget.product != null) {
      nameController.text = widget.product!.name;
      priceController.text = widget.product!.price.toString();
      taxController.text = widget.product!.tax.toString();
      discountController.text = widget.product!.discount.toString();
      productImage = widget.product!.image;
      selectedCategory = widget.product!.category;
      log("profimg-------$productImage");
    }
  }

  @override
  Widget build(BuildContext context) {
    String generateProductId(int index) {
      return index.toString().padLeft(3, '0');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Add Item",
            style: TextStyle(
              fontSize: 20,
              color: TextColorBlack,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            )),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: imageload1
                        ? const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircularProgressIndicator(),
                          )
                        : productImage != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(productImage!))
                            : const CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage("images/logo.png"),
                              ),
                  ),
                  Center(
                    child: TextButton(
                      child: Text(
                        "Add Photo",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: TextColorPurple,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      onPressed: () {
                        showImagePicker(context);
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Item Name",
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: TextColorPurple,
                            fontFamily: 'Poppins',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: TextColorGrey), 
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: TextColorPurple), 
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter name';
                          }
                          return null;
                        },
                        onTap: () {},
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categoryList.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Category",
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: TextColorPurple,
                          fontFamily: 'Poppins',
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: TextColorGrey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: TextColorPurple),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select Category';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Price",
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: TextColorPurple,
                            fontFamily: 'Poppins',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: TextColorGrey), 
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: TextColorPurple), 
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Price';
                          }
                          return null;
                        },
                        onTap: () {},
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: taxController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Tax %",
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: TextColorPurple,
                            fontFamily: 'Poppins',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: TextColorGrey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: TextColorPurple),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter tax%';
                          }
                          return null;
                        },
                        onTap: () {},
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: discountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Discount %",
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: TextColorPurple,
                            fontFamily: 'Poppins',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: TextColorGrey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: TextColorPurple),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Discount';
                          }
                          return null;
                        },
                        onTap: () {},
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel",
                              style: TextStyle(
                                fontSize: 20,
                                color: TextColorBlue,
                                fontFamily: 'Poppins',
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (productImage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Please select an image')),
                                  );
                                  return;
                                }
                                final id = generateProductId(
                                    mainController.productList.length + 1);

                                final newProduct = Product(
                                    id: widget.canEdit
                                        ? widget.product!.id
                                        : id,
                                    image: productImage ?? "",
                                    name: nameController.text.trim(),
                                    price: double.tryParse(
                                            priceController.text.trim()) ??
                                        0.0,
                                    tax: double.tryParse(
                                            taxController.text.trim()) ??
                                        0.0,
                                    discount: double.tryParse(
                                            discountController.text.trim()) ??
                                        0.0,
                                    category: selectedCategory ?? "");

                                if (widget.canEdit) {
                                  final index = mainController.productList
                                      .indexWhere((p) => p.id == newProduct.id);
                                  log("index $index");
                                  if (index != -1) {
                                    setState(() {
                                      mainController.productList[index] =
                                          newProduct;
                                    });
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Product "${newProduct.name}" updated!')),
                                  );
                                } else {
                                  setState(() {
                                    mainController.productList.add(newProduct);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Product "${newProduct.name}" saved!')),
                                  );
                                }
                                mainController.selectedCatIndex = 1;
                                Get.offAll(() => LandingPage(currentIndex: 1));
                              }
                            },
                            child: Text("Save",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: TextColorBlue,
                                  fontFamily: 'Poppins',
                                )),
                          ),
                        ),
                      ],
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

  void showImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Photo Gallery",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                      )),
                  onTap: () async {
                    // Navigator.of(context).pop();
                    // gallery();

                    setState(() {
                      imageload1 = true;
                    });
                    Navigator.pop(context);
                    final pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      _file = File(pickedImage.path);
                      var imageUrl = await uploadImages(_file!);
                      log("gggggg $imageUrl");
                      productImage = imageUrl;

                      setState(() {
                        imageload1 = false;
                        productImage = imageUrl;
                      });
                    } else {
                      setState(() {
                        imageload1 = false;
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text("Camera",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                      )),
                  onTap: () async {
                    // Navigator.of(context).pop();
                    // camera();

                    setState(() {
                      imageload1 = true;
                    });
                    Navigator.pop(context);
                    final pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      _file = File(pickedImage.path);
                      var imageUrl = await uploadImages(_file!);
                      productImage = imageUrl;
                      log("imgggggggggg ${productImage}");
                      setState(() {
                        imageload1 = false;
                        productImage = imageUrl;
                      });
                    } else {
                      setState(() {
                        imageload1 = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future uploadImages(File file) async {
    setState(() {
      uploading = true;
    });
    try {
      var dioClient = dio.Dio();
      String url = 'https://api.cloudinary.com/v1_1/dxe8a0n6x/upload';

      dio.FormData formData = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(
          file.path,
        ),
        'upload_preset': 'h8km3xoh',
        'cloud_name': 'dxe8a0n6x',
      });

      var response = await dioClient.post(
        url,
        data: formData,
      );
      log("responseee ${response.data}");
      log("responseee ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data;
       
        return data['url'];
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (error) {
      return null;
    }
  }
}

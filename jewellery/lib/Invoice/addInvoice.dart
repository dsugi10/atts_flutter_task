import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery/Controllers/mainController.dart';
import 'package:jewellery/Model/billing.dart';
import 'package:jewellery/Products/products.dart';
import 'package:jewellery/Themes/colors.dart';
import 'package:jewellery/Themes/textstyle.dart';
import 'package:jewellery/landingPage.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AddInvoice extends StatefulWidget {
  final isBack;
  AddInvoice({super.key, this.isBack});

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  bool isSwitched = false;
  TextEditingController invoicenoController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController invoicedateController = TextEditingController();
  bool toggleValue = false;
  final mainController = Get.put(MainController());
  DateTime selectedDateTime = DateTime.parse(DateTime.now().toString());
  var selectDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainController.invoiceProductList.clear();
    invoicedateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<pw.Font> getCustomFont() async {
    final fontData = await rootBundle.load("fonts/Poppins-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MMM/yyyy').format(parsedDate);
  }

  createAndOpenPdf() async {
    try {
      final pdf = pw.Document();
      String formattedDate = formatDate(invoicedateController.text);

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Center(
                      child: pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8.0),
                    child: pw.Text("INVOICE",
                        style: const pw.TextStyle(
                            color: PdfColors.black, fontSize: 15)),
                  )),
                  pw.Container(
                    height: 40,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        top: pw.BorderSide(),
                        left: pw.BorderSide(),
                        right: pw.BorderSide(),
                        bottom: pw.BorderSide.none,
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          child: pw.Text("ABC Jewellers",
                              style: pw.TextStyle(
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.black)),
                        ),
                      ],
                    ),
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            width: 240,
                            height: 40,
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("Date: ${formattedDate} ",
                                    style: const pw.TextStyle(
                                      fontSize: 12,
                                    )),
                                pw.Text(
                                    "Invoice No.: ${invoicenoController.text}",
                                    style: const pw.TextStyle(
                                      fontSize: 12,
                                    )),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 2.0),
                                  child: pw.Text(
                                      "Bill To: ${customerNameController.text} ",
                                      style: const pw.TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            height: 40,
                            alignment: pw.Alignment.center,
                            child: pw.Text("S No",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 7)),
                          ),
                          pw.Container(
                            height: 40,
                            alignment: pw.Alignment.center,
                            child: pw.Text("Particulars",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 7)),
                          ),
                          pw.Container(
                            height: 40,
                            alignment: pw.Alignment.center,
                            child: pw.Text("Qty",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 7)),
                          ),
                          pw.Container(
                            height: 40,
                            alignment: pw.Alignment.center,
                            child: pw.Text("Price",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 7)),
                          ),
                          pw.Container(
                            height: 40,
                            alignment: pw.Alignment.center,
                            child: pw.Text("Tax",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 7)),
                          ),
                          pw.Container(
                            height: 40,
                            alignment: pw.Alignment.center,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("Discount",
                                    style: pw.TextStyle(
                                        fontSize: 7,
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                          ),
                          pw.Container(
                            height: 40,
                            alignment: pw.Alignment.center,
                            child: pw.Text("Sub Total",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 7)),
                          ),
                        ],
                      ),
                      ...List.generate(mainController.invoiceProductList.length,
                          (index) {
                        final product =
                            mainController.invoiceProductList[index];
                        List<String> row = [
                          (index + 1).toString(),
                          product.name.toString(),
                          product.count.toString(),
                          product.price.toString(),
                          product.tax.toString(),
                          product.discount.toString(),
                          "Rs.${calculateAmount(product)}",
                        ];

                        return pw.TableRow(
                          children: row.map((data) {
                            return pw.Container(
                              height: 30,
                              alignment: pw.Alignment.center,
                              padding:
                                  const pw.EdgeInsets.symmetric(horizontal: 2),
                              child: pw.Text(data,
                                  style: const pw.TextStyle(fontSize: 8)),
                            );
                          }).toList(),
                        );
                      })
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text("Grand Total:  ",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 15)),
                        pw.Text("${calculateGrandTotal()}",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 15)),
                      ]),
                  pw.Center(
                      child: pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 8.0),
                    child: pw.Text("This is a computer generated invoice",
                        style: const pw.TextStyle(
                            color: PdfColors.black, fontSize: 15)),
                  )),
                ],
              ),
            );
          }));
      final output = await getTemporaryDirectory();
      final file = File(join(output.path, 'invoice.pdf'));

      await file.writeAsBytes(await pdf.save());
      print('PDF saved successfully at ${file.path}');

      final result = await OpenFile.open(file.path);
      if (result.type == ResultType.done) {
        print('PDF opened successfully');
      } else {
        print('Error opening PDF: ${result.message}');
      }
    } catch (e) {
      print('Error saving or opening PDF: $e');
    }
  }

  String calculateAmount(productDetails) {
    var amount;
    String quantityText = productDetails.count.toString();

    if (quantityText.isEmpty) {
      amount = 0;
    } else {
      int quantity = int.tryParse(quantityText) ?? 0;
      double price = double.tryParse(productDetails!.price.toString()) ?? 0.0;
      double discount =
          double.tryParse(productDetails!.discount.toString()) ?? 0.0;
      double tax = double.tryParse(productDetails!.tax.toString()) ?? 0.0;

      if (quantity <= 0) {
        amount = 0;
      }
      double amountonTax = price * (100 + tax) / 100;
      double subtotal = amountonTax * (100 - discount) / 100;
      amount = quantity * subtotal;
    }
    return amount.toStringAsFixed(2);
  }

  String calculateGrandTotal() {
    double total = 0.0;

    for (var product in mainController.invoiceProductList) {
      total += double.tryParse(calculateAmount(product)) ?? 0.0;
    }

    return total.toStringAsFixed(2);
  }

  itemDetails() {
    if (mainController.invoiceProductList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mainController.invoiceProductList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${mainController.invoiceProductList[index].name}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: TextColorBlack,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  mainController.invoiceProductList
                                      .removeAt(index);
                                });
                              },
                              child: Text("Remove",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: TextColorRed,
                                    fontFamily: 'Poppins',
                                  )),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${mainController.invoiceProductList[index].price} * ${mainController.invoiceProductList[index].count}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: TextColorBlack,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              "${calculateAmount(mainController.invoiceProductList[index])}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: TextColorBlack,
                                fontFamily: 'Poppins',
                              ),
                            )
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Grand Total: ${calculateGrandTotal()}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: TextColorBlack,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    log("message ${mainController.invoiceProductList}");
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading:  widget.isBack == true
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset("images/back.svg",fit: BoxFit.scaleDown,)
                          )
                        : const SizedBox(),
        title: Text("Add Invoice",
            style: TextStyle(
              fontSize: 20,
              color: TextColorBlack,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
               
                // const SizedBox(),
                Text(
                  "Item Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: TextColorPurple,
                    fontFamily: 'Poppins',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Products(
                                      forbill: true,
                                    ))).then((value) {
                          log("messageeeeeeeee $value");
                          setState(() {
                            mainController.invoiceProductList = value;
                          });
                        });
                        // Get.back();
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
                            child: Text("+ Add New",
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
                if (mainController.invoiceProductList.isNotEmpty) itemDetails(),
                // itemDetails(),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Text(
                    "Invoice Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: TextColorPurple,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Invoice Date:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: TextColorBlack,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: invoicedateController,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () async {
                                final value =
                                    await showCalendarDatePicker2Dialog(
                                  barrierDismissible: false,
                                  context: context,
                                  config: CalendarDatePicker2WithActionButtonsConfig(
                                      calendarType:
                                          CalendarDatePicker2Type.single,
                                      lastDate: DateTime.now(),
                                      weekdayLabels: [
                                        'Sun',
                                        'Mon',
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                        'Sat'
                                      ],
                                      lastMonthIcon: SvgPicture.asset(
                                          "images/svgImages/backwardmr.svg"),
                                      nextMonthIcon: SvgPicture.asset(
                                          'images/svgImages/forwardmr.svg')),
                                  dialogSize: const Size(325, 400),
                                  value: mainController.values,
                                  borderRadius: BorderRadius.circular(15),
                                );

                                if (value != null && value.isNotEmpty) {
                                  selectedDateTime =
                                      DateTime.parse(value[0].toString());

                                  selectDate = DateFormat('yyyy-MM-dd')
                                      .format(selectedDateTime);

                                  mainController.values.clear();
                                  mainController.values.add(selectedDateTime);

                                  invoicedateController.text = selectDate;

                                  log("Selected Date from Calendar: $selectedDateTime.............${mainController.values}...........$selectDate");
                                } else {
                                  selectDate = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());

                                  invoicedateController.text = selectDate;
                                }
                              },
                              child: const Icon(Icons.calendar_month_outlined)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: TextColorGrey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: TextColorPurple), 
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Invoice No:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: TextColorBlack,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: invoicenoController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: TextColorGrey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: TextColorPurple),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Customer Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: TextColorBlack,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: customerNameController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: TextColorGrey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: TextColorPurple),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (mainController.invoiceProductList.isNotEmpty &&
                        invoicedateController.text.isNotEmpty &&
                        invoicenoController.text.isNotEmpty &&
                        customerNameController.text.isNotEmpty) {
                      log("productController.productList ${mainController.invoiceProductList}");
                      await createAndOpenPdf();

                      // Get.offAll(LandingPage(currentIndex: 0));
                    } else {
                      String missingFields = "";

                      if (mainController.invoiceProductList.isEmpty)
                        missingFields += "Product List, ";
                      if (invoicedateController.text.isEmpty)
                        missingFields += "Invoice Date, ";
                      if (invoicenoController.text.isEmpty)
                        missingFields += "Invoice No, ";
                      if (customerNameController.text.isEmpty)
                        missingFields += "Customer Name, ";

                      if (missingFields.isNotEmpty) {
                        Fluttertoast.showToast(
                          msg:
                              "Please fill: ${missingFields.substring(0, missingFields.length - 2)}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    }
                  },
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: gradientColor,
                      ),
                      child: Text(
                        "Generate PDF ",
                        style: whiteText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: TextButton(
                        onPressed: () {
                          if (mainController.invoiceProductList.isNotEmpty &&
                              invoicedateController.text.isNotEmpty &&
                              invoicenoController.text.isNotEmpty &&
                              customerNameController.text.isNotEmpty) {
                                 setState(() {
                            for (var product
                                in mainController.invoiceProductList) {
                              final billedProduct = BilledProduct(
                                  product: product,
                                  customer_name: customerNameController.text,
                                  date: invoicedateController.text,
                                  invoice_no: invoicenoController.text);
                            // mainController.billingProduct.insert(0, billedProduct);
                            mainController.billingProduct.add(billedProduct);
                            }
                          });
                          log("billingProduct ${mainController.billingProduct}");
                            mainController.selectedCatIndex=2;
                            Get.offAll(LandingPage(
                              currentIndex: 2,
                            ));
                          } else {
                            String missingFields = "";

                            if (mainController.invoiceProductList.isEmpty)
                              missingFields += "Product List, ";
                            if (invoicedateController.text.isEmpty)
                              missingFields += "Invoice Date, ";
                            if (invoicenoController.text.isEmpty)
                              missingFields += "Invoice No, ";
                            if (customerNameController.text.isEmpty)
                              missingFields += "Customer Name, ";

                            if (missingFields.isNotEmpty) {
                              Fluttertoast.showToast(
                                msg:
                                    "Please fill: ${missingFields.substring(0, missingFields.length - 2)}",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }
                         
                        },
                        child: Text("Confirm Invoice Bill")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jewellery/Controllers/mainController.dart';
import 'package:jewellery/Themes/colors.dart';

class BillHistory extends StatefulWidget {
  const BillHistory({super.key});

  @override
  State<BillHistory> createState() => _BillHistoryState();
}

class _BillHistoryState extends State<BillHistory> {
  bool isCheckVariable = false;
  final mainController = Get.put(MainController());
  List filteredProducts = [];
  TextEditingController searchController = TextEditingController();
    int currentDisplayCount = 3; 
  final int lazyLoadIncrement = 3; 
  final int paginationThreshold = 6; 
  List displayedProducts = [];
  int currentPage = 1;
  Map<String, List<dynamic>> groupedBills = {};
  final Map<String, List<dynamic>> grouped = {};

 void groupBills() {
    groupedBills.clear();

    for (var item in mainController.billingProduct) {
      String groupKey = "${item.customer_name}_${item.invoice_no}";

      if (!groupedBills.containsKey(groupKey)) {
        groupedBills[groupKey] = [];
      }

      groupedBills[groupKey]!.add(item);
    }

    filteredProducts = groupedBills.entries.toList();
  }

  void filterOrder(String query) {
    grouped.clear();
    final filtered = mainController.billingProduct.where((product) {
      final name = product.customer_name.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();

    for (var item in filtered) {
      String key = "${item.customer_name}_${item.invoice_no}";
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }

    setState(() {
      filteredProducts = grouped.entries.toList();
      currentDisplayCount = 3; 
      initializeDisplayedProducts();
    });
  }

  void _loadMore() {
    setState(() {
      currentDisplayCount += lazyLoadIncrement;
      if (currentDisplayCount > filteredProducts.length) {
        currentDisplayCount = filteredProducts.length;
      }
      initializeDisplayedProducts();
    });
  }

 void goToPage(int page) {
  setState(() {
    currentPage = page;
    int startIndex = (page - 1) * paginationThreshold;
    int endIndex = (startIndex + paginationThreshold).clamp(0, filteredProducts.length);
    displayedProducts = filteredProducts.sublist(startIndex, endIndex);
  });
}

 void initializeDisplayedProducts() {
    int endIndex = currentDisplayCount.clamp(0, filteredProducts.length);
    displayedProducts = filteredProducts.sublist(0, endIndex);
  }

  
  @override
  void initState() {
    super.initState();
    filteredProducts = mainController.billingProduct;
    groupBills();
    initializeDisplayedProducts();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (filteredProducts.length / paginationThreshold).ceil();
    final showPagination = filteredProducts.length > paginationThreshold && 
                          currentDisplayCount >= paginationThreshold;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
       automaticallyImplyLeading: false,
        title: Text(
          "Billing History",
          style: TextStyle(
            fontSize: 20,
            color: TextColorBlack,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: TextColorBlack),
            onPressed: () {
              showDateFilterDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.sort, color: TextColorBlack),
            onPressed: () {
              showSortOptions(context);
            },
          ),
        ],
      ),
     body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        isCheckVariable = false;
                      });
                      filterOrder(value);
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
                                "No Bills found",
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
                    : Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: displayedProducts.length,
                            itemBuilder: (context, index) {
                              final billItems = displayedProducts[index].value;
                              final firstItem = billItems.first;
                      
                              double total = billItems.fold(
                                  0.0, (sum, item) => sum + item.totalPrice);
                      
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: GreyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Customer Name: ${firstItem.customer_name}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: TextColorBlack,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "Bill ID: ${firstItem.invoice_no}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: TextColorGrey,
                                          ),
                                        ),
                                        Text(
                                          "Date: ${firstItem.date}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: TextColorGrey,
                                          ),
                                        ),
                      
                                        ...billItems.map((item) => Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 4.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Product Name: ${item.product.name}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: TextColorBlack,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 105,
                                                        width: 105,
                                                        child: Image.network(
                                                            item.product.image,
                                                            fit: BoxFit.cover),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Category:${item.product.category}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: TextColorBlack,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Quantity:${item.product.count}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: TextColorBlack,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Price:Rs.${item.product.price}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: TextColorBlack,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Tax:${item.product.tax} %",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: TextColorBlack,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Discount:${item.product.discount} %",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: TextColorBlack,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total:",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: TextColorGrey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "₹ ${total.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: TextColorPurple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (currentDisplayCount < filteredProducts.length && 
                              !showPagination)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: _loadMore,
                                child: Text("Load More"),
                              ),
                            ),
                          if (showPagination)
  Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => GestureDetector(
          onTap: () => goToPage(index + 1),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: currentPage == index + 1 
                  ? TextColorPurple 
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: currentPage == index + 1 
                    ? Colors.white 
                    : Colors.black,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

 void showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sort by Total Price"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Low to High"),
              onTap: () {
                sortFilteredProducts(ascending: true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("High to Low"),
              onTap: () {
                sortFilteredProducts(ascending: false);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void sortFilteredProducts({required bool ascending}) {
    setState(() {
      filteredProducts.sort((a, b) {
        double totalA = a.value.fold(0.0, (sum, item) => sum + item.totalPrice);
        double totalB = b.value.fold(0.0, (sum, item) => sum + item.totalPrice);

        return ascending ? totalA.compareTo(totalB) : totalB.compareTo(totalA);
      });
      
    currentPage = 1; 
    
      currentDisplayCount = 3; 
      initializeDisplayedProducts();
    });
  }

  void showDateFilterDialog(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      filterByDate(selectedDate);
    }
  }

  void filterByDate(DateTime selectedDate) {
    grouped.clear();

    final filtered = mainController.billingProduct.where((product) {
      DateTime productDate = DateTime.parse(product.date);
      return productDate.year == selectedDate.year &&
          productDate.month == selectedDate.month &&
          productDate.day == selectedDate.day;
    }).toList();

    for (var item in filtered) {
      String key = "${item.customer_name}_${item.invoice_no}";
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }

    setState(() {
      filteredProducts = grouped.entries.toList();
      currentDisplayCount = 3; 
       currentPage = 1;
      initializeDisplayedProducts();
    });
  }
}

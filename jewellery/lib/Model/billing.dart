import 'package:jewellery/Model/product_model.dart';

class BilledProduct {
  final Product product;
  final String customer_name;
  final String date;
  final String invoice_no;
  double get totalPrice {
    final discounted_price = product.price * (100 - product.discount) / 100;
    final taxed_price = discounted_price * (100 + product.tax )/ 100;
    return taxed_price * product.count;
  }

  BilledProduct({
    required this.product,
    required this.customer_name,
    required this.date,
    required this.invoice_no,
  });

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'totalPrice': totalPrice,
        'customerName':customer_name,
        'date':date,
        'invoice_no': invoice_no  
      };

  factory BilledProduct.fromJson(Map<String, dynamic> json) => BilledProduct(
        product: Product.fromJson(json['product']),
        customer_name: json['customerName'],
        date:json['date'],
        invoice_no: json['invoice_no'],
      );
}

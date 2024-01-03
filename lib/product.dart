import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
int _pid;
String _name;
int _quantity;
double _price;
String _category;
String _image;

Product(this._pid, this._name, this._quantity, this._price, this._category, this._image);

int get productID => _pid;
String get productName => _name;
int get quantity => _quantity;
double get price => _price;
String get category => _category;
String get image => _image;


  set quantity(int value) {
    _quantity = value.clamp(1, 10);
  }

factory Product.fromJson(Map<String, dynamic> json) {
return Product(
int.parse(json['pid'].toString()),
json['name'] as String,
int.parse(json['quantity'].toString()),
double.parse(json['price'].toString()),
json['cid'] != null ? json['cid'].toString() : '',
json['image'] as String,
);
}
}


class ProductController {
  final productRepo = ProductRepo();

  Future<List<Product>> getproduct() async {
    final response = await productRepo.getproduct();

    if (response.statusCode != 200) {
      print('Error: ${response.statusCode}');
      return [];
    }

    try {
      final jsonDataStartIndex = response.body.indexOf('{');
      final jsonData = response.body.substring(jsonDataStartIndex);
      final data = jsonDecode(jsonData);

      if (data is Map<String, dynamic> && data.containsKey('products')) {
        final productsJson = data['products'];

        if (productsJson is List<dynamic>) {
          List<Product> products = [];

          for (dynamic productJson in productsJson) {
            print(productJson);
            products.add(Product.fromJson(productJson));
            print(1);
          }

          return products;
        } else {
          print('Error: "products" is not a List');
          return [];
        }
      } else {
        print('Error: Invalid JSON format');
        return [];
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      return [];
    }
  }
}

class ProductData {
  List<Product> products;

  ProductData({required this.products});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      products: (json['products'] as List<dynamic>)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
    );
  }
}

class ProductRepo {
  Future<http.Response> getproduct() async {
    final url = Uri.parse('https://sherinemobile.000webhostapp.com/showproducts.php');
    final response = await http.get(url);
    print('API Response: ${response.body}');
    return response;
  }
}

class CartController {

  static final CartController _instance = CartController._internal();
  factory CartController() {
    return _instance;
  }

  CartController._internal();
  List<Product> _cartItems = [];
  List<Product> get cartItems => _cartItems;


  void addToCart(Product product) {
    _cartItems.add(product);
  }
}


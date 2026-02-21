import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts({int limit = 20, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];
      return products.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to load products');
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/search?q=$query'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];
      return products.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to search products');
  }
}

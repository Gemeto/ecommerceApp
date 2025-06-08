import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  final http.Client client;
  static const String _baseUrl = 'https://fakestoreapi.com';

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Product>> fetchProducts({String? category}) async {
    String url = '$_baseUrl/products';
    if (category != null && category != "All Categories") {
      url = '$_baseUrl/products/category/$category';
    }
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load products. Status code: ${response.statusCode}',
      );
    }
  }

  Future<List<String>> fetchCategories() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/products/categories'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((category) => category.toString()).toList();
    } else {
      throw Exception(
        'Failed to load categories. Status code: ${response.statusCode}',
      );
    }
  }
}

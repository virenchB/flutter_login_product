import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  // Constructor to initialize the base URL
  ApiService(this.baseUrl);

  /// Login with email and password
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  /// Fetch the product list from the API
  Future<List<dynamic>> getProductList() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    return _handleResponse(response);
  }

  /// Handle API response and throw error if needed
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}

import 'package:flutter/material.dart';

import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService('https://dummyjson.com');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Login & Product Demo')),
        body: LoginScreen(apiService: apiService),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final ApiService apiService;
  const LoginScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      final result = await widget.apiService.login(
        _emailController.text,
        _passwordController.text,
      );
      print('Login Success: $result');
    } catch (e) {
      print('Login Failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                    apiService: widget.apiService,
                  ),
                ),
              );
            },
            child: const Text('View Products'),
          ),
        ],
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  final ApiService apiService;
  const ProductListScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getProductList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['title']),
                  subtitle: Text('\$${product['price']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

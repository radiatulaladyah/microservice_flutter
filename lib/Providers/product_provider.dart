import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  List<dynamic> _products = [];
  bool _isLoading = true;

  List<dynamic> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true; // Set loading state sebelum memulai fetch
    notifyListeners(); // Notifikasi perubahan pada loading state

    try {
      final response =
          await http.get(Uri.parse('http://192.168.19.53:3000/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _products = data['data'];
        _isLoading = false; // Hentikan loading saat data diterima
        notifyListeners(); // Hanya notifikasi jika data berhasil diterima
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      _isLoading = false; // Hentikan loading jika terjadi error
      notifyListeners(); // Tetap notifikasi untuk perubahan state
    }
  }
}

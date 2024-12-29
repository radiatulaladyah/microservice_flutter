import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewProvider with ChangeNotifier {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get reviews => _reviews;
  bool get isLoading => _isLoading;

  Future<void> fetchReviews(int productId) async {
  if (_isLoading) return; // Hindari memuat ulang data jika sudah dalam proses

  _isLoading = true;
  notifyListeners();

  try {
    final response = await http.get(
      Uri.parse('http://192.168.19.53:3003/products/$productId/reviews'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is Map<String, dynamic> && data['data'] is List) {
        _reviews = List<Map<String, dynamic>>.from(data['data']);
      } else {
        _reviews = [];
        print('Format respons tidak sesuai: $data');
      }
    } else {
      _reviews = [];
      print('Gagal memuat data: Status Code ${response.statusCode}');
    }
  } catch (error) {
    _reviews = [];
    print('Error terjadi saat fetch: $error');
  }

  _isLoading = false;
  notifyListeners();
}
}

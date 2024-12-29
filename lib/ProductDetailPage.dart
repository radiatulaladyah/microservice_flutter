import 'package:flutter/material.dart';
import 'package:product_app/Providers/ReviewProvider.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
      final productId = widget.product['id'];

      if (productId != null) {
        reviewProvider.fetchReviews(productId);
      } else {
        print('Product ID is null, tidak bisa memuat review.');
      }

      _isInitialized = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          widget.product['name'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dan detail produk
            Stack(
              children: [
                Image.asset(
                  widget.product['image_url'] ?? '../assets/baju1.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Rp ${widget.product['price']}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.product['description'] ?? 'No description available.',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Add to Cart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to cart")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
                    foregroundColor: Colors.white, // Mengubah warna teks menjadi putih
                  ),
                  child: const Text("Add to Cart"),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Bagian Review
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reviews:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  reviewProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : reviewProvider.reviews.isEmpty
                          ? const Text("No reviews yet.")
                          : Column(
                              children: reviewProvider.reviews.map((review) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Icon(
                                            index < review['review']['ratings']
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text("- ${review['review']['comment']}"),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

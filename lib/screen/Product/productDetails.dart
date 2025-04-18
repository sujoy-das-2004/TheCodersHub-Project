import 'package:flutter/material.dart';
import '../../widget/custom_cached_network_image.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80), // leave space for button
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big Cached Image
            SizedBox(
              height: 500,
              width: double.infinity,
              child: CustomCachedNetworkImage(
                imageUrl: product['imageUrl'] ?? '',
              ),
            ),

            const SizedBox(height: 16),

            // Product Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Fake Ratings
                  Row(
                    children: List.generate(5, (index) {
                      return const Icon(Icons.star, color: Colors.orange, size: 20);
                    }),
                  ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    '₹ ${product['price'] ?? 0}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['des'] ?? 'No description available.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // You can add a real action here later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proceeding to buy...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Buy Now'),
          ),
        ),
      ),
    );
  }
}

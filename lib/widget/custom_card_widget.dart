import 'package:flutter/material.dart';
import '../widget/custom_cached_network_image.dart';

class CustomCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;

  const CustomCardWidget({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bigger image using fixed height
            SizedBox(
              height: 250, // ⬅️ Increase this to make image bigger
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomCachedNetworkImage(
                  imageUrl: product['imageUrl'] ?? '',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product['name'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '₹ ${product['price'] ?? '0'}',
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

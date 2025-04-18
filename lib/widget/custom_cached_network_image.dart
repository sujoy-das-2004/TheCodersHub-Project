import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;

  const CustomCachedNetworkImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.error, size: 40);
    }

    // Debugging line
    print('Loading image from: $imageUrl');

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) {
        // Logging the error
        print('Error loading image: $url');
        return const Icon(Icons.error, size: 40);
      },
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageLoadingService extends StatelessWidget {
  final String imageUrl;
  final BorderRadius borderRadius;
  const ImageLoadingService(
      {super.key, required this.imageUrl, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: borderRadius,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ))
        : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/img/null_image.jpg',
              fit: BoxFit.cover,
            ));
  }
}
                          
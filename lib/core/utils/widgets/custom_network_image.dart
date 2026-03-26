import 'package:flutter/material.dart';
class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.showLoadingIndicator = false,
    this.fallback,
  });

  final String imageUrl;
  final BoxFit fit;
  final bool showLoadingIndicator;
  final Widget? fallback;

  bool get _isRemoteImage =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final trimmedUrl = imageUrl.trim();
    if (trimmedUrl.isEmpty) {
      return _buildFallback();
    }

    if (!_isRemoteImage) {
      return Image.asset(
        trimmedUrl,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }

    return Image.network(
      trimmedUrl,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildFallback(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null || !showLoadingIndicator) {
          return child;
        }
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Widget _buildFallback() {
    return fallback ??
        Container(
          color: const Color(0xFFEFF4F0),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF85948F),
          ),
        );
  }
}

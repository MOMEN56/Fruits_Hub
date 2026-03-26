import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.showLoadingSkeleton = false,
    this.fallback,
  });

  final String imageUrl;
  final BoxFit fit;
  final bool showLoadingSkeleton;
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
        if (loadingProgress == null || !showLoadingSkeleton) {
          return child;
        }
        return _buildSkeleton();
      },
    );
  }

  Widget _buildFallback() {
    return fallback ?? _buildSkeleton();
  }

  Widget _buildSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth ? constraints.maxWidth : 72.0;
        final height =
            constraints.hasBoundedHeight ? constraints.maxHeight : width;

        return Skeletonizer.zone(
          child: Bone(
            width: width,
            height: height,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

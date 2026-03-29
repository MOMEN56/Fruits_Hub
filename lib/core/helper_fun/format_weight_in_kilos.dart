import 'package:fruit_hub/generated/l10n.dart';

String formatWeightInKilos(S l10n, num weightInKilos) {
  final formattedWeight =
      weightInKilos == weightInKilos.toInt()
          ? weightInKilos.toInt().toString()
          : weightInKilos.toString();

  return l10n.isArabic ? '$formattedWeight كيلو' : '$formattedWeight kg';
}

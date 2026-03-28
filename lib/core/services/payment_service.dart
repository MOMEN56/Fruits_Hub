import 'dart:developer';

import 'package:fruit_hub/core/config/app_environment.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';

class PaymentService {
  static void initialize() {
    final missingKeys = AppEnvironment.missingValues([
      MapEntry('PAYMOB_API_KEY', AppEnvironment.paymobApiKey),
      MapEntry('PAYMOB_IFRAME_ID', AppEnvironment.paymobIframeId),
      MapEntry(
        'PAYMOB_INTEGRATION_CARD_ID',
        AppEnvironment.paymobIntegrationCardId,
      ),
      MapEntry(
        'PAYMOB_INTEGRATION_MOBILE_WALLET_ID',
        AppEnvironment.paymobIntegrationMobileWalletId,
      ),
    ]);

    if (missingKeys.isNotEmpty) {
      log(
        '[Config] Skipping Paymob setup. Missing: ${missingKeys.join(', ')}. '
        'Pass them with --dart-define or --dart-define-from-file=dart_defines.json.',
      );
      return;
    }

    PaymentData.initialize(
      apiKey: AppEnvironment.paymobApiKey.trim(),
      iframeId: AppEnvironment.paymobIframeId.trim(),
      integrationCardId: AppEnvironment.paymobIntegrationCardId.trim(),
      integrationMobileWalletId:
          AppEnvironment.paymobIntegrationMobileWalletId.trim(),
    );
  }
}

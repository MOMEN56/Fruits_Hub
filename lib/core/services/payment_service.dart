import 'package:fruit_hub/core/utils/app_keys.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';

class PaymentService {
  static void initialize() {
    PaymentData.initialize(
      apiKey: KPaymobApiKey,
      iframeId: KPaymobIframeId,
      integrationCardId: KPaymobIntegrationCardId,
      integrationMobileWalletId: KPaymobIntegrationMobileWalletId,
    );
  }
}

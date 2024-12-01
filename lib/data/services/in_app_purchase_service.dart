import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService {
  static Stream<List<PurchaseDetails>> get purchaseStream => InAppPurchase.instance.purchaseStream;

  static Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }
}

import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_user.dart';
import 'package:apphud/models/apphud_models/composite/apphud_product_composite.dart';

class AphudService {
  static ApphudUser? _user;

  static Future<void> init({required String apiKey}) async {
    _user = await Apphud.start(apiKey: apiKey);
  }

  static Future<List<ApphudProductComposite>> fetchProducts() async {
    return await Apphud.products();
  }

  static Future<bool> purchase({String? productId}) async {
    final result = await Apphud.purchase(productId: productId);
    return result.error == null;
  }

  static Future<bool> userHasProduct(String productId) async {
    return _user?.purchases.where((e) => e.productId == productId).firstOrNull != null;
  }

  static Future<List<String>> restorePurchases() async {
    final items = await Apphud.restorePurchases();
    if (items.purchases.isNotEmpty) {
      return items.purchases.map((e) => e.productId).toList();
    }
    return [];
  }

  static Future<bool> hasPremium() async {
    return await Apphud.hasPremiumAccess();
  }
}

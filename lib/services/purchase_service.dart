import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'billing_service.dart';

/// PurchaseService - PRD 6.9 IAP Monthly/Annual
/// Uses in_app_purchase 3.2.1, mock fallback for dev
class PurchaseService {
  static const _monthlyId = 'greetings_premium_monthly';
  static const _annualId = 'greetings_premium_annual';
  final InAppPurchase _iap = InAppPurchase.instance;

  Future<bool> init() async {
    final available = await _iap.isAvailable();
    if (!available) debugPrint('IAP not available - mock mode');
    return available;
  }

  Future<List<ProductDetails>> queryProducts() async {
    try {
      final resp = await _iap.queryProductDetails({_monthlyId, _annualId});
      return resp.productDetails;
    } catch (e) {
      debugPrint('IAP query failed: $e');
      return [];
    }
  }

  Future<bool> buyMonthly() async {
    try {
      final products = await queryProducts();
      final monthly = products.where((p) => p.id == _monthlyId).firstOrNull;
      if (monthly == null) {
        // Mock success for dev
        await BillingService.setPremium(true);
        return true;
      }
      final param = PurchaseParam(productDetails: monthly);
      return _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      debugPrint('Buy monthly mock: $e');
      await BillingService.setPremium(true);
      return true;
    }
  }

  Future<bool> buyAnnual() async {
    try {
      final products = await queryProducts();
      final annual = products.where((p) => p.id == _annualId).firstOrNull;
      if (annual == null) {
        await BillingService.setPremium(true);
        return true;
      }
      final param = PurchaseParam(productDetails: annual);
      return _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      debugPrint('Buy annual mock: $e');
      await BillingService.setPremium(true);
      return true;
    }
  }

  Future<void> restore() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('Restore failed: $e');
    }
    // Mock: if any purchase found, set premium
    // For dev, just set true after restore attempt
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

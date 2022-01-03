enum ReceiptValidationType { PURCHASE, RESTORE, AUTOMATIC }

extension DeepwallReceiptValidationType on ReceiptValidationType {
  static const values = {
    ReceiptValidationType.PURCHASE: 1,
    ReceiptValidationType.RESTORE: 2,
    ReceiptValidationType.AUTOMATIC: 3,
  };

  int? get value => values[this];
}

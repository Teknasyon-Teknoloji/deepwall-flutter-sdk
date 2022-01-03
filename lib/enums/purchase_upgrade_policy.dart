enum Policy { ENABLE_ALL_POLICIES, DISABLE_ALL_POLICIES, ENABLE_ONLY_UPGRADE, ENABLE_ONLY_DOWNGRADE }

extension PurchaseUpgradePolicy on Policy {
  static const values = {
    Policy.DISABLE_ALL_POLICIES: 0,
    Policy.ENABLE_ALL_POLICIES: 1,
    Policy.ENABLE_ONLY_UPGRADE: 2,
    Policy.ENABLE_ONLY_DOWNGRADE: 3
  };

  int? get value => values[this];
}

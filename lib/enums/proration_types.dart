enum ProrationMode { NONE, DEFERRED, IMMEDIATE_AND_CHARGE_PRORATED_PRICE, IMMEDIATE_WITHOUT_PRORATION, IMMEDIATE_WITH_TIME_PRORATION, 	UNKNOWN_SUBSCRIPTION_UPGRADE_DOWNGRADE_POLICY }

extension ProrationModeType on ProrationMode {
  static const values = {
    ProrationMode.NONE: 5,
    ProrationMode.DEFERRED: 4,
    ProrationMode.IMMEDIATE_AND_CHARGE_PRORATED_PRICE: 2,
    ProrationMode.IMMEDIATE_WITHOUT_PRORATION: 3,
    ProrationMode.IMMEDIATE_WITH_TIME_PRORATION: 1,
    ProrationMode.UNKNOWN_SUBSCRIPTION_UPGRADE_DOWNGRADE_POLICY: 0
  };

  int? get value => values[this];
}

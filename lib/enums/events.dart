enum Event {
  PAYWALL_REQUESTED,
  PAYWALL_RESPONSE_RECEIVED,
  PAYWALL_RESPONSE_FAILURE,
  PAYWALL_OPENED,
  PAYWALL_NOT_OPENED,
  PAYWALL_ACTION_SHOW_DISABLED,
  PAYWALL_CLOSED,
  PAYWALL_EXTRA_DATA_RECEIVED,
  PAYWALL_PURCHASING_PRODUCT,
  PAYWALL_PURCHASE_SUCCESS,
  PAYWALL_PURCHASE_FAILED,
  PAYWALL_RESTORE_SUCCESS,
  PAYWALL_RESTORE_FAILED,
  PAYWALL_CONSUME_SUCCESS,
  PAYWALL_CONSUME_FAILURE
}

extension DeepwallEvent on Event {
  static const values = {
    Event.PAYWALL_REQUESTED: 'deepWallPaywallRequested',
    Event.PAYWALL_RESPONSE_RECEIVED: 'deepWallPaywallResponseReceived',
    Event.PAYWALL_RESPONSE_FAILURE: 'deepWallPaywallResponseFailure',
    Event.PAYWALL_OPENED: 'deepWallPaywallOpened',
    Event.PAYWALL_NOT_OPENED: 'deepWallPaywallNotOpened',
    Event.PAYWALL_ACTION_SHOW_DISABLED: 'deepWallPaywallActionShowDisabled',
    Event.PAYWALL_CLOSED: 'deepWallPaywallClosed',
    Event.PAYWALL_EXTRA_DATA_RECEIVED: 'deepWallPaywallExtraDataReceived',
    Event.PAYWALL_PURCHASING_PRODUCT: 'deepWallPaywallPurchasingProduct',
    Event.PAYWALL_PURCHASE_SUCCESS: 'deepWallPaywallPurchaseSuccess',
    Event.PAYWALL_PURCHASE_FAILED: 'deepWallPaywallPurchaseFailed',
    Event.PAYWALL_RESTORE_SUCCESS: 'deepWallPaywallRestoreSuccess',
    Event.PAYWALL_RESTORE_FAILED: 'deepWallPaywallRestoreFailed',
    Event.PAYWALL_CONSUME_SUCCESS: 'deepWallPaywallConsumeSuccess',
    Event.PAYWALL_CONSUME_FAILURE: 'deepWallPaywallConsumeFailure',
  };

  String get value => values[this];
}

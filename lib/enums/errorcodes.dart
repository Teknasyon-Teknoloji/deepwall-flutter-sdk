enum ErrorCode {
  NATIVE_MODULE_NOT_FOUND,
  NATIVE_MODULE_EVENT_EMITTER_NOT_FOUND,
  USER_PROPERTIES_UUID_REQUIRED,
  USER_PROPERTIES_COUNTRY_REQUIRED,
  USER_PROPERTIES_LANGUAGE_REQUIRED,
  VALIDATE_RECEIPT_TYPE_NOT_VALID,
}

class DeepwallException implements Exception {
  int? code;
  String? message;

  DeepwallException(ErrorCode code){
    this.code = code.value!['code'];
    this.message = code.value!['message'];
  }
}

extension DeepwallError on ErrorCode {
  static const values = {
    ErrorCode.NATIVE_MODULE_NOT_FOUND: {
      "code": 101,
      "message": 'Native module "RNDeepWall" not found.',
    },
    ErrorCode.NATIVE_MODULE_EVENT_EMITTER_NOT_FOUND: {
      "code": 121,
      "message": 'Native module "RNDeepWallEmitter" not found.',
    },
    ErrorCode.USER_PROPERTIES_UUID_REQUIRED: {
      "code": 801,
      "message": 'Missing parameter "uuid" for UserProperties.',
    },
    ErrorCode.USER_PROPERTIES_COUNTRY_REQUIRED: {
      "code": 802,
      "message": 'Missing parameter "country" for UserProperties.',
    },
    ErrorCode.USER_PROPERTIES_LANGUAGE_REQUIRED: {
      "code": 803,
      "message": 'Missing parameter "language" for UserProperties.',
    },
    ErrorCode.VALIDATE_RECEIPT_TYPE_NOT_VALID: {
      "code": 902,
      "message": 'Validate receipt type is not valid.',
    },
  };

  Map? get value => values[this];
}

import Flutter
import UIKit
import DeepWall
import Foundation

public class SwiftDeepwallFlutterPlugin: NSObject, FlutterPlugin, DeepWallNotifierDelegate {

    let eventStreamHandler = DeepwallStreamHandler()
    static var viewController = UIViewController();

    override init(){
    }
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "deepwall_flutter_plugin", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "deepwall_plugin_stream", binaryMessenger: registrar.messenger())
        let instance = SwiftDeepwallFlutterPlugin()
        viewController =
                    (UIApplication.shared.delegate?.window??.rootViewController)!;
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(instance.eventStreamHandler)
    }

    class DeepwallStreamHandler : NSObject, FlutterStreamHandler {
        var eventSink: FlutterEventSink?
        override init(){
        }

        public func onListen(withArguments arguments: Any?,eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            self.eventSink = events
            return nil
        }

        func sendData(state: Dictionary<String,Any>) {
            print(state)
            self.eventSink?(state)
        }

        public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            return nil
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print(call.method)
        if(call.method == "initialize"){
            //observeDeepWallEvents()
            DeepWall.shared.observeEvents(for: self)
            guard let args = call.arguments else {
                return result("Could not recognize flutter arguments in method: (initialize)")
            }
            if let myArgs = args as? [String: Any]{
                let apiKey = myArgs["apiKey"] as! String
                let environment = myArgs["environment"] as! Int
                var deepWallEnvironment : DeepWallEnvironment;
                if (environment == 1){
                    deepWallEnvironment = .sandbox
                }
                else{
                    deepWallEnvironment = .production
                }
                DeepWall.initialize(apiKey: apiKey, environment: deepWallEnvironment)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract " +
                    "flutter arguments in method: (initialize)", details: nil))
            }

        }
        else if(call.method == "setUserProperties"){
            guard let args = call.arguments else {
                return result("Could not recognize flutter arguments in method: (setUserProperties)")
            }
            if let myArgs = args as? [String: Any]{
                let uuid = myArgs["uuid"] as! String
                let country = myArgs["country"] as! String
                let language = myArgs["language"] as! String
                let environmentStyle = myArgs["environmentStyle"] as! Int
                let debugAdvertiseAttributions = myArgs["debugAdvertiseAttributions"] as? [String: String]
                let theme: DeepWallEnvironmentStyle = (environmentStyle == 0) ? .light : .dark
                let properties = DeepWallUserProperties(uuid: uuid, country: country, language: language, environmentStyle: theme, debugAdvertiseAttributions:debugAdvertiseAttributions)
                DeepWall.shared.setUserProperties(properties)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract " +
                    "flutter arguments in method: (initialize)", details: nil))
            }
        }
        else if (call.method == "requestPaywall"){
            guard let args = call.arguments else {
                return result("Could not recognize flutter arguments in method: (requestPaywall)")
            }
            if let myArgs = args as? [String: Any]{
                let actionKey = myArgs["actionKey"] as! String
                if let extraData = myArgs["extraData"] as? Dictionary<String,Any> {

                    /*var bundle = Bundle()
                    if (extraData != nil) {
                        for key in extraData.keys {
                            if (extraData[key] is Bool) {
                                bundle.putBoolean(key, extraData[key] as Bool)
                            } else if (extraData[key] is Int) {
                                bundle.putInt(key, extraData[key] as Int)
                            } else if (extraData[key] is Double) {
                                bundle.putDouble(key, extraData[key] as Double)
                            } else if (extraData[key] is String) {
                                bundle.putString(key, extraData[key] as String)
                            }
                            else{
                                bundle.putString(key, extraData[key] as String)
                            }
                        }
                    }*/
                    DeepWall.shared.requestPaywall(action: actionKey, in: SwiftDeepwallFlutterPlugin.viewController, extraData: extraData)
                }
                else{
                    DeepWall.shared.requestPaywall(action: actionKey, in: SwiftDeepwallFlutterPlugin.viewController, extraData: [:])
                }

            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract " +
                    "flutter arguments in method: (requestPaywall)", details: nil))
            }

        }
        else if(call.method == "updateUserProperties"){
            guard let args = call.arguments else {
                return result("Could not recognize flutter arguments in method: (updateUserProperties)")
            }
            if let myArgs = args as? [String: Any]{
                let country = myArgs["country"] as! String
                let language = myArgs["language"] as! String
                let environmentStyle = myArgs["environmentStyle"] as! Int
                let debugAdvertiseAttributions = myArgs["debugAdvertiseAttributions"] as? [String: String]
                let theme: DeepWallEnvironmentStyle = (environmentStyle == 0) ? .light : .dark
                DeepWall.shared.updateUserProperties(country:country, language:language, environmentStyle:theme,debugAdvertiseAttributions:debugAdvertiseAttributions)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract " +
                    "flutter arguments in method: (updateUserProperties)", details: nil))
            }

        }
        else if (call.method == "closePaywall"){
            DeepWall.shared.closePaywall()
        }
        else if(call.method == "hidePaywallLoadingIndicator"){

        }
        else if(call.method == "validateReceipt"){
            guard let args = call.arguments else {
                return result("Could not recognize flutter arguments in method: (validateReceipt)")
            }
            if let myArgs = args as? [String: Any]{
                var validationType = myArgs["validationType"] as? Int
                var validation: PloutosValidationType
                switch (validationType) {
                    case 1:
                        validation = .purchase
                    case 2:
                        validation = .restore
                    case 3:
                        validation = .automatic
                    default:
                        validation = .purchase
                }
                DeepWall.shared.validateReceipt(for: validation)
            } else {
                result(FlutterError(code: "-1", message: "iOS could not extract " +
                    "flutter arguments in method: (validateReceipt)", details: nil))
            }

        }
        else if(call.method == "consumeProduct"){
            //TODO call DeepWall's consumeProduct method
        }
        else if(call.method == "setProductUpgradePolicy"){
            //TODO call DeepWall's setProductUpgradePolicy method
        }
        else if(call.method == "updateProductUpgradePolicy"){
            //TODO call DeepWall's updateProductUpgradePolicy method
        }
        else {
            result(FlutterMethodNotImplemented)
        }
    }

    public func deepWallPaywallRequested() -> Void {
        print("event:deepWallPaywallRequested");
        var mapData = [String: Any]()
        mapData["data"] =  ""
        mapData["event"] = "deepWallPaywallRequested"
        self.eventStreamHandler.sendData(state: mapData)
    }

    public func deepWallPaywallResponseReceived() -> Void {
        print("event:deepWallPaywallResponseReceived");
        var mapData = [String: Any]()
        mapData["data"] =  ""
        mapData["event"] = "deepWallPaywallResponseReceived"
        self.eventStreamHandler.sendData(state: mapData)
    }

    public func deepWallPaywallOpened(_ model: DeepWallPaywallOpenedInfoModel) -> Void {
        print("event:deepWallPaywallOpened");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["pageId"] = model.pageId
        mapData["data"] = modelMap
        mapData["event"] =  "deepWallPaywallOpened"
        self.eventStreamHandler.sendData(state: mapData)
    }

    public func deepWallPaywallNotOpened(_ model: DeepWallPaywallNotOpenedInfoModel) -> Void {
        print("event:deepWallPaywallNotOpened");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["pageId"] = model.pageId
        modelMap["reason"] = model.reason
        modelMap["errorCode"] = model.errorCode
        mapData["data"] =  modelMap
        mapData["event"] =  "deepWallPaywallNotOpened"
        self.eventStreamHandler.sendData(state: mapData)
    }
    public func deepWallPaywallClosed(_ model: DeepWallPaywallClosedInfoModel) -> Void {
        print("event:deepWallPaywallClosed");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["pageId"] = model.pageId
        mapData["data"] =  modelMap
        mapData["event"] =  "deepWallPaywallClosed"
        self.eventStreamHandler.sendData(state: mapData)
    }
    public func deepWallPaywallActionShowDisabled(_ model: DeepWallPaywallActionShowDisabledInfoModel) -> Void {
        print("event:deepWallPaywallActionShowDisabled");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["pageId"] = model.pageId
        mapData["data"] =  modelMap
        mapData["event"] =  "deepWallPaywallActionShowDisabled"
        self.eventStreamHandler.sendData(state: mapData)
    }
    public func deepWallPaywallResponseFailure(_ model: DeepWallPaywallResponseFailedModel) -> Void {
        print("event:deepWallPaywallResponseFailure");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["errorCode"] = model.errorCode
        modelMap["reason"] = model.reason
        mapData["data"] =  modelMap
        mapData["event"] =  "deepWallPaywallResponseFailure"
        self.eventStreamHandler.sendData(state: mapData)
    }
    public func deepWallPaywallPurchasingProduct(_ model: DeepWallPaywallPurchasingProduct) -> Void {
        print("event:deepWallPaywallPurchasingProduct");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["productCode"] = model.productCode
        mapData["data"] =  modelMap
        mapData["event"] =  "deepWallPaywallPurchasingProduct"
        self.eventStreamHandler.sendData(state: mapData)
    }
    public func deepWallPaywallPurchaseSuccess(_ model:  DeepWallValidateReceiptResult) -> Void {
        print("event:deepWallPaywallPurchaseSuccess");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["type"] = model.type.rawValue
        modelMap["result"] = model.result?.toDictionary() as? [String: Any];
        mapData["data"] =  modelMap
        mapData["event"] =  "deepWallPaywallPurchaseSuccess"
        self.eventStreamHandler.sendData(state: mapData)
    }
    public func deepWallPaywallPurchaseFailed(_ model: DeepWallPurchaseFailedModel) -> Void {
        print("event:deepWallPaywallPurchaseFailed");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["productCode"] = model.productCode
        modelMap["reason"] = model.reason
        modelMap["errorCode"] = model.errorCode
        modelMap["isPaymentCancelled"] = model.isPaymentCancelled
        mapData["data"] =  modelMap
        mapData["event"] =  "deepWallPaywallPurchaseFailed"
        self.eventStreamHandler.sendData(state: mapData)
    }
    public func deepWallPaywallRestoreSuccess() -> Void {
        print("event:deepWallPaywallRestoreSuccess");
        var map = [String: Any]()
        map["data"] =  ""
        map["event"] = "deepWallPaywallRestoreSuccess"
        self.eventStreamHandler.sendData(state: map)
    }
    public func deepWallPaywallRestoreFailed(_ model: DeepWallRestoreFailedModel) -> Void {
        print("event:deepWallPaywallRestoreFailed");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["reason"] = model.reason.rawValue
        modelMap["errorCode"] = model.errorCode
        modelMap["errorText"] = model.errorText
        modelMap["isPaymentCancelled"] = model.isPaymentCancelled
        mapData["data"] =  modelMap
        mapData["event"] = "deepWallPaywallRestoreFailed"
        self.eventStreamHandler.sendData(state: mapData)
    }
    public func deepWallPaywallExtraDataReceived(_ model: [AnyHashable : Any]) -> Void {
        print("event:deepWallPaywallExtraDataReceived");
        var mapData = [String: Any]()
        var modelMap = [String: Any]()
        modelMap["extraData"] = model as? [String: Any]
        mapData["data"] =  modelMap
        mapData["event"] = "deepWallPaywallExtraDataReceived"
        self.eventStreamHandler.sendData(state: mapData)
    }

    //private func convertJsonToMap(jsonObject: JSONObject) -> Dictionary<String,Any> {
    //    var map = [String: Any]()
    //
    //    var keysItr = jsonObject.keys().iterator()
    //    while (keysItr.hasNext()) {
    //        var key = keysItr.next()
    //        var value = jsonObject.get(key)
    //
    //        if (value is JSONArray) {
    //            value = convertJsonToArray(value)
    //        } else if (value is JSONObject) {
    //            value = convertJsonToMap(value)
    //        }
    //        map.put(key, value)
    //    }
    //    return map
    //}

    private func convertJson(data: Data?) -> [String: Any]? {
        do {
            //let data = try JSONSerialization.data(withJSONObject: model, options: .prettyPrinted)

            let jsonData = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any]
            return jsonData
        } catch {
            assertionFailure("JSON data creation failed with error: \(error).")
            return nil
        }
    }

    //private func convertJsonToArray(jsonArray: JSONArray) -> [Any]? {
    //    var array = [Any]()
    //    for i in 0...array.length() - 1 {
    //        var value = array.get(i)
    //        if (value is JSONArray) {
    //            value = convertJsonToArray(value)
    //        } else if (value is JSONObject) {
    //            value = convertJsonToMap(value)
    //        }
    //        list.add(value)
    //    }
    //    return list
    // }

}

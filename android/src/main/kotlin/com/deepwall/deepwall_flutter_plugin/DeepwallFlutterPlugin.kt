package com.deepwall.deepwall_flutter_plugin

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.google.gson.Gson
import deepwall.core.DeepWall
import deepwall.core.DeepWall.initDeepWallWith
import deepwall.core.DeepWall.setUserProperties
import deepwall.core.models.*
import manager.eventbus.EventBus
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.reactivex.functions.Consumer
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.util.*
import android.util.Log

/** DeepwallFlutterPlugin */
class DeepwallFlutterPlugin(): FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var context: Context
  private lateinit var activity: Activity
  val eventStremHandler = DeepwallStreamHandler()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    //val instance = DeepwallFlutterPlugin()
    val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "deepwall_flutter_plugin")
    channel.setMethodCallHandler(this)
    val eventChannel = EventChannel(flutterPluginBinding.binaryMessenger,"deepwall_plugin_stream")
    eventChannel.setStreamHandler(eventStremHandler)
    context = flutterPluginBinding.applicationContext
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = DeepwallFlutterPlugin()
      val channel = MethodChannel(registrar.messenger(), "deepwall_flutter_plugin")
      channel.setMethodCallHandler(instance)
      val eventChannel = EventChannel(registrar.messenger(),"deepwall_plugin_stream")
      eventChannel.setStreamHandler(instance.eventStremHandler)
      instance.context = registrar.context()
    }
  }

  class DeepwallStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    override fun onListen(argunents: Any?, sink: EventChannel.EventSink) {
      eventSink = sink
    }

    fun sendData(state: Map<String, Any>) {
      Handler(Looper.getMainLooper()).post {
        Log.e("SEND",Gson().toJson(state))
        eventSink?.success(state)
      }
    }

    override fun onCancel(p0: Any?) {
      eventSink = null
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if(call.method == "initialize"){
      observeDeepWallEvents();
      val apiKey = call.argument<String>("apiKey")
      val environment = call.argument<Int>("environment")
      val deepWallEnvironment = if (environment == 1) DeepWallEnvironment.SANDBOX else DeepWallEnvironment.PRODUCTION
      DeepWall.initDeepWallWith(activity.application, this.activity, apiKey!!, deepWallEnvironment)
    }
    else if(call.method == "setUserProperties"){
      val uuid = call.argument<String>("uuid")
      val country = call.argument<String>("country")
      val language = call.argument<String>("language")
      val environmentStyle = call.argument<Int>("environmentStyle")
      val debugAdvertiseAttributions = call.argument<HashMap<String,Any>> ("debugAdvertiseAttributions")
      val theme: DeepWallEnvironmentStyle = if (environmentStyle == 0) DeepWallEnvironmentStyle.LIGHT else DeepWallEnvironmentStyle.DARK
      // DeepWall.setUserProperties(uuid!!, country!!, language!!, theme!!)
      DeepWall.setUserProperties(
        deviceId = uuid!!,
        countryCode = country!!,
        languageCode = language!!,
        environmentStyle = theme!!
      )
    }
    else if (call.method == "requestPaywall"){
      val actionKey = call.argument<String>("actionKey")
      var extraData = call.argument<HashMap<String,Any>>("extraData")
      var bundle = Bundle()
      if (extraData != null) {
        for (key in extraData.keys) {
          if (extraData.get(key) is Boolean) {
            bundle.putBoolean(key, extraData.get(key) as Boolean)
          } else if (extraData.get(key) is Int) {
            bundle.putInt(key, extraData.get(key) as Int)
          } else if (extraData.get(key) is Double) {
            bundle.putDouble(key, extraData.get(key) as Double)
          } else if (extraData.get(key) is String) {
            bundle.putString(key, extraData.get(key) as String)
          }
          else{
            bundle.putString(key, extraData.get(key) as String)
          }
        }
      }
      DeepWall.showPaywall(this.activity, actionKey!!, bundle)
    }
    else if (call.method == "requestAppTracking"){
      //
    }
    else if (call.method == "sendExtraDataToPaywall"){
      //
    }
    else if(call.method == "updateUserProperties"){
      val country = call.argument<String>("country")
      val language = call.argument<String>("language")
      val environmentStyle = call.argument<Int>("environmentStyle")
      val debugAdvertiseAttributions = call.argument<HashMap<String,Any>> ("debugAdvertiseAttributions")
      val theme: DeepWallEnvironmentStyle = if (environmentStyle == 0) DeepWallEnvironmentStyle.LIGHT else DeepWallEnvironmentStyle.DARK
      DeepWall.updateUserProperties(country!!, language!!, theme)
    }
    else if (call.method == "closePaywall"){
      DeepWall.closePaywall()
    }
    else if(call.method == "hidePaywallLoadingIndicator"){

    }
    else if(call.method == "validateReceipt"){
      val validationType = call.argument<Int>("validationType")
      val validation = when (validationType) {
        1 -> DeepWallReceiptValidationType.PURCHASE
        2 -> DeepWallReceiptValidationType.RESTORE
        3 -> DeepWallReceiptValidationType.AUTOMATIC
        else -> DeepWallReceiptValidationType.PURCHASE
      }
      DeepWall.validateReceipt(validation)
    }
    else if(call.method == "consumeProduct"){
      val productId = call.argument<String>("productId")
      DeepWall.consumeProduct(productId!!)
    }
    else if(call.method == "setProductUpgradePolicy"){
      val prorationType = call.argument<Int>("prorationType")
      val upgradePolicy = call.argument<Int>("upgradePolicy")
      val proration = when (prorationType) {
        0 -> ProrationType.UNKNOWN_SUBSCRIPTION_UPGRADE_DOWNGRADE_POLICY
        1 -> ProrationType.IMMEDIATE_WITH_TIME_PRORATION
        2 -> ProrationType.IMMEDIATE_WITHOUT_PRORATION
        3 -> ProrationType.IMMEDIATE_AND_CHARGE_PRORATED_PRICE
        4 -> ProrationType.DEFERRED
        5 -> ProrationType.NONE
        else -> ProrationType.NONE
      }
      val policy = when (upgradePolicy) {
        0 -> PurchaseUpgradePolicy.DISABLE_ALL_POLICIES
        1 -> PurchaseUpgradePolicy.ENABLE_ALL_POLICIES
        2 -> PurchaseUpgradePolicy.ENABLE_ONLY_UPGRADE
        3 -> PurchaseUpgradePolicy.ENABLE_ONLY_DOWNGRADE
        else -> PurchaseUpgradePolicy.DISABLE_ALL_POLICIES
      }
      DeepWall.setProductUpgradePolicy(proration,policy)
    }
    else if(call.method == "updateProductUpgradePolicy") {
      val prorationType = call.argument<Int>("prorationType")
      val upgradePolicy = call.argument<Int>("upgradePolicy")
      val proration = when (prorationType) {
        0 -> ProrationType.UNKNOWN_SUBSCRIPTION_UPGRADE_DOWNGRADE_POLICY
        1 -> ProrationType.IMMEDIATE_WITH_TIME_PRORATION
        2 -> ProrationType.IMMEDIATE_WITHOUT_PRORATION
        3 -> ProrationType.IMMEDIATE_AND_CHARGE_PRORATED_PRICE
        4 -> ProrationType.DEFERRED
        5 -> ProrationType.NONE
        else -> ProrationType.NONE
      }
      val policy = when (upgradePolicy) {
        0 -> PurchaseUpgradePolicy.DISABLE_ALL_POLICIES
        1 -> PurchaseUpgradePolicy.ENABLE_ALL_POLICIES
        2 -> PurchaseUpgradePolicy.ENABLE_ONLY_UPGRADE
        3 -> PurchaseUpgradePolicy.ENABLE_ONLY_DOWNGRADE
        else -> PurchaseUpgradePolicy.DISABLE_ALL_POLICIES
      }
      DeepWall.updateProductUpgradePolicy(proration,policy)
    }
    else {
      result.notImplemented()
    }
  }

  private fun observeDeepWallEvents() {
    EventBus.subscribe(Consumer {

      var map = HashMap<String,Any>()

      when (it.type) {
        DeepWallEvent.PAYWALL_OPENED.value -> {
          map = HashMap<String,Any>()
          val data = it.data as PaywallOpenedInfo
          val modelMap = convertJsonToMap(convertJson(data))
          map.put("data", modelMap)
          map.put("event", "deepWallPaywallOpened")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }
        DeepWallEvent.DO_NOT_SHOW.value -> {
          map = HashMap<String,Any>()
          val data = it.data as PaywallActionShowDisabledInfo
          val modelMap = convertJsonToMap(convertJson(data))
          map.put("data", modelMap)
          map.put("event", "deepWallPaywallActionShowDisabled")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }
        DeepWallEvent.CLOSED.value -> {
          map = HashMap<String,Any>()
          val data = it.data as PaywallClosedInfo
          val modelMap = convertJsonToMap(convertJson(data))
          map.put("data", modelMap)
          map.put("event", "deepWallPaywallClosed")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }
        DeepWallEvent.PAYWALL_PURCHASING_PRODUCT.value -> {
          map = HashMap<String,Any>()
          val data = it.data as PaywallPurchasingProductInfo
          val modelMap = convertJsonToMap(convertJson(data))
          map.put("data", modelMap)
          map.put("event", "deepWallPaywallPurchasingProduct")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }
        DeepWallEvent.PAYWALL_PURCHASE_FAILED.value -> {
          map = HashMap<String,Any>()
          val data = it.data as SubscriptionErrorResponse
          val modelMap = convertJsonToMap(convertJson(data))
          map.put("data", modelMap)
          map.put("event", "deepWallPaywallPurchaseFailed")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }
        DeepWallEvent.PAYWALL_PURCHASE_SUCCESS.value -> {
          map = HashMap<String,Any>()
          val data = it.data as SubscriptionResponse
          val modelMap = convertJsonToMap(convertJson(data))
          map.put("data", modelMap)
          map.put("event", "deepWallPaywallPurchaseSuccess")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }

        DeepWallEvent.PAYWALL_RESPONSE_FAILURE.value -> {
          map = HashMap<String,Any>()
          val data = it.data as PaywallFailureResponse
          val modelData = convertJsonToMap(convertJson(data))
          map.put("data", modelData)
          map.put("event", "deepWallPaywallResponseFailure")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }

        DeepWallEvent.PAYWALL_RESTORE_SUCCESS.value -> {
          map = HashMap<String,Any>()
          map.put("data", it.data.toString())
          map.put("event", "deepWallPaywallRestoreSuccess")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }

        DeepWallEvent.PAYWALL_RESTORE_FAILED.value -> {
          map = HashMap<String,Any>()
          map.put("data", it.data.toString())
          map.put("event", "deepWallPaywallRestoreFailed")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }
        DeepWallEvent.EXTRA_DATA.value -> {
          map = HashMap<String,Any>()
          val modelData = it.data?.let { it1 -> convertJson(it1) }?.let { it2 -> convertJsonToMap(it2) }
          map.put("data", modelData as HashMap<String,Any>)
          map.put("event", "deepWallPaywallExtraDataReceived")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }

        DeepWallEvent.PAYWALL_REQUESTED.value -> {
          map = HashMap<String,Any>()
          map.put("data", "")
          map.put("event", "deepWallPaywallRequested")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }

        DeepWallEvent.PAYWALL_RESPONSE_RECEIVED.value -> {
          map = HashMap<String,Any>()
          map.put("data", "")
          map.put("event", "deepWallPaywallResponseReceived")
          eventStremHandler.sendData(map)
          //deepWallEmitter.sendEvent(reactContext, "DeepWallEvent", map)
        }

        DeepWallEvent.CONSUME_SUCCESS.value -> {
          map = HashMap<String,Any>()
          map.put("data", "")
          map.put("event", "deepWallPaywallConsumeSuccess")
          eventStremHandler.sendData(map)
        }

        DeepWallEvent.CONSUME_FAILURE.value -> {
          map = HashMap<String,Any>()
          map.put("data", "")
          map.put("event", "deepWallPaywallConsumeFailure")
          eventStremHandler.sendData(map)
        }
      }

    })
  }

  @Throws(JSONException::class)
  private fun convertJsonToMap(`object`: JSONObject): HashMap<String,Any> {
    val map = HashMap<String, Any>()

    val keysItr = `object`.keys().iterator()
    while (keysItr.hasNext()) {
      val key = keysItr.next()
      var value = `object`.get(key)

      if (value is JSONArray) {
        value = convertJsonToArray(value)
      } else if (value is JSONObject) {
        value = convertJsonToMap(value)
      }
      map.put(key, value)
    }
    return map
  }

  @Throws(JSONException::class)
  private fun convertJson(model: Any): JSONObject {
    val gson = Gson()
    val jsonInString = gson.toJson(model)
    return JSONObject(jsonInString)
  }


  @Throws(JSONException::class)
  private fun convertJsonToArray(array: JSONArray): ArrayList<Any> {
    val list = ArrayList<Any>()
    for (i in 0..array.length() - 1) {
      var value = array.get(i)
      if (value is JSONArray) {
        value = convertJsonToArray(value)
      } else if (value is JSONObject) {
        value = convertJsonToMap(value)
      }
      list.add(value)
    }
    return list
  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    //channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }
}

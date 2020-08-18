import Flutter
import UIKit
import Flurry_iOS_SDK


var methodChannel: FlutterMethodChannel?
let MESSAGE_CHANNEL = "flutter_flurry_sdk/message";
let ERROR_CODE = "FLUTTER_FLURRY_SDK_ERROR"

public class SwiftFlutterFlurrySdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftFlutterFlurrySdkPlugin()
        
        methodChannel = FlutterMethodChannel(name: MESSAGE_CHANNEL, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: methodChannel!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method.elementsEqual("initialize")) {
            initialize(call, result)
        } else if (call.method.elementsEqual("logEvent")) {
            logEvent(call, result)
        } else if (call.method.elementsEqual("endTimedEvent")) {
            endTimedEvent(call, result)
        } else if (call.method.elementsEqual("userId")) {
            setUserId(call, result)
        }
    }
    
    private func initialize(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        if let _args = arguments {
            let apiKey = _args["api_key_ios"] as? String
            let isLogEnabled = _args["is_log_enabled"] as? Bool
            let version = _args["app_version"] as? String
            
            if let _apiKey = apiKey, let _isLog = isLogEnabled {
                var builder = FlurrySessionBuilder.init()
                    .withLogLevel(_isLog ? FlurryLogLevelAll : FlurryLogLevelNone)
                    .withCrashReporting(true)
                    .withShowError(inLog: true)
                if let _version = version {
                    builder = builder?.withAppVersion(_version)
                }
                
                Flurry.startSession(_apiKey, with: builder)
            }
        }
        result(nil)
    }
    
    private func logEvent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        if let _args = arguments {
            let event = _args["event"] as? String
            let parameters = _args["parameters"] as? [AnyHashable: Any]
            
            if let _event = event {
                Flurry.logEvent(_event, withParameters: parameters);
            }
        }
        result(nil)
    }
    
    private func endTimedEvent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        if let _args = arguments, let _event = _args["event"] as? String {
            Flurry.endTimedEvent(_event, withParameters: nil);
        }
        result(nil)
    }
    
    private func setUserId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        if let _args = arguments, let _userId = _args["userId"] as? String {
            Flurry.setUserID(_userId)
        }
        result(nil)
    }
}

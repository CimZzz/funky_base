import Flutter
import UIKit

public class SwiftFunkyBasePlugin: NSObject, FlutterPlugin {

    var childProcessorList = [String: BaseMethodProcessor].init()

    public func addProcessor(_ processor: BaseMethodProcessor) {
        childProcessorList[processor.getMethodName()] = processor
    }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "funky_base", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(SwiftFunkyBasePlugin(), channel: channel)
  }

  public static func registerConfig(registry: FlutterPluginRegistry, configCallback: @escaping (SwiftFunkyBasePlugin) -> Void) {
    let registrar = registry.registrar(forPlugin: "FunkyBasePlugin")
    let channel = FlutterMethodChannel(name: "funky_base", binaryMessenger: registrar.messenger())
    let instance = SwiftFunkyBasePlugin()
    configCallback(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let findProcessor = childProcessorList[call.method]
    if let processor = findProcessor {
        processor.handleMethodCall(call, result: result)
    }
  }
}
import UIKit
import Flutter
import funky_base

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    SwiftFunkyBasePlugin.registerConfig(registry: self, configCallback: {
        config in
        config.addProcessor(TestPlugin.init())
        config.addProcessor(TestPlugin2.init())
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

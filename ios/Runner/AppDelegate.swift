import Flutter
import UIKit
import StoreKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    // Register method channel for presenting App Store product view
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "com.poink.app/store", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { (call, reply) in
        if call.method == "presentStore", let args = call.arguments as? [String: Any], let id = args["id"] as? String {
          self.presentStore(appId: id)
          reply(nil)
        } else {
          reply(FlutterMethodNotImplemented)
        }
      }
    }

    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

    private func presentStore(appId: String) {
      guard let root = window?.rootViewController else { return }

      if #available(iOS 11.0, *) {
        let storeVC = SKStoreProductViewController()
        storeVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: Int(appId) ?? 0)]) { (loaded, error) in
          if loaded {
            root.present(storeVC, animated: true, completion: nil)
          } else {
            // fallback: open URL
            if let url = URL(string: "https://apps.apple.com/app/id\(appId)") {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
          }
        }
      } else {
        if let url = URL(string: "https://apps.apple.com/app/id\(appId)") {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
    }

}

  private func presentStore(appId: String) {
    guard let root = window?.rootViewController else { return }

    if #available(iOS 11.0, *) {
      let storeVC = SKStoreProductViewController()
      storeVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: Int(appId) ?? 0)]) { (loaded, error) in
        if loaded {
          root.present(storeVC, animated: true, completion: nil)
        } else {
          // fallback: open URL
          if let url = URL(string: "https://apps.apple.com/app/id\(appId)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
        }
      }
    } else {
      if let url = URL(string: "https://apps.apple.com/app/id\(appId)") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
  }

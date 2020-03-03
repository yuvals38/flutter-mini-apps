import UIKit
import Flutter
import GoogleMaps
import Firebase

//AIzaSyB0erJwvorfDI3ZfanpNJ6NA5wrouUyDjo
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyDPaFRwkTfLGUgDovW6ZrldT9e77mYR7sU")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)

    
  }

}




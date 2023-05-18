import UIKit
import Flutter
import GoogleMaps
import zpdk
import background_locator

import path_provider

// chanel Init to handle Channel Flutter //Zalo SDK
enum ChannelName {
  static let channelPayOrder = "flutter.native/channelPayOrder"
  static let eventPayOrder = "flutter.native/eventPayOrder"
}

// methods define to handle in channel //Zalo SDK
enum MethodNames {
    static let methodPayOrder = "payOrder"
}

// change app icon chanel 
enum ChangeAppIconChanel {
    static let changeAppIcon = "changeAppIcon"
}

// background_locator
func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler, ZPPaymentDelegate {
    //Zalo SDK
    let PAYMENTCOMPLETE = 1
    let PAYMENTERROR = -1
    let PAYMENTCANCELED = 4
    
    var APP_RECEIVE_NOTIFICATION = "com.house.citizen/receive_notification"
    
    var receiveNotificationStreamHandler: StreamHandle?
    
    private var eventSink: FlutterEventSink?
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBGAciDODuJChXXJ1KNdg4FCee_bTicjIw")
      
        GeneratedPluginRegistrant.register(with: self)

        BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
        registerOtherPlugins()

        Thread.sleep(forTimeInterval: 1.0)

        self.initAllChannel()
        
        // [START register_for_notifications]
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        if let remoteNoti = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] {
            if let remoteNotiWhenLaunch = remoteNoti as? [AnyHashable : Any] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    if let jsonData = self.DictionaryToJSONString(dict: remoteNotiWhenLaunch) {
                        self.receiveNotificationStreamHandler?.excuteEventSink(data: jsonData)
                    }
                }
            }
        }
        
        // [END register_for_notifications]
        
        //Zalo Pay
        // handle channel in native iOS
        let controller = window.rootViewController as? FlutterViewController
        let nativeChannel = FlutterMethodChannel(name: ChannelName.channelPayOrder, binaryMessenger: controller!.binaryMessenger)
        
        nativeChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == MethodNames.methodPayOrder else {
              result(FlutterMethodNotImplemented)
              return
            }
            
            let args = call.arguments as? [String: Any]
            let  _zptoken = args?["zptoken"] as? String
            let _appId = args?["appId"] as? Int
            let isTestMode = args?["isTestMode"] as? Bool
            ZaloPaySDK.sharedInstance()?.initWithAppId(_appId ?? 0, uriScheme: "houzepayment://zalo", environment: isTestMode == true ? .sandbox : .production)
            ZaloPaySDK.sharedInstance()?.paymentDelegate = self
            ZaloPaySDK.sharedInstance()?.payOrder(_zptoken)
            result("Processing...")
        })
             
        let eventPayOrderChannel = FlutterEventChannel(name: ChannelName.eventPayOrder,
                                                  binaryMessenger: controller!.binaryMessenger)
        
        eventPayOrderChannel.setStreamHandler(self)

        //change app icon
        let appIconChannel = FlutterMethodChannel(name: ChangeAppIconChanel.changeAppIcon, binaryMessenger: controller!.binaryMessenger)
        
        appIconChannel.setMethodCallHandler({
            [weak self](call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "changeIcon" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.changeAppIcon(call: call)
        })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func paymentDidSucceeded(_ transactionId: String!, zpTranstoken: String!, appTransId: String!) {
        //Handle Success
        guard let eventSink = eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTCOMPLETE, "zpTranstoken": zpTranstoken ?? "", "transactionId": transactionId ?? "", "appTransId": appTransId ?? ""])
    }
    func paymentDidCanceled(_ zpTranstoken: String!, appTransId: String!) {
        //Handle Canceled
        guard let eventSink = eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTCANCELED, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }
    func paymentDidError(_ errorCode: ZPPaymentErrorCode, zpTranstoken: String!, appTransId: String!) {
        guard let eventSink = eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTERROR, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }
    
    
    // func implement with FlutterStreamHandler
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        return nil
     }

    // func implement with FlutterStreamHandler
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    override func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var rs = ZaloPaySDK.sharedInstance().application(app, open: url, sourceApplication: "vn.com.vng.zalo", annotation: nil)
        rs = rs || super.application(app, open: url, options: options)
        return rs
    }
    
    override func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func initAllChannel() {
        let controller: FlutterViewController = self.window?.rootViewController as! FlutterViewController
        let sizeChannel = FlutterMethodChannel.init(name: "com.house.citizen", binaryMessenger: controller.binaryMessenger)
        sizeChannel.setMethodCallHandler { (call, result) in
            if "size".compare(call.method) == .orderedSame {
                let a = [
                    [UIScreen.main.bounds.size.width],
                    [UIScreen.main.bounds.size.height]
                ]
                result(a)
            } else if "device_token".compare(call.method) == .orderedSame {
                let token = UserDefaults.standard.string(forKey: "device_token") ?? ""
                result(token)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        self.receiveNotificationStreamHandler = StreamHandle()
        FlutterEventChannel.init(name: self.APP_RECEIVE_NOTIFICATION, binaryMessenger: controller.binaryMessenger).setStreamHandler((self.receiveNotificationStreamHandler as! FlutterStreamHandler & NSObjectProtocol))
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewsfeedReload"), object: nil)
        // Change this to your preferred presentation option
        completionHandler([.alert, .sound, .badge])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        if let jsonData = DictionaryToJSONString(dict: userInfo) {
            self.receiveNotificationStreamHandler?.excuteEventSink(data: jsonData)
        }
        completionHandler()
    }
    
    func DictionaryToJSONString(dict: [AnyHashable :Any]) -> String?{
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        return jsonString
    }

    func registerOtherPlugins() {
        if !hasPlugin("io.flutter.plugins.pathprovider") {
            FLTPathProviderPlugin
                .register(with: registrar(forPlugin: "io.flutter.plugins.pathprovider") as! FlutterPluginRegistrar )
        }
    }

    private func changeAppIcon(call: FlutterMethodCall) {
        if #available(iOS 10.3, *) {
            guard UIApplication.shared.supportsAlternateIcons else {
                return
            }

            let changeableIcons: [String] = ["nozomi", "moonlight", "ipsc", "vanphuc"]
            let icon : String = call.arguments as! String
            
            if changeableIcons.contains(icon) {
                UIApplication.shared.setAlternateIconName(icon)
            } else {
                UIApplication.shared.setAlternateIconName(nil)
            }
        } else { 
            // Fallback on earlier versions
            showAlertDialog(title: "Message", msg: "Sorry, this feature is only supported on iOS version > 10.3")
        }
    }

    func showAlertDialog(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
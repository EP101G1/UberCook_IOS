//
//  AppDelegate.swift
//  UberCook
//
//  Created by 超 on 2020/8/29.
//

import UIKit
import AdSupport
import TPDirect
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    // set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask { //QR code使用
        return self.orientationLock
    }
    
    func clear(){
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChefGoogleMapVC") as! ChefGoogleMapVC
        window?.rootViewController = VC
        window?.makeKeyAndVisible()
    }
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyCRK1Iozkdnpu9ojMqwEOTqduzz6SFDTtE")
        GMSServices.provideAPIKey("AIzaSyCRK1Iozkdnpu9ojMqwEOTqduzz6SFDTtE")
        TPDSetup.setWithAppId(appId, withAppKey: appKey, with: TPDServerType.sandBox)
        // 使用IDFA，之後上架申請時，要勾選有使用廣告識別碼
        let IDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        // Please setup Advertising Identifier, to improve the accuracy of fraud detect.
        TPDSetup.shareInstance().setupIDFA(IDFA)
        TPDSetup.shareInstance().serverSync()
        TPDLinePay.addExceptionObserver(#selector(tappayLinePayExceptionHandler(notification:)))
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // For version higher than iOS 9.0
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Check Url from TapPay and parse URL data.
        let tapPayHandled = TPDLinePay.handle(url)
        if (tapPayHandled) {
            return true
        }
        
        return false
    }
    
    // For version lower than iOS 9.0
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Check Url from TapPay and parse URL data.
        let tapPayHandled = TPDLinePay.handle(url)
        if (tapPayHandled) {
            return true
        }
        
        return false
    }
    
    // When exception happened receive notification.
    @objc func tappayLinePayExceptionHandler(notification: Notification) {
        let result : TPDLinePayResult = TPDLinePay.parseURL(notification)
        print("status : \(result.status) , orderNumber : \(result.orderNumber ?? "No orderNumber!") , recTradeid : \(result.recTradeId ?? "No recTradeId!") , bankTransactionId : \(result.bankTransactionId ?? "No bankTransactionId!") ")
    }


}


//
//  AppDelegate.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if UserDefaults.standard.integer(forKey: kIsPass) == 0 {
            let now = Date()
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyyMMdd"
            let nowNum = Int(dformatter.string(from: now))
            if let nowday = nowNum {
                if nowday > 20181215 {
                    UserDefaults.standard.set( 2, forKey: kIsPass)
                } else {
                    UserDefaults.standard.set( 1, forKey: kIsPass)
                }
            } else {
                UserDefaults.standard.set( 1, forKey: kIsPass)
            }
        }
        AudioClass.shared.playSound(name: "Fantasy_Game_Background_Looping")
        if #available(iOS 10, *) {
            let entity = JPUSHRegisterEntity()
            
            entity.types = 0|1|2
            
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate:self)
            
        } else {
            
            JPUSHService.register(forRemoteNotificationTypes:0|1|2, categories:nil)
        }
        
        // reg JPushSDK
        JPUSHService.setup(withOption: nil, appKey: "266c0e5f2154a9bbc3519e90",
                           channel: "all", apsForProduction: true)
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

class AudioClass {
    static let shared = AudioClass()
    var player: AVAudioPlayer?
    func playSound(name: String) {
        if let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") {
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: soundURL)
                if let thePlayer = player {
                    thePlayer.prepareToPlay()
                    thePlayer.play()
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    func changeVolume( value: Float) {
        player?.volume = value
    }
}

extension AppDelegate: JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(0)
    }
    
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler()
    }
    
}


//
//  AppDelegate.swift
//  Route
//
//  Created by Надежда Морозова on 03/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        GMSServices.provideAPIKey("AIzaSyBV7R0VX7VUoew5SBhPT49T-H9Hk5Yyb8Y")
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            
            self.sendNotificatioRequest(
                content: self.makeNotificationContent(),
                trigger: self.makeIntervalNotificatioTrigger()
            )
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffect = UIVisualEffectView(effect: blur)
        blurEffect.frame = window!.frame
        blurEffect.tag = 1
        blurEffect.alpha = 0.9
        self.window?.addSubview(blurEffect)

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      self.window?.viewWithTag(1)?.removeFromSuperview()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func makeNotificationContent() -> UNNotificationContent {
        // Внешний вид уведомления
        let content = UNMutableNotificationContent()
        // Заголовок
        content.title = "Вы нас покинули :("
        // Подзаголовок
        content.subtitle = "Возвращайтесь!!!"
        // Основное сообщение
        content.body = "Мы вас ждем!"
        // Цифра в бейдже на иконке
        content.badge = 1
        // звук
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName.init("default"))
        return content
    }
    func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            // Количество секунд до показа уведомления
            timeInterval: 1800,
            // Надо ли повторять
            repeats: false
        )
    }
    func sendNotificatioRequest(
        content: UNNotificationContent,
        trigger: UNNotificationTrigger) {
        
        // Создаём запрос на показ уведомления
        let request = UNNotificationRequest(
            identifier: "alaram",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        // Добавляем запрос в центр уведомлений
        center.add(request) { error in
            // Если не получилось добавить запрос,
            // показываем ошибку, которая при этом возникла
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }


}


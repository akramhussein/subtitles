//
//  AppDelegate.swift
//  Subtitles
//
//  Created by Akram Hussein on 06/08/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import UIKit
import AHUtils

import DefaultsKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Theme.apply(statusBarColor: .black)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = AudioViewController()
        self.window?.makeKeyAndVisible()

        return true
    }

}

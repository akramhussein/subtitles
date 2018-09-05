//
//  UIDevice.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import UIKit

public extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }

    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case unknown
    }

    var screenType: ScreenType {
        guard iPhone else { return .unknown }

        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .unknown
        }
    }
    
    var iosVersion: Double? {
        guard let version = Double(self.systemVersion) else { return nil }
        return version
    }

    var iOS11: Bool {
        return self.iosVersion ?? 0.0 >= 11.0
    }
    
    var iOS10: Bool {
        return self.iosVersion ?? 0.0 >= 10.0
    }
    
    var iOS9: Bool {
        return self.iosVersion ?? 0.0 >= 9.0
    }
    
    var iOS8: Bool {
        return self.iosVersion ?? 0.0 >= 8.0
    }
    
    var iOS7: Bool {
        return self.iosVersion ?? 0.0 >= 7.0
    }
}

//
//  Platform.swift
//  AHUtils
//
//  Created by Akram Hussein on 02/11/2018.
//  Copyright (c) 2018 Akram Hussein. All rights reserved.
//

import Foundation

public struct Platform {
    public static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

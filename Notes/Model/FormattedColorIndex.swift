//
//  FormattedColorIndex.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/18/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

enum RGBA {
    case red
    case green
    case blue
    case alpha
    
    var index: Int {
        switch self {
        case .red: return 0
        case .green: return 1
        case .blue: return 2
        case .alpha: return 3
        }
    }
}

enum HSB {
    case hue
    case saturation
    case brightness
    
    var index: Int {
        switch self {
        case .hue: return 0
        case .saturation: return 1
        case .brightness: return 2
        }
    }
}

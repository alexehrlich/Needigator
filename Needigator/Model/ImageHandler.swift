//
//  ImageHandler.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 21.10.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation

struct ImageHandler{
    
    var inputCGImage = 
    
    let colorSpace       = CGColorSpaceCreateDeviceRGB()
    let width            = inputCGImage.width
    let height           = inputCGImage.height
    let bytesPerPixel    = 4
    let bitsPerComponent = 8
    let bytesPerRow      = bytesPerPixel * width
    let bitmapInfo       = RGBA32.bitmapInfo
    
}

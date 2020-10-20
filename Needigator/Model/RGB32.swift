//
//  RGB32.swift
//  Needigator
//
//  Created by Alexander Ehrlich on 21.03.20.
//  Copyright © 2020 Alexander Ehrlich. All rights reserved.
//

import Foundation
import CoreGraphics

struct RGBA32: Equatable {
       private var color: UInt32
       
    //Getter zugriffe auf die 32Bit RGB-Farbkomponente
       var redComponent: UInt8 {
           return UInt8((color >> 24))
       }
       
       var greenComponent: UInt8 {
           return UInt8((color >> 16))
       }
       
       var blueComponent: UInt8 {
           return UInt8((color >> 8))
       }
       
       var alphaComponent: UInt8 {
           return UInt8((color >> 0))
       }
       
    
        //Bei der Initialisierung wird eine 32-Bit Integer erzeigt mit rot, grün, blau und alpha Komponente - je 8 Bit
       init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
           let red   = UInt32(red)
           let green = UInt32(green)
           let blue  = UInt32(blue)
           let alpha = UInt32(alpha)
        
        //Zu Beginn ist z.B. red eine 32-Bit Zahl bei der nur die letzten 8 Stellen belegt sind. Für das 32-Bit RGB Format werden die Bits um 24 nach links verschoben, dass die Bits 32 bis 24 rot repräsentieren. Alle Farbanteile werden dann verodert ("addiert")
           color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
       }
       
        //Farben im RGB32-Format
       static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
       static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
       static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
       static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
       static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
       static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
       static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
       static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)
       
       
       static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
       
        //Implementierung des Equatable-Protokolls um Farben vergleichen zu können. Farben sind 32Bi Integer welche das Equatable-Protokoll implementieren und ohnehin vergleichbar sind.
    
       static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
           return lhs.color == rhs.color
       }
   }

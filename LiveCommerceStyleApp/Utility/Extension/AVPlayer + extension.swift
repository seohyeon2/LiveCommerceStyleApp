//
//  AVPlayer + extension.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/16.
//

import AVFoundation

extension AVPlayer {
     var isPlaying:Bool {
         get {
             return (self.rate != 0 && self.error == nil)
         }
     }
 }

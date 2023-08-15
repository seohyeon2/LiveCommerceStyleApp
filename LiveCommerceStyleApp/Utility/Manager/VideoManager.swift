//
//  VideoManager.swift
//  LiveCommerceStyleApp
//
//  Created by seohyeon park on 2023/02/15.
//

import AVFoundation

class VideoManager {
    static let shared = VideoManager()
    private var items = [[AVPlayerItem?]]()
    private let player = AVPlayer()
    
    private init() { }
    
    func makeItems(count: Int) {
        if items.isEmpty {
            items = Array(repeating: [], count: count)
        } else {
            let newItems: [[AVPlayerItem?]] = Array(repeating: [], count: count)
            newItems.forEach { itemList in
                items.append(itemList)
            }
        }
    }
    
    func play(row: Int, column: Int) {
        if player.isPlaying {
            pause()
        }
        replaceVideo(row: row, column: column)
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func resetPlayerItem() {
        pause()
        player.replaceCurrentItem(with: nil)
    }
    
    func replaceVideo(row: Int, column: Int) {
        if items.isEmpty || items[row].isEmpty {
            return
        }
        player.replaceCurrentItem(with: items[row][column])
    }
    
    func getPlayerLayer(row: Int, column: Int) -> AVPlayerLayer {
        replaceVideo(row: row, column: column)
        return AVPlayerLayer(player: player)
    }
    
    func addPlayerItem(for url: URL?, in row: Int) {
        if let url = url {
            let item = AVPlayerItem(url: url)
            items[row].append(item)
        } else {
            items[row].append(nil)
        }
    }
    
    func isVideoType() -> Bool {
        guard (player.currentItem != nil) else {
            return false
        }
        return true
    }
    
    func isMuted() -> Bool {
        player.isMuted.toggle()
        return player.isMuted
    }
}

//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Dan Galben on 27.07.20.
//  Copyright © 2020 Dan Galben. All rights reserved.
//

import Foundation

struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojies = [Emoji]()
    
    
    struct Emoji: Identifiable, Codable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        let id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt
        }
    }
    
    init() {}
    
    var uniqueEmojiId = 0
    
    mutating func addEmoji(text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojies.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
    
}

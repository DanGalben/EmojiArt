//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Dan Galben on 26.07.20.
//  Copyright © 2020 Dan Galben. All rights reserved.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable {
    
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @Published private var emojiArt: EmojiArt
    
    private var autosaveCancellable: AnyCancellable?
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultsKey))
        autosaveCancellable  = $emojiArt.sink { emojiArt in
            print("\(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: defaultsKey)
        }
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojies }
    
    // MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at Location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(text: emoji, x: Int(Location.x), y: Int(Location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojies.firstIndex(matching: emoji) {
            emojiArt.emojies[index].x += Int(offset.width)
            emojiArt.emojies[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojies.firstIndex(matching: emoji) {
            emojiArt.emojies[index].size = Int((CGFloat(emojiArt.emojies[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private var fetchImageCandellable: AnyCancellable?
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            fetchImageCandellable?.cancel()
            fetchImageCandellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }

}

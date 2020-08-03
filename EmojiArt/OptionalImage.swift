//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Dan Galben on 29.07.20.
//  Copyright © 2020 Dan Galben. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}

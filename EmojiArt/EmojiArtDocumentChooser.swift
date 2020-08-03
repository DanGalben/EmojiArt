//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Dan Galben on 03.08.20.
//  Copyright © 2020 Dan Galben. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    Text(store.name(for: document))
                }
            }
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}

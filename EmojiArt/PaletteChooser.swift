//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Dan Galben on 31.07.20.
//  Copyright © 2020 Dan Galben. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    
    @ObservedObject var document: EmojiArtDocument
    @Binding var choosenPalette: String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {
                self.choosenPalette = self.document.palette(after: self.choosenPalette)
            }, onDecrement: {
                self.choosenPalette = self.document.palette(before: self.choosenPalette)
            }, label: { EmptyView() })
            Text(self.document.paletteNames[self.choosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    self.showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor()
                        .frame(width: 300, height: 500)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    var body: some View {
        Text("Palette Editor")
    }
    
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), choosenPalette: Binding.constant(""))
    }
}

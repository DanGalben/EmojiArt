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
                .sheet(isPresented: $showPaletteEditor) {
                    PaletteEditor(choosenPalette: $choosenPalette, isShowing: $showPaletteEditor)
                        .environmentObject(self.document)
//                        .frame(width: 300, height: 500)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    
    @Binding var choosenPalette: String
    @Binding var isShowing: Bool
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }, label: {
                        Text("Done")
                    }).padding()
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began {
                            self.document.renamePalette(self.choosenPalette, to: self.paletteName)
                        }
                    })
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            self.choosenPalette = self.document.addEmoji(self.emojisToAdd, toPalette: self.choosenPalette)
                            self.emojisToAdd = ""
                        }
                    })
                }
                Section(header: Text("Remove Emoji")) {
                    Grid(choosenPalette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji).font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                self.choosenPalette = self.document.removeEmoji(emoji, fromPalette: self.choosenPalette)
                        }
                    }
                    .frame(height: self.height)
                }
            }
            Spacer()
        }
        .onAppear { self.paletteName = self.document.paletteNames[self.choosenPalette] ?? "" }
    }
    
    var height: CGFloat {
        CGFloat((choosenPalette.count - 1) / 6) * 70 + 70
    }
    
    var fontSize: CGFloat = 40
    
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), choosenPalette: Binding.constant(""))
    }
}

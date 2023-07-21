//
//  PokemonImageView.swift
//  PokemnchikApp
//
//  Created by Green on 21.07.2023.
//

import SwiftUI

struct PokemonImage: View {
    @State private var pokemonSprite = ""
    private(set) var imageLink = ""
    private(set) var side: PokemonSide = .front
    private(set) var imageSize = 100.0
    
    var body: some View {
        AsyncImage(url: URL(string: pokemonSprite))
            .frame(width: imageSize, height: imageSize)
            .onAppear {
                let loadedData = UserDefaults.standard.string(forKey: imageLink)
                
                if loadedData == nil {
                    getSprite(url: imageLink)
                    UserDefaults.standard.set(imageLink, forKey: imageLink)
                } else {
                    guard let data = loadedData else { return }
                    getSprite(url: data)
                }
            }
            .clipShape(Circle())
            .foregroundColor(Color.gray.opacity(0.60))
            .scaledToFit()
        
    }
    
    func getSprite(url: String) {
        var tempSprite: String?
        DetailInfoDataFetcher.getDetailInfo(url: url) { sprite in
            tempSprite = side == .front ? sprite.sprites.frontDefault : sprite.sprites.backDefault
            self.pokemonSprite = tempSprite ?? "placeholder"
        }
        
    }
}

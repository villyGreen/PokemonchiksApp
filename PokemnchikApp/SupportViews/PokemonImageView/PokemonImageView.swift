//
//  PokemonImageView.swift
//  PokemnchikApp
//
//  Created by Green on 21.07.2023.
//

import SwiftUI

struct PokemonImage: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(url: String, side: PokemonSide) {
        imageLoader = ImageLoader(url: url, side: side)
    }
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .frame(width: 75, height: 75)
        } else {
            ProgressView()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var url: String
    private var side: PokemonSide = .back
    private var task: URLSessionDataTask?
    
    init(url: String, side: PokemonSide) {
        self.url = url
        self.side = side
        getSprite(url: url)
    }
    
    func getSprite(url: String) {
        var spriteUrl: String?
        DetailInfoDataFetcher.getDetailInfo(url: url) { sprite in
            spriteUrl = self.side == .front ? sprite.sprites.frontDefault : sprite.sprites.backDefault
            guard let spriteUrl = spriteUrl else { return }
            
            if let cachedImage = ImageCache.shared.get(forKey: spriteUrl) {
                self.image = cachedImage
                return
            }
            
            guard let url = URL(string: spriteUrl) else { return }
            self.task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    self.image = image
                    ImageCache.shared.set(image, forKey: spriteUrl)
                }
            }
            self.task?.resume()
        }
    }
}


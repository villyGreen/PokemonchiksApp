//
//  DetailInfoDataFetcher.swift
//  PokemnchikApp
//
//  Created by Green on 21.07.2023.
//

import Foundation

final class DetailInfoDataFetcher {
    static func getDetailInfo(url: String, completion: @escaping (PokemonSelected) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            guard let pokemonSprite = try? JSONDecoder().decode(PokemonSelected.self, from: data) else { return }
            
            DispatchQueue.main.async {
                completion(pokemonSprite)
            }
        }.resume()
    }
}

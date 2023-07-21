//
//  DetailScreenViewModel.swift
//  PokemnchikApp
//
//  Created by Green on 20.07.2023.
//

import SwiftUI

struct DetailInfoEntity {
    var weight = 0
    var height = 0
    var baseExpirience = 0
    var order = 0
    var types: [String] = []
    var abilities: [String] = []
}

extension DetailScreenView {
    @MainActor
    final class DetailScreenViewModel: ObservableObject {
        var item: PokemonGridItem
        @Published var entity = DetailInfoEntity()
        
        init(item: PokemonGridItem) {
            self.item = item
        }
        
        func loadDetailInfo() {
            DetailInfoDataFetcher.getDetailInfo(url: item.pokemon.url) { data in
                self.entity.weight = data.weight
                self.entity.order = data.order
                self.entity.height = data.height
                self.entity.baseExpirience = data.baseExpirience
                self.entity.types = data.types.map { $0.type.name }
                self.entity.abilities = data.abilities.map { $0.ability.name }
            }
        }
    }
}

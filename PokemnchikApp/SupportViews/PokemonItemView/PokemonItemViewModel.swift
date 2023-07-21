//
//  PokemonItemViewModel.swift
//  PokemnchikApp
//
//  Created by Green on 21.07.2023.
//

import SwiftUI

extension PokemonItemView {
    @MainActor
    final class PokemonItemViewModel: ObservableObject {
        private(set) var item: PokemonGridItem
    
        init(pokemon: PokemonGridItem) {
            self.item = pokemon
        }
        
        func getTitleName() -> String {
            return item.pokemon.name
        }
        
        
    }
}

//
//  MainScreenViewModel.swift
//  PokemnchikApp
//
//  Created by Green on 20.07.2023.
//

import SwiftUI
import Combine


extension MainScreenView {
    final class MainScreenViewModel: ObservableObject {
        private var cancelableSet: Set<AnyCancellable> = []
        private var initPokemonsCount = 5
        private var firstPokemonIndex = 0
        
        func loadMoreContentIfNeeded(currentItem item: PokemonGridItem?) {
            guard let item = item else {
                initPokemonsCount += pokemons.count
                getPokemons()
                return
            }
            let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -5)
            if pokemons.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
                initPokemonsCount += pokemons.count
                getPokemons()
            }
        }
        
        @Published private(set) var pokemons: [PokemonGridItem] = []
        
        var favoritePokemons: [PokemonGridItem] {
            return pokemons.filter { $0.isFavorite }
        }
        
        var allPokemons: [PokemonGridItem] {
            return pokemons.filter { !$0.isFavorite }
        }
        
        init() {
            getPokemons()
        }
        
        func changeState(item: PokemonGridItem) {
            withAnimation(.easeInOut(duration: 0.15)) {
                guard let index = self.pokemons.firstIndex(of: item) else { return }
                self.pokemons[index].isFavorite.toggle()
                getButtonTitle(index: index)
            }
        }
        
        func getButtonTitle(index: Int) {
            self.pokemons[index].buttonTitle = self.pokemons[index].isFavorite ? "DISLIKE" : "LIKE ♡ "
        }
        
        
        func getPokemons() {
            DataFetcherService
                .getpokemons(with: initPokemonsCount)
                .receive(on: RunLoop.main)
                .sink { error in
                    print(error)
                } receiveValue: { data in
                    let results = data.results?[self.firstPokemonIndex ..< self.initPokemonsCount]
                    results?.forEach {
                        let gridItem = PokemonGridItem(pokemon: $0)
                        self.pokemons.append(gridItem)
                    }
                    self.firstPokemonIndex = self.pokemons.count
                }
                .store(in: &cancelableSet)
        }
    }
}


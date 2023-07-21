//
//  GridItem.swift
//  PokemnchikApp
//
//  Created by Green on 21.07.2023.
//

import SwiftUI

struct PokemonItemView: View {
    @ObservedObject private var viewModel: PokemonItemViewModel

    var itemViewModel: MainScreenView.MainScreenViewModel
    
    init(pokemon: PokemonGridItem, itemViewModel: MainScreenView.MainScreenViewModel) {
        viewModel = PokemonItemViewModel(pokemon: pokemon)
        self.itemViewModel = itemViewModel
    }
    
    var body: some View {
        ZStack {
            Color(.white)
            
            VStack {
                PokemonImage(imageLink: viewModel.item.pokemon.url, side: .front)
                    .aspectRatio(.infinity, contentMode: .fill)
                VStack(alignment: .center, spacing: 8) {
                    Text(viewModel.getTitleName())
                    Button(viewModel.item.buttonTitle) {
                        itemViewModel.changeState(item: viewModel.item)
                    }
                    .buttonStyle(.plain)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.black)
                    )
                }
            }
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(.black)
        )
        
    }
    
}

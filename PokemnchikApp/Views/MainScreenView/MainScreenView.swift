//
//  MainScreenView.swift
//  PokemnchikApp
//
//  Created by Green on 20.07.2023.
//

import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel = MainScreenViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    if !viewModel.favoritePokemons.isEmpty {
                        SectionView(sectionType: .favorite, viewModel: viewModel)
                    }
                    SectionView(sectionType: .all, viewModel: viewModel)
                }
            }
            .padding()
        }
    }
}


enum SectionType {
    case favorite
    case all
    
    var title: String {
        switch self {
        case .favorite:
            return "Favorites"
        case .all:
            return "All"
        }
    }
}

struct SectionView: View {
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var pokemons: [PokemonGridItem] = []
    var sectionType: SectionType = .all
    var viewModel: MainScreenView.MainScreenViewModel
    private let defaultSize = 80.0
    
    init(sectionType: SectionType, viewModel: MainScreenView.MainScreenViewModel) {
        self.sectionType = sectionType
        self.viewModel = viewModel
        self.pokemons = sectionType == .all ? viewModel.allPokemons : viewModel.favoritePokemons
    }
    
    var body: some View {
        Section(sectionType.title) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(pokemons, id: \.id) { item in
                    NavigationLink(destination: DetailScreenView(pokemon: item)) {
                        PokemonItemView(pokemon: item, itemViewModel: viewModel)
                            .onAppear {
                                viewModel.loadMoreContentIfNeeded(currentItem: item)
                            }
                            .frame(minWidth: defaultSize, minHeight: defaultSize)
                    }
       
                }
            }
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

//
//  DetailScreenView.swift
//  PokemnchikApp
//
//  Created by Green on 20.07.2023.
//

import SwiftUI

struct DetailScreenView: View {
    @ObservedObject private var viewModel: DetailScreenViewModel
    
    init(pokemon: PokemonGridItem) {
        viewModel = DetailScreenViewModel(item: pokemon)
    }
    
    var body: some View {
        VStack {
            HStack {
                PokemonImage(url: viewModel.item.pokemon.url, side: .front)
                PokemonImage(url: viewModel.item.pokemon.url, side: .back)
            }
            .aspectRatio(contentMode: .fit)
            VStack {
                
                CellView(keyValue: ("Name", viewModel.item.pokemon.name))
                CellView(keyValue: ("Weight", String(viewModel.entity.weight)))
                CellView(keyValue: ("Height", String(viewModel.entity.height)))
                CellView(keyValue: ("Order", String(viewModel.entity.order)))
                CellView(keyValue: ("Base Expirience", String(viewModel.entity.baseExpirience)))
            }
            VStack {
                SectionDetailView(type: .types)
                ForEach(viewModel.entity.types, id: \.self) { type in
                    CellView(keyValue: (type, ""))
                }
                
                SectionDetailView(type: .abilities)
                ForEach(viewModel.entity.abilities, id: \.self) { ability in
                    CellView(keyValue: (ability, ""))
                }
            }
            Spacer()
            
        }
        .onAppear {
            viewModel.loadDetailInfo()
        }
    }
}


struct CellView: View {
    var keyValue: (String, String) = ("", "")
    
    init(keyValue: (String, String)) {
        self.keyValue = keyValue
    }
    
    var body: some View {
        HStack {
            Text(keyValue.0)
            Spacer()
            Text(keyValue.1)
        }
        .padding(.horizontal)
    }
}

enum SectionDetailType {
    case types
    case abilities
    
    var title: String {
        switch self {
        case .abilities:
            return "Abilities"
        case .types:
            return "Types"
        }
    }
}

struct SectionDetailView: View {
    var type: SectionDetailType
    
    init(type: SectionDetailType) {
        self.type = type
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            Color(.gray)
                .opacity(0.5)
                .frame(height: 30)
            Text(type.title)
                .padding()
        }
    }
}

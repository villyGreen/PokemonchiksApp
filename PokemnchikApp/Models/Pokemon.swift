////
////  Pokemon.swift
////  PokemnchikApp
////
////  Created by Green on 20.07.2023.
////


import Foundation

enum PokemonSide {
    case front
    case back
}

struct PokemonSelected : Codable {
    var sprites: PokemonSprites
    var weight: Int
    var order: Int
    var height: Int
    var baseExpirience: Int
    let types: [TypeElement]
    let abilities: [Ability]
    
    enum CodingKeys: String, CodingKey {
        case sprites, weight, height, order
        case abilities
        case types
        case baseExpirience = "base_experience"
    }
}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

struct Ability: Codable {
    let ability: Species
    let isHidden: Bool
    let slot: Int
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

struct PokemonSprites : Codable {
    var frontDefault: String?
    var backDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
    }
}

// MARK: - Pokemon
struct JSONEntity: Codable {
    let count: Int?
    let next: String?
    let results: [Pokemon]?
}


// MARK: - Result
struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonGridItem: Identifiable, Equatable {
    static func == (lhs: PokemonGridItem, rhs: PokemonGridItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    var id = UUID()
    var isFavorite = false
    var buttonTitle = "LIKE ♡"
    var pokemon: Pokemon
}

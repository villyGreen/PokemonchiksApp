//
//  DataFetcherService.swift
//  PokemnchikApp
//
//  Created by Green on 20.07.2023.
//

import Foundation
import Combine

private extension DataFetcherService {
    static func getAPIUrl(_ limit: Int) -> String {
        return "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)"
    }
}

enum APIError: Error, LocalizedError {
    case unknown
    case apiError(reason: String)
    case invalidURL
    case parseError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unknown:
            return "Unknown error"
        case .parseError:
            return "Parse error"
        case .apiError:
            return "api error"
        }
    }
}

final class DataFetcherService {
    static func fetchJSON(limit: Int) -> AnyPublisher<Data, APIError> {
        guard let url = URL(string: getAPIUrl(limit)) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        let request = URLRequest(url: url)
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return data
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    static func getpokemons(with limit: Int) -> AnyPublisher<JSONEntity, APIError> {
        
        fetchJSON(limit: limit)
            .decode(type: JSONEntity.self, decoder: JSONDecoder())
            .mapError { error in
                if let _ = error as? DecodingError {
                    return APIError.parseError
                }  else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}

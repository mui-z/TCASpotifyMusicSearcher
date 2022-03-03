import Foundation
import Combine
import ComposableArchitecture

struct SpotifyAPIClient {
    var albums: (String) -> Effect<SearchItem, AlbumsApiError>
    struct AlbumsApiError: Error, Equatable {
        let reason: String
    }
}

extension SpotifyAPIClient {
    static let live = SpotifyAPIClient(
        albums: { searchWord in
            var components = URLComponents(string: "https://api.spotify.com/v1/search")!
            components.queryItems = [URLQueryItem(name: "q", value: searchWord),
                                     URLQueryItem(name: "type", value: "album"),
                                     URLQueryItem(name: "market", value: "JP"),
                                     URLQueryItem(name: "limit", value: "10")]
            
            let authHeaders = [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer "
            ]
            
            var request = URLRequest(url: (components.url)!)
            request.httpMethod = "GET"
            
            for (key, value) in authHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .map { data, _ in data}
                .decode(type: SearchItem.self, decoder: jsonDecoder)
                .mapError { error in AlbumsApiError(reason: error.localizedDescription) }
                .eraseToEffect()
        }
    )
}

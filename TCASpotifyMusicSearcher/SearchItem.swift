// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchItem = try? newJSONDecoder().decode(SearchItem.self, from: jsonData)

import Foundation

// MARK: - SearchItem
struct SearchItem: Codable, Equatable {
    let albums: Albums?
}

// MARK: - Albums
struct Albums: Codable, Equatable {
    let href: String?
    let items: [Item]
    let limit: Int?
    let next: String?
    let offset: Int?
    let total: Int?
}

// MARK: - Item
struct Item: Codable, Equatable {
    let albumType: String?
    let artists: [Artist]?
    let externalUrls: ExternalUrls?
    let href: String?
    let id: String?
    let images: [Image]?
    let name, releaseDate, releaseDatePrecision: String?
    let totalTracks: Int?
    let type, uri: String?
}

// MARK: - Artist
struct Artist: Codable, Equatable {
    let externalUrls: ExternalUrls?
    let href: String?
    let id, name, type, uri: String?
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable, Equatable {
    let spotify: String?
}

// MARK: - Image
struct Image: Codable, Equatable {
    let height: Int?
    let url: String?
    let width: Int?
}

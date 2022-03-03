//
// Created by osushi on 2022/02/27.
//

import Foundation

struct Album: Codable, Equatable, Hashable {
    var title: String
    var artist: String
    var releaseDate: String
    var imageUrl: URL
}
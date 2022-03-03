//
//  TCASpotifyMusicSearcherApp.swift
//  TCASpotifyMusicSearcher
//
//  Created by osushi on 2022/02/27.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCASpotifyMusicSearcherApp: App {
    var body: some Scene {
        WindowGroup {
            AlbumSearch(
                    store: Store(
                        initialState: AppState(albums: [], searchWord: ""),
                            reducer: appReducer.debug(),
                            environment: AppEnvironment(
                                    mainQueue: .main
                            )
            ))
        }
    }
}

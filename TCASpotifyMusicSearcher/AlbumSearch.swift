//
// Created by osushi on 2022/02/27.
//

import ComposableArchitecture
import SwiftUI

enum AppAction: Equatable {
    case searchWordChanged(String)
    case search(searchWord: String)
    case albumsResponse(Result<SearchItem, SpotifyAPIClient.AlbumsApiError>)
}

struct AppState: Equatable {
    var albums: [Album]
    var searchWord: String
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
    switch action {
    case let .search(searchWord):
        struct SpotifyAPIId: Hashable {}
        
        return SpotifyAPIClient.live.albums(searchWord)
            .receive(on: env.mainQueue)
            .catchToEffect(AppAction.albumsResponse)
            .cancellable(id: SpotifyAPIId(), cancelInFlight: true)
        
    case let .searchWordChanged(inputtedWord):
        state.searchWord = inputtedWord
        return .none
    
    case let .albumsResponse(.failure(items)):
        print(items.localizedDescription)
        return .none
        
    case let .albumsResponse(.success(items)):
        guard let albums = items.albums else { return .none }
        
        var newAlbum: [Album] = []
        
        albums.items.forEach { item in
            newAlbum.append(Album(title: item.name!, artist: item.artists!.first!.name!, releaseDate: item.releaseDate!, imageUrl: URL(string: item.images!.first!.url!)!))
        }
        state.albums = newAlbum
        return .none
    }
}

struct AlbumSearch: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVStack {
                    TextField("Let's Search Artist!", text: viewStore.binding(get: \.searchWord, send: AppAction.searchWordChanged))
                            .padding(25)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewStore.send(AppAction.search(searchWord: viewStore.state.searchWord))
                     }){
                         Text("Search")
                            .font(.largeTitle)
                     }

                    ForEach(viewStore.albums, id: \.self) { album in
                        HStack {
                            Spacer()
                                    .frame(width: 15)
                            AsyncImage(url: album.imageUrl) { phase in
                                if let image = phase.image {
                                    image
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                } else {
                                    ProgressView()
                                }
                            }.padding(30)
                            VStack {
                                Text(album.title)
                                Text(album.artist)
                                Text(album.releaseDate)
                                        .foregroundColor(Color.gray)
                                        .padding(3)
                            }
                            Spacer()
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

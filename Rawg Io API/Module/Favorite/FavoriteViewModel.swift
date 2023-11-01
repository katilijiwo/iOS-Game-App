//
//  FavoriteViewModel.swift
//  Rawg Io API
//
//  Created by koinworks on 08/09/23.
//

import Foundation
import Core

class FavoriteViewModel {
    
    var didGetListFavGame: ((Status<[GameModel]?>.type) -> Void)? = nil
    
    private let gameRepository: GameRepositoryProtocol
    init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }
    
    func getFavGame() {
        gameRepository.getFavGames(completion: { result in
            self.didGetListFavGame?(Status<[GameModel]?>.type.result(result))
        })
    }
    
}

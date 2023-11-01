//
//  DetailGameViewModel.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import Foundation
import Core

class DetailGameViewModel {
    
    var didGetGame: ((Status<GameDetailModel>.type) -> Void)? = nil
    var didFavGame: ((Status<Void?>.type) -> Void)? = nil
    var didGameIsFav: ((Status<GameModel?>.type) -> Void)? = nil
    
    private let gameDetailUseCase: GameDetailUseCase
    init(gameDetailUseCase: GameDetailUseCase) {
        self.gameDetailUseCase = gameDetailUseCase
    }
    
    func getGameDetail(id: Int) {
        gameDetailUseCase.getGameDetail(gameId: id) { result in
            self.didGetGame?(Status<GameDetailModel>.type.loading)
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.didGetGame?(Status<GameDetailModel>.type.result(result))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.didGetGame?(Status<GameDetailModel>.type.error(error.localizedDescription))
                }
            }
        }
    }
    
    func insertFavGame(gameModel: GameModel) {
        self.didGetGame?(Status<GameDetailModel>.type.loading)
        gameDetailUseCase.insertFavGame(
            gameModel: gameModel,
            completion: {
                self.didFavGame?(Status<Void?>.type.result(nil))
            }
        )
    }
    
    func updateFaveGame(gameModel: GameModel) {
        self.didGetGame?(Status<GameDetailModel>.type.loading)
        gameDetailUseCase.updateFaveGame(
            gameModel: gameModel,
            completion: {
                self.didFavGame?(Status<Void?>.type.result(nil))
            }
        )
    }
    
    func deleteFaveGame(gameId: Int) {
        self.didGetGame?(Status<GameDetailModel>.type.loading)
        gameDetailUseCase.deleteFavGame(
            gameId: gameId,
            completion: {
                self.didFavGame?(Status<Void?>.type.result(nil))
            }
        )
    }
    
    func getFavGameById(gameId: Int) {
        gameDetailUseCase.getFavGamesById(id: gameId, completion: { result in
            self.didGameIsFav?(Status<GameModel?>.type.result(result))
        })
    }
    
}

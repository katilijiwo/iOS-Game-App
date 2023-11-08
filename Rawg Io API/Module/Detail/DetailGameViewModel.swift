//
//  DetailGameViewModel.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import Foundation
import Combine
import Core

public class DetailGameViewModel {
    
    private var cancellables: Set<AnyCancellable> = []
    var didGetGame: ((Status<GameDetailModel>.type) -> Void)? = nil
    var didFavGame: ((Status<Void?>.type) -> Void)? = nil
    var didGameIsFav: ((Status<GameModel?>.type) -> Void)? = nil
    
    private let gameDetailUseCase: GameDetailUseCase
    init(gameDetailUseCase: GameDetailUseCase) {
        self.gameDetailUseCase = gameDetailUseCase
    }
    
    public func getGameDetail(id: Int) {
        self.didGetGame?(Status<GameDetailModel>.type.loading)
        gameDetailUseCase.getGameDetail(gameId: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure:
                  DispatchQueue.main.async {
                      self.didGetGame?(Status<GameDetailModel>.type.error(String(describing: completion)))
                  }
              case .finished:
                  break
              }
            }, receiveValue: { game in
                DispatchQueue.main.async {
                    if(game != nil) {
                        self.didGetGame?(Status<GameDetailModel>.type.result(game!))
                    } else {
                        self.didGetGame?(Status<GameDetailModel>.type.error("Something went wrong"))
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    public func insertFavGame(gameModel: GameModel) {
        self.didGetGame?(Status<GameDetailModel>.type.loading)
        gameDetailUseCase.insertFavGame(gameModel: gameModel)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure:
                  self.didFavGame?(Status<Void?>.type.error(String(describing: completion)))
              case .finished:
                break
              }
            }, receiveValue: { isSuccess in
                if(isSuccess) {
                    self.didFavGame?(Status<Void?>.type.result(nil))
                } else {
                    self.didFavGame?(Status<Void?>.type.error(String(describing: "Database error")))
                }
            })
            .store(in: &cancellables)
    }
    
    public func updateFaveGame(gameModel: GameModel) {
        self.didGetGame?(Status<GameDetailModel>.type.loading)
        gameDetailUseCase.updateFaveGame(gameModel: gameModel)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure:
                  self.didFavGame?(Status<Void?>.type.error(String(describing: completion)))
              case .finished:
                break
              }
            }, receiveValue: { isSuccess in
                if(isSuccess) {
                    self.didFavGame?(Status<Void?>.type.result(nil))
                } else {
                    self.didFavGame?(Status<Void?>.type.error(String(describing: "Database error")))
                }
            })
            .store(in: &cancellables)
    }
    
    public func deleteFaveGame(gameId: Int) {
        self.didFavGame?(Status<Void?>.type.loading)
        gameDetailUseCase.deleteFavGame(gameId: gameId)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure:
                  self.didFavGame?(Status<Void?>.type.error(String(describing: completion)))
              case .finished:
                break
              }
            }, receiveValue: { isSuccess in
                if(isSuccess) {
                    self.didFavGame?(Status<Void?>.type.result(nil))
                } else {
                    
                }
            })
            .store(in: &cancellables)
    }
    
    public func getFavGameById(gameId: Int) {
        self.didGetGame?(Status<GameDetailModel>.type.loading)
        gameDetailUseCase.getFavGamesById(id: gameId)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
              switch completion {
              case .failure:
                  self.didGetGame?(Status<GameDetailModel>.type.error(String(describing: completion)))
              case .finished:
                break
              }
            }, receiveValue: { result in
                self.didGameIsFav?(Status<GameModel?>.type.result(result))
            })
            .store(in: &cancellables)
    }
    
}

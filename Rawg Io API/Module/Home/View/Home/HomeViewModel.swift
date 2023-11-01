//
//  HomeViewModel.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation
import Core

class HomeViewModel {
    
    var didGetListGame: ((Status<[GameModel]>.type) -> Void)? = nil
    
    private let gameUseCase: GameUseCase
    init(gameUseCase: GameUseCase) {
        self.gameUseCase = gameUseCase
    }
    
    func getCategories() {
        gameUseCase.getListGame { result in
            self.didGetListGame?(Status<[GameModel]>.type.loading)
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.didGetListGame?(Status<[GameModel]>.type.result(result))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.didGetListGame?(Status<[GameModel]>.type.error(error.localizedDescription))
                }
            }
        }
    }
    
}

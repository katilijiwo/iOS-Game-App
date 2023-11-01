//
//  Injection.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation
import Core

final class Injection: NSObject {
    
    func provideRepository() -> GameRepositoryProtocol {
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        let gameProvider: GameDbProvider = GameDbProvider.sharedInstance
        let local: LocalDataSource = LocalDataSource.sharedInstance(gameProvider)
        return GameRepository.sharedInstance(remote, local)
    }
    
    func provideGameUseCase() -> GameUseCase {
        let repository = provideRepository()
        return GameUseCase.sharedInstance(repository)
    }
    
    func provideGameDetailUseCase() -> GameDetailUseCase {
        let repository = provideRepository()
        return GameDetailUseCase.sharedInstance(repository)
    }
    
}

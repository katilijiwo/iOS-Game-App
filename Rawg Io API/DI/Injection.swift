//
//  Injection.swift
//  Rawg Io API
//
//  Created by MAC on 19/08/23.
//

import Foundation
import RealmSwift
import Core

public final class Injection: NSObject {
    
    public func provideRepository(realm: Realm) -> GameRepositoryProtocol {
        let remote: RemoteDataSource = RemoteDataSource.sharedInstance
        let gameProvider: GameDbProvider = GameDbProvider.sharedInstance(realm)
        let favGameProvider: FavGameDbProvider = FavGameDbProvider.sharedInstance(realm)
        let local: LocalDataSource = LocalDataSource.sharedInstance(gameProvider, favGameProvider)
        return GameRepository.sharedInstance(remote, local)
    }
    
    public func provideGameUseCase(realm: Realm) -> GameUseCase {
        let repository = provideRepository(realm: realm)
        return GameUseCase.sharedInstance(repository)
    }
    
    public func provideGameDetailUseCase(realm: Realm) -> GameDetailUseCase {
        let repository = provideRepository(realm: realm)
        return GameDetailUseCase.sharedInstance(repository)
    }
}

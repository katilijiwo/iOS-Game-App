//
//  FavoriteViewController.swift
//  Rawg Io API
//
//  Created by MAC on 04/09/23.
//

import UIKit
import Core

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var favoriteIndicator: UIActivityIndicatorView!
    
    private var listGame: [GameModel]? = nil
    
    private lazy var viewModel: FavoriteViewModel = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let useCase = Injection.init().provideGameDetailUseCase(realm: appDelegate.realm)
        let vm = FavoriteViewModel(gameDetailUseCase: useCase)
        vm.didGetListFavGame = didGetListFavGame
        return vm
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFavGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        favoriteTableView.register(
            UINib(nibName: FavoriteTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Favorite"
    }
    
    private func didGetListFavGame(state: Status<[GameModel]?>.type?) {
        switch state {
        case .loading:
            showIndicator(isHidden: false)
            break
        case .result(let data):
            showIndicator(isHidden: true)
            self.listGame = data
            favoriteTableView.reloadData()
            break
        case .error(let err):
            showIndicator(isHidden: true)
            showErrorMessage(error: err)
            break
        case .none:
            showIndicator(isHidden: true)
            showErrorMessage(error: "Something went wrong")
            break
        }
    }
    
    private func showIndicator(isHidden: Bool) {
        DispatchQueue.main.async {
            self.favoriteIndicator.isHidden = isHidden
            if(isHidden) {
                self.favoriteIndicator.stopAnimating()
            } else {
                self.favoriteIndicator.startAnimating()
            }
        }
    }
    
    private func showErrorMessage(error: String) {
        showToast(message: error, font: .systemFont(ofSize: 12.0))
    }

}

extension FavoriteViewController: UITableViewDelegate {}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listGame?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        let listGame = self.listGame?[indexPath.row]
        if(listGame != nil) {
            cell.setupViews(data: listGame!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameId = Int(listGame?[indexPath.row].id ?? 0)
        let vc = DetailGameViewsController()
        vc.newInstance(gameId: gameId)

        self.navigationController?.pushViewController(vc, animated: true)
    }
}


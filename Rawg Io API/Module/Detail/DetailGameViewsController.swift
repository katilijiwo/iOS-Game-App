//
//  DetailGameViewsController.swift
//
//
//  Created by koinworks on 07/11/23.
//

import UIKit
import Core
import RealmSwift
import SDWebImage

public class DetailGameViewsController: UIViewController {
        
    @IBOutlet weak var loveImg: UIImageView!
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var esrbLbl: UILabel!
    @IBOutlet weak var dscLabel: UILabel!
    @IBOutlet weak var platformCollection: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    
   private var gameId = 0
   private var tempData: GameDetailModel? = nil
   private var isGameFav = false

   private lazy var viewModel: DetailGameViewModel = {
       let realm = try! Realm()
       let useCase = Injection.init().provideGameDetailUseCase(realm: realm)
       let vm = DetailGameViewModel(gameDetailUseCase: useCase)
       vm.didGetGame = didGetGame
       vm.didFavGame = didFavGame
       vm.didGameIsFav = didGameIsFav
       return vm
   }()

   public func newInstance(gameId: Int){
       self.gameId = gameId
   }

   public override func viewDidLoad() {
       super.viewDidLoad()
       viewModel.getGameDetail(id: gameId)
       platformCollection.delegate = self
       platformCollection.dataSource = self
       platformCollection.register(
           UINib(nibName: PlatformCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlatformCollectionViewCell.identifier)
    }

    func didGetGame(state: Status<GameDetailModel>.type?) {
        switch state {
        case .loading:
            showIndicator(isHidden: false)
            break
        case .result(let data):
            tempData = data
            displayData(data: data)
            showIndicator(isHidden: true)
            //platformCollection?.reloadData()
            viewModel.getFavGameById(gameId: self.gameId)
            break
        case .error(_):
            showIndicator(isHidden: true)
            break
        case .none:
            showIndicator(isHidden: true)
            break
        }
    }

    func didFavGame(state: Status<Void?>.type) {
        switch state {
        case .loading:
            showIndicator(isHidden: false)
            break
        case .result(_):
            showIndicator(isHidden: true)
            viewModel.getFavGameById(gameId: self.gameId)
            break
        case .error(_):
            showIndicator(isHidden: true)
            break
        }
    }

    func didGameIsFav(state: Status<GameModel?>.type) {
        switch state {
        case .loading:
            showIndicator(isHidden: false)
            break
        case .result(let data):
            isGameFav = data != nil
            if(data != nil) {
                loveImg.image = loveImg.image?.withRenderingMode(.alwaysTemplate)
                loveImg.tintColor = UIColor.red
            } else {
                loveImg.image = loveImg.image?.withRenderingMode(.alwaysTemplate)
                loveImg.tintColor = UIColor.black
            }
            showIndicator(isHidden: true)
            break
        case .error(_):
            showIndicator(isHidden: true)
            break
        }
    }

    private func showIndicator(isHidden: Bool) {
        loadingIndicator.isHidden = isHidden
        if(isHidden) {
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
        }
    }

    private func displayData(data: GameDetailModel) {
        gameImg.sd_setImage(with: URL(string: data.bgImage))
        titleLbl.text = data.name
        releaseLbl.text = data.released
        ratingLbl.text = String(data.rating)
        esrbLbl.text = data.esrbRating
        dscLabel.text = data.description.htmlToString
        dscLabel.numberOfLines = 0
        dscLabel.sizeToFit()
    }

    @IBAction func favDidTap(_ sender: UIButton) {
        var message = ""
        let gameModel = GameModel(
            id: tempData?.id ?? 0,
            title: tempData?.name ?? "",
            imageUrl: tempData?.bgImage ?? "",
            rating: tempData?.rating ?? 0,
            released: tempData?.released ?? ""
        )
        if(isGameFav) {
            viewModel.deleteFaveGame(gameId: gameId)
            message = "Game removed from favorite"
        } else {
            viewModel.insertFavGame(gameModel: gameModel)
            message = "Game added to favorite"
        }
        self.showToast(message: message, font: .systemFont(ofSize: 12.0))
    }
    
}

extension DetailGameViewsController: UICollectionViewDelegate {}

extension DetailGameViewsController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempData?.platforms?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlatformCollectionViewCell.identifier, for: indexPath) as! PlatformCollectionViewCell
        let platforms = self.tempData?.platforms?[indexPath.row]
        if(platforms != nil) {
            cell.setupViews(text: platforms?.name ?? "")
        }
        return cell
    }
}


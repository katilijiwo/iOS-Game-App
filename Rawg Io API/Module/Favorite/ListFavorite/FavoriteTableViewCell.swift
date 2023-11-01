//
//  FavoriteTableViewCell.swift
//  Rawg Io API
//
//  Created by MAC on 04/09/23.
//

import UIKit
import Core

class FavoriteTableViewCell: UITableViewCell {

    static let identifier = "FavoriteTableViewCell"
    
    @IBOutlet weak var gameImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupViews(data: GameModel) {
        titleLabel.text = data.title
        gameImg.sd_setImage(with: URL(string: data.imageUrl))
    }

}

//
//  ListGameViewTableCell.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import UIKit
import SDWebImage
import Core

class ListGameViewTableCell: UITableViewCell {
    static let identifier = "ListGameViewTableCell"
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseLbl: UILabel!
    @IBOutlet weak var ratingValueLbl: UILabel!
    @IBOutlet weak var gameImg: UIImageView!
    
    func setupViews(data: GameModel) {
        
        titleLbl.text = data.title
        releaseLbl.text = data.released
        ratingValueLbl.text = String(data.rating)
        gameImg.sd_setImage(with: URL(string: data.imageUrl))
        gameImg.roundCorners(corners: [.topLeft, .topRight], radius: 24)
        
        cardView.clipsToBounds = false
        cardView.layer.cornerRadius = 24
    }
}

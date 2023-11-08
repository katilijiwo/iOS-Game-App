//
//  PlatformCollectionViewCell.swift
//  Rawg Io API
//
//  Created by MAC on 01/09/23.
//

import UIKit

public class PlatformCollectionViewCell: UICollectionViewCell {

    public static let identifier = "PlatformCollectionViewCell"
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var textLbl: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    public func setupViews(text: String) {
        rootView.clipsToBounds = false
        rootView.layer.cornerRadius = 24
        textLbl.text = text
    }

}

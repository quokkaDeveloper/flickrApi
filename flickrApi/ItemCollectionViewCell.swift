//
//  ItemCollectionViewCell.swift
//  flickrApi
//
//  Created by 이규민 on 2020/04/15.
//  Copyright © 2020 quokka. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var highlightIndicator: UIView!
  @IBOutlet weak var selectIndicator: UIImageView!
  
  override var isHighlighted: Bool {
    didSet {
      highlightIndicator.isHidden = !isHighlighted
    }
  }
  
  override var isSelected: Bool {
    didSet {
      highlightIndicator.isHidden = !isSelected
      selectIndicator.isHidden = !isSelected
    }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

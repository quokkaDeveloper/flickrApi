//
//  DetailVC.swift
//  flickrApi
//
//  Created by 이규민 on 2020/04/13.
//  Copyright © 2020 quokka. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class DetailVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    
    var name = ""
    var photoUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        photoTitle.text = name
        let url = URL(string:photoUrl)
        image.kf.setImage(with:url )
        photoTitle.preferredMaxLayoutWidth = 150
    }
    func customImageView() {
    }
}

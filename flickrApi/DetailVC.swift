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
    var photoUrl = ""
    //for swipe
    
    var photoUrlTotal = [String]()
    var photoIndex = 0
    
    var userDefalutNewValueArray = [String]()
    var imageTitleArray = [String]()
    
    let defaults = UserDefaults.standard
    var userDefaultPrevValueArray = [String]()
    var titleArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureRegister()
        let url = URL(string:photoUrl)
        image.kf.setImage(with:url )
        userDefaultPrevValueArray = defaults.array(forKey: "url") as? [String] ?? [String]()
        userDefalutNewValueArray = userDefaultPrevValueArray
    }
    
    func gestureRegister() {
        // 한 손가락 스와이프 제스쳐 등록(좌, 우)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DetailVC.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(DetailVC.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        userDefalutNewValueArray.append(photoUrl)
        defaults.set(userDefalutNewValueArray, forKey:"url")
        userDefaultPrevValueArray = defaults.array(forKey: "url") as? [String] ?? [String]()
       }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
           // 만일 제스쳐가 있다면
           if let swipeGesture = gesture as? UISwipeGestureRecognizer{
               
               // 발생한 이벤트가 각 방향의 스와이프 이벤트라면
               // pageControl이 가르키는 현재 페이지에 해당하는 이미지를 imageView에 할당
               switch swipeGesture.direction {
                   case UISwipeGestureRecognizer.Direction.left :
                    if photoIndex == 0 {
                        return
                    }
                       photoIndex -= 1
                       let url = URL(string : photoUrlTotal[photoIndex])
                       image.kf.setImage(with: url )
                   case UISwipeGestureRecognizer.Direction.right :
                    if photoIndex == photoUrlTotal.count-1 {
                        return
                    }
                       photoIndex += 1
                       let url = URL(string : photoUrlTotal[photoIndex])
                       image.kf.setImage(with: url )
                   default:
                     break
               }

           }

       }
}

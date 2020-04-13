//
//  ViewController.swift
//  flickrApi
//
//  Created by 이규민 on 2020/04/09.
//  Copyright © 2020 quokka. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class MainVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var totalNum: UILabel!
    
    var page = 1
    var perPage = 15
    var photoUrl = [String]()
    var photoTitle = [String]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    //infinite scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height
        
         if offsetY > contentHeight - scrollView.frame.size.height  {
                 page += 1
                 callData()
             }
         }
    
    @IBAction func scrollUp(_ sender: Any) {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func scrollDown(_ sender: Any) {
        collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentSize.height-collectionView.bounds.height), animated: true)
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //이미지 카운터 하는 함수
        return photoUrl.count
        }
    
        //셀 구성하기
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! CustomCell
            let url = URL(string:photoUrl[indexPath.row])
            cell.image.kf.setImage(with: url)
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC
        vc?.name = photoTitle[indexPath.row]
        vc?.photoUrl = photoUrl[indexPath.row]
        vc?.photoTitleTotal = photoTitle
        vc?.photoUrlTotal = photoUrl
        vc?.photoIndex = indexPath.row
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
        // 사이즈
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
          let collectionViewCellWithd = collectionView.frame.width / 3 - 1
            return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
        }
    
        //위아래 라인 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
        //옆 라인 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    @IBAction func search(_ sender: Any) {
        print("Callphotos")
        photoUrl = [String]()
        photoTitle = [String]()
        page = 1
        callData()
        }
    
    func callData() {
        let req = Req()
        
        let text = searchText.text!
        let url = URL(string: req.baseUrl)
        let param = ["method": req.method, "api_key": req.apikey,"format": req.format, "text" : text
            , "nojsoncallback" : req.nojsoncallback, "page" : page , "per_page": perPage] as [String : Any]
                _ = Alamofire.request(url!, method: .post, parameters: param ).responseString {
                    response in
                    let decoder = JSONDecoder()
                    let jsonString = response.result.value!
                    let data = jsonString.data(using: .utf8)
                    if let data = data, let flickr = try? decoder.decode(Flickr.self, from: data) {
                        for photo in flickr.photos.photo {
                            self.photoUrl.append("https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg")
                            self.photoTitle.append(photo.title)
                        }
                        self.totalNum.text = String(self.photoUrl.count)
                        self.collectionView.reloadData()
                    }
                    else {
                        print("fail")
                    }
                }
    }
}

class CustomCell: UICollectionViewCell {
       @IBOutlet weak var image: UIImageView!
        
   }

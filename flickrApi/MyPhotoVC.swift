//
//  MyPhotoVC.swift
//  flickrApi
//
//  Created by 이규민 on 2020/04/14.
//  Copyright © 2020 quokka. All rights reserved.
//

import Foundation
import UIKit
class MyPhotoVC : UIViewController {
    let defaults = UserDefaults.standard
    var urlArray = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    let cellIdentifier = "ItemCollectionViewCell"
    
    @IBOutlet weak var totalNum: UILabel!
    
       
    var mMode: Mode = .view {
         didSet {
           switch mMode {
           case .view:
             for (key, value) in dictionarySelectedIndexPath {
               if value {
                 collectionView.deselectItem(at: key, animated: true)
               }
             }
             dictionarySelectedIndexPath.removeAll()
             selectBarButton.title = "Select"
             navigationItem.leftItemsSupplementBackButton = true
             navigationItem.leftBarButtonItem = .init()
             collectionView.allowsMultipleSelection = false
           case .select:
             selectBarButton.title = "Cancel"
             navigationItem.leftBarButtonItem = deleteBarButton
             navigationItem.leftItemsSupplementBackButton = false
             collectionView.allowsMultipleSelection = true
           }
         }
       }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        setupBarButtonItems()
        setupCollectionView()
        configureData()
     }
    
       private func setupCollectionView() {
         collectionView.delegate = self
         collectionView.dataSource = self
         let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
         collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
       }

       private func setupBarButtonItems() {
           navigationItem.rightBarButtonItem = selectBarButton
       }
        
    lazy var selectBarButton: UIBarButtonItem = {
      let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
      return barButtonItem
    }()
    
   lazy var deleteBarButton: UIBarButtonItem = {
      let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
      return barButtonItem
    }()
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
      mMode = mMode == .view ? .select : .view
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        
        let userDefaultPrevValueArray = defaults.array(forKey: "url") as? [String] ?? [String]() // 기존값
        var userDefaultNewValueArray = userDefaultPrevValueArray
        
      var deleteNeededIndexPaths: [IndexPath] = []
        
      for (key, value) in dictionarySelectedIndexPath {
        if value {
            deleteNeededIndexPaths.append(key)
            collectionView.deselectItem(at: key, animated: true)
        }
      }
      for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
        userDefaultNewValueArray.remove(at: i.item)
      }
      defaults.set(userDefaultNewValueArray, forKey:"url")
      urlArray = userDefaultNewValueArray
        self.collectionView.reloadData()
      dictionarySelectedIndexPath.removeAll()
      mMode = mMode == .view ? .select : .view
        totalNum.text = String(urlArray.count)
    }
    
    func configureData() {
        urlArray = defaults.array(forKey: "url") as? [String] ?? [String]()
        self.collectionView.reloadData()
    }
}
extension MyPhotoVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //이미지 카운터 하는 함수
        return urlArray.count
        }
        //셀 구성하기
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as!
            ItemCollectionViewCell
            let url = URL(string:urlArray[indexPath.row])
            totalNum.text = String(urlArray.count)
            cell.imageView.kf.setImage(with: url)
            return cell
        }
    
    //셀 눌렀을때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //flag
        switch mMode {
        case .view: collectionView.deselectItem(at: indexPath, animated: true)
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC
            vc?.photoUrl = urlArray[indexPath.row]
            vc?.photoUrlTotal = urlArray
            vc?.photoIndex = indexPath.row
            self.navigationController?.pushViewController(vc!, animated: true)
            
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select {
            dictionarySelectedIndexPath[indexPath] = false
        }
    }
    
        // 사이즈
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
          let collectionViewCellWithd = collectionView.frame.width / 3 - 1
            return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
        }
    
        //위아래 라인 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0.5
        }
    
        //옆 라인 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0.5
        }
    
}


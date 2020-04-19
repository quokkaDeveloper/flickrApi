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

class MainVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var totalNum: UILabel!
    
    var photoArray = [UIImage]()
    
    var page = 1
    var perPage = 15
    var photoUrl = [String]()
    
    var text = ""
    let whatVc : String = "MainVC"
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]

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
          navigationItem.leftBarButtonItem = myPhotoBarButton
          collectionView.allowsMultipleSelection = false
        case .select:
          selectBarButton.title = "Cancel"
          navigationItem.leftBarButtonItem = saveBarButton
          collectionView.allowsMultipleSelection = true
        }
      }
    }
    
    let cellIdentifier = "ItemCollectionViewCell"
    
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButtonItems()
        setupCollectionView()
//        setupCollectionViewItemSize()
        searchText.delegate = self
    }
    
    lazy var myPhotoBarButton: UIBarButtonItem = {
      let barButtonItem = UIBarButtonItem(title: "MyPhoto", style: .plain, target: self, action: #selector(didMyPhotoButtonClicked(_:)))
      return barButtonItem
    }()
    
    lazy var selectBarButton: UIBarButtonItem = {
      let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
      return barButtonItem
    }()
    
    lazy var saveBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didSaveButtonClicked(_:)))
      return barButtonItem
    }()
    
    
    @objc func didMyPhotoButtonClicked(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyPhotoVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
      mMode = mMode == .view ? .select : .view
    }
    
    @objc func didSaveButtonClicked(_ sender: UIBarButtonItem) {

        let defaults = UserDefaults.standard
        let userDefaultPrevValueArray = defaults.array(forKey: "url")  as? [String] ?? [String]() // 기존값
        var userDefaultNewValueArray = userDefaultPrevValueArray
        
        for (key, value) in dictionarySelectedIndexPath {
            if value {
                userDefaultNewValueArray.append(photoUrl[key.row])
                collectionView.deselectItem(at: key, animated: true) //
            }
        }
        dictionarySelectedIndexPath.removeAll()
        mMode = mMode == .view ? .select : .view
        defaults.set(userDefaultNewValueArray, forKey:"url")
    }

    private func setupCollectionView() {
      collectionView.delegate = self
      collectionView.dataSource = self
      let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
      collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }

    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = selectBarButton
        navigationItem.leftBarButtonItem = myPhotoBarButton
    }
    
    // text search
    @IBAction func search(_ sender: Any) {
        photoUrl = [String]()
        page = 1
        text = searchText.text!
        callData(text : text)
        dictionarySelectedIndexPath.removeAll()
        }
    
    // netWork request & response -> data setting
    func callData(text: String) {
        let req = Req()
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
                        }
                        self.totalNum.text = String(self.photoUrl.count)
                        print(self.photoUrl)
                        self.collectionView.reloadData()
                    }
                    else {
                        return
                    }
                }
    }
}

extension MainVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
       // cell.count per Section
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return photoUrl.count
           }
        // cell image setting
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
           let url = URL(string:photoUrl[indexPath.row])
               cell.imageView.kf.setImage(with: url)
           return cell
           }
       
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           //cell click
           switch mMode {
           case .view:
               collectionView.deselectItem(at: indexPath, animated: true)
               let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC
           vc?.photoUrl = photoUrl[indexPath.row]
           vc?.photoUrlTotal = photoUrl
           vc?.photoIndex = indexPath.row
           self.navigationController?.pushViewController(vc!, animated: true)
           // select && cell click
           case .select:
           dictionarySelectedIndexPath[indexPath] = true
           }
       }
        
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            // select && cell re click
            if mMode == .select {
                dictionarySelectedIndexPath[indexPath] = false
              }
            }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewCellWithd = collectionView.frame.width / 3 - 1
            return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
            }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 1
            }
            //옆 라인 간격
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 1
            }

      //scroll
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           if offsetY > contentHeight - scrollView.frame.size.height  {
                   page += 1
            callData(text: text)
               }
           }
      //high arrow
      @IBAction func scrollUp(_ sender: Any) {
          collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
      }
      //low arrow
      @IBAction func scrollDown(_ sender: Any) {
          collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentSize.height-collectionView.bounds.height), animated: true)
      }
}
        // keyboard
extension MainVC : UITextFieldDelegate {
    override func viewWillAppear(_ animated: Bool) {
            self.searchText.becomeFirstResponder()
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchText.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


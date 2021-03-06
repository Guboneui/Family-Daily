//
//  GalleryViewController.swift
//  Faily
//
//  Created by 구본의 on 2021/09/16.
//

import UIKit
import Photos
import Alamofire

struct photoInfo {
    var photoName: UIImage
    var isLoved: Bool
}

struct totalAlbumInfo {
    var album: [photoInfo]
    var isloved: Bool
    var albumTitle: String
}


class GalleryViewController: UIViewController {
    
    
    @IBOutlet weak var mainProfileImage: UIImageView!
    //@IBOutlet weak var galleryCategoryTableView: UITableView!
    
    static var totalAlbum: [totalAlbumInfo] = [
        totalAlbumInfo(album: GalleryViewController.recentPhotoAlbum, isloved: false, albumTitle: "최근 항목"),
        totalAlbumInfo(album: GalleryViewController.lovePhotoAlbum, isloved: true, albumTitle: "즐겨찾는 항목")
    ]
    
    static var recentPhotoAlbum: [photoInfo] = [
        photoInfo(photoName: UIImage(named: "chat_image1")!, isLoved: false),
        photoInfo(photoName: UIImage(named: "chat_image2")!, isLoved: false),
        photoInfo(photoName: UIImage(named: "chat_image3")!, isLoved: false),
        photoInfo(photoName: UIImage(named: "chat_image4")!, isLoved: true)
    ]
    
    static var lovePhotoAlbum: [photoInfo] = []
    
    @IBOutlet weak var galleryCategoryCollectionView: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 15, left: 32, bottom: 15, right: 32)
    
    
    override func loadView() {
        super.loadView()
        mainProfileImage.layer.cornerRadius = self.mainProfileImage.frame.height / 2
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setCollectionView()
        
        for i in 0..<GalleryViewController.recentPhotoAlbum.count {
            if GalleryViewController.recentPhotoAlbum[i].isLoved == true {
                GalleryViewController.lovePhotoAlbum.append(GalleryViewController.recentPhotoAlbum[i])
            }
        }
        
        print("❤️")
        print(GalleryViewController.lovePhotoAlbum)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.galleryCategoryCollectionView.reloadData()
    }
    
    
    
    func setCollectionView() {
        galleryCategoryCollectionView.delegate = self
        galleryCategoryCollectionView.dataSource = self
        galleryCategoryCollectionView.register(UINib(nibName: "GalleryCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCategoryCollectionViewCell")
        galleryCategoryCollectionView.register(UINib(nibName: "AddAlbumCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddAlbumCategoryCollectionViewCell")
    }
    
    
 
    
    
    
    
    
    //
    //    @IBAction func addGalleryCategoryAction(_ sender: Any) {
    //        let alert = UIAlertController(title: "갤러리", message: "추가할 카테고리 이름을 입력 해주세요.", preferredStyle: .alert)
    //        alert.addTextField { textField in
    //            textField.placeholder = "카테고리"
    //        }
    //        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil)
    //        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
    //        alert.addAction(cancelButton)
    //        alert.addAction(okButton)
    //        self.present(alert, animated: true, completion: nil)
    //    }
    //
    
}




extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            2
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return GalleryViewController.totalAlbum.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("컬렉션뷰 로드")
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCategoryCollectionViewCell", for: indexPath) as! GalleryCategoryCollectionViewCell
            cell.titleLabel.text = GalleryViewController.totalAlbum[indexPath.item].albumTitle
            let photoArray = GalleryViewController.totalAlbum[indexPath.item].album
            let lastArray = photoArray.last
            cell.thumbnailImage.image = lastArray!.photoName
            cell.countLabel.text = ("\(GalleryViewController.totalAlbum[indexPath.item].album.count)")
            if GalleryViewController.totalAlbum[indexPath.item].isloved == true {
                cell.heartImage.isHidden = false
            } else {
                cell.heartImage.isHidden = true
            }
            
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAlbumCategoryCollectionViewCell", for: indexPath) as! AddAlbumCategoryCollectionViewCell
            cell.addAlbumButton.addTarget(self, action: #selector(addAlbumCategory), for: .touchUpInside)
            return cell
        }
        
    }
    
    @objc func addAlbumCategory() {
        let alert = UIAlertController(title: "갤러리", message: "추가할 카테고리 이름을 입력 해주세요.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "카테고리"
        }
        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let detailGalleryVC = storyBoard.instantiateViewController(withIdentifier: "DetailGalleryViewController") as! DetailGalleryViewController
            detailGalleryVC.getPhoto = GalleryViewController.totalAlbum[indexPath.item].album
            detailGalleryVC.getTitle = GalleryViewController.totalAlbum[indexPath.item].albumTitle
            self.navigationController?.pushViewController(detailGalleryVC, animated: true)
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let width = self.galleryCategoryCollectionView.frame.width
            let height = self.galleryCategoryCollectionView.frame.height
            let itemsPerRow: CGFloat = 2
            let widthPadding = sectionInsets.left * (3)
            let itemsPerColumn: CGFloat = 2
            let heightPadding = sectionInsets.top * (3)
            let cellWidth = (width - widthPadding) / itemsPerRow
            let cellHeight = (height - heightPadding) / itemsPerColumn
            
            return CGSize(width: cellWidth, height: cellWidth * 1.34375)
        } else {
            return CGSize(width: self.galleryCategoryCollectionView.frame.width, height: 40)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return self.sectionInsets
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return sectionInsets.bottom
        } else {
            return 0
        }
        
    }
    ////
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return sectionInsets.bottom
        } else {
            return 0
        }
        
    }
    
    
}

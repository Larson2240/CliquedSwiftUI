//
//  ImagePreviewViewController.swift
//  SwapItSports
//
//  Created by C100-132 on 03/08/22.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    
    @IBOutlet var buttonCancel: UIButton!    
    @IBOutlet var collectionViewMedia: UICollectionView!
    @IBOutlet var labelMediaCount: UILabel!
    @IBOutlet var buttonSend: UIButton!
    
    var arrImages = [UIImage]()
    var is_preview = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewMedia.delegate = self
        collectionViewMedia.dataSource = self
        collectionViewMedia.registerNib(nibNames: [ImagePreviewCell.identifier])
        collectionViewMedia.isPagingEnabled = true
        collectionViewMedia.reloadData()
        
        if is_preview {
            buttonSend.isHidden = true
        } else {
            buttonSend.isHidden = false
        }
    }
    
    @IBAction func buttonCancelAction(_ sender: UIButton) {
        if is_preview {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonSendAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension ImagePreviewViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePreviewCell.identifier, for: indexPath) as? ImagePreviewCell {
            cell.imagePreview.image = arrImages[indexPath.item]
            labelMediaCount.text = "\((indexPath.row) + 1)/\(arrImages.count)"
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let indexPath = collectionViewMedia.indexPathForItem(at: center) {
            labelMediaCount.text = "\((indexPath.row) + 1)/\(arrImages.count)"
        }
    }
}

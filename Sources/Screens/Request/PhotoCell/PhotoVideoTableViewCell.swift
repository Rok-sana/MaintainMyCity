//
//  PhotoVideoTableViewCell.swift
//  MaintainMyCity
//
//  Created by swstation on 01.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit
protocol PhotoVideoTableViewCellDelegate: class {
    func showImagePickerToAdd()
    func showimagePickerToChange(_ index: Int)
    func image(at index: Int) -> UIImage?
    ///  var imageAtIndexPath:((Int) -> (UIImage)){ get }
    var numberOfItemsInSection: Int { get }
}

class PhotoVideoTableViewCell: UITableViewCell {
    
    enum CellType {
        case add
        case value
    }
    
    // array with added image
    weak var delegate: PhotoVideoTableViewCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: [CellType] = [.add]
    
    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 28, left: 28, bottom: 28, right: 8)
        return layout
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
    }
    
}
extension PhotoVideoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RequestVCDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attachmentCell", for: indexPath) as? AttachmentCell else {fatalError()}
        switch dataSource[indexPath.row] {
        case .add:
            cell.imageView.backgroundColor = .white
            cell.imageView.image = UIImage(named: "newPhotoCellIcon")
        case .value:
            cell.imageView.backgroundColor = .white
            let index = dataSource.contains(.add) ? indexPath.row - 1 : indexPath.row
            cell.imageView.image = delegate?.image(at: index)
        }
        return cell
    }
    
    func insertItemForPhotoCell(_ row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        dataSource.append(.value)
        self.collectionView.performBatchUpdates({
            self.collectionView?.insertItems(at: [indexPath])
        }, completion: nil)
        
    }
    
    func deleteItemForPhotoCell( _ row: Int) {
        if dataSource.contains(.add) {
            dataSource.remove(at: row+1)
        } else {
            dataSource.remove(at: row)
            dataSource.insert(.add, at: 0)
        }
        self.collectionView?.reloadData()
    }
    
    func reloadPhotoCells() {
        self.collectionView?.reloadData()
    }
    
    func deleteAllValueAfterUnload() {
       dataSource.removeAll()
       dataSource.insert(.add, at: 0)
       self.collectionView?.reloadData()
    }
    
    func deleteAddItemForPhotoCell() {
        dataSource.removeFirst()
        self.collectionView.performBatchUpdates({
            self.collectionView?.deleteItems(at: [IndexPath(row: 0, section: 0)])
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = self.bounds.height - layout.sectionInset.top - layout.sectionInset.bottom
        return CGSize(width: dimension, height: dimension)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataSource[indexPath.row] == .add {
            delegate?.showImagePickerToAdd()
        }
        if dataSource[indexPath.row] == .value {
            let index = dataSource.contains(.add) ? indexPath.row - 1 : indexPath.row
            delegate?.showimagePickerToChange(index)
        }
    }
}

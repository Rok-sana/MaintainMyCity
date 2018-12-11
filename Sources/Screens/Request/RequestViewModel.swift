//
//  RequestViewModel.swift
//  MaintainMyCity
//
//  Created by swstation on 04.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import KeychainSwift

enum StatusUploading {
    case uploading
    case finish
    
}

protocol RequstViewModelType {
    func countImageDataSourceForCell() -> Int
    func add(_ mediaFile: MediaFile)
    func replace(_ mediaFile: MediaFile, by index: Int)
    func delete(at index: Int)
    func clearAll()
    func imageName(at index: Int) -> String?
    func generateThumbnail(url: URL) -> UIImage?
    func resizeImage(_ image: UIImage) -> UIImage
    func checkMaxCountPhoto() -> Bool
    func showCategorySelection()
    func showLocation()
    var categoryType: Category? { get set}
    var location: String? { get set}
    var update:((_ value: Float)->())? { get set }
    func calculateValueForProgress()
    func createPost()
    func saveToTemp(_ image: UIImage) throws -> String
    var handlerError: ((Error) -> ())? {get set}
    var handlerUploadingStatus: ((StatusUploading) -> ())? { get set }
    var description: String? {get set}
}

class RequstViewModel: RequstViewModelType {
    
    weak var router: RequestRouterType?
    private let uploadingManager: AWSUploadManagerType
    private let postManager: PostManagerType
    var description: String?
    private var mediaFileDataSourceForCell: [MediaFile] = []
    var categoryType: Category?
    var location: String?
    var progressValueForImage: Float = 0.0
    var handlerError: ((Error) -> ())?
    var handlerUploadingStatus: ((StatusUploading) -> ())?
    init(dependencies: AppDependencies) {
        self.postManager = dependencies.postManager
        let authorizationManager = dependencies.authManager
        self.uploadingManager = AWSUploadManager.init(with: authorizationManager.getSettings()!)
        
    }
    var update:((_ value: Float)->())?
    func countImageDataSourceForCell() -> Int {
        return mediaFileDataSourceForCell.count
    }
    func checkMaxCountPhoto() -> Bool {
        if mediaFileDataSourceForCell.count == 5 {
            return true
        }
        return false
    }
    
    func saveToTemp(_ image: UIImage) throws -> String {
        var fileId = String()
        do {
            fileId = try image.saveToTemp()
            
        } catch {
            print(error)
        }
        return fileId
    }
    
    func clearAll() {
        mediaFileDataSourceForCell.removeAll()
        description = nil
        categoryType = nil
        calculateValueForProgress()
    }
    func add(_ mediaFile: MediaFile) {
        mediaFileDataSourceForCell.append(mediaFile)
        calculateValueForProgress()
    }
    
    func replace(_ mediaFile: MediaFile, by index: Int) {
        mediaFileDataSourceForCell[index] = mediaFile
    }
    
    func delete(at index: Int) {
        mediaFileDataSourceForCell.remove(at: index)
        calculateValueForProgress()
    }
    
    func imageName(at index: Int) -> String? {
        return mediaFileDataSourceForCell[index].thumbnailImageName
    }
    
    func calculateValueForProgress() {
        var progressValue: Float = 0.0
        if mediaFileDataSourceForCell.count > 0 {
            progressValue = 0.25
        }
        if categoryType != nil {
            progressValue += 0.25
        }
        if  description != nil {
            progressValue += 0.25
        }
        if location != nil {
            progressValue += 0.25
            
        }
        self.update?(progressValue)
    }
    private func prepareNewPostFields() -> [String: Any] {
        var fields: [String: Any] = [:]
        var assets = [[String: String]]()
        for mediaFile in mediaFileDataSourceForCell {
            let asset = ["thumbnail": mediaFile.thumbnailImageName, "asset": mediaFile.fileName]
            assets.append(asset)
        }
        fields["description"] = description ?? ""
        fields["assets"] = assets
        fields["category_id"] = categoryType?.id
        fields["address"] = (location != nil && location != " ") ? location: "Местоположение неизвестно"
        
        return fields
    }
    
    func  createPost() {
        DispatchQueue.main.async {
            self.handlerUploadingStatus?(.uploading)
        }
        uploadingManager.upload(mediaFileDataSourceForCell) { (result) in
            switch result {
            case .success( _):
                self.postManager.createPost(parameters: self.prepareNewPostFields()) { (result) in
                   
                    switch result {
                    case .success(_):
                        self.clearAll()
                    case .failure(let error):
                        
                        self.handlerError?(error)
                    }
                    DispatchQueue.main.async {
                        self.handlerUploadingStatus?(.finish)
                    }
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    self.handlerUploadingStatus?(.finish)
                }
                self.handlerError?(error)
            }
        }
        
    }
    func generateThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
            
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    func resizeImage(_ image: UIImage) -> UIImage {
        return  image.resizeImage(targetSize: CGSize(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height * 0.15))
    }
    
    func showCategorySelection() {
        router?.showType(completion: { category in
            self.categoryType = category
            self.calculateValueForProgress()
        })
    }
    
    func showLocation() {
        router?.showLocation(completion: { (location) in
            self.location = location
            self.calculateValueForProgress()
        })
    }
    
}

//
//  UploadingManager.swift
//  MaintainMyCity
//
//  Created by swstation on 16.10.2018.
//  Copyright © 2018 swstation. All rights reserved.
//

import Foundation
import AWSS3
import KeychainSwift

protocol AWSUploadManagerType {
    init(with settings: AWSInfo)
    func upload( _ mediaFiles: [MediaFile], completion: @escaping (Resulting<Void>) -> Void)
}

struct UploaderError: Error {
    var localizedDescription: String = "Error at uploading media to cloud"
}

class AWSUploadManager: AWSUploadManagerType {
    
    private let settings: AWSInfo
    static let availablePhotoSize: CGFloat = 2000
    var transferManager: AWSS3TransferManager?
    var bucketName: String?
    let internetManager: InternetManagerType = InternetManager()
    
    required init(with settings: AWSInfo) {
        self.settings = settings
        let regionType = AWSUploadManager.regionTypeForString(regionString: settings.uploadRegion)
        self.bucketName = settings.bucketName
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: regionType,
                                                                identityPoolId: settings.poolID)
        let configuration = AWSServiceConfiguration(region: regionType,
                                                    credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        self.transferManager = AWSS3TransferManager.default()
    }
    
    func upload( _ mediaFiles: [MediaFile], completion: @escaping (Resulting<Void>) -> Void) {
     
        let group = DispatchGroup()
         var uploadError: Error?
        for file in mediaFiles {
            group.enter()
            switch file.type {
            case .image:
                uploadFile(at: file.fileName, mediaType: .image) { result in
                    switch result {
                    case .success(let file):
                        print("Hey + \(file)")
                        group.leave()
                    case .fail(let error):
                        uploadError = error
                        group.leave()
                    }
                }
            case .video:
                
                uploadFile(at: file.fileName, mediaType: .video) { result in
                    switch result {
                    case .success( _):
                        print("Hey + \(file)")
                        group.leave()
                    case .fail(let error):
                        uploadError = error
                        group.leave()
                    }
                    
                }
                uploadFile(at: file.thumbnailImageName, mediaType: .image) { result in
                    switch result {
                    case .success( _):
                         print("Hey + \(file)")
                        group.leave()
                    case .fail(let error):
                        uploadError = error
                        print("Error")
                        group.leave()
                    }
                    
                }
                
            }
            
        }
        group.notify(queue: DispatchQueue.global()) {
            if let error = uploadError {
                completion(.fail(error))
            } else {
                completion(.success( (Void()) ))
            }
        }
        
    }
    
    func uploadFile(at filename: String, mediaType: MediaFile.MediaFileType, completion: @escaping (Resulting<Void>) -> Void) {
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else {
            completion(.fail(UploaderError()))
            return
        }
        let mediaURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        uploadRequest.body = mediaURL
        uploadRequest.key = filename
        uploadRequest.bucket = self.bucketName
        switch mediaType {
        case .image:
            uploadRequest.contentType = "image/jpeg"
        case .video:
            uploadRequest.contentType = "video/mp4"
            
        }
        
        self.transferManager!.upload(uploadRequest).continueWith { taskResult -> Any? in
            if let error = taskResult.error {
                completion(.fail(error))
                return nil
            }
            
            if taskResult.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                print("Uploaded to:\(publicURL)")
            }
            completion(.success( Void() ))
            return nil
            
        }
    }
    
    static func regionTypeForString(regionString: String) -> AWSRegionType {
        switch regionString {
        case "us-east-1": return .USEast1
        case "us-west-1": return .USWest1
        case "us-west-2": return .USWest2
        case "eu-west-1": return .EUWest1
        case "eu-central-1": return .EUCentral1
        case "ap-northeast-1": return .APNortheast1
        case "ap-northeast-2": return .APNortheast2
        case "ap-southeast-1": return .APSoutheast1
        case "ap-southeast-2": return .APSoutheast2
        case "sa-east-1": return .SAEast1
        case "cn-north-1": return .CNNorth1
        case "us-gov-west-1": return .USGovWest1
        default: return .Unknown
        }
    }
    
}

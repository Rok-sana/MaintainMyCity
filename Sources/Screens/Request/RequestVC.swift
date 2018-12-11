//
//  RequestVC.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol RequestVCDelegate: class {
    func insertItemForPhotoCell( _ row: Int)
    func deleteItemForPhotoCell( _ row: Int)
    func reloadPhotoCells()
    func deleteAddItemForPhotoCell()
    func deleteAllValueAfterUnload()
}

class RequestVC: UIViewController {
    
    enum CellType: String {
        case photo = "Фото и Bидео(максимум 5 единиц)"
        case address = "Адрес происшествия"
        case incidentType = "Вид проблемы или происшествия"
        case comment = "Комментарий к заявке"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var router: FlowRouter!
    var viewModel: RequstViewModelType!
    var dataSource: [CellType] = [.photo, .address, .incidentType, .comment]
    var sectionHeaderHeight: CGFloat = 50.0
    weak var delegate: RequestVCDelegate?
    private var selectedImageIndex: Int?
    var emptyUploadingView =  EmptyUploadingView()
   
    func configure(router: FlowRouter, viewModel: RequstViewModelType) {
        self.router = router
        self.viewModel = viewModel
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = self.navigationController?.navigationBar as? CustomNavigationBar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.addSubview(emptyUploadingView)
        emptyUploadingView.isHidden = true
        emptyUploadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        emptyUploadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        emptyUploadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        emptyUploadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        viewModel.handlerUploadingStatus = { status in
            self.emptyUploadingView.updateState(status)
        }
        
        viewModel.update = { [weak self]  value in
            self?.tableView.reloadData()
            
            navBar?.updateProgress(value)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отправить", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
        view.backgroundColor = .white
        
        viewModel.handlerError = { error in
            self.handleError(error)
        }
        tableView.tableFooterView = UIView(frame: .zero)
    }
   deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        
        var tabbarHeight: CGFloat = 0
        if self.tabBarController != nil {
            tabbarHeight = self.tabBarController!.tabBar.frame.height
        }
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            self.tableView.contentInset.bottom = endFrame!.size.height - tabbarHeight
            self.tableView.setContentOffset(CGPoint(x: self.tableView.contentOffset.x, y: self.tableView.contentOffset.y + endFrame!.size.height - tabbarHeight), animated: true)
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.tableView.contentInset.bottom = 0
        self.viewModel.calculateValueForProgress()
    }
    
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //This func will be rename
    @objc func addTapped() {
        viewModel.createPost()
        self.delegate?.deleteAllValueAfterUnload()
        tableView.reloadData()
        
    }
    
}
extension RequestVC: UITableViewDataSource, UITableViewDelegate {
    var numberOfItemsInSection: Int {
        return viewModel.countImageDataSourceForCell()
    }
    
    func image(at index: Int) -> UIImage? {
        guard let imageName = viewModel.imageName(at: index) else { return nil }
        let imageData = Data.getDataFromTemp(fileName: imageName)
        guard let data = imageData else {return nil}
        let image = UIImage(data: data)
        return image
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = dataSource[indexPath.section]
        switch  cellType {
        case .photo:
            let  cell = (tableView.dequeueReusableCell( withIdentifier: "photoCell") as? PhotoVideoTableViewCell)!
            cell.delegate = self
            self.delegate = cell
            return cell
        case .address:
            let  cell = (tableView.dequeueReusableCell( withIdentifier: "addressCell") as? AddressTypeTableCell)!
            if let location = viewModel.location {
                cell.chooseAdressLabel.text = location != " " ? location: "Местоположение неизвестно"
            } else {
                cell.chooseAdressLabel.text = "Введите или выберите на карте"
            }
            return cell
        case .incidentType:
            let cell = (tableView.dequeueReusableCell( withIdentifier: "typeOfIncident") as? TypeOfIncidentTableViewCell)!
            if let category = viewModel.categoryType {
                cell.typeOfIncidentLabel.text = category.title
                
            } else {
                cell.typeOfIncidentLabel.text = "Выбрать из списка"
            }
            
            return cell
        case .comment:
            let cell = (tableView.dequeueReusableCell( withIdentifier: "commentCell") as? CommentForReguestTableViewCell)!
            cell.delegate = self
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = dataSource[indexPath.section]
        switch cellType {
        case .photo:
            return 106
        case .address:
            return 50
        case .incidentType:
            return 50
        case .comment:
            return 200
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1)
        headerView.layer.borderWidth = 0.3
        headerView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        let cellType = dataSource[section]
        titleLabel.text = cellType.rawValue
        
        titleLabel.sizeToFit()
        titleLabel.font = UIFont(name: "SFProText-Regular", size: 13)
        titleLabel.textColor = UIColor(red: 109 / 255.0, green: 109 / 255.0, blue: 114 / 255.0, alpha: 1)
        titleLabel.frame = CGRect(x: 10, y: sectionHeaderHeight - titleLabel.frame.height - 5, width: titleLabel.frame.width, height: titleLabel.frame.height)
        headerView.addSubview(titleLabel)
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = dataSource[indexPath.section]
        if cellType == .incidentType {
            viewModel.showCategorySelection()
        }
        if cellType == .address {
            viewModel.showLocation()
        }
    }
}

extension RequestVC: PhotoVideoTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerToAdd() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { [weak self] _ in
            self?.presentGalleryImagePicker()
        }))
        alertController.addAction(UIAlertAction(title: "Новое фото или видео", style: .default, handler: { [weak self] _ in
            self?.presentCameraImagePicker()
        }))
        present(alertController, animated: true)
    }
    func showimagePickerToChange(_ index: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { [weak self] _ in
            self?.selectedImageIndex = index
            self?.presentGalleryImagePicker()
        }))
        alertController.addAction(UIAlertAction(title: "Новое фото или видео", style: .default, handler: { [weak self] _ in
            self?.selectedImageIndex = index
            self?.presentCameraImagePicker()
        }))
        alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {(alertAction) in
            self.viewModel.delete(at: index)
            self.delegate?.deleteItemForPhotoCell(index)
            
        }))
        present(alertController, animated: true)
    }
    
    private func presentGalleryImagePicker() {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentCameraImagePicker() {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.noCamera()
        }
    }
    
    func noCamera() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(info)
        if let image = info[.editedImage] as? UIImage {
            
            let resized = image.resizeImage(targetSize: CGSize(width: AWSUploadManager.availablePhotoSize, height: AWSUploadManager.availablePhotoSize))
            let fileName =  try? viewModel.saveToTemp(resized)
            let mediaFile = MediaFile(type: .image, fileName: fileName!, thumbnailImageName: fileName!)
            
            if let selectedImageIndex = self.selectedImageIndex {
                viewModel.replace(mediaFile, by: selectedImageIndex)
                self.selectedImageIndex = nil
                delegate?.reloadPhotoCells()
            } else {
                viewModel.add(mediaFile)
                delegate?.insertItemForPhotoCell(viewModel.countImageDataSourceForCell() )
            }
            
        }
        if let videoURL = info[.mediaURL] as? URL {
            let image = viewModel.generateThumbnail(url: videoURL)
            if let image = image {
                let resized = image.resizeImage(targetSize: CGSize(width: AWSUploadManager.availablePhotoSize, height: AWSUploadManager.availablePhotoSize))
                
                if let selectedImageIndex = self.selectedImageIndex {
                    
                    if let thumbnail = try? viewModel.saveToTemp(resized) {
                        let mediaFile = MediaFile(type: .video, fileName: videoURL.lastPathComponent, thumbnailImageName: thumbnail)
                        viewModel.replace(mediaFile, by: selectedImageIndex)}
                    
                    self.selectedImageIndex = nil
                    delegate?.reloadPhotoCells()
                } else {
                    do {
                        let mediaFile = MediaFile(type: .video, fileName: videoURL.lastPathComponent, thumbnailImageName: try viewModel.saveToTemp(resized))
                        viewModel.add(mediaFile)
                    } catch {
                        self.handleError(error)
                    }
                    delegate?.insertItemForPhotoCell(viewModel.countImageDataSourceForCell() )
                }
                
            }
            
        }
        if viewModel.checkMaxCountPhoto() {
            delegate?.deleteAddItemForPhotoCell()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
extension RequestVC: CommentForReguestTableViewCellDelegate {
    func descriptionDidChange(text: String) {
        self.viewModel.description = text
        
    }
}
extension RequestVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        router.prepare(for: segue, sender: sender)
    }
}
